library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RV32I.all;

entity alu is
  port(
    OP1            : in  std_logic_vector(XLEN-1 downto 0);
    OP2            : in  std_logic_vector(XLEN-1 downto 0);
    IMM_VAL        : in  std_logic_vector(XLEN-1 downto 0);
    PC             : in  std_logic_vector(XLEN-1 downto 0);
    OP             : in  std_logic;
    IMM            : in  std_logic;
    JUMP           : in  std_logic;
    JALR           : in  std_logic;
    BRANCH         : in  std_logic;
    AUIPC          : in  std_logic;
    FUNCT7_BIT     : in  std_logic;
    FUNCT3         : in  std_logic_vector(2 downto 0);
    RES            : out std_logic_vector(XLEN-1 downto 0);
    BRANCH_SUCCESS : out std_logic
  );
end alu;

architecture rtl of alu is

  constant zero : std_logic_vector(XLEN-1 downto 0) := (others => '0');
  
  signal src1            : std_logic_vector(XLEN-1 downto 0);
  signal src2            : std_logic_vector(XLEN-1 downto 0);

  signal adder_src1      : unsigned(XLEN downto 0);

  signal add_res         : std_logic_vector(XLEN downto 0);
  signal s_is_lesser     : std_logic;
  signal u_is_lesser     : std_logic;
  signal is_equal        : std_logic;

  signal shamt           : integer range 0 to XLEN;

  signal shift_left_res  : std_logic_vector(XLEN-1 downto 0);
  signal shift_right_res : std_logic_vector(XLEN-1 downto 0);

  signal result          : std_logic_vector(XLEN-1 downto 0);

  signal branch_res      : std_logic;
  
  signal branch_slt_res  : std_logic;
  signal slt_res         : std_logic;
  signal branch_sltu_res : std_logic;
  signal sltu_res        : std_logic;

begin

  -- Src values for OP
  src1 <= PC when ((AUIPC = '1') or (JUMP = '1') or (BRANCH = '1') or (JALR = '1')) else OP1;

  src2 <= IMM_VAL when (OP = '0') else OP2;

  -- Adder
  adder_src1 <= (('0' & unsigned((not src1))) + 1) when (((OP = '1') or (IMM = '1')) and (FUNCT7_BIT = '1')) else ('0' & unsigned(src1));

  add_res <= std_logic_vector(adder_src1(XLEN-1 downto 0) + ('0' & unsigned(src2)));

  --Shift circuit:
  -- TODO: REMOVE CIRCUIT AND IMPLEMENT THIS:
  --
  -- SHIFT RIGHT LOGICAL = 
  -- SHIFT LEFT LOGICAL =
  
  shamt <= to_integer(unsigned(src2(4 downto 0))); --FIXME: Interger conversion error 

  shift_right_res <= std_logic_vector(shift_right(signed(src1), shamt)) when (FUNCT7_BIT = '1') else
                     std_logic_vector(shift_right(unsigned(src1), shamt));
                    
  shift_left_res <= std_logic_vector(shift_left(unsigned(src1), shamt)); 

  -- SLT 
  
  branch_slt_res <= '1' when ((signed(OP1)) < (signed(OP2))) else '0';
  
  slt_res <= '1' when ((signed(src1)) < (signed(src2))) else '0'; -- FIXME: Does not like the <
  
  s_is_lesser <= branch_slt_res when (BRANCH = '1') else slt_res;
                 
  
  -- SLTU
  branch_sltu_res <= '1' when ((unsigned(OP1)) < (unsigned(OP2))) else '0';
  
  sltu_res <= '1' when ((unsigned(src1)) < (unsigned(src2))) else '0'; -- FIXME: Does not like the <
  
  u_is_lesser <= branch_sltu_res when (BRANCH = '1') else sltu_res;
  

  -- Selector
  with funct3 select
    result <= add_res(XLEN-1 downto 0) when FUNCT3_ADDSUB, -- Redundant...
              shift_left_res           when FUNCT3_SLL,
              zero(XLEN-1 downto 1) & s_is_lesser  when FUNCT3_SLT,
              zero(XLEN-1 downto 1) & u_is_lesser  when FUNCT3_SLTU,
              (src1 xor src2)          when FUNCT3_XOR,
              shift_right_res          when FUNCT3_SR,
              (src1 or src2)           when FUNCT3_OR,
              (src1 and src2)          when FUNCT3_AND,
              (others => '-')          when others;

  RES <= result when ((OP = '1') or (IMM ='1')) else add_res(XLEN-1 downto 0);

  -- Branch
  is_equal <= '1' when (OP1 = OP2) else '0';

  -- is_equal and is_lesser must be on OP1 and OP2 when branching,
  -- because SRC1 and SRC2 are addr + offset...
  with FUNCT3 select
    branch_res <= is_equal                      when FUNCT3_BEQ,
                  (not is_equal)                when FUNCT3_BNE,
                  s_is_lesser                   when FUNCT3_BLT,
                  (not s_is_lesser) or is_equal when FUNCT3_BGE,
                  u_is_lesser                   when FUNCT3_BLTU,
                  (not u_is_lesser) or is_equal when FUNCT3_BGEU,
                  '-'                           when others;

  BRANCH_SUCCESS <= branch_res when (BRANCH = '1') else '0';

end architecture rtl;
