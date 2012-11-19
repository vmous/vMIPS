----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    02:55:23 08/18/2009 
-- Design Name: 
-- Module Name:    ADDER_32_U - ADDER_32_U_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit Adder
--                 for Unsigned
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

entity ADDER_32_U is
    port(
        A : in  STD_LOGIC_VECTOR (31 downto 0);
        B : in  STD_LOGIC_VECTOR (31 downto 0);
        S : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end ADDER_32_U;

architecture ADDER_32_U_BEH of ADDER_32_U is

    signal a_u, b_u, s_u : UNSIGNED(31 downto 0);

begin

    a_u <= UNSIGNED(A);
    b_u <= UNSIGNED(B);
    s_u <= a_u + b_u;
    S <= STD_LOGIC_VECTOR(s_u);

end ADDER_32_U_BEH;

