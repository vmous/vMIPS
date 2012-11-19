--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:01:27 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_MUX_4_2IN1.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_N_2IN1
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
 
ENTITY tb_MUX_4_2IN1 IS
END tb_MUX_4_2IN1;
 
ARCHITECTURE behavior OF tb_MUX_4_2IN1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX_N_2IN1
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         Sel : IN  std_logic;
         O : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := "0011";
   signal B : std_logic_vector(3 downto 0) := "0100";
   signal Sel : std_logic := '1';

 	--Outputs
   signal O : std_logic_vector(3 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX_N_2IN1 PORT MAP (
          A => A,
          B => B,
          Sel => Sel,
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
        -- -------------  Current Time:  100ns
        WAIT FOR 100 ns;
        Sel <= '0';
        -- -------------------------------------
        -- -------------  Current Time:  200ns
        WAIT FOR 100 ns;
        Sel <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  300ns
        WAIT FOR 100 ns;
        Sel <= '0';
        WAIT FOR 700 ns;


      wait;
   end process;

END;
