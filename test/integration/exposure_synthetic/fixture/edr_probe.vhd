-- A small unit built to be rewired by Vivado inside the old pin-exposure harness, shaped like a
-- memory controller's write path: the top computes one request per port (req(k) = a_valid(k) and
-- b_valid(k)) and hands them to an arbiter entity. The library synthesizes with
-- -flatten_hierarchy none, so each request stays a LUT2 of its own at the entity boundary: copies
-- of the same function of different ports, which the old harness made look equivalent.
-- See test/integration/exposure_synthetic/run.sh.
library ieee;
use ieee.std_logic_1164.all;

entity edr_probe_arbiter is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        req      : in  std_logic_vector(23 downto 0);
        data_in  : in  std_logic_vector(383 downto 0);
        grant    : out std_logic_vector(23 downto 0);
        out_valid : out std_logic;
        out_data : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of edr_probe_arbiter is
    signal g : std_logic_vector(23 downto 0);
    signal valid_q : std_logic := '0';
    signal data_q : std_logic_vector(15 downto 0) := (others => '0');
begin
    -- fixed priority: port k is granted when it requests and no lower port does
    process (req)
        variable taken : std_logic;
    begin
        taken := '0';
        for k in 0 to 23 loop
            g(k) <= req(k) and not taken;
            taken := taken or req(k);
        end loop;
    end process;
    grant <= g;

    process (clk)
        variable d : std_logic_vector(15 downto 0);
        variable any : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                valid_q <= '0';
                data_q <= (others => '0');
            else
                d := (others => '0');
                any := '0';
                for k in 0 to 23 loop
                    if g(k) = '1' then
                        d := d or data_in(16 * k + 15 downto 16 * k);
                    end if;
                    any := any or req(k);
                end loop;
                valid_q <= any;
                data_q <= d;
            end if;
        end if;
    end process;
    out_valid <= valid_q;
    out_data <= data_q;
end architecture;

library ieee;
use ieee.std_logic_1164.all;

entity edr_probe is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        a_valid  : in  std_logic_vector(23 downto 0);
        b_valid  : in  std_logic_vector(23 downto 0);
        data_in  : in  std_logic_vector(383 downto 0);
        grant    : out std_logic_vector(23 downto 0);
        out_valid : out std_logic;
        out_data : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of edr_probe is
    signal req : std_logic_vector(23 downto 0);
begin
    req <= a_valid and b_valid;

    arbiter : entity work.edr_probe_arbiter port map (
        clk => clk, rst => rst, req => req, data_in => data_in,
        grant => grant, out_valid => out_valid, out_data => out_data);
end architecture;
