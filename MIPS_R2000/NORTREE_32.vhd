----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:30:44 08/11/2009 
-- Design Name: 
-- Module Name:    NORTREE_32 - NORTREE_32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit NOR-Tree
--                 Zero Detector
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

entity NORTREE_32 is
    port (
        A : in  STD_LOGIC_VECTOR (31 downto 0);
        B : out  STD_LOGIC
    );
end NORTREE_32;

architecture NORTREE_32_BEH of NORTREE_32 is

begin

    process (A)
    begin
        if (A = "00000000000000000000000000000000") then
            B <= '1';
        else
            B <= '0';
        end if;
    end process;

end NORTREE_32_BEH;

