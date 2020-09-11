library ieee;
use ieee.std_logic_1164.all;

entity adder is
  generic(
    N : integer := 32
  );
  port(
    A,B      : in  std_logic_vector(N-1 downto 0);
    C        : out std_logic_vector(N-1 downto 0);
    OVERFLOW : out std_logic
  );
end entity adder;

architecture rtl of adder is
  use ieee.numeric_std.all;
  signal result : std_logic_vector(N downto 0);

begin

  result <= std_logic_vector((unsigned('0' & A)) + (unsigned('0' & B)));

  C <= result(N-1 downto 0);
  OVERFLOW <= result(N);

end architecture rtl;
