----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    10:17:43 09/10/2009 
-- Design Name: 
-- Module Name:    MUX_N_4IN1 - MUX_N_4IN1_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Variable Width 4-in-1 Multiplexor
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

entity MUX_N_4IN1 is
    generic (N : positive);
    port (
        A : in  STD_LOGIC_VECTOR (N - 1 downto 0);
        B : in  STD_LOGIC_VECTOR (N - 1 downto 0);
        C : in  STD_LOGIC_VECTOR (N - 1 downto 0);
        D : in  STD_LOGIC_VECTOR (N - 1 downto 0);
        Sel : in  STD_LOGIC_VECTOR (1 downto 0);
        O : out  STD_LOGIC_VECTOR (N - 1 downto 0)
    );
end MUX_N_4IN1;

architecture MUX_N_4IN1_BEH of MUX_N_4IN1 is

begin

    process (A, B, C, D, Sel)
    begin
        case Sel is
            when "00" => O <= A;
            when "01" => O <= B;
            when "10" => O <= C;
            when "11" => O <= D;
            when others => O <= (others => '-'); -- don't care
        end case;
    end process;

end MUX_N_4IN1_BEH;

