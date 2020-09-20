library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RV32I.all;

entity regfile is
  port (
    RS1 : in  std_logic_vector(4 downto 0);
    RS2 : in  std_logic_vector(4 downto 0);
    RD  : in  std_logic_vector(4 downto 0);
    RES : in  std_logic_vector(XLEN-1 downto 0);
    WE  : in  std_logic;
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

  OP1 <= x(to_integer(unsigned(RS1)));
  OP2 <= x(to_integer(unsigned(RS2)));

  reg_write:
  process(WE, RES, RD)
  begin
    --TODO: Fix RD comparison
    if WE = '1' and (RD /= "00000") then
      x(to_integer(unsigned(RD))) <= RES;
    end if;
  end process;

end architecture rtl;
