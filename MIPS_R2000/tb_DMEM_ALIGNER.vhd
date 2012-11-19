--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:20:00 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_DMEM_ALIGNER.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DMEM_ALIGNER
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
 
ENTITY tb_DMEM_ALIGNER IS
END tb_DMEM_ALIGNER;
 
ARCHITECTURE behavior OF tb_DMEM_ALIGNER IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DMEM_ALIGNER
    PORT(
         LSB : IN  std_logic_vector(1 downto 0);
         isWord : IN  std_logic;
         ByteHalf : IN  std_logic;
         ERR : OUT  std_logic;
         M : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal LSB : std_logic_vector(1 downto 0) := (others => '0');
   signal isWord : std_logic := '0';
   signal ByteHalf : std_logic := '1';

 	--Outputs
   signal ERR : std_logic := '0';
   signal M : std_logic_vector(3 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DMEM_ALIGNER PORT MAP (
          LSB => LSB,
          isWord => isWord,
          ByteHalf => ByteHalf,
          ERR => ERR,
          M => M
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
        LSB <= "01";
        -- -------------------------------------
        -- -------------  Current Time:  200ns
        WAIT FOR 100 ns;
        LSB <= "10";
        -- -------------------------------------
        -- -------------  Current Time:  300ns
        WAIT FOR 100 ns;
        LSB <= "11";
        -- -------------------------------------
        -- -------------  Current Time:  400ns
        WAIT FOR 100 ns;
        ByteHalf <= '0';
        LSB <= "00";
        -- -------------------------------------
        -- -------------  Current Time:  500ns
        WAIT FOR 100 ns;
        LSB <= "01";
        -- -------------------------------------
        -- -------------  Current Time:  600ns
        WAIT FOR 100 ns;
        LSB <= "10";
        -- -------------------------------------
        -- -------------  Current Time:  700ns
        WAIT FOR 100 ns;
        LSB <= "11";
        -- -------------------------------------
        -- -------------  Current Time:  800ns
        WAIT FOR 100 ns;
        isWord <= '1';
        LSB <= "00";
        -- -------------------------------------
        -- -------------  Current Time:  900ns
        WAIT FOR 100 ns;
        LSB <= "01";
        -- -------------------------------------
        -- -------------  Current Time:  1000ns
        WAIT FOR 100 ns;
        LSB <= "10";
        -- -------------------------------------
        -- -------------  Current Time:  1100ns
        WAIT FOR 100 ns;
        LSB <= "11";
        WAIT FOR 400 ns;


      wait;
   end process;

END;
