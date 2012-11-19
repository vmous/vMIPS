----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:00:58 08/14/2009 
-- Design Name: 
-- Module Name:    REGFILE_BR32X32 - REGFILE_BR32X32_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Register File Construct
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This attempt does not infer a Block RAM but it does
--                      have the characteristics (writes at the rising edge
--                      while reads at the falling edge) the design requires.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REGFILE_BR32X32 is
    port (
        CLK : in  STD_LOGIC;
        RADDR_A : in  STD_LOGIC_VECTOR (4 downto 0);
        RADDR_B : in  STD_LOGIC_VECTOR (4 downto 0);
        WADDR : in  STD_LOGIC_VECTOR (4 downto 0);
        WDAT : in  STD_LOGIC_VECTOR (31 downto 0);
        WE : in  STD_LOGIC;
        ACLRL : in  STD_LOGIC;
        RDAT_A : out  STD_LOGIC_VECTOR (31 downto 0);
        RDAT_B : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end REGFILE_BR32X32;

architecture REGFILE_BR32X32_BEH of REGFILE_BR32X32 is

    type br32x32_t is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal regfile : br32x32_t;

begin

    -- Read Functional Section
    process(CLK)
    begin
        if (CLK'event and CLK='0') then
            -- buildin function conv_integer change the type
            -- from std_logic_vector to integer
            RDAT_A <= regfile(CONV_INTEGER(RADDR_A)); 
            RDAT_B <= regfile(CONV_INTEGER(RADDR_B)); 
        end if;				
    end process;

    -- Write Functional Section
    process(CLK, WE, WADDR, ACLRL, WDAT)
    begin
        if (CLK'event and CLK='1') then
            if(ACLRL = '0') then
                for I in 0 to 31 loop
                    regfile(CONV_INTEGER(I)) <= (others => '0');
                end loop;
            else
                if (WE = '1') then
                    if(WADDR /= "00000") then
                        regfile(CONV_INTEGER(WADDR)) <= WDAT;
                    end if;
                end if;
            end if;
        end if;
    end process;

end REGFILE_BR32X32_BEH;

