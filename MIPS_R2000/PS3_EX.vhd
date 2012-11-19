----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:02:42 08/13/2009 
-- Design Name: 
-- Module Name:    PS3_EX - PS3_EX_RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pipeline Stage 3 : Execution
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

entity PS3_EX is
    port (
        CLK : in STD_LOGIC;
        ACLRL : in STD_LOGIC;
        -- input from previous pipeline stage
        N : in STD_LOGIC_VECTOR(31 downto 0);
        D : in STD_LOGIC_VECTOR(31 downto 0);
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0);
        I : in STD_LOGIC_VECTOR(31 downto 0);
        SHAMT : in STD_LOGIC_VECTOR(4 downto 0);
        WR : in STD_LOGIC_VECTOR(4 downto 0);
        -- input from other components/stages
        CtrlSignals : in STD_LOGIC_VECTOR(16 downto 0); -- CU
        EXMEMFlush : in STD_LOGIC; -- CU
        ForwardA : in STD_LOGIC_VECTOR(1 downto 0); -- FWU
        ForwardB : in STD_LOGIC_VECTOR(1 downto 0); -- FWU
        ForwardMEM : in STD_LOGIC; -- FWU
        FW_WD : in STD_LOGIC_VECTOR(31 downto 0); -- WB stage
        FW_ALU : in STD_LOGIC_VECTOR(31 downto 0); -- MEM stage
        FW_MDRO : in STD_LOGIC_VECTOR(31 downto 0); -- MEM stage
        -- output to next pipeline stage
        EXMEMout_N : out STD_LOGIC_VECTOR(31 downto 0);
        EXMEMout_OV : out STD_LOGIC;
        EXMEMout_ALUO : out STD_LOGIC_VECTOR(31 downto 0);
        EXMEMout_HI : out STD_LOGIC_VECTOR(31 downto 0);
        EXMEMout_LO : out STD_LOGIC_VECTOR(31 downto 0);
        EXMEMout_MDRI : out STD_LOGIC_VECTOR(31 downto 0);
        EXMEMout_WR : out STD_LOGIC_VECTOR(4 downto 0);
        -- output to other components/stages
        BRTRGT : out STD_LOGIC_VECTOR(31 downto 0) -- IF stage and CHDU
    );
end PS3_EX;

