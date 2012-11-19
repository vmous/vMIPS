----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:03:08 08/13/2009 
-- Design Name: 
-- Module Name:    PS4_MEM - PS4_MEM_RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pipeline Stage 4 : Data Memory Access
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

entity PS4_MEM is
    port (
        CLK : in STD_LOGIC;
        ACLRL : in STD_LOGIC;
        -- input from previous pipeline stage
        ALUO : in STD_LOGIC_VECTOR(31 downto 0);
        MDRI : in STD_LOGIC_VECTOR(31 downto 0);
        HI : in STD_LOGIC_VECTOR(31 downto 0);
        LO : in STD_LOGIC_VECTOR(31 downto 0);
        DREAD : inout STD_LOGIC_VECTOR(31 downto 0); 
        DWRITE : inout STD_LOGIC_VECTOR(31 downto 0);
        -- input from other components/stages
        CtrlSignals : in STD_LOGIC_VECTOR(4 downto 0); -- CU
        EXMEM_HiLo : in STD_LOGIC; -- CU
        EXMEM_WriteBack : in STD_LOGIC_VECTOR(1 downto 0); -- CU
        -- output to next pipeline stage
        -- output to other components/stages
        FW_ALU : out STD_LOGIC_VECTOR(31 downto 0); -- EX
        MDRO : out STD_LOGIC_VECTOR(31 downto 0); -- EX
        ERR : out STD_LOGIC
    );
end PS4_MEM;

architecture PS4_MEM_STRUCT of PS4_MEM is

    -- components --
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

    component DMEM_CTRL is
        port (
            ALUO : in STD_LOGIC_VECTOR(31 downto 0);
            MDRI : in STD_LOGIC_VECTOR(31 downto 0);
            DMDI : in STD_LOGIC_VECTOR(31 downto 0);
            MemRead : in STD_LOGIC;
            MemWrite : in STD_LOGIC;
            SignZeroLoad : in STD_LOGIC;
            isWord : in STD_LOGIC;
            ByteHalf : in STD_LOGIC;
            E : out STD_LOGIC;
            DMWE : out STD_LOGIC;
            DMA : out STD_LOGIC_VECTOR(29 downto 0);
            MDRO : out STD_LOGIC_VECTOR(31 downto 0);
            DMDO : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component DMEM_BR512X32 is
        port (
            CLK : in STD_LOGIC;
            ADDR : in STD_LOGIC_VECTOR(8 downto 0);
            WE : in STD_LOGIC;
            DI : in STD_LOGIC_VECTOR(31 downto 0);
            DO : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component DFF_wACLRLWE is
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            WE : in  STD_LOGIC;
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

    -- signals --
    -- control
    signal MemRead : STD_LOGIC;
    signal MemWrite : STD_LOGIC;
    signal SignZeroLoad : STD_LOGIC;
    signal isWord : STD_LOGIC;
    signal ByteHalf : STD_LOGIC;

    -- data memory controller outputs
    signal s_DMWEOut : STD_LOGIC;
    signal s_DMAOut : STD_LOGIC_VECTOR(29 downto 0);
    signal s_ErrWE : STD_LOGIC;
    signal s_ErrOut : STD_LOGIC;
    -- temporary signal for selecting forwarding data
    signal s_FWALUSel : STD_LOGIC_VECTOR(1 downto 0);

begin

    -- control signal mapping
    MemRead <= CtrlSignals(0);
    MemWrite <= CtrlSignals(1);
    SignZeroLoad <= CtrlSignals(2);
    isWord <= CtrlSignals(3);
    ByteHalf <= CtrlSignals(4);


s_FWALUSel(1) <= EXMEM_WriteBack(0) and (not EXMEM_WriteBack(1));
s_FWALUSel(0) <= (EXMEM_WriteBack(0) and (not EXMEM_WriteBack(1))) and EXMEM_HiLo;

FWALUMux: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => ALUO,
        B => "--------------------------------",
        C => HI,
        D => LO,
        Sel => s_FWALUSel,
        O => FW_ALU
    );

DMController: DMEM_CTRL
    port map (
        ALUO => ALUO,
        MDRI => MDRI,
        DMDI => DREAD,
        MemRead => MemRead,
        MemWrite => MemWrite,
        SignZeroLoad => SignZeroLoad,
        isWord => isWord,
        ByteHalf => ByteHalf,      
        E => s_ErrOut,
        DMWE => s_DMWEOut,
        DMA => s_DMAOut,
        MDRO => MDRO,
        DMDO => DWRITE
    );

s_ErrWE <= MemRead or MemWrite;

ErrReg: DFF_wACLRLWE
    port map (
        CLK => CLK,
        D => s_ErrOut,
        ACLRL  => ACLRL,
        WE => s_ErrWE,
        Q => ERR
    );

DataMemory: DMEM_BR512X32
    port map (
        CLK => CLK,
        ADDR => s_DMAOut(8 downto 0), -- CAUTION: Maybe 9 bits cause probs (check 8)
        WE => s_DMWEOut,
        DI => DWRITE,
        DO => DREAD
    );

end PS4_MEM_STRUCT;

