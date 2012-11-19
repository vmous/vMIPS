--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:16:28 08/18/2009
-- Design Name:   
-- Module Name:   Z:/516-add/MIPS_R2000/tb_MUX_32_2IN1.vhd
-- Project Name:  MIPS_R2000
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MUX_32_2IN1
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
 
ENTITY tb_MUX_32_2IN1 IS
END tb_MUX_32_2IN1;
 
ARCHITECTURE behavior OF tb_MUX_32_2IN1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MUX_32_2IN1
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Sel : IN  std_logic;
         O : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := "00000000000000000000000000000111";
   signal B : std_logic_vector(31 downto 0) := "00000000000000000000000000001000";
   signal Sel : std_logic := '0';

 	--Outputs
   signal O : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MUX_32_2IN1 PORT MAP (
          A => A,
          B => B,
          Sel => Sel,
          O => O
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- insert stimulus here 

        -- Current Time:  100ns
        wait for 100 ns;
        Sel <= '1';

        -- Current Time:  200ns
        wait for 100 ns;
        Sel <= '0';

        -- Current Time:  300ns
        wait for 100 ns;
        SEL <= '1';

        -- Current Time:  400ns
        wait for 100 ns;
        A <= "00000000000000000000000000001110";
        B <= "00000000000000000000000000001111";
        wait for 600 ns;

        wait;
    end process;

END;
