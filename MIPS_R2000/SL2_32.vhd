----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    00:05:56 09/01/2009 
-- Design Name: 
-- Module Name:    SL2_32 - SL2_32_DF 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Shift Left by 2
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

entity SL2_32 is
    port (
        I : in  STD_LOGIC_VECTOR (31 downto 0);
        O : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end SL2_32;

architecture SL2_32_DF of SL2_32 is

begin

    O <= I(29 downto 0) & "00";

end SL2_32_DF;

