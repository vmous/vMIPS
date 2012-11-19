----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    00:38:02 09/01/2009 
-- Design Name: 
-- Module Name:    ADDER_32_S - ADDER_32_S_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit Adder
--                 for Signed
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

entity ADDER_32_S is
    port(
        A : in  STD_LOGIC_VECTOR (31 downto 0);
        B : in  STD_LOGIC_VECTOR (31 downto 0);
        S : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end ADDER_32_S;

architecture ADDER_32_S_BEH of ADDER_32_S is

    signal a_s, b_s, s_s : SIGNED(31 downto 0);

begin

    a_s <= SIGNED(A);
    b_s <= SIGNED(B);
    s_s <= a_s + b_s;
    S <= STD_LOGIC_VECTOR(s_s);

end ADDER_32_S_BEH;

