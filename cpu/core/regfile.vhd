library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RV32I.all;

entity regfile is
  port (
    RST : in  std_logic;
    RS1 : in  std_logic_vector(4 downto 0);
    RS2 : in  std_logic_vector(4 downto 0);
    RD  : in  std_logic_vector(4 downto 0);
    RES : in  std_logic_vector(XLEN-1 downto 0);
    WE  : in  std_logic;
    WR  : in  std_logic;                          -- Added write signal, Activate this to write the result in RD
    OP1 : out std_logic_vector(XLEN-1 downto 0);
    OP2 : out std_logic_vector(XLEN-1 downto 0)
  );
end entity regfile;

architecture rtl of regfile is

  constant zero : std_logic_vector(XLEN-1 downto 0) := (others => '0');

  type reg_type is array (NUM_REG-1 downto 0) of std_logic_vector(XLEN-1 downto 0);
  signal x : reg_type;
  
begin

  -- x0 hard wired to zero
  x(0) <= zero;
  
  -- Will need to update read procedure when pipelined
  OP1 <= x(to_integer(unsigned(RS1)));
  OP2 <= x(to_integer(unsigned(RS2)));
  
  reg_write:
  process(RST, WE, RES, RD)
  begin
    
    -- FIXME: Race course between write and read. Fix by making register file a READ-BEFORE-WRITE.
    
    if(RST = '1') then
      x <= (others => (others => '0'));
      
    elsif WE = '1' and (RD /= b"00000") and WR = '1' then
      x(to_integer(unsigned(RD))) <= RES;
      
    end if;
  end process;

end architecture rtl;
