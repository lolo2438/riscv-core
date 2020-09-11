library ieee;
use ieee.std_logic_1164.all;

use work.RV32I.all;

entity reg is
  port (
    RS1 : in  std_logic_vector(4 downto 0);
    RS2 : in  std_logic_vector(4 downto 0);
    RD  : in  std_logic_vector(4 downto 0);
    RES : in  std_logic_vector(XLEN-1 downto 0);
    OP1 : out std_logic_vector(XLEN-1 downto 0);
    OP2 : out std_logic_vector(XLEN-1 downto 0)
  );
end entity reg;

architecture rtl of regfile is

type reg_type is array (31 downto 0) of std_logic_vector(XLEN-1 downto 0);

signal x : reg_type;

begin

end architecture rtl;
