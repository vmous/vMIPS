--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:09:12 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_MUX_4_4IN1.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_N_4IN1
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
 
ENTITY tb_MUX_4_4IN1 IS
END tb_MUX_4_4IN1;
 
ARCHITECTURE behavior OF tb_MUX_4_4IN1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX_N_4IN1
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         C : IN  std_logic_vector(3 downto 0);
         D : IN  std_logic_vector(3 downto 0);
         Sel : IN  std_logic_vector(1 downto 0);
         O : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := "0001";
   signal B : std_logic_vector(3 downto 0) := "0010";
   signal C : std_logic_vector(3 downto 0) := "0100";
   signal D : std_logic_vector(3 downto 0) := "1000";
   signal Sel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal O : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX_N_4IN1 PORT MAP (
          A => A,
          B => B,
          C => C,
          D => D,
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
            -- -------------  Current Time:  285ns
            WAIT FOR 285 ns;
            Sel <= "01";
            -- -------------------------------------
            -- -------------  Current Time:  485ns
            WAIT FOR 200 ns;
            Sel <= "10";
            -- -------------------------------------
            -- -------------  Current Time:  685ns
            WAIT FOR 200 ns;
            Sel <= "11";
            -- -------------------------------------
            WAIT FOR 715 ns;

      wait;
   end process;

END;
