library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity imem is
  port (addr : in  std_logic_vector(5 downto 0);
        data : out std_logic_vector(XLEN-1 downto 0));
end;

architecture rom of imem is

  constant rom_size : positive := 32;
  type romtype is array (0 to rom_size) of std_logic_vector(XLEN-1 downto 0);

  constant mem : romtype := (
    0  => x"",	-- main:   addi $3, $0, 1
    1  => x"",	-- addi $7, $3, 11
    2  => x"",  -- and  $2, $3, $7
    3  => x"",  -- sw   $7, 8192($2)
    4  => x"",  -- add  $5, $2, $3
    5  => x"",  -- lw   $2, 8191($5)
	  6  => x"",  -- NOP
    7  => x"",  -- To:     beq  $2, $3, next
    8  => x"",  -- NOP
    9  => x"",  -- NOP
    10 => x"",	-- j    To
    11 => x"",	-- addi $3, $3, 11
    12 => x"",	-- next:   slt  $4, $5, $7
    13 => x"",	-- beq  $4, $2, around
    14 => x"",  -- NOP
    15 => x"",  -- NOP
    16 => x"",	-- sw   $5, 8191($4)
    17 => x"",	-- around: slt  $4, $7, $2
    18 => x"",	-- or   $4, $3, $2
    19 => x"",	-- addi $7, $3, -1
    20 => x"",	-- sub  $7, $7, $2
    21 => x"",	-- lw   $2, 8180($3)
    22 => x"",	-- sw   $7, 8180($4)
    23 => x"",	-- add  $3, $0, $5
    24 => x"",	-- beq  $5, $3, main
    25 => x"",  -- NOP
	  26 => x"",  -- NOP
	  others => (others => '0'));

begin

  process(addr)
  begin
    data <= mem(to_integer(unsigned((addr))));
  end process;

end rom;
