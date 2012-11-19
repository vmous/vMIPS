--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:15:53 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_BRTRGT_CTRL.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BRTRGT_CTRL
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
 
ENTITY tb_BRTRGT_CTRL IS
END tb_BRTRGT_CTRL;
 
ARCHITECTURE behavior OF tb_BRTRGT_CTRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BRTRGT_CTRL
    PORT(
         BranchType : IN  std_logic_vector(1 downto 0);
         ZRNGMask : IN  std_logic_vector(1 downto 0);
         OneZero : IN  std_logic;
         ZR : IN  std_logic;
         NG : IN  std_logic;
         Target : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal BranchType : std_logic_vector(1 downto 0) := (others => '0');
   signal ZRNGMask : std_logic_vector(1 downto 0) := (others => '0');
   signal OneZero : std_logic := '0';
   signal ZR : std_logic := '0';
   signal NG : std_logic := '0';

 	--Outputs
   signal Target : std_logic_vector(1 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BRTRGT_CTRL PORT MAP (
          BranchType => BranchType,
          ZRNGMask => ZRNGMask,
          OneZero => OneZero,
          ZR => ZR,
          NG => NG,
          Target => Target
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period := 1ns;
 
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ms;	

      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
