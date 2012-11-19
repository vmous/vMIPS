--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:28:39 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_CTRL_FSM.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CTRL_FSM
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
 
ENTITY tb_CTRL_FSM IS
END tb_CTRL_FSM;
 
ARCHITECTURE behavior OF tb_CTRL_FSM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CTRL_FSM
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         IR : IN  std_logic_vector(31 downto 0);
         Branch : IN  std_logic;
         Stall : IN  std_logic;
         IDSignals : OUT  std_logic_vector(4 downto 0);
         EXSignals : OUT  std_logic_vector(16 downto 0);
         MEMSignals : OUT  std_logic_vector(4 downto 0);
         WBSignals : OUT  std_logic_vector(3 downto 0);
         IDEX_MemRead : OUT  std_logic;
         IDEX_MemWrite : OUT  std_logic;
         EXMEM_RegWrite : OUT  std_logic;
         EXMEM_HiLo : OUT  std_logic;
         EXMEM_WriteBack : OUT  std_logic_vector(1 downto 0);
         IFIDWrite : OUT  std_logic;
         PCWrite : OUT  std_logic;
         IFIDFlush : OUT  std_logic;
         IDEXFlush : OUT  std_logic;
         EXMEMFlush : OUT  std_logic;
         ACLRL : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
   signal IR : std_logic_vector(31 downto 0) := (others => '0');
   signal Branch : std_logic := '0';
   signal Stall : std_logic := '0';

 	--Outputs
   signal IDSignals : std_logic_vector(4 downto 0);
   signal EXSignals : std_logic_vector(16 downto 0);
   signal MEMSignals : std_logic_vector(4 downto 0);
   signal WBSignals : std_logic_vector(3 downto 0);
   signal IDEX_MemRead : std_logic;
   signal IDEX_MemWrite : std_logic;
   signal EXMEM_RegWrite : std_logic;
   signal EXMEM_HiLo : std_logic;
   signal EXMEM_WriteBack : std_logic_vector(1 downto 0);
   signal IFIDWrite : std_logic;
   signal PCWrite : std_logic;
   signal IFIDFlush : std_logic;
   signal IDEXFlush : std_logic;
   signal EXMEMFlush : std_logic;
   signal ACLRL : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CTRL_FSM PORT MAP (
          CLK => CLK,
          Reset => Reset,
          IR => IR,
          Branch => Branch,
          Stall => Stall,
          IDSignals => IDSignals,
          EXSignals => EXSignals,
          MEMSignals => MEMSignals,
          WBSignals => WBSignals,
          IDEX_MemRead => IDEX_MemRead,
          IDEX_MemWrite => IDEX_MemWrite,
          EXMEM_RegWrite => EXMEM_RegWrite,
          EXMEM_HiLo => EXMEM_HiLo,
          EXMEM_WriteBack => EXMEM_WriteBack,
          IFIDWrite => IFIDWrite,
          PCWrite => PCWrite,
          IFIDFlush => IFIDFlush,
          IDEXFlush => IDEXFlush,
          EXMEMFlush => EXMEMFlush,
          ACLRL => ACLRL
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
