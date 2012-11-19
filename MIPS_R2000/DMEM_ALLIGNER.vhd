----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    15:26:07 09/06/2009 
-- Design Name: 
-- Module Name:    DMEM_ALLIGNER - DMEM_ALLIGNER_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Allignment Error Detector and Byte Mask Selector
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

entity DMEM_ALLIGNER is
    port(
        LSB : in STD_LOGIC_VECTOR(1 downto 0);
        isWord : in STD_LOGIC;
        ByteHalf : in STD_LOGIC;
        ERR : out STD_LOGIC;
        M : out STD_LOGIC_VECTOR(3 downto 0)
    );
end DMEM_ALLIGNER;

architecture DMEM_ALLIGNER_BEH of DMEM_ALLIGNER is

begin

    process(isWord, ByteHalf, LSB)
        variable v_mask : STD_LOGIC_VECTOR(3 downto 0);
        variable v_error : STD_LOGIC;
    begin

        v_error := '0';
        if (isWord = '1') then
            -- is word
            if (LSB = "00") then
                v_mask := "1111";
            else
                -- error
                v_mask := "0000";
                v_error := '1';
            end if;
        else
            if (ByteHalf = '1') then
                -- is byte
                -- no possibility of allignment error
                if (LSB = "00") then
                    v_mask := "1000";
                elsif (LSB = "01") then
                    v_mask := "0100";
                elsif (LSB = "10") then
                    v_mask := "0010";
                else
                    v_mask := "0001";
                end if;
            else
                -- is half-word
                if (LSB = "00") then
                    v_mask := "1100";
                elsif (LSB = "10") then
                    v_mask := "0011";
                else
                    -- error
                    v_mask := "0000";
                    v_error := '1';
                end if;
            end if;
        end if;

        M <= v_mask;
        ERR <= v_error;

    end process;

end DMEM_ALLIGNER_BEH;

