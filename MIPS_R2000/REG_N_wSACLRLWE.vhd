----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    00:38:18 10/10/2009 
-- Design Name: 
-- Module Name:    REG_N_wSACLRLWE - REG_N_wSACLRLWE_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Variable Width Register
--                 with both Synchronous and Asynchronous Clear Low
--                 and Write Enable
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

entity REG_N_wSACLRLWE is
    generic (N : positive);
    port (
        CLK : in  STD_LOGIC;
        D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
        SCLRL : in STD_LOGIC;
        ACLRL : in  STD_LOGIC;
        WE : in  STD_LOGIC;
        Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
    );
end REG_N_wSACLRLWE;

architecture REG_N_wSACLRLWE_BEH of REG_N_wSACLRLWE is

begin

    process (CLK, ACLRL)
    begin
        if (ACLRL = '0') then
            Q <= (others => '0');
        elsif (RISING_EDGE(CLK)) then
            if (SCLRL = '0') then
                Q <= (others => '0');
            else
                if (WE ='1') then
                    Q <= D;
                end if;
            end if;
        end if;
    end process;

end REG_N_wSACLRLWE_BEH;

