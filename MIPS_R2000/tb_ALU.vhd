--------------------------------------------------------------------------------
-- Company:       National and Kapodistrian University of Athens
-- Engineer:      Vassilis S. Moustakas
--
-- Create Date:   22:14:38 10/26/2009
-- Design Name:   
-- Module Name:   Z:/516-add/myproject/MIPS_R2000/tb_ALU.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Shamt : IN  std_logic_vector(4 downto 0);
         ALUOp : IN  std_logic_vector(1 downto 0);
         AddSub : IN  std_logic;
         SignUnsign : IN  std_logic;
         LogicOp : IN  std_logic_vector(1 downto 0);
         HiLoWE : IN  std_logic_vector(1 downto 0);
         ShiftOp : IN  std_logic_vector(1 downto 0);
         VarShift : IN  std_logic;
         ZR : OUT  std_logic;
         NG : OUT  std_logic;
         OV : OUT  std_logic;
         ALUO : OUT  std_logic_vector(31 downto 0);
         HI : OUT  std_logic_vector(31 downto 0);
         LO : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
   signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000000010";
   signal Shamt : std_logic_vector(4 downto 0) := (others => '0');
   signal ALUOp : std_logic_vector(1 downto 0) := (others => '0');
   signal AddSub : std_logic := '1';
   signal SignUnsign : std_logic := '0';
   signal LogicOp : std_logic_vector(1 downto 0) := (others => '0');
   signal HiLoWE : std_logic_vector(1 downto 0) := (others => '0');
   signal ShiftOp : std_logic_vector(1 downto 0) := (others => '0');
   signal VarShift : std_logic := '0';

 	--Outputs
   signal ZR : std_logic;
   signal NG : std_logic;
   signal OV : std_logic;
   signal ALUO : std_logic_vector(31 downto 0);
   signal HI : std_logic_vector(31 downto 0);
   signal LO : std_logic_vector(31 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Shamt => Shamt,
          ALUOp => ALUOp,
          AddSub => AddSub,
          SignUnsign => SignUnsign,
          LogicOp => LogicOp,
          HiLoWE => HiLoWE,
          ShiftOp => ShiftOp,
          VarShift => VarShift,
          ZR => ZR,
          NG => NG,
          OV => OV,
          ALUO => ALUO,
          HI => HI,
          LO => LO
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
                AddSub <= '0';
                -- -------------  Current Time:  200ns
                WAIT FOR 100 ns;
                AddSub <= '1';
                -- -------------  Current Time:  300ns
                WAIT FOR 100 ns;
                AddSub <= '0';
                A <= "00000000000000000000000000000010";
                -- -------------  Current Time:  400ns
                WAIT FOR 100 ns;
                A <= "00000000000000000000000000000001";
                -- -------------------------------------
                -- -------------  Current Time:  500ns
                WAIT FOR 100 ns;
                ALUOp <= "01";
                -- -------------  Current Time:  600ns
                WAIT FOR 100 ns;
                ALUOp <= "10";
                Shamt <= "00001";
                -- -------------  Current Time:  700ns
                WAIT FOR 100 ns;
                ALUOp <= "10";
                Shamt <= "00001";
                -- -------------  Current Time:  800ns
                WAIT FOR 100 ns;
                ALUOp <= "11";
                Shamt <= "00001";
                -- -------------  Current Time:  900ns
                WAIT FOR 100 ns;
                A <= "00000000000000000000000000000011";
                -- -------------  Current Time:  1000ns
                WAIT FOR 900 ns;
                AddSub <= '1';

      wait;
   end process;

END;
