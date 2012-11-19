--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:19:24 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_DMEM_CTRL.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DMEM_CTRL
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
 
ENTITY tb_DMEM_CTRL IS
END tb_DMEM_CTRL;
 
ARCHITECTURE behavior OF tb_DMEM_CTRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DMEM_CTRL
    PORT(
         ALUO : IN  std_logic_vector(31 downto 0);
         MDRI : IN  std_logic_vector(31 downto 0);
         DMDI : IN  std_logic_vector(31 downto 0);
         MemRead : IN  std_logic;
         MemWrite : IN  std_logic;
         SignZeroLoad : IN  std_logic;
         isWord : IN  std_logic;
         ByteHalf : IN  std_logic;
         E : OUT  std_logic;
         DMWE : OUT  std_logic;
         DMA : OUT  std_logic_vector(29 downto 0);
         MDRO : OUT  std_logic_vector(31 downto 0);
         DMDO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ALUO : std_logic_vector(31 downto 0) := "00000000000000000000000000001010";
   signal MDRI : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
   signal DMDI : std_logic_vector(31 downto 0) := (others => '0');
   signal MemRead : std_logic := '0';
   signal MemWrite : std_logic := '1';
   signal SignZeroLoad : std_logic := '0';
   signal isWord : std_logic := '0';
   signal ByteHalf : std_logic := '1';

 	--Outputs
   signal E : std_logic;
   signal DMWE : std_logic;
   signal DMA : std_logic_vector(29 downto 0) := (others => '0');
   signal MDRO : std_logic_vector(31 downto 0) := (others => '0');
   signal DMDO : std_logic_vector(31 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DMEM_CTRL PORT MAP (
          ALUO => ALUO,
          MDRI => MDRI,
          DMDI => DMDI,
          MemRead => MemRead,
          MemWrite => MemWrite,
          SignZeroLoad => SignZeroLoad,
          isWord => isWord,
          ByteHalf => ByteHalf,
          E => E,
          DMWE => DMWE,
          DMA => DMA,
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
        -- -------------  Current Time:  100ns
        WAIT FOR 100 ns;
        ByteHalf <= '0';
        -- -------------------------------------
        -- -------------  Current Time:  200ns
        WAIT FOR 100 ns;
        isWord <= '1';
        -- -------------------------------------
        -- -------------  Current Time:  300ns
        WAIT FOR 100 ns;
        ALUO <= "00000000000000000000000000001100";
        -- -------------------------------------
        -- -------------  Current Time:  400ns
        WAIT FOR 100 ns;
        isWord <= '0';
        ALUO <= "00000000000000000000000000001011";
        -- -------------------------------------
        -- -------------  Current Time:  500ns
        WAIT FOR 100 ns;
        ByteHalf <= '1';
        WAIT FOR 500 ns;


      wait;
   end process;

END;
