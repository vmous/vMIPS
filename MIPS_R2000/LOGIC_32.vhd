----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    16:47:16 08/10/2009 
-- Design Name: 
-- Module Name:    LOGIC_32 - LOGIC_32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:     32-bit Logic Unit
--                  performs AND, OR, XOR operations
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments:
--                  LogicOp = 00 : AND
--                  LogicOp = 01 : OR
--                  LogicOp = 10 : NOR
--                  LogicOp = 11 : XOR
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LOGIC_32 is
    port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0);
        LogicOp : in STD_LOGIC_VECTOR(1 downto 0);
        C : out STD_LOGIC_VECTOR(31 downto 0)
    );
end LOGIC_32;

architecture LOGIC_32_BEH of LOGIC_32 is

begin

    process (A, B, LogicOp)
    begin
        case LogicOp is
            when "00" => C <= A AND B;
            when "01" => C <= A OR B;
            when "10" => C <= A NOR B;
            when "11" => C <= A XOR B;
            when others => C <= (others => '0');
        end case;
    end process;

end LOGIC_32_BEH;

