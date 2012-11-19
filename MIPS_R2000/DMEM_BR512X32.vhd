----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    23:12:32 08/13/2009 
-- Design Name: 
-- Module Name:    DMEM_BR512X32 - DMEM_BR512X32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Data Memory Block RAM
--                 with "False" Synchronous Read
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

entity DMEM_BR512X32 is
    port(
        CLK : in STD_LOGIC;
        ADDR : in STD_LOGIC_VECTOR(8 downto 0);
        WE : in STD_LOGIC;
        DI : in STD_LOGIC_VECTOR(31 downto 0);
        DO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DMEM_BR512X32;

architecture DMEM_BR512X32_BEH of DMEM_BR512X32 is

    type br512x32_t is array(511 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal dmem : br512x32_t;

begin

    process(CLK)
    begin
        if (FALLING_EDGE(CLK)) then
            if (WE = '1') then
                dmem(CONV_INTEGER(ADDR)) <= DI;
            end if;
        end if;
    end process;
    DO <= dmem(CONV_INTEGER(ADDR));

end DMEM_BR512X32_BEH;

