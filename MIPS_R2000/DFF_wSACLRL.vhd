----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    03:44:29 10/12/2009 
-- Design Name: 
-- Module Name:    DFF_wSACLRL - DFF_wSACLRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Positive-Edge-Triggered D-Flip-Flop
--                 with both Synchronous and Asynchronous Clear Low
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

entity DFF_wSACLRL is
    port (
        CLK : in  STD_LOGIC;
        D : in  STD_LOGIC;
        SCLRL : in STD_LOGIC;
        ACLRL : in  STD_LOGIC;
        Q : out  STD_LOGIC
    );
end DFF_wSACLRL;

architecture DFF_wSACLRL_BEH of DFF_wSACLRL is

begin

    process (CLK, ACLRL)
    begin
        if (ACLRL = '0') then
            Q <= '0';
        elsif (RISING_EDGE(CLK)) then
            if (SCLRL = '0') then
                Q <= '0';
            else
                Q <= D;
            end if;
        end if;
    end process;

end DFF_wSACLRL_BEH;

