----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    07:50:16 09/07/2009 
-- Design Name: 
-- Module Name:    DMEM_COORD - DMEM_COORD_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Data Memory Controling Operation
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

entity DMEM_COORD is
    port (
        MDRI : in STD_LOGIC_VECTOR(31 downto 0);
        DMDI : in STD_LOGIC_VECTOR(31 downto 0);
        MemRead : in STD_LOGIC;
        MemWrite : in STD_LOGIC;
        SignZeroLoad : in STD_LOGIC;
        ByteMask : in STD_LOGIC_VECTOR(3 downto 0);
        MDRO : out STD_LOGIC_VECTOR(31 downto 0);
        DMDO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DMEM_COORD;

architecture DMEM_COORD_BEH of DMEM_COORD is

begin

    process (MemRead, MemWrite, SignZeroLoad, ByteMask, DMDI, MDRI)
    begin
        if (MemRead = '1') then
            -- read data memory operation
            case ByteMask is
                -- read byte
                when "0001" =>
                    MDRO(7 downto 0) <= DMDI(7 downto 0);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 8 to 31 loop
                            MDRO(I) <= DMDI(7);
                        end loop;
                    else
                        MDRO(31 downto 8) <= "000000000000000000000000";
                    end if;
                when "0010" =>
                    MDRO(7 downto 0) <= DMDI(15 downto 8);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 8 to 31 loop
                            MDRO(I) <= DMDI(15);
                        end loop;
                    else
                        MDRO(31 downto 8) <= "000000000000000000000000";
                    end if;
                when "0100" =>
                    MDRO(7 downto 0) <= DMDI(23 downto 16);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 8 to 31 loop
                            MDRO(I) <= DMDI(23);
                        end loop;
                    else
                        MDRO(31 downto 8) <= "000000000000000000000000";
                    end if;
                when "1000" =>
                    MDRO(7 downto 0) <= DMDI(31 downto 24);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 8 to 31 loop
                            MDRO(I) <= DMDI(31);
                        end loop;
                    else
                        MDRO(31 downto 8) <= "000000000000000000000000";
                    end if;
                -- read half-word
                when "0011" =>
                    MDRO(15 downto 0) <= DMDI(15 downto 0);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 16 to 31 loop
                            MDRO(I) <= DMDI(15);
                        end loop;
                    else
                        MDRO(31 downto 16) <= "0000000000000000";
                    end if;
                when "1100" =>
                    MDRO(15 downto 0) <= DMDI(31 downto 16);
                    -- sign or zero extention
                    if (SignZeroLoad = '1') then
                        for I in 16 to 31 loop
                            MDRO(I) <= DMDI(31);
                        end loop;
                    else
                        MDRO(31 downto 16) <= "0000000000000000";
                    end if;
                -- read word
                when others =>
                    MDRO <= DMDI;
            end case;
            DMDO <= (others => '0');
        else
            MDRO <= (others => '0');
        end if;

        if (MemWrite = '1') then
            -- write data memory operation
            case ByteMask is
                -- write byte
                when "0001" =>
                    DMDO(7 downto 0) <= MDRI(7 downto 0);
                    -- leave rest as are
                    DMDO(31 downto 8) <= DMDI(31 downto 8);
                when "0010" =>
                    DMDO(15 downto 8) <= MDRI(7 downto 0);
                    -- leave rest as are
                    DMDO(7 downto 0) <= DMDI(7 downto 0);
                    DMDO(31 downto 16) <= DMDI(31 downto 16);
                when "0100" =>
                    DMDO(23 downto 16) <= MDRI(7 downto 0);
                    -- leave rest as are
                    DMDO(15 downto 0) <= DMDI(15 downto 0);
                    DMDO(31 downto 24) <= DMDI(31 downto 24);
                when "1000" =>
                    DMDO(31 downto 24) <= MDRI(7 downto 0);
                    -- leave rest as are
                    DMDO(23 downto 0) <= DMDI(23 downto 0);
                -- write half-word
                when "0011" =>
                    DMDO(15 downto 0) <= MDRI(15 downto 0);
                    -- leave rest as are
                    DMDO(31 downto 16) <= DMDI(31 downto 16);
                when "1100" =>
                    DMDO(31 downto 16) <= MDRI(15 downto 0);
                    -- leave rest as are
                    DMDO(15 downto 0) <= DMDI(15 downto 0);
                -- write word
                when others =>
                    DMDO <= MDRI;
            end case;
            MDRO <= (others => '0');
        else
            -- don't care
            DMDO <= (others => '0');
        end if;
    end process;

end DMEM_COORD_BEH;

