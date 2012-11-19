--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:59:52 10/24/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_DATAPATH.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DATAPATH
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
 
ENTITY tb_DATAPATH IS
END tb_DATAPATH;
 
ARCHITECTURE behavior OF tb_DATAPATH IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         OV : OUT  std_logic;
         E : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '1';

 	--Outputs
   signal OV : std_logic;
   signal E : std_logic;
 
   constant CLK_period: time := 300ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET : time := 0 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH PORT MAP (
          CLK => CLK,
          RESET => RESET,
          OV => OV,
          E => E
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
    CLK_process: process    -- clock process for CLK
    begin
        wait for OFFSET;
        CLOCK_LOOP : loop
            CLK <= '0';
            wait for (CLK_period - (CLK_period * DUTY_CYCLE));
            CLK <= '1';
            wait for (CLK_period * DUTY_CYCLE);
        end loop CLOCK_LOOP;
    end process;

   -- Stimulus process
   stim_proc: process
   begin

      -- insert stimulus here
      WAIT FOR 285 ns;
      RESET <= '0';
      ---------------------------------------
      WAIT FOR 99915 ns;

      
      --wait for 100ns;
      --RESET <= '0';
      --wait for 100ns;
      --RESET <= '1';

      wait;
   end process;

END;
