library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
  port (clk, MemWrite      : in  std_logic;
        adresse, WriteData : in  std_logic_vector(XLEN-1 downto 0);
        ReadData           : out std_logic_vector(XLEN-1 downto 0)
  );
end;

architecture ram OF dmem IS
  CONSTANT MEM_SIZE     : integer := 128; -- Nombre de mots (a ajuster en
                                          -- fonction des adresses utilises par
                                          -- le programme
  TYPE ramtype IS ARRAY (MEM_SIZE-1 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL mem            : ramtype;
  -- Nombre de bits d'adresse selon le nombre de mots
  CONSTANT LOG_MEM_SIZE : integer := integer(ceil(log2(real(MEM_SIZE))));

begin
 
  -- Port de lecture combinatoire
  ReadData <= mem(to_integer(unsigned((adresse(LOG_MEM_SIZE-1 DOWNTO 0)))));
end ram;
