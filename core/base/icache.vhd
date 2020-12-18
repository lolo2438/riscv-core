library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity icache is
  port ( -- Interface with system
         addr_in    : in  std_logic_vector(XLEN-1 downto 0);  -- Address to store instruction
         inst_in    : in  std_logic_vector(31 downto 0);      -- Instruction to store
         we         : in  std_logic;                          -- Write enable for instruction

         -- Interface with core
         addr_core  : in  std_logic_vector(XLEN-1 downto 0);  -- Requested instruction's address
         inst_core  : out std_logic_vector(31 downto 0)       -- Instruction requested from core
  );
end;

architecture cache OF icache IS

begin

end cache;
