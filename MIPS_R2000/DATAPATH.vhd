----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    17:13:48 09/20/2009 
-- Design Name: 
-- Module Name:    DATAPATH - DATAPATH_STRUCT 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    The Full Datapath of the MIPSR2000
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

entity DATAPATH is
    port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        OV : out STD_LOGIC;
        E : out STD_LOGIC
    );
end DATAPATH;

architecture DATAPATH_STRUCT of DATAPATH is

    -- components --

    -- Instruction Fetch
    component PS1_IF is
        port (
            CLK : in STD_LOGIC;
            ACLRL : in STD_LOGIC;
            -- input from previous pipeline stage
            -- input from other components/stages
            Branch : in STD_LOGIC; -- CHDU
            PCWrite : in STD_LOGIC; -- DHDU
            IFIDFlush : in STD_LOGIC; -- CU
            IFIDWrite : in STD_LOGIC; -- DHDU
            BRTRGT : in STD_LOGIC_VECTOR(31 downto 0); -- EX stage
            -- output to next pipeline stage
            IFIDout_N : out STD_LOGIC_VECTOR(31 downto 0);
            IFIDout_IR : out STD_LOGIC_VECTOR(31 downto 0)
            -- output to other components/stages
        );
    end component;

    -- Instruction Decode
    component PS2_ID is
        port (
            CLK : in STD_LOGIC;
            ACLRL : in STD_LOGIC;
            -- input from previous pipeline stage
            N : in STD_LOGIC_VECTOR(31 downto 0);
            IR : in STD_LOGIC_VECTOR(31 downto 0);
            -- input from other components/stages
            CtrlSignals : in STD_LOGIC_VECTOR(4 downto 0); -- CU
            IDEXFlush : in STD_LOGIC; -- CU
            MEMWB_RegWrite : in STD_LOGIC; -- WB stage
            WR : in STD_LOGIC_VECTOR(4 downto 0); -- WB stage
            WD : in STD_LOGIC_VECTOR(31 downto 0); -- WB stage
            -- output to next pipeline stage
            IDEXout_N : out STD_LOGIC_VECTOR(31 downto 0);
            IDEXout_D : out STD_LOGIC_VECTOR(31 downto 0);
            IDEXout_A : out STD_LOGIC_VECTOR(31 downto 0);
            IDEXout_B : out STD_LOGIC_VECTOR(31 downto 0);
            IDEXout_WR : out STD_LOGIC_VECTOR(4 downto 0);
            IDEXout_SHAMT : out STD_LOGIC_VECTOR(4 downto 0);
            IDEXout_I : out STD_LOGIC_VECTOR(31 downto 0);
            IDEXout_RS : out STD_LOGIC_VECTOR(4 downto 0);
            IDEXout_RT : out STD_LOGIC_VECTOR(4 downto 0);
            -- output to other components/stages
            RS : out STD_LOGIC_VECTOR(4 downto 0); -- DHDU
            RT : out STD_LOGIC_VECTOR(4 downto 0) -- DHDU
        );
    end component;

    component CTRL_FSM is
        port (
            CLK : in STD_LOGIC;
            Reset : in STD_LOGIC;
            -- input
            IR : in STD_LOGIC_VECTOR(31 downto 0);
            -- control signals from other units
            Branch : in STD_LOGIC;
            Stall : in STD_LOGIC;
            -- main control signals
            IDSignals : out STD_LOGIC_VECTOR(4 downto 0);
            EXSignals : out STD_LOGIC_VECTOR(16 downto 0);
            MEMSignals : out STD_LOGIC_VECTOR(4 downto 0);
            WBSignals : out STD_LOGIC_VECTOR(3 downto 0);
            IDEX_MemRead : out STD_LOGIC;
            IDEX_MemWrite : out STD_LOGIC;
            EXMEM_RegWrite : out STD_LOGIC;
            EXMEM_HiLo : out STD_LOGIC;
            EXMEM_WriteBack : out STD_LOGIC_VECTOR(1 downto 0);
            -- other pipeline stage control signals
            -- stall insertion signals
            IFIDWrite : out STD_LOGIC; -- IF stage
            PCWrite : out STD_LOGIC; -- IF stage
            -- bubble insertion signals
            IFIDFlush : out STD_LOGIC;
            IDEXFlush : out STD_LOGIC;
            EXMEMFlush : out STD_LOGIC;
            -- other controls
            ACLRL : out STD_LOGIC
        );
    end component;

    component DATA_HAZARD_CTRL is
        port (
            -- input
            IDEX_MemRead : in STD_LOGIC;
            IDEX_Rt : in STD_LOGIC_VECTOR(4 downto 0);
            ID_Rs : in STD_LOGIC_VECTOR(4 downto 0);
            ID_Rt : in STD_LOGIC_VECTOR(4 downto 0);
            -- output
            Stall : out STD_LOGIC -- CU
        );
    end component;

    -- Execute
    component PS3_EX is
        port (
            CLK : in STD_LOGIC;
            ACLRL : in STD_LOGIC;
            -- input from previous pipeline stage
            N : in STD_LOGIC_VECTOR(31 downto 0);
            D : in STD_LOGIC_VECTOR(31 downto 0);
            A : in STD_LOGIC_VECTOR(31 downto 0);
            B : in STD_LOGIC_VECTOR(31 downto 0);
            I : in STD_LOGIC_VECTOR(31 downto 0);
            SHAMT : in STD_LOGIC_VECTOR(4 downto 0);
            WR : in STD_LOGIC_VECTOR(4 downto 0);
            -- input from other components/stages
            CtrlSignals : in STD_LOGIC_VECTOR(16 downto 0); -- CU
            EXMEMFlush : in STD_LOGIC; -- CU
            ForwardA : in STD_LOGIC_VECTOR(1 downto 0); -- FWU
            ForwardB : in STD_LOGIC_VECTOR(1 downto 0); -- FWU
            ForwardMEM : in STD_LOGIC; -- FWU
            FW_WD : in STD_LOGIC_VECTOR(31 downto 0); -- WB stage
            FW_ALU : in STD_LOGIC_VECTOR(31 downto 0); -- MEM stage
            FW_MDRO : in STD_LOGIC_VECTOR(31 downto 0); -- MEM stage
            -- output to next pipeline stage
            EXMEMout_N : out STD_LOGIC_VECTOR(31 downto 0);
            EXMEMout_OV : out STD_LOGIC;
            EXMEMout_ALUO : out STD_LOGIC_VECTOR(31 downto 0);
            EXMEMout_HI : out STD_LOGIC_VECTOR(31 downto 0);
            EXMEMout_LO : out STD_LOGIC_VECTOR(31 downto 0);
            EXMEMout_MDRI : out STD_LOGIC_VECTOR(31 downto 0);
            EXMEMout_WR : out STD_LOGIC_VECTOR(4 downto 0);
            -- output to other components/stages
            BRTRGT : out STD_LOGIC_VECTOR(31 downto 0) -- IF stage and CHDU
        );
    end component;

    component FORWARD_CTRL is
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
    end component;

    -- Memory Access
    component PS4_MEM is
        port (
            CLK : in STD_LOGIC;
            ACLRL : in STD_LOGIC;
            -- input from previous pipeline stage
            --N : in STD_LOGIC_VECTOR(31 downto 0);
            ALUO : in STD_LOGIC_VECTOR(31 downto 0);
            MDRI : in STD_LOGIC_VECTOR(31 downto 0);
            HI : in STD_LOGIC_VECTOR(31 downto 0);
            LO : in STD_LOGIC_VECTOR(31 downto 0);
            DREAD : inout STD_LOGIC_VECTOR(31 downto 0); 
            DWRITE : inout STD_LOGIC_VECTOR(31 downto 0);
            -- input from other components/stages
            CtrlSignals : in STD_LOGIC_VECTOR(4 downto 0); -- CU
            EXMEM_HiLo : in STD_LOGIC; -- CU
            EXMEM_WriteBack : in STD_LOGIC_VECTOR(1 downto 0); -- CU
            -- output to next pipeline stage
            -- output to other components/stages
            FW_ALU : out STD_LOGIC_VECTOR(31 downto 0); -- EX
            MDRO : out STD_LOGIC_VECTOR(31 downto 0); -- EX
            ERR : out STD_LOGIC
        );
    end component;

    component CONTROL_HAZARD_CTRL is
        port (
            -- input
            Target : in STD_LOGIC_VECTOR(31 downto 0);
            -- output
            Branch : out STD_LOGIC -- CU
        );
    end component;

    -- Write Back
    component PS5_WB is
        port (
            CLK : in STD_LOGIC;
            ACLRL : in STD_LOGIC;
            -- input from previous pipeline stage
            N : in STD_LOGIC_VECTOR(31 downto 0);
            HI : in STD_LOGIC_VECTOR(31 downto 0);
            LO : in STD_LOGIC_VECTOR(31 downto 0);
            ALUO : in STD_LOGIC_VECTOR(31 downto 0);
            MDRO : in STD_LOGIC_VECTOR(31 downto 0);
            WR : in STD_LOGIC_VECTOR(4 downto 0);
            -- input from other components/stages
            CtrlSignals : in STD_LOGIC_VECTOR(3 downto 0); -- CU
            -- output to next pipeline stage
            MEMWBout_WD : out STD_LOGIC_VECTOR(31 downto 0);
            MEMWBout_WR : out STD_LOGIC_VECTOR(4 downto 0);
            -- output to other componets/stages
            WD : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- signals --
    signal s_Reset : STD_LOGIC;
    -- IF
    -- IF/ID
    signal s_IFID_N : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IFID_IR : STD_LOGIC_VECTOR(31 downto 0);
    -- ID
    signal s_ID_RS : STD_LOGIC_VECTOR(4 downto 0);
    signal s_ID_RT : STD_LOGIC_VECTOR(4 downto 0);
    -- ID/EX
    signal s_IDEX_N : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IDEX_D : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IDEX_A : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IDEX_B : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IDEX_WR : STD_LOGIC_VECTOR(4 downto 0);
    signal s_IDEX_SHAMT : STD_LOGIC_VECTOR(4 downto 0);
    signal s_IDEX_I : STD_LOGIC_VECTOR(31 downto 0);
    signal s_IDEX_RS : STD_LOGIC_VECTOR(4 downto 0);
    signal s_IDEX_RT : STD_LOGIC_VECTOR(4 downto 0);
    -- EX
    signal s_EX_BRTRGT : STD_LOGIC_VECTOR(31 downto 0);
    -- EX/MEM
    signal s_EXMEM_N : STD_LOGIC_VECTOR(31 downto 0);
    signal s_EXMEM_OV : STD_LOGIC;
    signal s_EXMEM_ALUO : STD_LOGIC_VECTOR(31 downto 0);
    signal s_EXMEM_HI : STD_LOGIC_VECTOR(31 downto 0);
    signal s_EXMEM_LO : STD_LOGIC_VECTOR(31 downto 0);
    signal s_EXMEM_MDRI : STD_LOGIC_VECTOR(31 downto 0);
    signal s_EXMEM_WR : STD_LOGIC_VECTOR(4 downto 0);
    -- MEM
    signal s_MEM_DREAD : STD_LOGIC_VECTOR(31 downto 0);
    signal s_MEM_DWRITE : STD_LOGIC_VECTOR(31 downto 0);
    signal s_MEM_FW_ALU : STD_LOGIC_VECTOR(31 downto 0);
    signal s_MEM_MDRO : STD_LOGIC_VECTOR(31 downto 0);
    signal s_MEM_ERR : STD_LOGIC;
    signal s_MEM_WD : STD_LOGIC_VECTOR(31 downto 0);
    -- MEM/WB
    signal s_MEMWB_WD : STD_LOGIC_VECTOR(31 downto 0);
    signal s_MEMWB_WR : STD_LOGIC_VECTOR(4 downto 0);
    -- WB

    -- CU
    signal s_CU_IDSignals : STD_LOGIC_VECTOR(4 downto 0);
    signal s_CU_EXSignals : STD_LOGIC_VECTOR(16 downto 0);
    signal s_CU_MEMSignals : STD_LOGIC_VECTOR(4 downto 0);
    signal s_CU_WBSignals : STD_LOGIC_VECTOR(3 downto 0);
    signal s_CU_IDEX_MemRead : STD_LOGIC;
    signal s_CU_IDEX_MemWrite : STD_LOGIC;
    signal s_CU_EXMEM_RegWrite : STD_LOGIC;
    signal s_CU_EXMEM_HiLo : STD_LOGIC;
    signal s_CU_EXMEM_WriteBack : STD_LOGIC_VECTOR(1 downto 0);
    signal s_CU_IFIDFlush : STD_LOGIC;
    signal s_CU_IDEXFlush : STD_LOGIC;
    signal s_CU_EXMEMFlush : STD_LOGIC;
    signal s_CU_ACLRL : STD_LOGIC;

    signal s_CU_EXMEM_WBSignals : STD_LOGIC_VECTOR(3 downto 0);
    -- DHDU
    signal s_DHDU_IFIDWrite : STD_LOGIC;
    signal s_DHDU_PCWrite : STD_LOGIC;
    signal s_DHDU_Stall : STD_LOGIC;
    -- FWU
    signal s_FWU_ForwardA : STD_LOGIC_VECTOR(1 downto 0);
    signal s_FWU_ForwardB : STD_LOGIC_VECTOR(1 downto 0);
    signal s_FWU_ForwardMEM : STD_LOGIC;
    -- CHDU
    signal s_CHDU_Branch : STD_LOGIC;

    attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of InstructionFetch: label is "true";
    attribute KEEP_HIERARCHY of InstructionDecode: label is "true";
    attribute KEEP_HIERARCHY of ControlUnit: label is "true";
    attribute KEEP_HIERARCHY of DataHazardDetector: label is "true";
    attribute KEEP_HIERARCHY of Execute: label is "true";
    attribute KEEP_HIERARCHY of Forwarder: label is "true";
    attribute KEEP_HIERARCHY of MemoryAccess: label is "true";
    attribute KEEP_HIERARCHY of ControlHazardDetector: label is "true";
    attribute KEEP_HIERARCHY of WriteBack: label is "true";

begin

    s_Reset <= RESET;

InstructionFetch: PS1_IF
    port map (
        CLK => CLK,
        ACLRL => s_CU_ACLRL,
        -- input from previous pipeline stage
        -- input from other components/stages
        Branch => s_CHDU_Branch, -- CHDU
        PCWrite => s_DHDU_PCWrite, -- DHDU
        IFIDFlush => s_CU_IFIDFlush, -- CU
        IFIDWrite => s_DHDU_IFIDWrite, -- DHDU
        BRTRGT => s_EX_BRTRGT, -- EX stage
        -- output to next pipeline stage
        IFIDout_N => s_IFID_N,
        IFIDout_IR => s_IFID_IR
        -- output to other components/stages
    );

InstructionDecode: PS2_ID
    port map (
        CLK => CLK,
        ACLRL => s_CU_ACLRL,
        -- input from previous pipeline stage
        N => s_IFID_N,
        IR => s_IFID_IR,
        -- input from other components/stages
        CtrlSignals => s_CU_IDSignals, -- CU
        IDEXFlush => s_CU_IDEXFlush, -- CU
        MEMWB_RegWrite => s_CU_EXMEM_RegWrite, -- WB stage
        WR => s_EXMEM_WR, -- MEM (WB) stage
        WD => s_MEM_WD, -- MEM (WB) stage
        -- output to next pipeline stage
        IDEXout_N => s_IDEX_N,
        IDEXout_D => s_IDEX_D,
        IDEXout_A => s_IDEX_A,
        IDEXout_B => s_IDEX_B,
        IDEXout_WR => s_IDEX_WR,
        IDEXout_SHAMT => s_IDEX_SHAMT,
        IDEXout_I => s_IDEX_I,
        IDEXout_RS => s_IDEX_RS,
        IDEXout_RT => s_IDEX_RT,
        -- output to other components/stages
        RS => s_ID_RS, -- DHDU
        RT => s_ID_RT -- DHDU
    );

ControlUnit: CTRL_FSM
    port map (
        CLK => CLK,
        Reset => s_Reset,
        -- input
        IR => s_IFID_IR,
        -- control signals from other units
        Branch => s_CHDU_Branch,
        Stall => s_DHDU_Stall,
        -- main control signals
        IDSignals => s_CU_IDSignals,
        EXSignals => s_CU_EXSignals,
        MEMSignals => s_CU_MEMSignals,
        WBSignals => s_CU_WBSignals,
        IDEX_MemRead => s_CU_IDEX_MemRead,
        IDEX_MemWrite => s_CU_IDEX_MemWrite,
        EXMEM_RegWrite => s_CU_EXMEM_RegWrite,
        EXMEM_HiLo => s_CU_EXMEM_HiLo,
        EXMEM_WriteBack => s_CU_EXMEM_WriteBack,
        -- other pipeline stage control signals
        -- stall insertion signals
        IFIDWrite => s_DHDU_IFIDWrite, -- IF stage
        PCWrite => s_DHDU_PCWrite, -- IF stage
        -- bubble insertion signals
        IFIDFlush => s_CU_IFIDFlush,
        IDEXFlush => s_CU_IDEXFlush,
        EXMEMFlush => s_CU_EXMEMFlush,
        -- other controls
        ACLRL => s_CU_ACLRL
    );

DataHazardDetector: DATA_HAZARD_CTRL
    port map (
        -- input
        IDEX_MemRead => s_CU_IDEX_MemRead,
        IDEX_Rt => s_IDEX_RT,
        ID_Rs => s_ID_RS,
        ID_Rt => s_ID_RT,
        -- output
        Stall => s_DHDU_Stall -- CU
    );

Execute: PS3_EX
    port map (
        CLK => CLK,
        ACLRL => s_CU_ACLRL,
        -- input from previous pipeline stage
        N => s_IDEX_N,
        D => s_IDEX_D,
        A => s_IDEX_A,
        B => s_IDEX_B,
        I => s_IDEX_I,
        SHAMT => s_IDEX_SHAMT,
        WR => s_IDEX_WR,
        -- input from other components/stages
        CtrlSignals => s_CU_EXSignals, -- CU
        EXMEMFlush => s_CU_EXMEMFlush, -- CU
        ForwardA => s_FWU_ForwardA, -- FWU
        ForwardB => s_FWU_ForwardB, -- FWU
        ForwardMEM => s_FWU_ForwardMEM, -- FWU
        FW_WD => s_MEMWB_WD, -- WB stage
        FW_ALU => s_MEM_FW_ALU, -- MEM stage
        FW_MDRO => s_MEM_MDRO, -- MEM stage
        -- output to next pipeline stage
        EXMEMout_N => s_EXMEM_N,
        EXMEMout_OV => s_EXMEM_OV,
        EXMEMout_ALUO => s_EXMEM_ALUO,
        EXMEMout_HI => s_EXMEM_HI,
        EXMEMout_LO => s_EXMEM_LO,
        EXMEMout_MDRI => s_EXMEM_MDRI,
        EXMEMout_WR => s_EXMEM_WR,
        -- output to other components/stages
        BRTRGT => s_EX_BRTRGT -- IF stage and CHDU
    );

    OV <= s_EXMEM_OV;

Forwarder: FORWARD_CTRL
    port map (
        -- input
        IDEX_Rs => s_IDEX_RS,
        IDEX_Rt => s_IDEX_RT,
        EXMEM_RegWrite => s_CU_EXMEM_RegWrite,
        EXMEM_Rd => s_EXMEM_WR,
        MEMWB_RegWrite => s_CU_WBSignals(0),
        MEMWB_Rd => s_MEMWB_WR,
        IDEX_MemWrite => s_CU_IDEX_MemWrite,
        EXMEM_MemRead => s_CU_MEMSignals(0),
        -- output
        ForwardA => s_FWU_ForwardA, -- EX
        ForwardB => s_FWU_ForwardB, -- EX
        ForwardMEM => s_FWU_ForwardMEM -- EX        
    );

MemoryAccess: PS4_MEM
    port map (
        CLK => CLK,
        ACLRL => s_CU_ACLRL,
        -- input from previous pipeline stage
        --N => s_EXMEM_N,
        ALUO => s_EXMEM_ALUO,
        MDRI => s_EXMEM_MDRI,
        HI => s_EXMEM_HI,
        LO => s_EXMEM_LO,
        DREAD => s_MEM_DREAD, 
        DWRITE => s_MEM_DWRITE,
        -- input from other components/stages
        CtrlSignals => s_CU_MEMSignals, -- CU
        EXMEM_HiLo => s_CU_EXMEM_HiLo, -- CU
        EXMEM_WriteBack => s_CU_EXMEM_WriteBack, -- CU
        -- output to next pipeline stage
        -- output to other components/stages
        FW_ALU => s_MEM_FW_ALU, -- EX
        MDRO => s_MEM_MDRO, -- EX
        ERR => s_MEM_ERR
    );

    E <= s_MEM_ERR;

ControlHazardDetector: CONTROL_HAZARD_CTRL
    port map (
        -- input
        Target => s_EX_BRTRGT,
        -- output
        Branch => s_CHDU_Branch -- IF stage and CU
    );
    
   s_CU_EXMEM_WBSignals(3 downto 2) <= s_CU_EXMEM_WriteBack;
   s_CU_EXMEM_WBSignals(1) <= s_CU_EXMEM_HiLo;
   s_CU_EXMEM_WBSignals(0) <= s_CU_EXMEM_RegWrite;

WriteBack: PS5_WB
    port map (
        CLK => CLK,
        ACLRL => s_CU_ACLRL,
        -- input from previous pipeline stage
        N => s_EXMEM_N,
        HI => s_EXMEM_HI,
        LO => s_EXMEM_LO,
        ALUO => s_EXMEM_ALUO,
        MDRO => s_MEM_MDRO,
        WR => s_EXMEM_WR,
        -- input from other components/stages
        CtrlSignals => s_CU_EXMEM_WBSignals, -- CU
        -- output to next pipeline stage
        MEMWBout_WD => s_MEMWB_WD,
        MEMWBout_WR => s_MEMWB_WR,
        -- output to other componets/stages
        WD => s_MEM_WD -- before register
    );

end DATAPATH_STRUCT;

