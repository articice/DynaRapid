/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
* For any questions, please contact Andrea Guerrieri <andrea.guerrieri@ieee.org> (C) 2024
*/


package ch.agsl.dynarapid.pblockgenerator;
import ch.agsl.dynarapid.databasegenerator.*;
import ch.agsl.dynarapid.debug.*;
import ch.agsl.dynarapid.entry.*;
import ch.agsl.dynarapid.error.*;
import ch.agsl.dynarapid.graphgenerator.*;
import ch.agsl.dynarapid.graphplacer.*;
import ch.agsl.dynarapid.interrouting.*;
import ch.agsl.dynarapid.map.*;
import ch.agsl.dynarapid.modules.*;
import ch.agsl.dynarapid.parser.*;
import ch.agsl.dynarapid.pblockgenerator.*;
import ch.agsl.dynarapid.placer.*;
     
import ch.agsl.dynarapid.strings.*;
import ch.agsl.dynarapid.synthesizer.*;
import ch.agsl.dynarapid.tclgenerator.*;
import ch.agsl.dynarapid.vivado.*;
//This goes through all the starting points and genertaes the placed and routed pblocks
//No pblocks are generated with teh border as the border of the FPGA

import com.google.protobuf.MapEntryLite;
import com.xilinx.rapidwright.design.Design;
import com.xilinx.rapidwright.design.Module;
import com.xilinx.rapidwright.design.ModuleInst;
import com.xilinx.rapidwright.design.PBlockCorner;
import com.xilinx.rapidwright.design.SiteInst;
import com.xilinx.rapidwright.device.Device;
import com.xilinx.rapidwright.device.Site;
import com.xilinx.rapidwright.device.Tile;
import com.xilinx.rapidwright.device.SiteTypeEnum;
import com.xilinx.rapidwright.device.TileTypeEnum;
import com.xilinx.rapidwright.device.helper.TileColumnPattern;
import com.xilinx.rapidwright.edif.EDIFCell;
import com.xilinx.rapidwright.edif.EDIFDirection;
import com.xilinx.rapidwright.edif.EDIFNet;
import com.xilinx.rapidwright.edif.EDIFNetlist;
import com.xilinx.rapidwright.tests.CodePerfTracker;
import com.xilinx.rapidwright.examples.SLRCrosserGenerator;
import com.xilinx.rapidwright.design.blocks.PBlock;
import com.xilinx.rapidwright.router.Router;
import com.xilinx.rapidwright.placer.handplacer.HandPlacer;
import com.xilinx.rapidwright.rwroute.RWRoute;

import java.io.*;
import java.util.*;
import java.lang.*;

import org.python.antlr.PythonParser.else_clause_return;
import org.python.core.util.StringUtil;

public class PblockGenerator
{
    public Component component;
    public boolean status; //tells the status of the pblock generator. True if all good else false
    public boolean remove; //Tells if the un-successful pblock file are to be removed or not
    public boolean shorten; //True if the pblock generation is to be done in shortened format
    public int numShapes;
    public boolean licence;

    /*
     * Logic sites (CLEL + CLEM) a pblock must have, as a fraction the unit fills: a pblock is first
     * tried at about this utilization rather than at an exact fit, then grown by GROWTH of its columns
     * per routing failure. An exact fit routes for small units (columns are coarse at their size), but
     * a large LUT-bound unit fails at it for hours: the LSQ of histogram (8452 LUTs) filled its first
     * pblocks to 95% and failed every route, one column added per hour-long attempt.
     * 0 (the default): 1.0 for units of up to LARGE_UNIT_SITES logic sites, LARGE_UNIT_UTILIZATION above.
     * GeneratePblocks -util <fraction> sets it.
     */
    public static double utilization = 0;
    public static final int LARGE_UNIT_SITES = 200;
    public static final double LARGE_UNIT_UTILIZATION = 0.75;
    public static final double GROWTH = 0.1;
    //Most map columns per row for a large unit's pblock (about 2:1 wide in sites)
    public static final int MAX_ASPECT = 1;
    //component.dcp with the logic sites scaled to the target utilization
    public ResourceElement need;

    static ResourceElement required(ResourceElement dcp, double util)
    {
        int logic = dcp.clel + dcp.clem;
        double u = (util > 0) ? util : ((logic > LARGE_UNIT_SITES) ? LARGE_UNIT_UTILIZATION : 1.0);
        //CLEM-only resources stay as they are; the margin goes to the sites either kind can serve
        int clel = (int) Math.ceil(logic / u) - dcp.clem;
        return new ResourceElement(clel, dcp.clem, dcp.dsp, dcp.bram);
    }

