--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:26:45 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_SHIFTROT_32.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SHIFTROT_32
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
 
ENTITY tb_SHIFTROT_32 IS
END tb_SHIFTROT_32;
 
ARCHITECTURE behavior OF tb_SHIFTROT_32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SHIFTROT_32
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         ShiftOp : IN  std_logic_vector(1 downto 0);
         Shamt : IN  std_logic_vector(4 downto 0);
         B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "10000000000000000000000000010111";
   signal ShiftOp : std_logic_vector(1 downto 0) := (others => '0');
   signal Shamt : std_logic_vector(4 downto 0) := "00010";

 	--Outputs
   signal B : std_logic_vector(31 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SHIFTROT_32 PORT MAP (
          A => A,
          ShiftOp => ShiftOp,
          Shamt => Shamt,
          B => B
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
        ShiftOp <= "01";
        -- -------------------------------------
        -- -------------  Current Time:  200ns
        WAIT FOR 100 ns;
        ShiftOp <= "10";
        -- -------------------------------------
        -- -------------  Current Time:  300ns
        WAIT FOR 100 ns;
        ShiftOp <= "11";
        -- -------------------------------------
        -- -------------  Current Time:  1000ns
        WAIT FOR 700 ns;
        A <= "00000000000000000000000000010111";

      wait;
   end process;

END;
