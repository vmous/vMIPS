----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    10:24:39 10/03/2009 
-- Design Name: 
-- Module Name:    DATA_HAZARD_CTRL - DATA_HAZARD_CTRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Data Hazard Detecting Unit
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

entity DATA_HAZARD_CTRL is
    port (
        -- input
        IDEX_MemRead : in STD_LOGIC;
        IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
        ID_Rs : in STD_LOGIC_VECTOR(4 downto 0);
        ID_Rt : in STD_LOGIC_VECTOR(4 downto 0);
        -- output        
        Stall : out STD_LOGIC -- CU
    );
end DATA_HAZARD_CTRL;

architecture DATA_HAZARD_CTRL_BEH of DATA_HAZARD_CTRL is

begin

    process (IDEX_MemRead, IDEX_Rt, ID_Rs, ID_Rt)
    begin
        if (
            -- the instruction in the EX stage is a Load
            (IDEX_MemRead = '1') and
             -- the destination register of the load in the EX stage matches
             -- either sources register  of the instruction in the ID stage
             -- maybe should be changed to:
             --((IDEX_Rt = ID_Rs) or
             --((IDEX_Rt = ID_Rt) and (MemRead = 0) and (MemWrite = 0)))
            ((IDEX_Rt = ID_Rs) or (IDEX_Rt = ID_Rt))
        ) then
            -- stall the pipeline
            Stall <= '1';
        else
            -- proceed normally
            -- maybe with some help from the Forwarding Unit :)
            Stall <= '0';
        end if;
    end process;

end DATA_HAZARD_CTRL_BEH;

