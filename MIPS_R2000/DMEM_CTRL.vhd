----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    00:34:11 09/02/2009 
-- Design Name: 
-- Module Name:    DMEM_CTRL - DMEM_CTRL_STRUCT 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Control for the Data Memory
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

entity DMEM_CTRL is
    port(
        ALUO : in STD_LOGIC_VECTOR(31 downto 0);
        MDRI : in STD_LOGIC_VECTOR(31 downto 0);
        DMDI : in STD_LOGIC_VECTOR(31 downto 0);
        MemRead : in STD_LOGIC;
        MemWrite : in STD_LOGIC;
        SignZeroLoad : in STD_LOGIC;
        isWord : in STD_LOGIC;
        ByteHalf : in STD_LOGIC;        
        E : out STD_LOGIC;
        DMWE : out STD_LOGIC;
        DMA : out STD_LOGIC_VECTOR(29 downto 0);
        MDRO : out STD_LOGIC_VECTOR(31 downto 0);
        DMDO : out STD_LOGIC_VECTOR(31 downto 0)
    );
end DMEM_CTRL;

architecture DMEM_CTRL_STRUCT of DMEM_CTRL is

    -- components --
    component DMEM_ALIGNER is
        port(
            LSB : in STD_LOGIC_VECTOR(1 downto 0);
            isWord : in STD_LOGIC;
            ByteHalf : in STD_LOGIC;
            ERR : out STD_LOGIC;
            M : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component DMEM_COORD is
        port(
            MDRI : in STD_LOGIC_VECTOR(31 downto 0);
            DMDI : in STD_LOGIC_VECTOR(31 downto 0);
            MemRead : in STD_LOGIC;
            MemWrite : in STD_LOGIC;
            SignZeroLoad : in STD_LOGIC;
            ByteMask : in STD_LOGIC_VECTOR(3 downto 0);
            MDRO : out STD_LOGIC_VECTOR(31 downto 0);
            DMDO : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- signals --
    signal s_bytes : STD_LOGIC_VECTOR(3 downto 0);
    signal s_error : STD_LOGIC;

begin

AllignByteSelector: DMEM_ALIGNER
    port map(
        LSB => ALUO(1 downto 0),
        isWord => isWord,
        ByteHalf => ByteHalf,
        ERR => s_error,
        M => s_bytes
    );

    E <= s_error;
    DMWE <= MemWrite AND (NOT s_error);

DMCoordinator: DMEM_COORD
    port map(
        MDRI => MDRI,
        DMDI => DMDI,
        MemRead => MemRead,
        MemWrite => MemWrite,
        SignZeroLoad => SignZeroLoad,
        ByteMask => s_bytes,
        MDRO => MDRO,
        DMDO => DMDO
    );

    DMA <= ALUO(31 downto 2);

end DMEM_CTRL_STRUCT;

