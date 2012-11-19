----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:47:06 10/04/2009 
-- Design Name: 
-- Module Name:    EX_HAZARD_FW - EX_HAZARD_FW_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    EX Hazard Forwarder
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

entity EX_HAZARD_FW is
    port (
        IDEX_Rs : in STD_LOGIC_VECTOR(4 downto 0);
        IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
        EXMEM_RegWrite : in STD_LOGIC;
        EXMEM_Rd : in STD_LOGIC_VECTOR(4 downto 0);
        MEMWB_RegWrite : in STD_LOGIC;
        MEMWB_Rd : in STD_LOGIC_VECTOR(4 downto 0);

        ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
        ForwardB : out STD_LOGIC_VECTOR(1 downto 0)
    );
end EX_HAZARD_FW;

architecture EX_HAZARD_FW_BEH of EX_HAZARD_FW is

begin

    process (IDEX_Rs, IDEX_Rt, EXMEM_RegWrite, EXMEM_Rd, MEMWB_RegWrite, MEMWB_Rd)
    begin
        -- ForwardA
        if (
            (EXMEM_RegWrite = '1') and
            (EXMEM_Rd /= "00000") and
            (EXMEM_Rd = IDEX_Rs)
        ) then
            ForwardA <= "10";
        elsif (
            (MEMWB_RegWrite = '1') and
            (MEMWB_Rd /= "00000") and
            (EXMEM_Rd /= IDEX_Rs) and
            (MEMWB_Rd = IDEX_Rs)
        ) then
            ForwardA <= "01";
        else
            ForwardA <= "00";
        end if;

        -- ForwardB
        if (
            (EXMEM_RegWrite = '1') and
            (EXMEM_Rd /= "00000") and
            (EXMEM_Rd = IDEX_Rt)
        ) then
            ForwardB <= "10";
        elsif (
            (MEMWB_RegWrite = '1') and
            (MEMWB_Rd /= "00000") and
            (EXMEM_Rd /= IDEX_Rt) and
            (MEMWB_Rd = IDEX_Rt)
        ) then
            ForwardB <= "01";
        else
            ForwardB <= "00";
        end if;
    end process;

end EX_HAZARD_FW_BEH;

