--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:12:46 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_SL2_32.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SL2_32
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
 
ENTITY tb_SL2_32 IS
END tb_SL2_32;
 
ARCHITECTURE behavior OF tb_SL2_32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SL2_32
    PORT(
         I : IN  std_logic_vector(31 downto 0);
         O : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(31 downto 0) := "00000000000000000000000000000101";

 	--Outputs
   signal O : std_logic_vector(31 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SL2_32 PORT MAP (
          I => I,
          O => O
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
        -- -------------  Current Time:  300ns
        WAIT FOR 300 ns;
        I <= "11000000000000000000000000000101";
        -- -------------------------------------
        -- -------------  Current Time:  600ns
        WAIT FOR 300 ns;
        I <= "11000000000000000000000000000000";
        -- -------------------------------------
        -- -------------  Current Time:  1000ns
        WAIT FOR 400 ns;
        I <= "01000000000000000000000000000000";

      wait;
   end process;

END;
