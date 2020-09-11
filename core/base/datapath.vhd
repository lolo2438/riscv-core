library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RV32I.all;

entity datapath is
  port( CLK : in std_logic;
        RESET : in std_logic;
        INST : in std_logic_vector(XLEN - 1 downto 0);
        PC : out std_logic_vector(XLEN-1 downto 0)
  );
end datapath;

architecture rtl of datapath is

  signal imm : std_logic_vector(XLEN-1 downto 0);

  signal pc : std_logic_vector(XLEN-1 downto 0);

  signal r_type : std_logic;
  signal i_type : std_logic;
  signal s_type : std_logic;
  signal b_type : std_logic;
  signal u_type : std_logic;
  signal j_type : std_logic;

begin
  --------
  -- PC --
  --------
  process(CLK,RESET)
  begin
    if RESET = '1' then
      pc <= (others => '0');
    elsif rising_edge(CLK) then
      pc <= pc + 4;
    end if;
  end process;

  ----------------
  -- IMMEDIATES --
  ----------------
  imm <= resize(INST(31), 31-11 + 1) & INST(30 downto 25) & INST(24 downto 21) & INST(20)                             when i_type else
         resize(INST(31), 31-11 + 1) & INST(30 downto 25) & INST(11 downto 8) & INST(7)                               when s_type else
         resize(INST(31), 31-12 + 1) & INST(30 downto 25) & INST(11 downto 8) & '0';                                  when b_type else
         INST(31) & INST(30 downto 20) & INST(19 downto 12) & resize('0',11-0 + 1);                                   when u_type else
         resize(INST(31), 31-20 + 1) & INST(19 downto 12) & INST(20) & INST(30 downto 25) & INST(24 downto 21) & '0'; when j_type else
         (others => '-') when others;

  ----------
  -- JUMP --
  ----------

  ------------
  -- BRANCH --
  ------------

  ---------
  -- ALU --
  ---------

  ---------
  -- REG --
  ---------

  ------------
  -- DECODE --
  ------------


end architecture rtl;
