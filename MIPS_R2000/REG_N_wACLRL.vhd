----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    10:17:31 08/27/2009 
-- Design Name: 
-- Module Name:    REG_N_wACLRL - REG_N_wACLRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Variable Width Register
--                 with Asynchronous Clear Low
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

entity REG_N_wACLRL is
    generic (N : positive);
    port (
        CLK : in  STD_LOGIC;
        D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
        ACLRL : in  STD_LOGIC;
        Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
    );
end REG_N_wACLRL;

architecture REG_N_wACLRL_BEH of REG_N_wACLRL is

begin

    process (CLK, ACLRL)
    begin
        if (ACLRL = '0') then
            Q <= (others => '0');
        elsif (RISING_EDGE(CLK)) then
            Q <= D;
        end if;        
    end process;

end REG_N_wACLRL_BEH;

