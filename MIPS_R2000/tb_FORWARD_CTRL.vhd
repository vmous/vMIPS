--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:30:37 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_FORWARD_CTRL.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FORWARD_CTRL
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
 
ENTITY tb_FORWARD_CTRL IS
END tb_FORWARD_CTRL;
 
ARCHITECTURE behavior OF tb_FORWARD_CTRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FORWARD_CTRL
    PORT(
         IDEX_Rs : IN  std_logic_vector(4 downto 0);
         IDEX_Rt : IN  std_logic_vector(4 downto 0);
         EXMEM_RegWrite : IN  std_logic;
         EXMEM_Rd : IN  std_logic_vector(4 downto 0);
         MEMWB_RegWrite : IN  std_logic;
         MEMWB_Rd : IN  std_logic_vector(4 downto 0);
         IDEX_MemWrite : IN  std_logic;
         EXMEM_MemRead : IN  std_logic;
         ForwardA : OUT  std_logic_vector(1 downto 0);
         ForwardB : OUT  std_logic_vector(1 downto 0);
         ForwardMEM : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IDEX_Rs : std_logic_vector(4 downto 0) := (others => '0');
   signal IDEX_Rt : std_logic_vector(4 downto 0) := (others => '0');
   signal EXMEM_RegWrite : std_logic := '0';
   signal EXMEM_Rd : std_logic_vector(4 downto 0) := (others => '0');
   signal MEMWB_RegWrite : std_logic := '0';
   signal MEMWB_Rd : std_logic_vector(4 downto 0) := (others => '0');
   signal IDEX_MemWrite : std_logic := '0';
   signal EXMEM_MemRead : std_logic := '0';

 	--Outputs
   signal ForwardA : std_logic_vector(1 downto 0);
   signal ForwardB : std_logic_vector(1 downto 0);
   signal ForwardMEM : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FORWARD_CTRL PORT MAP (
          IDEX_Rs => IDEX_Rs,
          IDEX_Rt => IDEX_Rt,
          EXMEM_RegWrite => EXMEM_RegWrite,
          EXMEM_Rd => EXMEM_Rd,
          MEMWB_RegWrite => MEMWB_RegWrite,
          MEMWB_Rd => MEMWB_Rd,
          IDEX_MemWrite => IDEX_MemWrite,
          EXMEM_MemRead => EXMEM_MemRead,
          ForwardA => ForwardA,
          ForwardB => ForwardB,
          ForwardMEM => ForwardMEM
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period := 1ns;
 
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ms;	

      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