    /*
     * Pblock generator which generates the pblocks with all the pins exposed
     * @param d Name of teh component
     * @param r True if the unsuccessful pblocks are to be removed and false if they are not to be removed.
     * @param s True if the pblock generator is to be run in shortened format and false if the pblock generator is to be run in the elongated format
     */
    public PblockGenerator (String d, boolean r, boolean s, int num, boolean licence)
    {
        component = new Component(d, licence);
        need = required(component.dcp, utilization);
        System.out.println("Pblock logic sites required: " + (need.clel + need.clem) + " for " + (component.dcp.clel + component.dcp.clem) + " used");
        remove = r;
        shorten = s;
        status = true;
        numShapes = num;
        this.licence = licence;

        int i = ResourceElement.starti;

        //Traverse through all starting sites, most relocatable first (see startColumns)
        for(int j : startColumns(i))
        {
            StringUtils.printIntro("Starting Location I = " + i + " J = " + j);
            if(!incrementRows(i, j))
            {
                status = false;
                break;
            }

            if(component.pblockList.size() >= numShapes)
            {
                System.out.println("Generated " + numShapes + " pblock(s). Exiting this component");
                break;
            }
        }

        if(status)
            System.out.println("The number of unique pblocks are: " + component.pblockList.size());

        else   
            System.out.println("ERROR: Code ended incorrectly. See above logs");

    }

    //Columns a pblock spans are compared over this many map columns when ranking start columns
    static final int PATTERN_COLUMNS = 3;

    /*
     * Start columns for pblock generation, in the order to try them. A shape can only be relocated to
     * columns with the same resource pattern, so columns whose pattern repeats most across the device
     * come first (ties: nearest the middle). With a small shape budget (pass 1) the old order, from the
     * right edge leftwards, put every shape of a variant in a rare edge pattern on some parts (xcu55n:
     * 3 shapes at columns 145-146, ~5k valid places, versus ~50k+ in common columns).
     * -Ddynarapid.pblockScan=edge restores the old order.
     */
    static List<Integer> startColumns(int i)
    {
        List<Integer> cols = new ArrayList<>();
        for(int j = (ResourceElement.endj - 1); j > ResourceElement.startj; j--)
            cols.add(j);
        if("edge".equals(System.getProperty("dynarapid.pblockScan")))
            return cols;

        ArrayList<MapElement> row = MapElement.map.get(i);
        Map<Integer, String> key = new HashMap<>();
        Map<String, Integer> count = new HashMap<>();
        for(int j : cols)
        {
            StringBuilder k = new StringBuilder();
            for(int c = 0; c < PATTERN_COLUMNS; c++)
            {
                MapElement e = (j + c < row.size()) ? row.get(j + c) : null;
                k.append(e == null ? "-" : e.leftElementRootname + "/" + e.rightElementRootname).append('|');
            }
            key.put(j, k.toString());
            count.merge(k.toString(), 1, Integer::sum);
        }
        int mid = (ResourceElement.startj + ResourceElement.endj) / 2;
        cols.sort(Comparator.<Integer>comparingInt(j -> -count.get(key.get(j))).thenComparingInt(j -> Math.abs(j - mid)));
        System.out.println("Pblock start columns, most common pattern first: " + cols.subList(0, Math.min(8, cols.size()))
                + " (pattern of column " + cols.get(0) + " occurs " + count.get(key.get(cols.get(0))) + " times; of column "
                + (ResourceElement.endj - 1) + ", " + count.get(key.get(ResourceElement.endj - 1)) + ")");
        return cols;
    }

    //For the given i and j in the map, it gives the minimum number of columns the pblock can have
    public int findMinCol(int i, int j)
    {
        boolean l, m, d, b;
        int minCol = 0;
        
        m = component.dcp.clem > 0;
        l = component.dcp.clel > 0;
        d = component.dcp.dsp > 0;
        b = component.dcp.bram > 0;

        ArrayList<ArrayList<MapElement>> map = MapElement.map;

        for(; j < map.get(i).size(); j++)
        {
            if(!l && !m && !d && !b)
                break;

            MapElement tempElement = map.get(i).get(j);
            if(tempElement.isCLEL(tempElement.leftElementRootname) || tempElement.isCLEL(tempElement.rightElementRootname))
                l = false;
    
            if(tempElement.isCLEM(tempElement.leftElementRootname) || tempElement.isCLEM(tempElement.rightElementRootname))
            {
                l = false;
                m = false;
            }
    
            if(tempElement.isDSP(tempElement.leftElementRootname) || tempElement.isDSP(tempElement.rightElementRootname))
                d = false;
    
            if(tempElement.isBRAM(tempElement.leftElementRootname) || tempElement.isBRAM(tempElement.rightElementRootname))
                b = false;
                
            minCol++;
        }
    
        if(l || m || d || b)
            minCol++;
    
        System.out.println("The minimum number of columns for the given anchor sites are: " + minCol);
        return minCol;
    }


