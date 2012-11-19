--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:28:14 11/03/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_REG_4_wSACLRL.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: REG_N_wSACLRL
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
 
ENTITY tb_REG_4_wSACLRL IS
END tb_REG_4_wSACLRL;
 
ARCHITECTURE behavior OF tb_REG_4_wSACLRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT REG_N_wSACLRL
    PORT(
         CLK : IN  std_logic;
         D : IN  std_logic_vector(3 downto 0);
         SCLRL : IN  std_logic;
         ACLRL : IN  std_logic;
         Q : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal D : std_logic_vector(3 downto 0) := (others => '0');
   signal SCLRL : std_logic := '1';
   signal ACLRL : std_logic := '1';

 	--Outputs
   signal Q : std_logic_vector(3 downto 0) := (others => '0');
 
   constant PERIOD: time := 200ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET : time := 0 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: REG_N_wSACLRL PORT MAP (
          CLK => CLK,
          D => D,
          SCLRL => SCLRL,
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
        SCLRL <= '1';
        D <= "0001";
        -- -------------------------------------
        -- -------------  Current Time:  285ns
        WAIT FOR 200 ns;
        D <= "0000";
        -- -------------------------------------
        -- -------------  Current Time:  485ns
        WAIT FOR 200 ns;
        D <= "0101";
        -- -------------------------------------
        -- -------------  Current Time:  685ns
        WAIT FOR 200 ns;
        SCLRL <= '0';
        D <= "1101";
        -- -------------------------------------
        -- -------------  Current Time:  885ns
        WAIT FOR 200 ns;
        SCLRL <= '1';
        -- -------------------------------------
        WAIT FOR 315 ns;

      wait;
   end process;

END;
