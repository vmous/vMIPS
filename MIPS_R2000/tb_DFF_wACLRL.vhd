--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:06:15 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_DFF_wACLRL.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DFF_wACLRL
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
 
ENTITY tb_DFF_wACLRL IS
END tb_DFF_wACLRL;
 
ARCHITECTURE behavior OF tb_DFF_wACLRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DFF_wACLRL
    PORT(
         CLK : IN  std_logic;
         D : IN  std_logic;
         ACLRL : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal D : std_logic := '0';
   signal ACLRL : std_logic := '0';

 	--Outputs
   signal Q : std_logic;
 
   constant PERIOD: time := 200ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET : time := 0 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DFF_wACLRL PORT MAP (
          CLK => CLK,
          D => D,
          ACLRL => ACLRL,
          Q => Q
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
 
CLK_process: process    -- clock process for CLK
    begin
        wait for OFFSET;
        CLOCK_LOOP : loop
            CLK <= '0';
            wait for (PERIOD - (PERIOD * DUTY_CYCLE));
            CLK <= '1';
            wait for (PERIOD * DUTY_CYCLE);
        end loop CLOCK_LOOP;
    end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
--      wait for 100ms;	

--      wait for <clock>_period*10;

      -- insert stimulus here 
        -- -------------  Current Time:  85ns
        WAIT FOR 85 ns;
        ACLRL <= '1';
        D <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  285ns
        WAIT FOR 200 ns;
        D <= '0';
        -- -------------------------------------
        -- -------------  Current Time:  485ns
        WAIT FOR 200 ns;
        D <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  685ns
        WAIT FOR 200 ns;
        ACLRL <= '0';
        D <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  885ns
        WAIT FOR 200 ns;
        ACLRL <= '1';
        -- -------------------------------------
        WAIT FOR 315 ns;

      wait;
   end process;

END;
