--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:24:56 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_MULTI_32_SU_wHILO.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MULTI_32_SU_wHILO
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_MULTI_32_SU_wHILO IS
END tb_MULTI_32_SU_wHILO;
 
ARCHITECTURE behavior OF tb_MULTI_32_SU_wHILO IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MULTI_32_SU_wHILO
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         HiLoWE : IN  std_logic_vector(1 downto 0);
         SignUnsign : IN  std_logic;
         HI : OUT  std_logic_vector(31 downto 0);
         LO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000101";
   signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000000011";
   signal HiLoWE : std_logic_vector(1 downto 0) := "11";
   signal SignUnsign : std_logic := '0';

 	--Outputs
   signal HI : std_logic_vector(31 downto 0) := (others => '0');
   signal LO : std_logic_vector(31 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MULTI_32_SU_wHILO PORT MAP (
          A => A,
          B => B,
          HiLoWE => HiLoWE,
          SignUnsign => SignUnsign,
          HI => HI,
          LO => LO
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period := 1ns;
 
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
--      wait for 100ms;	

--      wait for <clock>_period*10;

      -- insert stimulus here 
        -- -------------  Current Time:  200ns
        WAIT FOR 200 ns;
        SignUnsign <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  400ns
        WAIT FOR 200 ns;
        A <= "11111111111111111111111111111011";
        -- -------------------------------------
        -- -------------  Current Time:  600ns
        WAIT FOR 200 ns;
        A <= "00000000000000000000000000000101";
        -- -------------------------------------
        -- -------------  Current Time:  700ns
        WAIT FOR 100 ns;
        HiLoWE <= "00";
        -- -------------------------------------
        -- -------------  Current Time:  1000ns
        WAIT FOR 300 ns;
        SignUnsign <= '0';


      wait;
   end process;

END;
