library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity adder_tb is
 generic(N : integer := 32);
end entity adder_tb;

architecture gen of adder_tb is

  signal A,B      : std_logic_vector(N-1 downto 0);
  signal C        : std_logic_vector(N-1 downto 0);
  signal OVERFLOW : std_logic;

begin

  DUT: entity work.adder(rtl)
    generic map(N)
    port map(A,B,C,OVERFLOW);

  GEN : process
    begin
      wait for 10 ns;
      A <= std_logic_vector(unsigned(A) + 1);
      B <= std_logic_vector(unsigned(B) + 3);
    end process GEN;

  REPORT: process
    begin
      wait for 100 ns;
        assert false report "A = B = "  -- todo
        severity note;
    end process REPORT;

  VERIFY: process
    begin
      wait on A,B;
      wait for 5 ns;
      assert(C = std_logic_vector(unsigned(A) + unsigned(B)))
        report "C /= A + B"
        SEVERITY error;
    end process VERIFY;

end architecture gen;
