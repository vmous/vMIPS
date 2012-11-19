----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    21:18:02 08/10/2009 
-- Design Name: 
-- Module Name:    MULTI_32_SU_wHILO - MULTI_32_SU_wHILO_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:   32-bit Multiplier    
--                for Signed/Unsigned
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

entity MULTI_32_SU_wHILO is
    port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0);
        HiLoWE : in STD_LOGIC_VECTOR(1 downto 0);
        SignUnsign : in STD_LOGIC;
        HI : out STD_LOGIC_VECTOR(31 downto 0);
        LO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end MULTI_32_SU_wHILO;

architecture MULTI_32_SU_wHILO_BEH of MULTI_32_SU_wHILO is

begin

    process (A, B, HiLoWE, SignUnsign)
        variable a_u, b_u : UNSIGNED(31 downto 0);
        variable hilo_u : UNSIGNED(63 downto 0);
        variable a_s, b_s : SIGNED(31 downto 0);
        variable hilo_s : SIGNED(63 downto 0);
        variable s_local : STD_LOGIC_VECTOR(63 downto 0);
    begin
        if (HiLoWE = "11") then
            if (SignUnsign = '0') then
                -- Unsigned
                a_u := UNSIGNED(A);
                b_u := UNSIGNED(B);
                hilo_u := a_u * b_u;
                s_local := STD_LOGIC_VECTOR(hilo_u);
            else
                -- Signed
                a_s := SIGNED(A);
                b_s := SIGNED(B);
                hilo_s := a_s * b_s;
                s_local := STD_LOGIC_VECTOR(hilo_s);
            end if;
            HI <= s_local(63 downto 32);
            LO <= s_local(31 downto 0);
        else
            -- Move to HI/LO Action
            HI <= A;
            LO <= A;
        end if;
    end process;

end MULTI_32_SU_wHILO_BEH;

