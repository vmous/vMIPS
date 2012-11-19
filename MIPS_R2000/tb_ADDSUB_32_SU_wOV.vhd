--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:23:58 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_ADDSUB_32_SU_wOV.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ADDSUB_32_SU_wOV
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
--USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ADDSUB_32_SU_wOV IS
END tb_ADDSUB_32_SU_wOV;
 
ARCHITECTURE behavior OF tb_ADDSUB_32_SU_wOV IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ADDSUB_32_SU_wOV
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         AddSub : IN  std_logic;
         SignUnsign : IN  std_logic;
         S : OUT  std_logic_vector(31 downto 0);
         OV : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000001010";
   signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000000111";
   signal AddSub : std_logic := '1';
   signal SignUnsign : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(31 downto 0) := (others => '0');
   signal OV : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ADDSUB_32_SU_wOV PORT MAP (
          A => A,
          B => B,
          AddSub => AddSub,
          SignUnsign => SignUnsign,
          S => S,
          OV => OV
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
        -- -------------  Current Time:  100ns
        WAIT FOR 100 ns;
        SignUnsign <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  200ns
        WAIT FOR 100 ns;
        AddSub <= '0';
        -- -------------------------------------
        -- -------------  Current Time:  300ns
        WAIT FOR 100 ns;
        B <= "00000000000000000000000000001101";
        -- -------------------------------------
        -- -------------  Current Time:  500ns
        WAIT FOR 200 ns;
        AddSub <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  600ns
        WAIT FOR 100 ns;
        A <= "11111111111111111111111111110011";
        -- -------------------------------------
        -- -------------  Current Time:  700ns
        WAIT FOR 100 ns;
        A <= "11111111111111111111111111110010";
        -- -------------------------------------
        -- -------------  Current Time:  800ns
        WAIT FOR 100 ns;
        SignUnsign <= '0';
        WAIT FOR 200 ns;


      wait;
   end process;

END;
