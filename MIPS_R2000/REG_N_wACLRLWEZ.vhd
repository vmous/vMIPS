----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:59:05 08/30/2009 
-- Design Name: 
-- Module Name:    REG_N_wACLRLWEZ - REG_N_wACLRLWEZ_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Variable Width Register
--                 with Asynchronous Clear Low and Write Enable/Zero
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

entity REG_N_wACLRLWEZ is
    generic (N : positive);
    port(
        CLK : in  STD_LOGIC;
        D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
        ACLRL : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
    );
end REG_N_wACLRLWEZ;

architecture REG_N_wACLRLWEZ_BEH of REG_N_wACLRLWEZ is

    signal q_tmp : STD_LOGIC_VECTOR(N - 1 downto 0);

begin

    process(CLK, ACLRL)
    begin
        if (ACLRL = '0') then
            q_tmp <= (q_tmp'range => '0');
        elsif (RISING_EDGE(CLK)) then
            if (WE = '1') then
                q_tmp <= D;
            else
                q_tmp <= (q_tmp'range => '0');
            end if;
        end if;        
    end process;
    
    Q <= q_tmp;

end REG_N_wACLRLWEZ_BEH;

