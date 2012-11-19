----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    01:43:10 10/04/2009 
-- Design Name: 
-- Module Name:    FORWARD_CTRL - FORWARD_CTRL_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Forwarding Unit
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FORWARD_CTRL is
    port (
        -- input
        IDEX_Rs : in STD_LOGIC_VECTOR(4 downto 0);
        IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
        EXMEM_RegWrite : in STD_LOGIC;
        EXMEM_Rd : in STD_LOGIC_VECTOR(4 downto 0);
        MEMWB_RegWrite : in STD_LOGIC;
        MEMWB_Rd : in STD_LOGIC_VECTOR(4 downto 0);
        IDEX_MemWrite : in STD_LOGIC;
        EXMEM_MemRead : in STD_LOGIC;
        -- output
        ForwardA : out STD_LOGIC_VECTOR(1 downto 0); -- EX
        ForwardB : out STD_LOGIC_VECTOR(1 downto 0); -- EX
        ForwardMEM : out STD_LOGIC -- EX
        
    );
end FORWARD_CTRL;

architecture FORWARD_CTRL_STRUCT of FORWARD_CTRL is

    -- components --
    component EX_HAZARD_FW is
        port (
            IDEX_Rs : in STD_LOGIC_VECTOR(4 downto 0);
            IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
            EXMEM_RegWrite : in STD_LOGIC;
            EXMEM_Rd : in STD_LOGIC_VECTOR(4 downto 0);
            MEMWB_RegWrite : in STD_LOGIC;
            MEMWB_Rd : in STD_LOGIC_VECTOR(4 downto 0);

            ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
            ForwardB : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    component MEM_HAZARD_FW is
        port (
            IDEX_MemWrite : in STD_LOGIC;
            IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
            EXMEM_MemRead : in STD_LOGIC;
            EXMEM_Rd : in STD_LOGIC_VECTOR(4 downto 0);

            ForwardMEM : out STD_LOGIC
        );
    end component;

begin

EXForwardDetector: EX_HAZARD_FW
    port map (
        IDEX_Rs => IDEX_Rs,
        IDEX_Rt => IDEX_Rt,
        EXMEM_RegWrite => EXMEM_RegWrite,
        EXMEM_Rd => EXMEM_Rd,
        MEMWB_RegWrite => MEMWB_RegWrite,
        MEMWB_Rd => MEMWB_Rd,

        ForwardA => ForwardA,
        ForwardB => ForwardB
    );

MEMForwardDetector: MEM_HAZARD_FW
    port map (
        IDEX_MemWrite => IDEX_MemWrite,
        IDEX_Rt => IDEX_Rt,
        EXMEM_MemRead => EXMEM_MemRead,
        EXMEM_Rd => EXMEM_Rd,

        ForwardMEM => ForwardMEM
    );

end FORWARD_CTRL_STRUCT;

