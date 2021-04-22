library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.RV32I.all;

entity alu_tb is  
end alu_tb;

architecture tb of alu_tb is

component alu 
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
end component;


signal    op1            : std_logic_vector(XLEN-1 downto 0) := (others => '0');
signal    op2            : std_logic_vector(XLEN-1 downto 0) := (others => '0');
signal    imm_val        : std_logic_vector(XLEN-1 downto 0) := (others => '0');
signal    pc             : std_logic_vector(XLEN-1 downto 0) := (others => '0');
signal    op             : std_logic := '0';
signal    imm            : std_logic := '0';
signal    jump           : std_logic := '0';
signal    jalr           : std_logic := '0';
signal    branch         : std_logic := '0';
signal    auipc          : std_logic := '0';
signal    funct7_bit     : std_logic := '0';
signal    funct3         : std_logic_vector(2 downto 0) := (others => '0');
signal    res            : std_logic_vector(XLEN-1 downto 0) := (others => '0');
signal    branch_success : std_logic := '0';



begin

-- UUT instantation
uut: alu 
port map (
    OP1            => op1,
    OP2            => op2,
    IMM_VAL        => imm_val,
    PC             => pc,
    OP             => op,
    IMM            => imm,
    JUMP           => jump,
    JALR           => jalr,
    BRANCH         => branch,
    AUIPC          => auipc,
    FUNCT7_BIT     => funct7_bit,
    FUNCT3         => funct3,
    RES            => res,
    BRANCH_SUCCESS => branch_success
);


-- Main process
MAIN:process

begin

imm <= '1';
funct3 <= FUNCT3_ADDSUB;
op1 <= x"00000001";
op2 <= x"00000002";
imm_val <= x"00000003";

wait for 10 ns;
op1 <= x"00000007";
op2 <= x"00000003";
imm_val <= x"00000002";

wait for 10 ns;

report "Just Kidding.   Test Done."  severity failure ;
wait;
end process;


end architecture tb;
 
