----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    15:51:05 08/06/2009 
-- Design Name: 
-- Module Name:    SIGNZEROEXT_16TO32 - SIGNZEROEXT_16TO32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    16 to 32-bit Sign or Zero Extender
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

entity SIGNZEROEXT_16TO32 is
    port (
        I : in  STD_LOGIC_VECTOR (15 downto 0);
        SignZero : in  STD_LOGIC;
        O : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end SIGNZEROEXT_16TO32;

architecture SIGNZEROEXT_16TO32_BEH of SIGNZEROEXT_16TO32 is

begin

    process (I, SignZero)
    begin
        if (SignZero = '1') then
            for index in 0 to 15 loop
                O(index) <= I(index);
            end loop;
            -- sign extention
            for index in 16 to 31 loop
                O(index) <= I(15);
            end loop;
        else
            for index in 0 to 15 loop
                O(index) <= I(index);
            end loop;
            -- zero extention
            for index in 16 to 31 loop
                O(index) <= '0';
            end loop;
        end if;
    end process;

end SIGNZEROEXT_16TO32_BEH;

