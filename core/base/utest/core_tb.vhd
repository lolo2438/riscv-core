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

  signal clk      : std_logic := '0';
  signal reset    : std_logic;
  signal inst     : std_logic_vector(31 downto 0);
  signal data_in  : std_logic_vector(XLEN - 1 downto 0);
  signal addr_out : std_logic_vector(XLEN - 1 downto 0);
  signal data_out : std_logic_vector(XLEN - 1 downto 0);
  signal load     : std_logic;
  signal store    : std_logic;
  signal pc_out   : std_logic_vector(XLEN - 1 downto 0);

  signal dmem_data : std_logic_vector(XLEN - 1 downto 0);

begin

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

    inst_mem : entity work.imem(rom)
      port map(
        addr => pc_out,
        data => inst
      );

    dmem_data <= data_out when store = '1' else
                 data_in when load = '1' else
                 (others => 'Z');

    data_mem : entity work.dmem(ram)
      port ( addr => addr_out,
             data => dmem_data,
             cs => '1',
             oe => load,
             we => store
      );

    -- Clock process;
    clk <= not clk after half_period;


end architecture tb;
