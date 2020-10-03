library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity imem is 
  port (addr : in  std_logic_vector(XLEN-1 downto 0);
        data : out std_logic_vector(XLEN-1 downto 0));
end;

architecture rom of imem is

  constant rom_size : positive := 2**XLEN; -- maybe too big for simulation...
  type romtype is array (0 to rom_size) of std_logic_vector(XLEN-1 downto 0);

  constant mem : romtype := (
    0  => x"20030001",	-- main:   addi $3, $0, 1
    1  => x"2067000B",	-- addi $7, $3, 11
    2  => x"00671024",  -- and  $2, $3, $7
    3  => x"AC472000",  -- sw   $7, 8192($2)
    4  => x"00432820",  -- add  $5, $2, $3
    5  => x"8CA21FFF",  -- lw   $2, 8191($5)
	6  => x"00000020",  -- NOP
	7  => x"10430004",  -- To:     beq  $2, $3, next
	8  => x"00000020",  -- NOP
	9  => x"00000020",  -- NOP
    10 => x"08000007",	-- j    To
	11 => x"2063000B",	-- addi $3, $3, 11
    12 => x"00A7202A",	-- next:   slt  $4, $5, $7
    13 => x"10820003",	-- beq  $4, $2, around
    14 => x"00000020",  -- NOP
	15 => x"00000020",  -- NOP
	16 => x"AC851FFF",	-- sw   $5, 8191($4)
    17 => x"00E2202A",	-- around: slt  $4, $7, $2
    18 => x"00622025",	-- or   $4, $3, $2
    19 => x"2067FFFF",	-- addi $7, $3, -1
    20 => x"00E23822",	-- sub  $7, $7, $2
    21 => x"8C621FF4",	-- lw   $2, 8180($3)
    22 => x"AC871FF4",	-- sw   $7, 8180($4)
    23 => x"00051820",	-- add  $3, $0, $5
    24 => x"10A3FFE7",	-- beq  $5, $3, main
    25 => x"00000020",  -- NOP
	26 => x"00000020",  -- NOP
	others => (others => '0'));

begin

  process(addr)
  begin
    data <= mem(to_integer(unsigned((addr))));
  end process;
  
end rom;