    /*
     * This function increments rows and creates pblocks for each row.
     * Thsi function also updates the pblockList for each successful pblock
     * @param i This is the top-left corner site i coordinate
     * @param j This is the top-left corner site j coordinate
     * @return If there were any errors, it returns false or else true
     */
    public boolean incrementRows(int i, int j)
    {
        int minCol = findMinCol(i, j);
        int rows = 0;
        int maxRows = ResourceElement.endi - ResourceElement.starti;
        int cols = MapElement.map.get(i).size() - j; //maximum number of columns available from the given starting site. All pblocks MUST BE SMALLER than cols
                                                        //ie. The cols is 1 more that what is permissible

        if(cols == minCol)
        {
            System.out.println("Maximum pblock would not have sufficient placement resources");
            return true;
        }
        
        while((cols >= minCol) && (rows <= (maxRows - component.incFactor)))
        {
            rows += component.incFactor;
            StringUtils.printIntro("Investicating for pblock with rows: " + rows);
            System.out.println("Maximum number of columns allowed is " + cols);
            System.out.println("Minimum number of columns allowed are: " + minCol);
            cols = findCol(rows, minCol, cols, i, j);

            if(cols == -1)
                return false;

            if(cols == minCol)
                break;

            if(component.pblockList.size() >= numShapes)
            {
                System.out.println("Generated " + numShapes + " pblock(s). Exiting this component");
                break;
            }
        }

        return true;
    }

    /*
     * Function finds the column that must be present in the pblock given the rows. The condition is: (minCol <= col < maxCol)
     * @param rows The number of rows in the pblock
     * @param minCol Minimum number of columns in the pblock
     * @param maxColMaximum number of columns in the pblock
     * @param i, j, The starting coordinates of the pblock
     * @return Returns the number of columns in the newly formed pblock (in case of error it returns -1)
     */
    public int findCol(int rows, int minCol, int maxCol, int i, int j)
    {
        int currCol = maxCol - 1;
        
        //Checking if pblock reduction is even possible or not
        ResourceElement resourceElement = ResourceElement.getPblock(i, j, i + rows - 1, j + currCol - 1);

        if(!resourceElement.isPblockAppropriate(need))
        {
            System.out.println("Cannot reduce any more columns");
            return maxCol;
        }

        //Finding the minumum number of columns we can go based just on placement resources
        System.out.print("The number of columns in the attempted pblock is: ");
        while(currCol >= minCol)
        {
            System.out.print(currCol + ", \t");
            ResourceElement tempResourceElement = ResourceElement.getPblock(i, j, i + rows - 1, j + currCol - 1);

            if(tempResourceElement.isPblockAppropriate(need))
            {
                resourceElement = tempResourceElement;
                currCol--;
            }

            else
            {
                currCol++;
                break;
            }
        }

        System.out.println();
        if(currCol < minCol)
            currCol++;

        if(resourceElement.isFirstColRemovable(need))
        {
            System.out.println("Could not form pblock since first column is removable. Going to next row");
            if(currCol == minCol)
            {
                System.out.println("Could not proceed with more rows in this starting site as the number of columns is already " + minCol);
                return minCol;
            }

            return maxCol;
        }

        /*
         * A large unit in a flat strip (histogram's LSQ: 13 rows by 69 columns, half the device wide) has
         * long routes through a few rows and runs into the timeout; it is tried from the squarer shapes
         * of more rows instead. A map column holds two sites (one each side of an interconnect column).
         */
        if((need.clel + need.clem > LARGE_UNIT_SITES) && (currCol > MAX_ASPECT * rows))
        {
            System.out.println("Pblock of " + rows + " rows and " + currCol + " columns is too flat for this unit. Going to next row");
            return maxCol;
        }

        int stage = (shorten) ? 1 : 0;

        while(currCol < maxCol)
        {
            System.out.println("Trying to generate pblock with rows: " + rows + " columns: " + currCol);

            resourceElement = ResourceElement.getPblock(i, j, i + rows - 1, j + currCol - 1);

            String s = component.searchPblockList(resourceElement);
            if(!s.equals(""))
            {
                System.out.println("Pblock with columns: " + currCol + " already exists as pblock: " + s);
                return currCol;
            }

            Pblock pblock = new Pblock(component, i, j, rows, currCol, stage, remove, licence);
            int status = pblock.currStatus;
            stage = pblock.stage;

            if(status == 7) //successful pblock creation with pinExposed
            {
                component.pblockList.add(pblock);
                System.out.println("Pblock generated with rows: " + rows + " and columns: " + currCol);
                return currCol;
            }

            if((status == -1) || (status == 0) || (status == 1) || (status == 5) || (status == 6))
            //Placed and routed log errors which require code stopping in case it happens
                return -1;

            if(status == 2) 
            //placement not succeessful. No point increasing the number of columns
                return maxCol;

            //Routing problems
            currCol += Math.max(1, (int) Math.ceil(currCol * GROWTH));
        }

        System.out.println("Could not generate pblock with given number of rows. Going to next rows");
        //growth can step past maxCol, the columns available from j
        return maxCol;
    }
}
