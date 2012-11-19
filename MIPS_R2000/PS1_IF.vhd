----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:01:01 08/13/2009 
-- Design Name: 
-- Module Name:    PS1_IF - PS1_IF_RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pipeline Stage 1 : Instruction Fetch
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

entity PS1_IF is
    port (
        CLK : in STD_LOGIC;
        ACLRL : in STD_LOGIC;
        -- input from previous pipeline stage
        -- input from other components/stages
        Branch : in STD_LOGIC; -- CHDU
        PCWrite : in STD_LOGIC; -- CU
        IFIDFlush : in STD_LOGIC; -- CU
        IFIDWrite : in STD_LOGIC; -- DHDU
        BRTRGT : in STD_LOGIC_VECTOR(31 downto 0); -- EX stage
        -- output to next pipeline stage
        IFIDout_N : out STD_LOGIC_VECTOR(31 downto 0);
        IFIDout_IR : out STD_LOGIC_VECTOR(31 downto 0)
        -- output to other components/stages
    );
end PS1_IF;

architecture PS1_IF_STRUCT of PS1_IF is

    -- components --
    component MUX_N_2IN1 is
        generic (N : positive);
        port (
            A : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            B : in  STD_LOGIC_VECTOR (N - 1 downto 0);
            Sel : in  STD_LOGIC;
            O : out  STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component REG_N_wACLRLWE is
        generic (N : positive);
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
            ACLRL : in  STD_LOGIC;
            WE : in  STD_LOGIC;
            Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    component IMEM_BR512X32 is
        port (
            CLK : in STD_LOGIC;
            ADDR : in STD_LOGIC_VECTOR(8 downto 0);
            WE : in STD_LOGIC;
            DI : in STD_LOGIC_VECTOR(31 downto 0);
            DO : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component ADDER_32_U is
        port (
            A : in  STD_LOGIC_VECTOR(31 downto 0);
            B : in  STD_LOGIC_VECTOR(31 downto 0);
            S : out  STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component DFF_wACLRL is
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            Q : out  STD_LOGIC
        );
    end component;

    component REG_N_wACLRL is
        generic (N : positive);
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
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

    -- signals --
    -- next PC selector output
    signal s_NPCMuxOut : STD_LOGIC_VECTOR(31 downto 0);
    -- PC register output
    signal s_PCOut : STD_LOGIC_VECTOR(31 downto 0);
    -- PC+4 adder output
    signal s_IncOut : STD_LOGIC_VECTOR(31 downto 0);
    -- instruction memory output
    signal s_IMemOut : STD_LOGIC_VECTOR(31 downto 0);
    -- stalled instruction memory output
    signal s_IMemSOut : STD_LOGIC_VECTOR(31 downto 0);
    -- IFIDWrite of the previous cycle (for stalls)
    signal s_IFIDWriteSOut : STD_LOGIC;
    -- instruction memory selector output
    signal s_IMemMuxOut : STD_LOGIC_VECTOR(31 downto 0);
    -- Branch of the previous cycle (for branches)
    signal s_IRFlushMuxOut : STD_LOGIC_VECTOR(31 downto 0);
    -- instruction or nop selector outpout
    signal s_BranchSOut : STD_LOGIC;

begin

NPCSelector: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => s_IncOut,
        B => BRTRGT,
        Sel => Branch,
        O => s_NPCMuxOut
    );

PC: REG_N_wACLRLWE
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_NPCMuxOut, 
        ACLRL => ACLRL,
        WE => PCWrite,
        Q => s_PCOut
    );

InstructionMemory: IMEM_BR512X32
    port map (
        CLK => CLK,
        ADDR => s_PCOut(10 downto 2),
        -- the instruction memory is never written
        WE => '0',
        -- set to a default value (don't cares) at component declaration
        DI => "--------------------------------",
        DO => s_IMemOut
    );    

Inc: ADDER_32_U
    port map (
        A => s_PCOut,
        B => "00000000000000000000000000000100",
        S => s_IncOut
    );

IMemS: REG_N_wACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_IMemOut,
        ACLRL => ACLRL,
        Q => s_IMemSOut
    );

IFIDWriteS: DFF_wACLRL
    port map (
        CLK => CLK,
        D => IFIDWrite,
        ACLRL => ACLRL,
        Q => s_IFIDWriteSOut
    );
    
    
BranchS: DFF_wACLRL
    port map (
        CLK => CLK,
        D => Branch,
        ACLRL => ACLRL,
        Q => s_BranchSOut
    );

IMemMux: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => s_IMemSOut,
        B => s_IMemOut,
        Sel => s_IFIDWriteSOut,
        O => s_IMemMuxOut
    );


IRFlushMux: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => s_IMemMuxOut,
        B => "00000000000000000000000000000000",
        Sel => s_BranchSOut,
        O => s_IRFlushMuxOut
    );

    -- IF/ID pipeline registers --
IFID_N: REG_N_wSACLRLWE
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_PCOut,
        SCLRL => IFIDFlush,
        ACLRL => ACLRL,
        WE => IFIDWrite,
        Q => IFIDout_N
    );

IFID_IR: REG_N_wSACLRLWE
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_IRFlushMuxOut,
        SCLRL => IFIDFlush,
        ACLRL => ACLRL,
        WE => IFIDWrite,
        Q => IFIDout_IR
    );

end PS1_IF_STRUCT;

