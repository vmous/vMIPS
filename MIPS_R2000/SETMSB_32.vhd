----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    18:12:34 08/11/2009 
-- Design Name: 
-- Module Name:    SETMSB_32 - SETMSB_32_DF 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit MSB Setter
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

entity SETMSB_32 is
    port(
        A : in  STD_LOGIC_VECTOR (31 downto 0);
        B : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end SETMSB_32;

architecture SETMSB_32_DF of SETMSB_32 is

begin

    B <= "0000000000000000000000000000000" & A(31);

end SETMSB_32_DF;

