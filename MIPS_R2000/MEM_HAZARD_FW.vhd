----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:48:13 10/04/2009 
-- Design Name: 
-- Module Name:    MEM_HAZARD_FW - MEM_HAZARD_FW_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    MEM Hazard Forwarder
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

entity MEM_HAZARD_FW is
    port (
        IDEX_MemWrite : in STD_LOGIC;
        IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
        EXMEM_MemRead : in STD_LOGIC;
        EXMEM_Rd : in STD_LOGIC_VECTOR(4 downto 0);

        ForwardMEM : out STD_LOGIC
    );
end MEM_HAZARD_FW;

architecture MEM_HAZARD_FW_BEH of MEM_HAZARD_FW is

begin

    process (IDEX_MemWrite, IDEX_Rt, EXMEM_MemRead, EXMEM_Rd)
    begin
        if (
            -- there is a Load instruction in MEM stage
            (EXMEM_MemRead = '1') and
            -- there is a Store instruction in EX Stage
            (IDEX_MemWrite = '1') and
            -- the register that is written by the Load instruction
            -- is the same to be read by the Store instruction
            (EXMEM_Rd /= "00000") and (EXMEM_Rd = IDEX_Rt)
        ) then
            ForwardMEM <= '1';
        else
            ForwardMEM <= '0';
        end if;
    end process;

end MEM_HAZARD_FW_BEH;

