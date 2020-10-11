library ieee;
use ieee.std_logic_1164.all;

entity mem is
  port(
    clk : in std_logic;
    addr : in std_logic_vector();
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0)
  );
end entity mem;

architecture rtl of mem is

begin

end architecture;
