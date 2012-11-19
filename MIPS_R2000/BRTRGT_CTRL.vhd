----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    11:11:50 09/05/2009 
-- Design Name: 
-- Module Name:    BRTRGT_CTRL - BRTRGT_CTRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Control for the Branch Target Selector
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

entity BRTRGT_CTRL is
    port(
        BranchType : in STD_LOGIC_VECTOR(1 downto 0);
        ZRNGMask : in STD_LOGIC_VECTOR(1 downto 0);
        OneZero : in STD_LOGIC;
        ZR : in STD_LOGIC;
        NG : in STD_LOGIC;
        Target: out STD_LOGIC_VECTOR(1 downto 0)
    );
end BRTRGT_CTRL;

architecture BRTRGT_CTRL_BEH of BRTRGT_CTRL is

begin

    process (BranchType, ZRNGMask, OneZero, ZR, NG)
    begin
        if (BranchType /= "11") then
            -- if BranchType = 00 then no branch
            --                   01 then unconditional branch (jump)
            --                   10 then unconditional branch (jump register)
            Target <= BranchType;
        else
            -- else BranchType = 11 then conditional branch
            -- checking ZR and/or NG flags
            if (ZRNGMask = "01") then
                -- check negative (NG) flag...
                if(OneZero = '1') then
                    -- ... asserted
                    if (NG = '1') then
                        -- branch taken
                        Target <= "11";
                    else
                        -- branch NOT taken
                        Target <= "00";
                    end if;
                else
                    -- ... deasserted
                    if (NG = '1') then
                        -- branch NOT taken
                        Target <= "00";
                    else
                        -- branch taken
                        Target <= "11";
                    end if;
                end if;
            elsif (ZRNGMask = "10") then
                -- check zero (ZR) flag...
                if (OneZero = '1') then
                    -- ... asserted
                    if (ZR = '1') then
                        -- branch taken
                        Target <= "11";
                    else
                        -- branch NOT taken
                        Target <= "00";
                    end if;
                else
                    -- ... deasserted
                    if (ZR = '1') then
                        -- branch NOT taken
                        Target <= "00";
                    else
                        -- branch taken
                        Target <= "11";
                    end if;
                end if;
            elsif (ZRNGMask = "11") then
                -- check both zero (ZR) and negative (NG) flags...
                if(OneZero = '1') then
                    -- ... ZR or NG asserted
                    if(NG = '1' or ZR = '1') then
                        -- branch taken
                        Target <= "11";
                    else
                        -- branch NOT taken
                        Target <= "00";
                    end if;
                else
                    -- ... ZR or NG deasserted
                    if(NG = '0' or ZR = '0') then
                        -- branch taken
                        Target <= "11";
                    else
                        -- branch NOT taken
                        Target <= "00";
                    end if;
                end if;
            else
                -- no branch
                Target <= "00";
            end if;
        end if;
    end process;
    
end BRTRGT_CTRL_BEH;

