----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    13:59:14 08/10/2009 
-- Design Name: 
-- Module Name:    ADDSUB_32_SU_wOV - ADDSUB_32_SU_wOV_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit Adder-Subtractor
--                 for Signed/Unsigned with Overflow (Carry)
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADDSUB_32_SU_wOV is
    port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0);
        AddSub : in STD_LOGIC;
        SignUnsign : in STD_LOGIC;
        S : out STD_LOGIC_VECTOR(31 downto 0);
        OV : out STD_LOGIC
    );
end ADDSUB_32_SU_wOV;

architecture ADDSUB_32_SU_wOV_BEH of ADDSUB_32_SU_wOV is

begin

    process (A, B, AddSub, SignUnsign)
        variable a_u, b_u, s_u : UNSIGNED(32 downto 0);
        variable a_s, b_s, s_s : SIGNED(32 downto 0);
        variable s_local : STD_LOGIC_VECTOR(32 downto 0);
    begin
        if (SignUnsign = '0') then
            -- Unsigned
            a_u := UNSIGNED('0' & A);
            b_u := UNSIGNED('0' & B);
            if (AddSub = '0') then
                -- Unsigned Subtraction
                s_u := a_u - b_u;
            else
                -- Unsigned Addition
                s_u := a_u + b_u;
            end if;            
            s_local := STD_LOGIC_VECTOR(s_u);
            S <= s_local(31 downto 0);
            OV <= s_local(32);
        else
            -- Signed
            a_s := SIGNED(A(31) & A);
            b_s := SIGNED(A(31) & B);
            if(AddSub = '0') then
                -- Signed Subtraction
                s_s := a_s - b_s;
            else
                -- Signed Addition
                s_s := a_s + b_s;
            end if;
            s_local := STD_LOGIC_VECTOR(s_s);
            S <= s_local(31 downto 0);
            OV <= s_local(32) xor s_local(31);
        end if;
    end process;

end ADDSUB_32_SU_wOV_BEH;

