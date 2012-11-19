----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    23:20:07 10/03/2009 
-- Design Name: 
-- Module Name:    CONTROL_HAZARD_CTRL - CONTROL_HAZARD_CTRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Control Hazard Detecting Unit
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

entity CONTROL_HAZARD_CTRL is
    port (
        -- input
        Target : in STD_LOGIC_VECTOR(31 downto 0);
        -- output
        Branch : out STD_LOGIC -- CU
    );
end CONTROL_HAZARD_CTRL;

architecture CONTROL_HAZARD_CTRL_BEH of CONTROL_HAZARD_CTRL is

begin

    process (Target)
    begin
        if (Target = "00000000000000000000000000000000") then
            -- branch NOT taken
            Branch <= '0';
        else
            -- branch taken
            Branch <= '1';
        end if;
    end process;

end CONTROL_HAZARD_CTRL_BEH;

