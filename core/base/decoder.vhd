library ieee;
use ieee.std_logic_1164.all;

use work.RV32I.all;

entity decoder is
  port(
    OPCODE : in std_logic_vector(6 downto 0);
    R_TYPE : out std_logic;
    I_TYPE : out std_logic;
    S_TYPE : out std_logic;
    B_TYPE : out std_logic;
    U_TYPE : out std_logic;
    J_TYPE : out std_logic
  );
end entity decoder;

architecture rtl of decoder is

  signal type_vector : std_logic_vector(5 downto 0);

  -- RV32I INSTRUCTIONS
  constant r_type : positive := 0;
  constant i_type : positive := 1;
  constant s_type : positive := 2;
  constant b_type : positive := 3;
  constant u_type : positive := 4;
  constant j_type : positive := 5;

  -- EXTENSIONS

begin

  type_vector <=
    "000001" when (OPCODE = OP) else
      -- Maybe add i_type && r_type -> shift, i_type && s_type -> load, i_type && j_type -> jalr
    "000010" when (OPCODE = OP_IMM) or (OPCODE = OP_LOAD) or (OPCODE = OP_JALR) else
    "000100" when (OPCODE = OP_STORE) else
    "001000" when (OPCODE = OP_BRANCH) else
    "010000" when (OPCODE = OP_LUI) or (OPCODE = OP_AUIPC) else
    "100000" when (OPCODE = OP_JAL) else
    "000000" when others;

  -- RV32I INSTRUCTIONS
  R_TYPE <= type_vector(r_type);
  I_TYPE <= type_vector(i_type);
  S_TYPE <= type_vector(s_type);
  B_TYPE <= type_vector(b_type);
  U_TYPE <= type_vector(u_type);
  J_TYPE <= type_vector(j_type);

  -- EXTENSIONS

end architecture rtl;
