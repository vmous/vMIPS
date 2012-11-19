----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    23:26:26 08/10/2009 
-- Design Name: 
-- Module Name:    SHIFTROT_32 - SHIFTROT_32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    32-bit Shifter - Rotator
--                 supports Logical(Unsigned) and Arithmetic(Signed)
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--                  ShiftOp = 00 : LOGIC LEFT SHIFT 
--                  ShiftOp = 01 : LOGIC RIGHT SHIFT
--                  ShiftOp = 10 : ARITHMETIC RIGHT SHIFT
--                  ShiftOp = 11 : LEFT ROTATION
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- The following import must be commented out in order for
-- the IEEE.NUMERIC_STD.ALL to work with line
-- foo := TO_INTEGER(UNSIGNED(FOO))
-- use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SHIFTROT_32 is
    port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        ShiftOp : in STD_LOGIC_VECTOR(1 downto 0);
        Shamt : in STD_LOGIC_VECTOR(4 downto 0);
        B : out STD_LOGIC_VECTOR(31 downto 0)
    );
end SHIFTROT_32;

architecture SHIFTROT_32_BEH of SHIFTROT_32 is

begin

    process (A, ShiftOp, Shamt)
        variable shamt_n : NATURAL range 0 to 31;
        variable a_u : UNSIGNED(31 downto 0);
        variable a_s : SIGNED(31 downto 0);
    begin
        shamt_n := TO_INTEGER(UNSIGNED(Shamt));
        a_u := UNSIGNED(A);
        a_s := SIGNED(A);
        case ShiftOp is
            when "00" => B <= STD_LOGIC_VECTOR(SHIFT_LEFT(a_u, shamt_n));
            when "01" => B <= STD_LOGIC_VECTOR(SHIFT_RIGHT(a_u, shamt_n));
            when "10" => B <= STD_LOGIC_VECTOR(SHIFT_RIGHT(a_s, shamt_n));
            when "11" => B <= STD_LOGIC_VECTOR(ROTATE_LEFT(a_u, shamt_n));
            when others => null;
        end case;
    end process;

end SHIFTROT_32_BEH;

