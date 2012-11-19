----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:01:53 08/13/2009 
-- Design Name: 
-- Module Name:    PS2_ID - PS2_ID_RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pipeline Stage 2 : Instruction Decode
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2_ID is
    port (
        CLK : in STD_LOGIC;
        ACLRL : in STD_LOGIC;
        -- input from previous pipeline stage
        N : in STD_LOGIC_VECTOR(31 downto 0);
        IR : in STD_LOGIC_VECTOR(31 downto 0);
        -- input from other components/stages
        CtrlSignals : in STD_LOGIC_VECTOR(4 downto 0); -- CU
        IDEXFlush : in STD_LOGIC; -- CU
        MEMWB_RegWrite : in STD_LOGIC; -- WB stage
        WR : in STD_LOGIC_VECTOR(4 downto 0); -- WB stage
        WD : in STD_LOGIC_VECTOR(31 downto 0); -- WB stage
        -- output to next pipeline stage
        IDEXout_N : out STD_LOGIC_VECTOR(31 downto 0);
        IDEXout_D : out STD_LOGIC_VECTOR(31 downto 0);
        IDEXout_A : out STD_LOGIC_VECTOR(31 downto 0);
        IDEXout_B : out STD_LOGIC_VECTOR(31 downto 0);
        IDEXout_WR : out STD_LOGIC_VECTOR(4 downto 0);
        IDEXout_SHAMT : out STD_LOGIC_VECTOR(4 downto 0);
        IDEXout_I : out STD_LOGIC_VECTOR(31 downto 0);
        IDEXout_RS : out STD_LOGIC_VECTOR(4 downto 0);
        IDEXout_RT : out STD_LOGIC_VECTOR(4 downto 0);
        -- output to other components/stages
        RS : out STD_LOGIC_VECTOR(4 downto 0); -- DHDU
        RT : out STD_LOGIC_VECTOR(4 downto 0) -- DHDU
    );
end PS2_ID;

architecture PS2_ID_STRUCT of PS2_ID is

    -- components --
    component PSD is
        port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (25 downto 0);
            O : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component MUX_N_2IN1 is
        generic (N : positive);
        port (
            A : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            B : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            Sel : in  STD_LOGIC;
            O : out  STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component REGFILE_BR32X32 is
        port (
            CLK : in  STD_LOGIC;
            RADDR_A : in  STD_LOGIC_VECTOR (4 downto 0);
            RADDR_B : in  STD_LOGIC_VECTOR (4 downto 0);
            WADDR : in  STD_LOGIC_VECTOR (4 downto 0);
            WDAT : in  STD_LOGIC_VECTOR (31 downto 0);
            WE : in  STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            RDAT_A : out  STD_LOGIC_VECTOR (31 downto 0);
            RDAT_B : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component MUX_N_4IN1 is
        generic (N : positive);
        port (
            A : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            B : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            C : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            D : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            Sel : in  STD_LOGIC_VECTOR (1 downto 0);
            O : out  STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component SIGNZEROEXT_16TO32 is
        port (
            I : in  STD_LOGIC_VECTOR (15 downto 0);
            SignZero : in  STD_LOGIC;
            O : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component REG_N_wSACLRL is
        generic (N : positive);
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
            SCLRL : in STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    -- signals --
    -- control signals
    signal RegWrite : STD_LOGIC;
    signal RtZero : STD_LOGIC;
    signal RegDst : STD_LOGIC_VECTOR(1 downto 0);
    signal isLUI : STD_LOGIC;
    signal SignZero : STD_LOGIC;

    -- PSD unit output
    signal s_PSDOut : STD_LOGIC_VECTOR(31 downto 0);
    -- rt register selector output
    signal s_RtMuxOut : STD_LOGIC_VECTOR(4 downto 0);
    -- register file's A output
    signal s_DataAOut : STD_LOGIC_VECTOR(31 downto 0);
    -- register file's B output
    signal s_DataBOut : STD_LOGIC_VECTOR(31 downto 0);
    -- destination register selector output
    signal s_DestRegMuxOut : STD_LOGIC_VECTOR(4 downto 0);
    -- shift amount selector output
    signal s_ShamtMuxOut : STD_LOGIC_VECTOR(4 downto 0);
    -- sign extention output
    signal s_SZExtOut : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- control signal mapping
    RegWrite <= MEMWB_RegWrite;

    SignZero <= CtrlSignals(4);
    isLUI <= CtrlSignals(3);
    RegDst <= CtrlSignals(2 downto 1);
    RtZero <= CtrlSignals(0);

PSDUnit: PSD
    port map (
        A => N(31 downto 28),
        B => IR(25 downto 0),
        O => s_PSDOut
    );

RtMux: MUX_N_2IN1
    generic map (N => 5)
    port map (
        A => "00000",
        B => IR(20 downto 16),
        Sel => RtZero,
        O => s_RtMuxOut
    );

RegisterFile: REGFILE_BR32X32
    port map (
        CLK => CLK,
        RADDR_A => IR(25 downto 21),
        RADDR_B => s_RtMuxOut,
        WADDR => WR,
        WDAT => WD,
        WE => RegWrite,
        ACLRL => ACLRL,
        RDAT_A => s_DataAOut,
        RDAT_B => s_DataBOut
    );

DestRegMux: MUX_N_4IN1
    generic map (N => 5)
    port map (
        A => s_RtMuxOut,
        B => IR(15 downto 11),
        C => "11111",
        D => "-----",
        Sel => RegDst,
        O => s_DestRegMuxOut
    );

ShamtMux: MUX_N_2IN1
    generic map (N => 5)
    port map (
        A => IR(10 downto 6),
        B => "10000",
        Sel => isLUI,
        O => s_ShamtMuxOut
    );

SignExt: SIGNZEROEXT_16TO32
    port map (
        I => IR(15 downto 0),
        SignZero => SignZero,
        O => s_SZExtOut
    );

    -- input for the DHDU
    RS <= IR(25 downto 21);
    RT <= s_RtMuxOut;


    -- ID/EX pipeline registers --
IDEX_N: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => N,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_N
    );

IDEX_D: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_PSDOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_D
    );

IDEX_A: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_DataAOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_A
    );

IDEX_B: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_DataBOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_B
    );

IDEX_WR: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => s_DestRegMuxOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_WR
    );

IDEX_SHAMT: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => s_ShamtMuxOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_SHAMT
    );

IDEX_I: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_SZExtOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_I
    );

IDEX_RS: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => IR(25 downto 21),
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_RS
    );

IDEX_RT: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => s_RtMuxOut,
        SCLRL => IDEXFlush,
        ACLRL => ACLRL,
        Q => IDEXout_RT
    );

end PS2_ID_STRUCT;

