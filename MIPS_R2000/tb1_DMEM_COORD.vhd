--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   03:27:38 10/27/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb1_DMEM_COORD.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DMEM_COORD
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
 
ENTITY tb1_DMEM_COORD IS
END tb1_DMEM_COORD;
 
ARCHITECTURE behavior OF tb1_DMEM_COORD IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DMEM_COORD
    PORT(
         MDRI : IN  std_logic_vector(31 downto 0);
         DMDI : IN  std_logic_vector(31 downto 0);
         MemRead : IN  std_logic;
         MemWrite : IN  std_logic;
         SignZeroLoad : IN  std_logic;
         ByteMask : IN  std_logic_vector(3 downto 0);
         MDRO : OUT  std_logic_vector(31 downto 0);
         DMDO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MDRI : std_logic_vector(31 downto 0) := "11110000011100000011000000010000";
   signal DMDI : std_logic_vector(31 downto 0) := "00001111000001110000001100000001";
   signal MemRead : std_logic := '0';
   signal MemWrite : std_logic := '1';
   signal SignZeroLoad : std_logic := '0';
   signal ByteMask : std_logic_vector(3 downto 0) := "1111";

 	--Outputs
   signal MDRO : std_logic_vector(31 downto 0) := (others => '0');
   signal DMDO : std_logic_vector(31 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DMEM_COORD PORT MAP (
          MDRI => MDRI,
          DMDI => DMDI,
          MemRead => MemRead,
          MemWrite => MemWrite,
          SignZeroLoad => SignZeroLoad,
          ByteMask => ByteMask,
          MDRO => MDRO,
          DMDO => DMDO
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
                ByteMask <= "0011";
                -- -------------------------------------
                -- -------------  Current Time:  300ns
                WAIT FOR 100 ns;
                ByteMask <= "1100";
                -- -------------------------------------
                -- -------------  Current Time:  400ns
                WAIT FOR 100 ns;
                ByteMask <= "1000";
                -- -------------------------------------
                -- -------------  Current Time:  500ns
                WAIT FOR 100 ns;
                ByteMask <= "0100";
                -- -------------------------------------
                -- -------------  Current Time:  600ns
                WAIT FOR 100 ns;
                ByteMask <= "0010";
                -- -------------------------------------
                -- -------------  Current Time:  700ns
                WAIT FOR 100 ns;
                ByteMask <= "0001";
                -- -------------------------------------
                -- -------------  Current Time:  1000ns
                WAIT FOR 300 ns;
                MemRead <= '1';
                MemWrite <= '0';

      wait;
   end process;

END;
