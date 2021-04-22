library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.RV32I.all;

entity core_tb is  
end core_tb;

architecture tb of core_tb is

component core 
    port( 
        CLK      : in  std_logic;
        RESET    : in  std_logic;
        INST     : in  std_logic_vector(31 downto 0);
        DATA_IN  : in  std_logic_vector(XLEN - 1 downto 0);
        ADDR_OUT : out std_logic_vector(XLEN - 1 downto 0);
        DATA_OUT : out std_logic_vector(XLEN - 1 downto 0);
        LOAD     : out std_logic;
        STORE    : out std_logic;
        PC_OUT   : out std_logic_vector(XLEN - 1 downto 0)
    );
end component;

signal clk      : std_logic := '0';

signal reset    : std_logic := '0';
signal inst     : std_logic_vector(31 downto 0) := (others => '0');
signal data_in  : std_logic_vector(XLEN - 1 downto 0) := (others => 'Z');
signal addr_out : std_logic_vector(XLEN - 1 downto 0) := (others => 'Z');
signal data_out : std_logic_vector(XLEN - 1 downto 0) := (others => 'Z');
signal load     : std_logic := '0';
signal store    : std_logic := '0';
signal pc_out   : std_logic_vector(XLEN - 1 downto 0) := (others => '0');

signal mem_data_link : std_logic_vector(XLEN - 1 downto 0) := (others => 'Z'); -- used since no cache atm

begin

-- UUT instantation
uut: core 
port map (
    CLK      => clk,
    RESET    => reset,
    INST     => inst,
    DATA_IN  => mem_data_link,
    ADDR_OUT => mem_data_link,
    DATA_OUT => data_out,
    LOAD     => load,
    STORE    => store,
    PC_OUT   => pc_out
);

-- Clock generation, specify the half period of the clock here
clk <= not clk after 1 ns;


-- Main process
MAIN:process

    file inst_file : text open read_mode is "instructions.txt";  
    variable inst_l : line;
    variable instruction : std_logic_vector(31 downto 0);
    variable read_good : boolean := false;
    
    file dump_file : text open write_mode is "dump.txt";
    variable dump_l : line;

begin

-- INIT
-- Open output file with this format: INSTRUCTION BINARY **COMPONENT SIGNALS** REGISTER0..31 
    
    --dump_l := "INSTRUCTION PC LOAD STORE DATA_OUT"
    
    reset <= '1';
    wait on clk;
    reset <= '0';
    
mainloop: loop
    
    -- Input format: 1 instruction per line
    if(not endfile(inst_file)) then
      readline(inst_file, inst_l);
      hread(inst_l, instruction, read_good);
    else
      exit mainloop; -- Exit condition
    end if;
    
    inst <= instruction;
    
    wait on CLK;
    wait on CLK;

end loop;


file_close(inst_file);
file_close(dump_file);

report "Just Kidding.   Test Done."  severity failure ;

wait;
end process;


end architecture tb;
