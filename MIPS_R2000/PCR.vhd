----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    20:23:37 09/14/2009 
-- Design Name: 
-- Module Name:    PCR - PCR_STRUCT 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    PC-Relative Addressing Unit
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

entity PCR is
    port (
        N : in STD_LOGIC_VECTOR(31 downto 0);
        I : in STD_LOGIC_VECTOR(31 downto 0);
        PCRO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end PCR;

architecture PCR_STRUCT of PCR is

    -- components --
    component SL2_32 is
        port (
            I : in  STD_LOGIC_VECTOR (31 downto 0);
            O : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
    
    component ADDER_32_S is
        port (
            A : in  STD_LOGIC_VECTOR (31 downto 0);
            B : in  STD_LOGIC_VECTOR (31 downto 0);
            S : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    -- signals --
    -- output of shift left 2
    signal s_SL2Out : STD_LOGIC_VECTOR(31 downto 0);

begin

ShiftLeft2: SL2_32
    port map (
        I => I,
        O => s_SL2Out
    );

Adder: ADDER_32_S
    port map (
        A => N,
        B => s_SL2Out,
        S => PCRO
    );

end PCR_STRUCT;

