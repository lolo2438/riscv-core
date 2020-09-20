library ieee;
use ieee.std_logic_1164.all;

use work.RV32I.all;

entity decoder is
  port(
    OPCODE : in  std_logic_vector(6 downto 0);
    WE     : out std_logic;
    OP     : out std_logic;
    IMM    : out std_logic;
    LOAD   : out std_logic;
    STORE  : out std_logic;
    JUMP   : out std_logic;
    JALR   : out std_logic;
    BRANCH : out std_logic;
    AUIPC  : out std_logic;
    LUI    : out std_logic
  );
end entity decoder;

architecture rtl of decoder is

  -- RV32I INSTRUCTIONS
  signal s_op          : std_logic;
  signal s_imm         : std_logic;
  signal s_load        : std_logic;
  signal s_store       : std_logic;
  signal s_jump        : std_logic;
  signal s_jalr        : std_logic;
  signal s_branch      : std_logic;
  signal s_auipc       : std_logic;
  signal s_lui         : std_logic;

  -- EXTENSIONS

begin

  WE <= s_branch nor s_store;

  -- Decode
  s_op     <= '1' when (OPCODE = OP_OP)     else '0';
  s_imm    <= '1' when (OPCODE = OP_IMM)    else '0';
  s_load   <= '1' when (OPCODE = OP_LOAD)   else '0';
  s_store  <= '1' when (OPCODE = OP_STORE)  else '0';
  s_jump   <= '1' when (OPCODE = OP_JAL)    else '0';
  s_jalr   <= '1' when (OPCODE = OP_JALR)   else '0';
  s_branch <= '1' when (OPCODE = OP_BRANCH) else '0';
  s_auipc  <= '1' when (OPCODE = OP_AUIPC)  else '0';
  s_lui    <= '1' when (OPCODE = OP_LUI)    else '0';

  -- Mapping
  OP      <= s_op;
  IMM     <= s_imm;
  LOAD    <= s_load;
  STORE   <= s_store;
  JUMP    <= s_jump;
  JALR    <= s_jalr;
  BRANCH  <= s_branch;
  AUIPC   <= s_auipc;
  LUI     <= s_lui;

end architecture rtl;
