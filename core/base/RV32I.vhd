library ieee;
use ieee.std_logic_1164.all;

package RV32I is
-- TODO: Cleanup with Records maybe
  constant XLEN : integer := 32
  --                             R-type
  -- [31 funct7 25][24 rs2 20][19 rs1 15][14 funct3 13][11 rd 7][6 opcode 0]
  --                            I-type
  -- [31 funct7 20][19 rs1 15][14 funct3 13][11 rd 7][6 opcode 0]
  -- Shifts:[31 funct7 25][24 shamt 20][19 rs1 15][14 funct3 13][11 rd 7][6 opcode 0]
  --                            S-type
  -- [31 imm[11:5] 25][24 rs2 20][19 rs1 15][14 funct3 13][11 imm[4:0] 7][6 opcode 0]
  --                            B-type
  -- [31 imm[12|10:5] 25][24 rs2 20][19 rs1 15][14 funct3 13][11 imm[4:1:11] 7][6 opcode 0]
  --                            U-Type
  -- [31 imm[32:12] 12][11 rd 7][6 opcode 0]
  --                            J-Type
  -- [31 imm[20|10:1|11|19:12] 12][11 rd 7][6 opcode 0]

  -- OP CODES
  constant OP           : std_logic_vector(6 downto 0) := b"0110011";
  constant OP_JALR      : std_logic_vector(6 downto 0) := b"1100111";
  constant OP_IMM       : std_logic_vector(6 downto 0) := b"0010011";
  constant OP_LUI       : std_logic_vector(6 downto 0) := b"0110111";
  constant OP_AUIPC     : std_logic_vector(6 downto 0) := b"0010111";
  constant OP_JAL       : std_logic_vector(6 downto 0) := b"1101111";
  constant OP_BRANCH    : std_logic_vector(6 downto 0) := b"1100011";
  constant OP_STORE     : std_logic_vector(6 downto 0) := b"0100011";
  constant OP_LOAD      : std_logic_vector(6 downto 0) := b"0000011";
  constant OP_FENCE     : std_logic_vector(6 downto 0) := b"0001111";
  constant OP_SYSTEM    : std_logic_vector(6 downto 0) := b"1110011";

  -- R-type and I-type functs
  constant FUNCT3_ADD   : std_logic_vector(2 downto 0) := b"000";
  constant FUNCT7_ADD   : std_logic_vector(6 downto 0) := b"0000000";
  constant FUNCT7_SUB   : std_logic_vector(6 downto 0) := b"0100000";
  constant FUNCT3_SLL   : std_logic_vector(2 downto 0) := b"001";
  constant FUNCT3_SLT   : std_logic_vector(2 downto 0) := b"010";
  constant FUNCT3_SLTU  : std_logic_vector(2 downto 0) := b"011";
  constant FUNCT3_XOR   : std_logic_vector(2 downto 0) := b"100";
  constant FUNCT3_SR    : std_logic_vector(2 downto 0) := b"101";
  constant FUNCT7_SRL   : std_logic_vector(6 downto 0) := b"0000000";
  constant FUNCT7_SRA   : std_logic_vector(6 downto 0) := b"0100000";
  constant FUNCT3_OR    : std_logic_vector(2 downto 0) := b"110";
  constant FUNCT3_AND   : std_logic_vector(2 downto 0) := b"111";

  -- STORE
  constant FUNCT3_SB   : std_logic_vector(2 downto 0) := b"000";
  constant FUNCT3_SH   : std_logic_vector(2 downto 0) := b"001";
  constant FUNCT3_SW   : std_logic_vector(2 downto 0) := b"010";

  -- LOAD
  constant FUNCT3_LB   : std_logic_vector(2 downto 0) := b"000";
  constant FUNCT3_LH   : std_logic_vector(2 downto 0) := b"001";
  constant FUNCT3_LW   : std_logic_vector(2 downto 0) := b"010";
  constant FUNCT3_LBU  : std_logic_vector(2 downto 0) := b"100";
  constant FUNCT3_LHU  : std_logic_vector(2 downto 0) := b"101";

  -- BRANCH
  constant FUNCT3_BEQ  : std_logic_vector(2 downto 0) := b"000";
  constant FUNCT3_BNE  : std_logic_vector(2 downto 0) := b"001";
  constant FUNCT3_BLT  : std_logic_vector(2 downto 0) := b"100";
  constant FUNCT3_BGE  : std_logic_vector(2 downto 0) := b"101";
  constant FUNCT3_BLTU : std_logic_vector(2 downto 0) := b"110";
  constant FUNCT3_BGEU : std_logic_vector(2 downto 0) := b"111";

end package RV32I;