architecture PS3_EX_STRUCT of PS3_EX is

    -- components --
    component PCR is
        port (
            N : in STD_LOGIC_VECTOR(31 downto 0);
            I : in STD_LOGIC_VECTOR(31 downto 0);
            PCRO : out STD_LOGIC_VECTOR(31 downto 0)
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

    component ALU is
        port(
            A : in STD_LOGIC_VECTOR(31 downto 0);
            B : in STD_LOGIC_VECTOR(31 downto 0);
            Shamt : in STD_LOGIC_VECTOR(4 downto 0);
            ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
            AddSub : in STD_LOGIC;   
            SignUnsign : in STD_LOGIC;
            LogicOp : in STD_LOGIC_VECTOR(1 downto 0);
            HiLoWE : in STD_LOGIC_VECTOR(1 downto 0);
            ShiftOp : in STD_LOGIC_VECTOR(1 downto 0);
            VarShift : in STD_LOGIC;

            ZR : out STD_LOGIC;
            NG : out STD_LOGIC;
            OV : out STD_LOGIC; 
            ALUO : out STD_LOGIC_VECTOR(31 downto 0);
            HI : out STD_LOGIC_VECTOR(31 downto 0);
            LO : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component BRTRGT_CTRL is
        port (
            BranchType : in STD_LOGIC_VECTOR(1 downto 0);
            ZRNGMask : in STD_LOGIC_VECTOR(1 downto 0);
            OneZero : in STD_LOGIC;
            ZR : in STD_LOGIC;
            NG : in STD_LOGIC;
            Target: out STD_LOGIC_VECTOR(1 downto 0)
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

    component REG_N_wSACLRLWE is
        generic (N : positive);
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
            SCLRL : in STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            WE : in  STD_LOGIC;
            Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    component DFF_wSACLRL is
        port(
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC;
            SCLRL : in STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            Q : out  STD_LOGIC
        );
    end component;

    -- signals --
    -- control
    signal ALUSrc : STD_LOGIC;
    signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
    signal AddSub : STD_LOGIC;
    signal SignUnsign : STD_LOGIC;
    signal LogicOp : STD_LOGIC_VECTOR(1 downto 0);
    signal HiLoWE : STD_LOGIC_VECTOR(1 downto 0);
    signal ShiftOp : STD_LOGIC_VECTOR(1 downto 0);
    signal VarShift : STD_LOGIC;
    signal BranchType : STD_LOGIC_VECTOR(1 downto 0);
    signal ZRNGMask : STD_LOGIC_VECTOR(1 downto 0);
    signal OneZero : STD_LOGIC;

    -- PCR unit ouput
    signal s_PCROut : STD_LOGIC_VECTOR(31 downto 0);
    -- Forward A selector output
    signal s_FWMuxAOut : STD_LOGIC_VECTOR(31 downto 0);
    -- Forwrd B selector output
    signal s_FWMuxBOut : STD_LOGIC_VECTOR(31 downto 0);
    -- ALU source selector output
    signal s_ALUSrcMuxOut : STD_LOGIC_VECTOR(31 downto 0);
    -- ALU outputs
    signal s_ZROut : STD_LOGIC;
    signal s_NGOut : STD_LOGIC;
    signal s_OVOut : STD_LOGIC;
    signal s_ALUOut : STD_LOGIC_VECTOR(31 downto 0);
    signal s_HIOut : STD_LOGIC_VECTOR(31 downto 0);
    signal s_LOOut : STD_LOGIC_VECTOR(31 downto 0);
    -- ALU out Forward MEM selector output
    signal s_FWMuxMEMOut : STD_LOGIC_VECTOR(31 downto 0);
    -- branch target selector controler output
    signal s_TargetOut : STD_LOGIC_VECTOR(1 downto 0);

begin

    -- control signal mapping
    ALUSrc <= CtrlSignals(0);
    ALUOp <= CtrlSignals(2 downto 1);
    AddSub <= CtrlSignals(3);
    SignUnsign <= CtrlSignals(4);
    LogicOp <= CtrlSignals(6 downto 5);
    HiLoWE <= CtrlSignals(8 downto 7);
    ShiftOp <= CtrlSignals(10 downto 9);
    VarShift <= CtrlSignals(11);
    BranchType <= CtrlSignals(13 downto 12);
    ZRNGMask <= CtrlSignals(15 downto 14);
    OneZero <= CtrlSignals(16);

PCRUnit: PCR
    port map (
        N => N,
        I => I,
        PCRO => s_PCROut
    );

FWMuxA: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => A,
        B => FW_WD,
        C => FW_ALU,
        D => "--------------------------------",
        Sel => ForwardA,
        O => s_FWMuxAOut
    );

FWMuxB: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => B,
        B => FW_WD,
        C => FW_ALU,
        D => "--------------------------------",
        Sel => ForwardB,
        O => s_FWMuxBOut
    );

ALUSrcMux: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => s_FWMuxBOut,
        B => I,
        Sel => ALUSrc,
        O => s_ALUSrcMuxOut
    );

ArithmeticLogicUnit: ALU
    port map (
        A => s_FWMuxAOut,
        B => s_ALUSrcMuxOut,
        Shamt => SHAMT,
        ALUOp => ALUOp,
        AddSub => AddSub,
        SignUnsign => SignUnsign,
        LogicOp => LogicOp,
        HiLoWE => HiLoWE,
        ShiftOp => ShiftOp,
        VarShift => VarShift,

        ZR => s_ZROut,
        NG => s_NGOut,
        OV => s_OVOut,
        ALUO => s_ALUOut,
        HI => s_HIOut,
        LO => s_LOOut
    );

FWMuxMEM: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => s_ALUOut,
        B => FW_MDRO,
        Sel => ForwardMEM,
        O => s_FWMuxMEMOut
    );

BranchTargetController: BRTRGT_CTRL
    port map (
        BranchType => BranchType,
        ZRNGMask => ZRNGMask,
        OneZero => OneZero,
        ZR => s_ZROut,
        NG => s_NGOut,
        Target => s_TargetOut
    );

BranchSelector: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => "00000000000000000000000000000000",
        B => D,
        C => A,
        D => s_PCROut,
        Sel => s_TargetOut,
        O => BRTRGT
    );

    -- EX/MEM pipeline registers

EXMEM_N: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => N,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        Q => EXMEMout_N
    );

EXMEM_OV: DFF_wSACLRL
    port map (
        CLK => CLK,
        D => s_OVOut,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        Q => EXMEMout_OV
    );

EXMEM_ALUO: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_FWMuxMEMOut,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        Q => EXMEMout_ALUO
    );

EXMEM_HI: REG_N_wSACLRLWE
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_HIOut,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        WE => HiLoWE(1),
        Q => EXMEMout_HI
    );

EXMEM_LO: REG_N_wSACLRLWE
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_LOOut,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        WE => HiLoWE(0),
        Q => EXMEMout_LO
    );

EXMEM_MDRI: REG_N_wSACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_FWMuxBOut,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        Q => EXMEMout_MDRI
    );

EXMEM_WR: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => WR,
        SCLRL => EXMEMFlush,
        ACLRL => ACLRL,
        Q => EXMEMout_WR
    );

end PS3_EX_STRUCT;

