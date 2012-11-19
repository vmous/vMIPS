--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:08:35 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_REGFILE_BR32X32.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: REGFILE_BR32X32
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
 
ENTITY tb_REGFILE_BR32X32 IS
END tb_REGFILE_BR32X32;
 
ARCHITECTURE behavior OF tb_REGFILE_BR32X32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT REGFILE_BR32X32
    PORT(
         CLK : IN  std_logic;
         RADDR_A : IN  std_logic_vector(4 downto 0);
         RADDR_B : IN  std_logic_vector(4 downto 0);
         WADDR : IN  std_logic_vector(4 downto 0);
         WDAT : IN  std_logic_vector(31 downto 0);
         WE : IN  std_logic;
         ACLRL : IN  std_logic;
         RDAT_A : OUT  std_logic_vector(31 downto 0);
         RDAT_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RADDR_A : std_logic_vector(4 downto 0) := "00000";
   signal RADDR_B : std_logic_vector(4 downto 0) := "00001";
   signal WADDR : std_logic_vector(4 downto 0) := "00000";
   signal WDAT : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal ACLRL : std_logic := '0';

 	--Outputs
   signal RDAT_A : std_logic_vector(31 downto 0);
   signal RDAT_B : std_logic_vector(31 downto 0);
 
   constant PERIOD : time := 200 ns;
   constant DUTY_CYCLE : real := 0.5;
   constant OFFSET : time := 0 ns;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: REGFILE_BR32X32 PORT MAP (
          CLK => CLK,
          RADDR_A => RADDR_A,
          RADDR_B => RADDR_B,
          WADDR => WADDR,
          WDAT => WDAT,
          WE => WE,
          ACLRL => ACLRL,
          RDAT_A => RDAT_A,
          RDAT_B => RDAT_B
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
        -- -------------------------------------
        -- -------------  Current Time:  285ns
        WAIT FOR 200 ns;
        WE <= '1';
        WADDR <= "00001";
        WDAT <= "00000000000000000000000000000101";
        -- -------------------------------------
        -- -------------  Current Time:  485ns
        WAIT FOR 200 ns;
        RADDR_A <= "00001";
        WADDR <= "00010";
        WDAT <= "00000000000000000000000000000110";
        -- -------------------------------------
        -- -------------  Current Time:  685ns
        WAIT FOR 200 ns;
        WE <= '0';
        RADDR_A <= "00010";
        WADDR <= "00000";
        -- -------------------------------------
        WAIT FOR 515 ns;


      wait;
   end process;

END;
