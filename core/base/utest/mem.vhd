library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
	port(
		addr 	 : in  std_logic_vector(XLEN-1 downto 0);
		data_in  : in  std_logic_vector(XLEN-1 downto 0);
		we   	 : in  std_logic;
		data_out : out std_logic_vector(XLEN-1 downto 0);
	);
end entity mem;

architecture ram of mem is

	constant ram_size : positive := 2**XLEN;
	type ram_type is (o to ram_size) of std_logic_vector(
begin

end architecture ram;