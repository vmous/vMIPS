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
-- Description: 
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
library UNISIM;
use UNISIM.VComponents.all;

entity FOOBAR is
    port(
        CLK : in  STD_LOGIC;
        RADDR_A : in  STD_LOGIC_VECTOR (4 downto 0);
        RADDR_B : in  STD_LOGIC_VECTOR (4 downto 0);
        WADDR : in  STD_LOGIC_VECTOR (4 downto 0);
        WDAT : in  STD_LOGIC_VECTOR (31 downto 0);
        WE : in  STD_LOGIC;
        EN : in  STD_LOGIC;
        RST  : in  STD_LOGIC;
        RDAT_B : out  STD_LOGIC_VECTOR (31 downto 0);
        RDAT_A : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end FOOBAR;

architecture FOOBAR_BEH of FOOBAR is





-- Component Declaration for these design elements
-- should be placed after architecture statement but before begin keyword
-- For the following component declaration, enter RAMB16_S9_{S9 | S18 | S36},
-- RAMB16_S18_{S18 | S36}, or RAMB16_S36_S36
component RAMB16_S36_S36
-- synthesis translate_off
generic (
       INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_20 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_21 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_22 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_23 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_24 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_25 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_26 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_27 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_28 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_29 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_2F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_30 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_31 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_32 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_33 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_34 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_35 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_36 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_37 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_38 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_39 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
INIT_3F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_A : bit_vector := X"0";
       INIT_B : bit_vector := X"0";
       INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       SRVAL_A : bit_vector := X"0";
       SRVAL_B : bit_vector := X"0";
       WRITE_MODE_A : string := "WRITE_FIRST";
       WRITE_MODE_B : string := "WRITE_FIRST";
);
   -- synthesis translate_on
   port (DOA : out STD_LOGIC_VECTOR (31 downto 0);
         DOB : out STD_LOGIC_VECTOR (31 downto 0);
         --DOPA : out STD_LOGIC_VECTOR (3 downto 0);
         --DOPB : out STD_LOGIC_VECTOR (3 downto 0);
         ADDRA : in STD_LOGIC_VECTOR (4 downto 0);
         ADDRB : in STD_LOGIC_VECTOR (4 downto 0);
         CLKA : in STD_ULOGIC;
         CLKB : in STD_ULOGIC;
         DIA : in STD_LOGIC_VECTOR (31 downto 0);
         DIB : in STD_LOGIC_VECTOR (31 downto 0);
         --DIPA : in STD_LOGIC_VECTOR (3 downto 0);
         --DIPB : in STD_LOGIC_VECTOR (3 downto 0);
         ENA: in STD_ULOGIC;
         ENB : in STD_ULOGIC;
         SSRA : in STD_ULOGIC;
         SSRB : in STD_ULOGIC;
         WEA : in STD_ULOGIC;
         WEB : in STD_ULOGIC);
end component; 

begin
  
   -- RAMB16_S36_S36: Spartan-3/3E 512 x 32 + 4 Parity bits Dual-Port RAM
   -- Xilinx HDL Language Template, version 11.1

   RAMB16_S36_S36_inst : RAMB16_S36_S36
   port map (
      DOA => RDAT_A,      -- Port A 32-bit Data Output
      DOB => RDAT_B,      -- Port B 32-bit Data Output
      --DOPA => "0000",    -- Port A 4-bit Parity Output
      --DOPB => "0000",    -- Port B 4-bit Parity Output
      ADDRA => WADDR,  -- Port A 9-bit Address Input
      ADDRB => WADDR,  -- Port B 9-bit Address Input
      CLKA => CLK,    -- Port A Clock
      CLKB => CLK,    -- Port B Clock
      DIA => WDAT,      -- Port A 32-bit Data Input
      DIB => WDAT,      -- Port B 32-bit Data Input
      --DIPA => "0000",    -- Port A 4-bit parity Input
      --DIPB => "0000",    -- Port-B 4-bit parity Input
      ENA => EN,      -- Port A RAM Enable Input
      ENB => EN,      -- PortB RAM Enable Input
      SSRA => RST,    -- Port A Synchronous Set/Reset Input
      SSRB => RST,    -- Port B Synchronous Set/Reset Input
      WEA => WE,      -- Port A Write Enable Input
      WEB => WE       -- Port B Write Enable Input
   );

end FOOBAR_BEH;


			

