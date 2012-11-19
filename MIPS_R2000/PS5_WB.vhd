----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:03:43 08/13/2009 
-- Design Name: 
-- Module Name:    PS5_WB - PS5_WB_RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pipeline Stage 5 : Write Back
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

entity PS5_WB is
    port (
        CLK : in STD_LOGIC;
        ACLRL : in STD_LOGIC;
        -- input from previous pipeline stage
        N : in STD_LOGIC_VECTOR(31 downto 0);
        HI : in STD_LOGIC_VECTOR(31 downto 0);
        LO : in STD_LOGIC_VECTOR(31 downto 0);
        ALUO : in STD_LOGIC_VECTOR(31 downto 0);
        MDRO : in STD_LOGIC_VECTOR(31 downto 0);
        WR : in STD_LOGIC_VECTOR(4 downto 0);
        -- input from other components/stages
        CtrlSignals : in STD_LOGIC_VECTOR(3 downto 0); -- CU
        -- output to next pipeline stage
        MEMWBout_WD : out STD_LOGIC_VECTOR(31 downto 0);
        MEMWBout_WR : out STD_LOGIC_VECTOR(4 downto 0);
        -- output to other componets/stages
        WD : out STD_LOGIC_VECTOR(31 downto 0)
    );
end PS5_WB;

architecture PS5_WB_STRUCT of PS5_WB is

    -- components
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
    --control
    signal HiLo : STD_LOGIC;
    signal WriteBack : STD_LOGIC_VECTOR(1 downto 0);
    
    -- Hi-Lo selector output
    signal s_HiLoOut : STD_LOGIC_VECTOR(31 downto 0);
    
    -- RF selector output
    signal s_RFOut : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- control signal mapping
    HiLo <= CtrlSignals(1);
    WriteBack <= CtrlSignals(3 downto 2);

HiLoSelector: MUX_N_2IN1
    generic map (N => 32)
    port map (
        A => HI,
        B => LO,
        Sel => HiLo,
        O => s_HiLoOut
    );

RF: MUX_N_4IN1
    generic map (N => 32)
    port map (
        A => N,
        B => s_HiLoOut,
        C => ALUO,
        D => MDRO,
        Sel => WriteBack,
        O => s_RFOut
    );

    WD <= s_RFOut;

    -- MEM/WB pipeline registers
MEMWB_WD: REG_N_wACLRL
    generic map (N => 32)
    port map (
        CLK => CLK,
        D => s_RFOut,
        ACLRL => ACLRL,
        Q => MEMWBout_WD
    );

MEMWB_WR: REG_N_wACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => WR,
        ACLRL  => ACLRL,
        Q => MEMWBout_WR
    );

end PS5_WB_STRUCT;

