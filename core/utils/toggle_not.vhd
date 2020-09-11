library ieee;
use ieee.std_logic_1164.all;

entity toggle_not is
  port(A      : in  std_logic;
       ENABLE : in  std_logic;
       B      : out std_logic);
end entity toggle_not;

architecture rtl of toggle_not is
begin

  with ENABLE select
    B <= not A when '1',
             A when others;

end architecture;
