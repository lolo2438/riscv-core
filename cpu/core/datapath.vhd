library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RV32I.all;

entity datapath is
  port( CLK      : in  std_logic;
        RESET    : in  std_logic;
        INST     : in  std_logic_vector(31 downto 0);
        DATA_IN  : in  std_logic_vector(XLEN - 1 downto 0);
        ADDR_OUT : out std_logic_vector(XLEN - 1 downto 0);
        DATA_OUT : out std_logic_vector(XLEN - 1 downto 0);
        LOAD     : out std_logic;
        STORE    : out std_logic;
        PC_OUT   : out std_logic_vector(XLEN - 1 downto 0)
  );
end datapath;

architecture rtl of datapath is

  constant zero      : std_logic_vector(XLEN-1 downto 0) := (others => '0');

  signal simm_val    : signed(XLEN-1 downto 0);
  signal sinst       : signed(31 downto 0);
  signal imm_val     : std_logic_vector(XLEN-1 downto 0);

  signal funct3      : std_logic_vector(2 downto 0);
  signal funct7      : std_logic_vector(6 downto 0);

  signal pc          : std_logic_vector(XLEN-1 downto 0);
  signal pc_plus_4   : std_logic_vector(XLEN-1 downto 0);
  signal s_pc_out    : std_logic_vector(XLEN-1 downto 0);

  -- decoder
  signal regfile_we  : std_logic;
  signal op          : std_logic;
  signal imm         : std_logic;
  signal s_load      : std_logic;
  signal s_store     : std_logic;
  signal jump        : std_logic;
  signal jalr        : std_logic;
  signal branch      : std_logic;
  signal auipc       : std_logic;
  signal lui         : std_logic;

  -- regfile
  signal regfile_op1 : std_logic_vector(XLEN-1 downto 0);
  signal regfile_op2 : std_logic_vector(XLEN-1 downto 0);

  -- sign/zero ext
  signal mem_in_data : std_logic_vector(XLEN-1 downto 0);

  -- alu
  signal alu_res     : std_logic_vector(XLEN-1 downto 0);
  signal branch_success : std_logic;
  -- wb
  signal wb_res      : std_logic_vector(XLEN-1 downto 0);
  signal rd_in       : std_logic_vector(XLEN-1 downto 0);

begin
  --------
  -- PC --
  --------

  process(CLK,RESET)
  begin
    if RESET = '1' then
      pc <= (others => '0');
    elsif rising_edge(CLK) then
      pc <= s_pc_out;
    end if;
  end process;

  pc_plus_4 <= std_logic_vector(unsigned(pc) + b"100");

  s_pc_out <= alu_res                        when ((jump = '1') or (branch_success = '1')) else
              alu_res(XLEN-1 downto 1) & '0' when (jalr = '1')                             else
              pc_plus_4;

  ------------
  -- DECODE --
  ------------
  DECODE: entity work.decoder(rtl)
    port map(
      OPCODE => INST(6 downto 0),
      WE     => regfile_we,
      OP     => op,
      IMM    => imm,
      LOAD   => s_load,
      STORE  => s_store,
      JUMP   => jump,
      JALR   => jalr,
      BRANCH => branch,
      AUIPC  => auipc,
      LUI    => lui
    );

  funct3 <= INST(14 downto 12);
  funct7 <= INST(31 downto 25);

  ----------------
  -- IMMEDIATES --
  ----------------

  -- Todo : Tidy up by making 6 5 signals: u_imm, j_imm, i_imm .. etc
  sinst <= signed(INST);

  simm_val <= resize(sinst(31) & sinst(30 downto 25) & sinst(24 downto 21) & sinst(20), XLEN)                             when ((imm = '1') or (s_load = '1') or (jalr = '1')) else
              resize(sinst(31) & sinst(30 downto 25) & sinst(11 downto 8) & sinst(7), XLEN)                               when (s_store = '1')                                 else
              resize(sinst(31) & sinst(30 downto 25) & sinst(11 downto 8) & '0', XLEN)                                    when (branch = '1')                                  else
              sinst(31) & sinst(30 downto 20) & sinst(19 downto 12) & signed(zero(12 downto 0))                           when ((lui = '1') or (auipc = '1'))                  else
              resize(sinst(31) & sinst(19 downto 12) & sinst(20) & sinst(30 downto 25) & sinst(24 downto 21) & '0', XLEN) when (jump = '1')                                    else
              (others => '-');

  imm_val <= std_logic_vector(simm_val);

  ---------
  -- REG --
  ---------

  REGFILE: entity work.regfile(rtl)
  port map(
    RS1 => INST(19 downto 15),
    RS2 => INST(24 downto 20),
    RD  => INST(11 downto 7),
    RES => rd_in,
    WE  => regfile_we,
    OP1 => regfile_op1,
    OP2 => regfile_op2
  );

  -------------------
  -- SIGN/ZERO EXT --
  -------------------
  with funct3 select
    mem_in_data <= std_logic_vector(resize(signed(DATA_IN(7 downto 0)), XLEN))    when FUNCT3_LB,
                   std_logic_vector(resize(signed(DATA_IN(15 downto 0)), XLEN))   when FUNCT3_LH,
                   DATA_IN                                                        when FUNCT3_LW,
                   std_logic_vector(resize(unsigned(DATA_IN(7 downto 0)), XLEN))  when FUNCT3_LBU,
                   std_logic_vector(resize(unsigned(DATA_IN(15 downto 0)), XLEN)) when FUNCT3_LHU,
                   (others => 'Z')                                                when others;

  ---------
  -- ALU --
  ---------

  ALU: entity work.alu(rtl)
    port map(
      OP1            => regfile_op1,
      OP2            => regfile_op2,
      IMM_VAL        => imm_val,
      PC             => pc,
      OP             => op,
      IMM            => imm,
      JUMP           => jump,
      JALR           => jalr,
      BRANCH         => branch,
      AUIPC          => auipc,
      FUNCT7_BIT     => funct7(5),
      FUNCT3         => funct3,
      RES            => alu_res,
      BRANCH_SUCCESS => branch_success
    );

  --------
  -- WB --
  --------
  wb_res <= pc_plus_4       when ((jump = '1') or (jalr = '1'))               else
            alu_res         when ((op = '1') or (auipc = '1') or (imm = '1')) else
            imm_val         when (lui = '1')                                  else
            (others => '-');

  rd_in <= mem_in_data when (s_load = '1') else wb_res;

  ----------------
  -- Memory Out --
  ----------------

  ADDR_OUT <= alu_res when ((s_load = '1') or (s_store = '1')) else (others => 'Z');

  process(s_store, funct3)
  begin
    if (s_store = '1') then
      case funct3 is
        when FUNCT3_SB => DATA_OUT <= zero(XLEN-1 downto 8) & regfile_op2(7 downto 0);
        when FUNCT3_SH => DATA_OUT <= zero(XLEN-1 downto 16) & regfile_op2(15 downto 0);
        when FUNCT3_SW => DATA_OUT <= regfile_op2;
        when others => DATA_OUT <= (others => 'Z');
      end case;
    end if;
  end process;

  LOAD <= s_load;
  STORE <= s_store;

  -----------------------
  -- EXCEPTION HANDLER --
  -----------------------
  -- load at x0 must be ditched.
  -- misaligned exeption: Jump, JALR, Branch if success. TODO: bit 1 and 0 must be checked on PC + offset, if either one is 1 then there is a misalignment
  --                      Note: If does not supports misaligned data (packed structs) Load and Store can cause this kind of exception for target address.


end architecture rtl;
