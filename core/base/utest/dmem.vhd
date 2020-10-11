library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmem is
  port ( addr       : in     std_logic_vector(31 downto 0);
         data       : inout  std_logic_vector(31 downto 0);
         cs, oe, we : in     std_logic  -- Chip select, output enable, write enable
  );
end;

architecture ram OF dmem IS

  -- BYTE_SIZE: Number of bits in a byte
  constant BYTE_SIZE : positive := 8;
  -- MEM_SIZE_WORD: Ammount of XLEN sized word that we can store in mem, make this a power of 2
  constant MEM_SIZE_WORD : positive := 4;
  -- MEM_SIZE_BYTE: Number of bytes needed to store MEM_SIZE_WORD
  constant MEM_SIZE_BYTE : positive := MEM_SIZE_WORD * (XLEN/BYTE_SIZE);
  -- MEM_SIZE: Number of bits needed for ramtype
  constant MEM_SIZE : positive := log2(MEM_SIZE_BYTE);

  type ramtype is array (MEM_SIZE-1 downto 0) of std_logic_vector (7 downto 0);
  signal mem : ramtype := (others=>(others=>'0');

  signal s_addr : positive;

begin

  s_addr <= to_integer(unsigned(addr(xx downto 0));

  -- Little endian
  process(addr,cs,oe,we)
  begin
    if cs = '1' then
      if we = '1' then
        mem(s_addr+0) <= data(7 downto 0);
        mem(s_addr+1) <= data(15 downto 8);
        mem(s_addr+2) <= data(23 downto 16);
        mem(s_addr+3) <= data(31 downto 24);
      else
        if oe = '1' then
          data(7 downto 0)   <= mem(s_addr+0);
          data(15 downto 8)  <= mem(s_addr+1);
          data(23 downto 16) <= mem(s_addr+2);
          data(31 downto 24) <= mem(s_addr+3);
        else
          data => (others => 'Z');
        end if;
      end if;
    else
      data => (others => 'Z');
    end if;
  end process;

end ram;
