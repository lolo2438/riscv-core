library ieee;
use ieee.std_logic_1164.all;

use work.RV32I.all;

entity shifter is
  port(
    OP    : in  std_logic_vector(XLEN-1 downto 0);  -- Operand
    SHAMT : in  std_logic_vector(XLEN_BIT-1 downto 0);
    LR    : in  std_logic;                          -- Shift Left (0)/Right (1)
    ARI   : in  std_logic;                          -- Arithmetic shift (1) only for shift right
    RES   : out std_logic_vector(XLEN-1 downto 0)  -- Shifted result
  );
end entity shifter;

----
architecture barrel of shifter is

  signal in;
  signal out;

begin

--Description: Array of buffer with decoder enabling the shifting 

end architecture barrel;

---
architecture logarithmic of shifter is

begin

--Description: Using SHAMT as enable pin, hardcode shifts by n,...,8,4,2,1. Ex: SHAMT = 00011: shift by 2 then shift by 1, result = shift by 3 

end architecture logarithmic;
