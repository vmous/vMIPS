----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    14:49:44 10/21/2009 
-- Design Name: 
-- Module Name:    DFF_wACLRLWE - DFF_wACLRLWE 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Positive-Edge-Triggered D-Flip-Flop
--                 with Asynchronous Clear Low and Write Enable
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

entity DFF_wACLRLWE is
    port (
        CLK : in  STD_LOGIC;
        D : in  STD_LOGIC;
        ACLRL : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Q : out  STD_LOGIC
    );
end DFF_wACLRLWE;

architecture DFF_wACLRLWE of DFF_wACLRLWE is

begin

    process (CLK, ACLRL)
    begin
        if (ACLRL = '0') then
            Q <= '0';
        elsif (RISING_EDGE(CLK)) then
            if (WE = '1') then
                Q <= D;
            end if;
        end if;        
    end process;

end DFF_wACLRLWE;

