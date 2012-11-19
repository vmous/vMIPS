----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:16:53 08/11/2009 
-- Design Name: 
-- Module Name:    ALU - ALU_STRUCT 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Arithmetic-Logic Unit
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

entity ALU is
    port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0);
        Shamt : in STD_LOGIC_VECTOR(4 downto 0);
        ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
        -- Selection for ADDSUB_32_SU_wOV
        AddSub : in STD_LOGIC;        
        -- Selection for ADDSUB_32_SU_wOV and MULTI_32_SU_wHILO
        SignUnsign : in STD_LOGIC;
        -- Selection for LOGIC_32
        LogicOp : in STD_LOGIC_VECTOR(1 downto 0);
        -- Selection for MULTI_32_SU_wHILO
        HiLoWE : in STD_LOGIC_VECTOR(1 downto 0);
        -- Selections for SHIFTROT_32
        ShiftOp : in STD_LOGIC_VECTOR(1 downto 0);
        VarShift : in STD_LOGIC;

        ZR : out STD_LOGIC;
        NG : out STD_LOGIC;
        OV : out STD_LOGIC; 
        ALUO : out STD_LOGIC_VECTOR(31 downto 0);
        HI : out STD_LOGIC_VECTOR(31 downto 0);
        LO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end ALU;

architecture ALU_STRUCT of ALU is

    -- components --
    component ADDSUB_32_SU_wOV is
        port (
            A : in STD_LOGIC_VECTOR(31 downto 0);
            B : in STD_LOGIC_VECTOR(31 downto 0);
            AddSub : in STD_LOGIC;
            SignUnsign : in STD_LOGIC;
            S : out STD_LOGIC_VECTOR(31 downto 0);
            OV : out STD_LOGIC
        );
    end component;

    component LOGIC_32 is
        port (
            A : in STD_LOGIC_VECTOR(31 downto 0);
            B : in STD_LOGIC_VECTOR(31 downto 0);
            LogicOp : in STD_LOGIC_VECTOR(1 downto 0);
            C : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component MULTI_32_SU_wHILO is
        port (
            A : in STD_LOGIC_VECTOR(31 downto 0);
            B : in STD_LOGIC_VECTOR(31 downto 0);
            HiLoWE : in STD_LOGIC_VECTOR(1 downto 0);
            SignUnsign : in STD_LOGIC;
            HI : out STD_LOGIC_VECTOR(31 downto 0);
            LO : out STD_LOGIC_VECTOR(31 downto 0)
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

    component SHIFTROT_32 is
        port (
            A : in STD_LOGIC_VECTOR(31 downto 0);
            Shamt : in STD_LOGIC_VECTOR(4 downto 0);
            ShiftOp : in STD_LOGIC_VECTOR(1 downto 0);
            B : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component SETMSB_32
        port (
            A : in  STD_LOGIC_VECTOR (31 downto 0);
            B : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
    
    component MUX_N_4IN1 is
        generic (N : positive);
        port (
            A : in  STD_LOGIC_VECTOR (31 downto 0);
            B : in  STD_LOGIC_VECTOR (31 downto 0);
            C : in  STD_LOGIC_VECTOR (31 downto 0);
            D : in  STD_LOGIC_VECTOR (31 downto 0);
            Sel : in  STD_LOGIC_VECTOR (1 downto 0);
            O : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
    
    component NORTREE_32 is
        port (
            A : in  STD_LOGIC_VECTOR (31 downto 0);
            B : out  STD_LOGIC
        );
    end component;

    -- signals --
    signal s_AddSubOut : STD_LOGIC_VECTOR(31 downto 0);
    signal s_LogicOut : STD_LOGIC_VECTOR(31 downto 0);
    signal s_ShamtMuxOut : STD_LOGIC_VECTOR(4 downto 0);
    signal s_ShiftOut : STD_LOGIC_VECTOR(31 downto 0);
    signal s_SLTOut : STD_LOGIC_VECTOR(31 downto 0);

begin

AdditionSubtraction: ADDSUB_32_SU_wOV
    port map (
        A => A,
        B => B,
        AddSub => AddSub,
        SignUnsign => SignUnsign,
        S => s_AddSubOut,
        OV => OV
    );

LogicalOperation: LOGIC_32
    port map (
        A => A,
        B => B,
        LogicOp => LogicOp,
        C => s_LogicOut
    );
    
Multiplication: MULTI_32_SU_wHILO
    port map (
        A => A,
        B => B,
        HiLoWE => HiLoWE,
        SignUnsign => SignUnsign,
        HI => HI,
        LO => LO
    );

ShiftAmountMux:  MUX_N_2IN1
    generic map (N => 5)
    port map (
        A => Shamt,
        B => A(4 downto 0),
        Sel => VarShift,
        O => s_ShamtMuxOut
    );

Shifting: SHIFTROT_32
    port map (
        A => B,
        Shamt => s_ShamtMuxOut,
        ShiftOp => ShiftOp,
        B => s_ShiftOut
    );

SetLessThan: SETMSB_32
    port map (
        A => s_AddSubOut,
        B => s_SLTOut
    );

ALUOutSelection: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => s_AddSubOut,
        B => s_LogicOut,
        C => s_ShiftOut,
        D => s_SLTOut,
        Sel => ALUOp,
        O => ALUO
    );

ZeroDetection: NORTREE_32
    port map (
        A => s_AddSubOut,
        B => ZR
    );
    
    NG <= s_AddSubOut(31);

end ALU_STRUCT;

