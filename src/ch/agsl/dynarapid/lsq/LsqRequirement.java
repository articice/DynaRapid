/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.lsq;

import java.nio.file.*;
import java.util.*;

import org.json.*;

/*
 * An LSQ's split into library sub-units, as scripts/lsq_subunits.py writes it (<extern>.req.json):
 * its key, the sub-unit of each role (core, ga, lda, ldd, sta, std, stb), the group allocator's
 * table INITs for this kernel, and the net map. Net ends are [block, port]: block "lsq" is the
 * LSQ's own port (the generator's wrapper port, io_<port>[_bits|_valid|_ready]), any other block
 * a sub-unit role. Ports are whole ports: vectors connect bit for bit.
 */
public class LsqRequirement {
    public static final String LSQ = "lsq";

    public static class End {
        public final String block, port;

        End(JSONArray a) {
            block = a.getString(0);
            port = a.getString(1);
        }

        public boolean isLsq() {
            return block.equals(LSQ);
        }

        public String toString() {
            return block + "." + port;
        }
    }

    public static class Net {
        public End from;          //null for a constant
        public String constant;   //"0" or "1"
        public List<End> to = new ArrayList<>();
    }

    public String name, key;
    public Map<String, String> subunits = new LinkedHashMap<>();
    public Map<String, String> gaInits = new LinkedHashMap<>();
    public List<Net> nets = new ArrayList<>();

    public static LsqRequirement read(Path path) throws Exception {
        JSONObject o = new JSONObject(new String(Files.readAllBytes(path)));
        LsqRequirement r = new LsqRequirement();
        r.name = o.getString("name");
        r.key = o.getString("key");
        JSONObject s = o.getJSONObject("subunits");
        for (String tag : s.keySet())
            r.subunits.put(tag, s.getString(tag));
        JSONObject g = o.getJSONObject("ga_inits");
        for (String cell : g.keySet())
            r.gaInits.put(cell, g.getString(cell));
        JSONArray nets = o.getJSONArray("nets");
        for (int i = 0; i < nets.length(); i++) {
            JSONObject n = nets.getJSONObject(i);
            Net net = new Net();
            if (n.has("const"))
                net.constant = n.getString("const");
            else
                net.from = new End(n.getJSONArray("from"));
            JSONArray to = n.getJSONArray("to");
            for (int k = 0; k < to.length(); k++)
                net.to.add(new End(to.getJSONArray(k)));
            r.nets.add(net);
        }
        return r;
    }

    //The sub-unit ports an LSQ input port drives
    public List<End> sinks(String lsqPort) {
        List<End> out = new ArrayList<>();
        for (Net n : nets)
            if (n.from != null && n.from.isLsq() && n.from.port.equals(lsqPort))
                out.addAll(n.to);
        return out;
    }

    //The net that drives an LSQ output port (a sub-unit port or a constant), or null
    public Net driver(String lsqPort) {
        for (Net n : nets)
            for (End e : n.to)
                if (e.isLsq() && e.port.equals(lsqPort))
                    return n;
        return null;
    }

    //Nets between sub-units
    public List<Net> internal() {
        List<Net> out = new ArrayList<>();
        for (Net n : nets)
            if (n.from != null && !n.from.isLsq())
                for (End e : n.to)
                    if (!e.isLsq()) {
                        out.add(n);
                        break;
                    }
        return out;
    }

    //Number of nets between two roles, either way (for the gap between their sub-units)
    public int netsBetween(String a, String b) {
        int k = 0;
        for (Net n : nets) {
            if (n.from == null)
                continue;
            for (End e : n.to)
                if ((n.from.block.equals(a) && e.block.equals(b)) || (n.from.block.equals(b) && e.block.equals(a)))
                    k++;
        }
        return k;
    }
}
