----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    10:53:18 08/30/2009 
-- Design Name: 
-- Module Name:    PSD - PSD_DF 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Pseudo-Direct (PSD) Addressing Unit
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

entity PSD is
    port (
        A : in  STD_LOGIC_VECTOR (3 downto 0);
        B : in  STD_LOGIC_VECTOR (25 downto 0);
        O : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end PSD;

architecture PSD_DF of PSD is

begin

    O <= A & B & "00";

end PSD_DF;

