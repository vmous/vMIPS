--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   04:03:17 10/27/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_DMEM_BR512X32.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DMEM_BR512X32
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
 
ENTITY tb_DMEM_BR512X32 IS
END tb_DMEM_BR512X32;
 
ARCHITECTURE behavior OF tb_DMEM_BR512X32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DMEM_BR512X32
    PORT(
         CLK : IN  std_logic;
         ADDR : IN  std_logic_vector(8 downto 0);
         WE : IN  std_logic;
         DI : IN  std_logic_vector(31 downto 0);
         DO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal ADDR : std_logic_vector(8 downto 0) := "000000000";
   signal WE : std_logic := '0';
   signal DI : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

 	--Outputs
   signal DO : std_logic_vector(31 downto 0) := (others => '0');
 
   constant PERIOD: time := 200ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET : time := 0 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DMEM_BR512X32 PORT MAP (
          CLK => CLK,
          ADDR => ADDR,
          WE => WE,
          DI => DI,
          DO => DO
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
        WE <= '1';
        ADDR <= "000000100";
        DI <= "00000000000000000000000000000101";
        -- -------------------------------------
        -- -------------  Current Time:  285ns
        WAIT FOR 200 ns;
        WE <= '0';
        DI <= "00000000000000000000000000000111";
        -- -------------------------------------
        -- -------------  Current Time:  485ns
        WAIT FOR 200 ns;
        WE <= '1';
        ADDR <= "000001000";
        -- -------------------------------------
        -- -------------  Current Time:  685ns
        WAIT FOR 200 ns;
        --ADDR <= "000000101";
        --DI <= "00000000000011010000000000001101";
        -- -------------------------------------
        WAIT FOR 515 ns;


      wait;
   end process;

END;
