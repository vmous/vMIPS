--------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
--
-- Create Date:   02:54:39 08/11/2009
-- Design Name:   
-- Module Name:   Z:/516-add/MIPS_R2000/tb_MUX_4IN1.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_4IN1
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
 
ENTITY tb_MUX_4IN1 IS
END tb_MUX_4IN1;
 
ARCHITECTURE behavior OF tb_MUX_4IN1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX_4IN1
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         C : IN  std_logic_vector(31 downto 0);
         D : IN  std_logic_vector(31 downto 0);
         SEL : IN  std_logic_vector(1 downto 0);
         O : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000101";
   signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000001001";
   signal C : std_logic_vector(31 downto 0) := "00000000000000000000000000001100";
   signal D : std_logic_vector(31 downto 0) := "00000000000000000000000000001111";
   signal SEL : std_logic_vector(1 downto 0) := "00";

 	--Outputs
   signal O : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX_4IN1 PORT MAP (
          A => A,
          B => B,
          C => C,
          D => D,
          SEL => SEL,
          O => O
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- insert stimulus here

        -- Current Time:  100ns
        wait for 100 ns;
        SEL <= "01";

        -- Current Time:  200ns
        wait for 100 ns;
        SEL <= "10";

        -- Current Time:  300ns
        wait for 100 ns;
        SEL <= "11";

        -- Current Time:  400ns
        wait for 100 ns;
        D <= "00000000000000000000000000010000";
        wait for 600 ns; 

      wait;
   end process;

END;
