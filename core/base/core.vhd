library ieee;
library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity core is
  port(
    CLK : in std_logic;
    ADDR_IN : in std_logic_vector(XLEN-1 downto 0);
    MEM_IN : in std_logic_vector(XLEN-1 downto 0)
  );
end entity core;

architecture rtl of core is

begin

-- icache

-- dcache

-- datapath

end architecture rtl;
