library ieee;
use ieee.std_logic_1164.all;

entity twocomp is
  generic(N : integer range 2 to 1024 := 32);
  port(A : in  std_logic_vector(N-1 downto 0);
       B : out std_logic_vector(N-1 downto 0));
end entity twocomp;


architecture rtl of twocomp is
begin

  process(a)
    B <= std_logic_vector((not unsigned(A)) + 1);
  end process;

end architecture rtl;


-- Concept:
-- Every bits of input A goes through a not gate that will invert if enable or let through if disabled
-- The enable condition is made of incrementing redux or gates
architecture structural of twocomp is
  signal enable : std_logic_vector(N-1 downto 1);
begin

  B(0) <= A(0);
  toggle_not_gen: for I range 1 to N-1 generate
    toggle_not: entity work.toggle_not(rtl)
    port map(A(I), enable(I), B(I));
  end generate toggle_not_gen;

  enable(1) <= A(0);
  enable_gen: for i range 2 to N-1 generate
      enable(I) <= enable(i - 1) or A(i - 1);
  end generate enable_gen;

end architecture structural;
