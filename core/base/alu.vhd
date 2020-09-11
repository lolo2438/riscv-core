library ieee;
use ieee.std_logic_1164.all;

use work.RV32I.all;

entity alu is
  port(
    OP1 : in  std_logic_vector(XLEN-1 downto 0);
    OP2 : in  std_logic_vector(XLEN-1 downto 0);
    IMM : in  std_logic_vector(XLEN-1 downto 0);
    RES : out std_logic_vector(XLEN-1 downto 0);

    R_TYPE : in std_logic;
    FUNCT3 : in std_logic_vector(2 downto 0);
    FUNCT7 : in std_logic_vector(6 downto 0)  -- todo optimization
  );
end alu;

architecture rtl of alu is

  constant zero : std_logic_vector(XLEN-1 downto 0) := (others => '0');

begin

  -- TO FIX: make parallel so slt can use sub op or find a fast slt module
  -- -> use a multiplexer to select correct output!!
  process(OP,OP2,IMM,R_TYPE)
    if R_TYPE <= '1' then
      case FUNCT3 is
        when FUNCT3_ADD =>
          if FUNCT7(5) = '0' then
            RES <= std_logic_vector(unsigned(OP1) + unsigned(OP2));
          else
            RES <= std_logic_vector(unsigned(OP1) + unsigned(not OP2) + 1);
          end if;
        when FUNCT3_SLL =>
          --todo
        when FUNCT3_SLT =>

        when FUNCT3_SLTU =>

        when FUNCT3_XOR =>
          RES <= OP1 xor OP2;
        when FUNCT3_SR =>
          if FUNCT7(5) = '0' then
            constant FUNCT7_SRL   : std_logic_vector(6 downto 0) := b"0000000";
            constant FUNCT7_SRA   : std_logic_vector(6 downto 0) := b"0100000";
          else
          end if;
        when FUNCT3_OR =>
          RES <= OP1 or OP2;
        when FUNCT3_AND =>
          RES <= OP1 and OP2;
      end case;
    end if;

end architecture rtl;
