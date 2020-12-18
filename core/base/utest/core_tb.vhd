library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity core_tb is
end core_tb;

architecture tb of core_tb is

  constant period : time := 20 ns;
  constant half_period : time := 10 ns;

  signal begin_simultation : boolean := false;
  signal clk      : std_logic := '0';
  signal reset    : std_logic;
  signal inst     : std_logic_vector(31 downto 0);
  signal data_in  : std_logic_vector(XLEN - 1 downto 0);
  signal addr_out : std_logic_vector(XLEN - 1 downto 0);
  signal data_out : std_logic_vector(XLEN - 1 downto 0);
  signal load     : std_logic;
  signal store    : std_logic;
  signal pc_out   : std_logic_vector(XLEN - 1 downto 0);

  signal cache_addr : std_logic_vector(XLEN - 1 downto 0);
  signal cache_data : std_logic_vector(XLEN - 1 downto 0);

begin

  -- Clock process;
  clk <= not clk after half_period when begin_simulation = true;

  -- Cache
  cache : entity work.cache(ram)
    port ( addr => cache_addr,
           data => cache_data,
           cs => '1',
           oe => load,
           we => store
    );

  cache_op: process(clk)
  begin

    if (rising_edge(clk)) and (begin_simulation = true) then
      cache_data <=
    elsif begin_simulation = false then
      -- Read file
      -- Load memory
      begin_simulation := true;
    end if;
  end process;

  core : entity work.datapath(rtl)
    port map(
      CLK      => clk,
      RESET    => reset,
      INST     => inst,
      DATA_IN  => data_in,
      ADDR_OUT => addr_out,
      DATA_OUT => data_out,
      LOAD     => load,
      STORE    => store,
      PC_OUT   => pc_out
    );

end architecture tb;
