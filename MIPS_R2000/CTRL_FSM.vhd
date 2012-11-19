----------------------------------------------------------------------------------
-- Company:        National and Kapodistrian University of Athens
-- Engineer:       Vassilis S. Moustakas
-- 
-- Create Date:    15:46:44 09/16/2009 
-- Design Name: 
-- Module Name:    CTRL_FSM - CTRL_FSM_BEH 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    Main Control - Finish State Machine
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

entity CTRL_FSM is
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
end CTRL_FSM;

architecture CTRL_FSM_HYBRID of CTRL_FSM is

    constant i_add   : STD_LOGIC_VECTOR(5 downto 0) := "100000"; -- R	R[rd] = R[rs] + R[rt]	000000b (0hex) / 100000b (20hex)
    constant i_addi  : STD_LOGIC_VECTOR(5 downto 0) := "001000"; -- I	R[rt] = R[rs] + SignExtImm	001000b (8hex)
    constant i_addiu : STD_LOGIC_VECTOR(5 downto 0) := "001001"; -- I	R[rt] = R[rs] + SignExtImm	001001b (9hex)
    constant i_addu  : STD_LOGIC_VECTOR(5 downto 0) := "100001"; -- R	R[rd] = R[rs] + R[rt]	000000b (0hex) / 100001b (21hex)
    constant i_and   : STD_LOGIC_VECTOR(5 downto 0) := "100100"; -- R	R[rd] = R[rs] & R[rt]	000000b (0hex) / 100100b (24hex)
    constant i_andi  : STD_LOGIC_VECTOR(5 downto 0) := "001100"; -- I	R[rt] = R[rs] + ZeroExtImm	001100b (Chex)
    constant i_beq   : STD_LOGIC_VECTOR(5 downto 0) := "000100"; -- I	if(R[rs]==R[rt]) PC=PC+4+BranchAddr	000100b (4hex)
    constant i_bgez  : STD_LOGIC_VECTOR(5 downto 0) := "000001"; -- I		000001b (1hex), rt = 00001
    constant i_bgezal: STD_LOGIC_VECTOR(5 downto 0) := "000001"; -- I		000001b (1hex), rt = 10001
    constant i_bgtz  : STD_LOGIC_VECTOR(5 downto 0) := "000111"; -- I		000111b (7hex), rt = 00000
    constant i_blez  : STD_LOGIC_VECTOR(5 downto 0) := "000110"; -- I		000110b (6hex), rt = 00000
    constant i_bltz  : STD_LOGIC_VECTOR(5 downto 0) := "000001"; -- I		000001b (1hex), rt = 00000
    constant i_bltzal: STD_LOGIC_VECTOR(5 downto 0) := "000001"; -- I		000001b (1hex), rt = 10000
    constant i_bne   : STD_LOGIC_VECTOR(5 downto 0) := "000101"; -- I	if(R[rs]!=R[rt]) PC=PC+4+BranchAddr	000101b (5hex)
    constant i_j     : STD_LOGIC_VECTOR(5 downto 0) := "000010"; -- J	PC=JumpAddr	000010b (2hex)
    constant i_jal   : STD_LOGIC_VECTOR(5 downto 0) := "000011"; -- J	R[31]=PC+8;PC=JumpAddr	000011b (3hex)
    constant i_jalr  : STD_LOGIC_VECTOR(5 downto 0) := "001001"; -- R		000000b (0hex) / 001001b (9hex)
    constant i_jr    : STD_LOGIC_VECTOR(5 downto 0) := "001000"; -- R	PC=R[rs]	000000b (0hex) / 001000b (8hex)
    constant i_lb    : STD_LOGIC_VECTOR(5 downto 0) := "100000"; -- I		100000b (20hex)
    constant i_lbu   : STD_LOGIC_VECTOR(5 downto 0) := "100100"; -- I	R[rt]={24'b0,M[R[rs]+SignExtImm](7:0)}	100100b (24hex)
    constant i_lh    : STD_LOGIC_VECTOR(5 downto 0) := "100001"; -- I		100001b (21hex)
    constant i_lhu   : STD_LOGIC_VECTOR(5 downto 0) := "100101"; -- I	R[rt]={16'b0,M[R[rs]+SignExtImm](15:0)}	100101b (25hex)
    constant i_lui   : STD_LOGIC_VECTOR(5 downto 0) := "001111"; -- I	R[rt]={imm, 16'b0}	000000b (0hex) / 001111b (Fhex)
    constant i_lw    : STD_LOGIC_VECTOR(5 downto 0) := "100011"; -- I	R[rt]=M[R[rs]+SignExtImm]	100011b (23hex)
    constant i_mfhi  : STD_LOGIC_VECTOR(5 downto 0) := "010000"; -- R		000000b (0hex) / 010000b (10hex)
    constant i_mflo  : STD_LOGIC_VECTOR(5 downto 0) := "010010"; -- R		000000b (0hex) / 010010b (12hex)
    constant i_mthi  : STD_LOGIC_VECTOR(5 downto 0) := "010001"; -- R		000000b (0hex) / 010001b (11hex)
    constant i_mtlo  : STD_LOGIC_VECTOR(5 downto 0) := "010011"; -- R		000000b (0hex) / 010011b (13hex)
    constant i_mult  : STD_LOGIC_VECTOR(5 downto 0) := "011000"; -- R	{Hi,Lo}=R[rs]*R[rt]	000000b (0hex) / 011000b (18hex)
    constant i_multu : STD_LOGIC_VECTOR(5 downto 0) := "011001"; -- R	{Hi,Lo}=R[rs]*R[rt]	000000b (0hex) / 011001b (19hex)
    constant i_nor   : STD_LOGIC_VECTOR(5 downto 0) := "100111"; -- R   R[rd]=R[rs]norR[rt] 000000b (0hex) / 100111b (27hex)
    constant i_or    : STD_LOGIC_VECTOR(5 downto 0) := "100101"; -- R	R[rd]=R[rs]|R[rt]	000000b (0hex) / 100101b (25hex)
    constant i_ori   : STD_LOGIC_VECTOR(5 downto 0) := "001101"; -- I	R[rt]=R[rs]|ZeroExtImm	001101b (Dhex)
    constant i_sb    : STD_LOGIC_VECTOR(5 downto 0) := "101000"; -- I	M[R[rs]+SignExtImm](7:0)=R[rt](7:0)	101000b (28hex)
    constant i_sh    : STD_LOGIC_VECTOR(5 downto 0) := "101001"; -- I	M[R[rs]+SignExtImm](15:0)=R[rt](15:0)	101001b (29hex)
    constant i_sll   : STD_LOGIC_VECTOR(5 downto 0) := "000000"; -- R	R[rd]=R[rt]<<shamt	000000b (0hex) / 000000b (0hex)
    constant i_sllv  : STD_LOGIC_VECTOR(5 downto 0) := "000100"; -- R		000000b (0hex) / 000100b (4hex)
    constant i_slt   : STD_LOGIC_VECTOR(5 downto 0) := "101010"; -- R	R[rd]=(R[rs]<R[rt])?1:0	000000b (0hex) / 101010b (2Ahex)
    constant i_slti  : STD_LOGIC_VECTOR(5 downto 0) := "001010"; -- I	R[rt]=(R[rs]<SignExtImm)?1:0	001010b (Ahex)
    constant i_sltiu : STD_LOGIC_VECTOR(5 downto 0) := "001011"; -- I	R[rt]=(R[rs]<SignExtImm)?1:0	001011b (Bhex)
    constant i_sltu  : STD_LOGIC_VECTOR(5 downto 0) := "101011"; -- R	R[rd]=(R[rs]<R[rt])?1:0	000000b (0hex) / 101011b (2Bhex)
    constant i_sra   : STD_LOGIC_VECTOR(5 downto 0) := "000011"; -- R		000000b (0hex) / 000011b (3hex)
    constant i_srav  : STD_LOGIC_VECTOR(5 downto 0) := "000111"; -- R		000000b (0hex) / 000111b (7hex)
    constant i_srl   : STD_LOGIC_VECTOR(5 downto 0) := "000010"; -- R	R[rd]=R[rt]>>shamt	000000b (0hex) / 000010b (2hex)
    constant i_srlv  : STD_LOGIC_VECTOR(5 downto 0) := "000110"; -- R		000000b (0hex) / 000110b (6hex)
    constant i_sub   : STD_LOGIC_VECTOR(5 downto 0) := "100010"; -- R	R[rd]=R[rs]-R[rt]	000000b (0hex) / 100010b (22hex)
    constant i_subu  : STD_LOGIC_VECTOR(5 downto 0) := "100011"; -- R	R[rd]=R[rs]-R[rt]	000000b (0hex) / 100011b (23hex)
    constant i_sw    : STD_LOGIC_VECTOR(5 downto 0) := "101011"; -- I	M[R[rs]+SignExtImm]=R[rt]	101011b (2Bhex)
    constant i_xor   : STD_LOGIC_VECTOR(5 downto 0) := "100110"; -- R	R[rd]=R[rs]xorR[rt] 000000b (0hex) / 100110b (26hex)
    constant i_xori  : STD_LOGIC_VECTOR(5 downto 0) := "001110"; -- I	R[rd]=R[rs]xorZeroExtImm	001110b (Ehex)

    -- components --
    component REG_N_wSACLRL is
        generic (N : positive);
        port (
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
            SCLRL : in STD_LOGIC;
            ACLRL : in  STD_LOGIC;
            Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    component REG_N_wACLRL is
        generic (N : positive);
        port(
            CLK : in  STD_LOGIC;
            D : in  STD_LOGIC_VECTOR(N - 1 downto 0);
            ACLRL : in  STD_LOGIC;
            Q : out  STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    -- signals --
    signal s_ACLRL : STD_LOGIC;
    signal s_IFIDWrite : STD_LOGIC;
    signal s_PCWrite : STD_LOGIC;
    signal s_IFIDFlush : STD_LOGIC;
    signal s_IDEXFlush : STD_LOGIC;
    signal s_EXMEMFlush : STD_LOGIC;
    signal s_IDEXFlushCtrl : STD_LOGIC;
    signal s_EXMEMFlushCtrl : STD_LOGIC;
    -- ID signals
    signal s_IDSignals : STD_LOGIC_VECTOR(4 downto 0);
    -- CU to ID/EX control pipeline register signals
    signal s_IDEX_WBSignals : STD_LOGIC_VECTOR(3 downto 0);
    signal s_IDEX_MEMSignals : STD_LOGIC_VECTOR(4 downto 0);
    signal s_IDEX_EXSignals : STD_LOGIC_VECTOR(16 downto 0);
    -- ID/EX to EX/MEM control pipeline register signals
    signal s_EXMEM_WBSignals : STD_LOGIC_VECTOR(3 downto 0);
    signal s_EXMEM_MEMSignals : STD_LOGIC_VECTOR(4 downto 0);
    -- EX/MEM to MEM/WB control pipeline register signals
    signal s_MEMWB_WBSignals : STD_LOGIC_VECTOR(3 downto 0);

begin

Resetter: process (CLK, Reset)
    begin
        if (RISING_EDGE(CLK)) then
            if(Reset = '1') then
                s_ACLRL <= '0';
            else
                s_ACLRL <= '1';
            end if;
        end if;
    end process;

Controller: process (CLK, IR, Branch, Stall)

        -- IF signals

        -- ID signals
        variable RtZero : STD_LOGIC;
        variable RegDst : STD_LOGIC_VECTOR(1 downto 0);
        variable isLUI : STD_LOGIC;
        variable SignZero : STD_LOGIC;

        -- EX signals
        variable ALUSrc : STD_LOGIC;
        variable ALUOp : STD_LOGIC_VECTOR(1 downto 0);
        variable AddSub : STD_LOGIC;
        variable SignUnsign : STD_LOGIC;
        variable LogicOp : STD_LOGIC_VECTOR(1 downto 0);
        variable HiLoWE : STD_LOGIC_VECTOR(1 downto 0);
        variable ShiftOp : STD_LOGIC_VECTOR(1 downto 0);
        variable VarShift : STD_LOGIC;
        variable BranchType : STD_LOGIC_VECTOR(1 downto 0);
        variable ZRNGMask : STD_LOGIC_VECTOR(1 downto 0);
        variable OneZero : STD_LOGIC;

        -- MEM Signals
        variable MemRead : STD_LOGIC;
        variable MemWrite : STD_LOGIC;
        variable SignZeroLoad : STD_LOGIC;
        variable isWord : STD_LOGIC;
        variable ByteHalf : STD_LOGIC;

        -- WB Signals
        variable HiLo : STD_LOGIC;
        variable WriteBack : STD_LOGIC_VECTOR(1 downto 0);
        variable RegWrite : STD_LOGIC;

        variable opcode : STD_LOGIC_VECTOR(5 downto 0);
        variable funct  : STD_LOGIC_VECTOR(5 downto 0);
        variable rt : STD_LOGIC_VECTOR(4 downto 0);
    begin

        -- initialization --
        -- IF signals

        -- ID signals
        RtZero := '0';
        RegDst := "00";
        isLUI := '0';
        SignZero := '0';

        -- EX signals
        ALUSrc := '0';
        ALUOp := "00";
        AddSub := '0';
        SignUnsign := '0';
        LogicOp := "00";
        HiLoWE := "00";
        ShiftOp := "00";
        VarShift := '0';
        BranchType := "00";
        ZRNGMask := "00";
        OneZero := '0';

        -- MEM Signals
        MemRead := '0';
        MemWrite := '0';        
        SignZeroLoad := '0';
        isWord := '0';
        ByteHalf := '0';

        -- WB Signals
        HiLo := '0';
        WriteBack := "00";
        RegWrite := '0';

        opcode := IR(31 downto 26);
        funct := IR(5 downto 0);
        rt := IR(20 downto 16);

        if (opcode = "000000") then
            -- R-type instructions
            case funct is
                when i_mfhi =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    HiLo := '0';
                    WriteBack := "01";
                    RegWrite := '1';
                when i_mflo =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    HiLo := '1';
                    WriteBack := "01";
                    RegWrite := '1';
                when i_mthi => -- TODO: double check it!
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    HiLoWE := "10";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_mtlo => -- TODO: double check it!
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    HiLoWE := "01";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_add =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_addu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sub =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_subu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_mult =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    HiLoWE := "11";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_multu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    SignUnsign := '0';
                    --LogicOp := "00";
                    HiLoWE := "11";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_and =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_or =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "01";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_xor =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "11";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_nor =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "10";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sll =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "00";
                    VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_srl =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "01";
                    VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sra =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "10";
                    VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sllv =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "00";
                    VarShift := '1';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_srlv =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "01";
                    VarShift := '1';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_srav =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    ShiftOp := "10";
                    VarShift := '1';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_slt =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "11";
                    AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sltu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "11";
                    AddSub := '0';
                    SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_jr =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '1';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "10";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_jalr =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "01";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '1';
                    --SignUnsign := '0';
                    --LogicOp := "10";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "10";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "00";
                    RegWrite := '1';
                when others => null;
            end case;
        else
            -- I- or J-type instructions
            case opcode is
                when i_lb =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '1';
                    MemWrite := '0';
                    SignZeroLoad := '1';
                    isWord := '0';
                    ByteHalf := '1';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "11";
                    RegWrite := '1';
                when i_lbu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '1';
                    MemWrite := '0';        
                    SignZeroLoad := '0';
                    isWord := '0';
                    ByteHalf := '1';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "11";
                    RegWrite := '1';
                when i_lh =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '1';
                    MemWrite := '0';        
                    SignZeroLoad := '1';
                    isWord := '0';
                    ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "11";
                    RegWrite := '1';
                when i_lhu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '1';
                    MemWrite := '0';        
                    SignZeroLoad := '0';
                    isWord := '0';
                    ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "11";
                    RegWrite := '1';
                when i_lw =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '1';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    isWord := '1';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "11";
                    RegWrite := '1';
                when i_sb =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '1';        
                    --SignZeroLoad := '0';
                    isWord := '0';
                    ByteHalf := '1';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_sh =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '1';        
                    --SignZeroLoad := '0';
                    isWord := '0';
                    ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_sw =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '1';        
                    --SignZeroLoad := '0';
                    isWord := '1';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_addi =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_addiu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "00";
                    AddSub := '1';
                    SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_andi =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '0';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_ori =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '0';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "01";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_xori =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '0';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "01";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    LogicOp := "11";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_lui =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    isLUI := '1';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "10";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_slti =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "11";
                    AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_sltiu =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "00";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '1';
                    ALUOp := "11";
                    AddSub := '0';
                    SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "00";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "10";
                    RegWrite := '1';
                when i_beq =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "11";
                    ZRNGMask := "10";
                    OneZero := '1';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_bne =>
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "11";
                    ZRNGMask := "10";
                    OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_blez => -- TODO: Double check it! (RtZero = '0'??)
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "11";
                    ZRNGMask := "11";
                    OneZero := '1';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_bgtz => -- TODO: Double check it! (RtZero = '0'??)
                    -- ID signals
                    RtZero := '1';
                    RegDst := "11";
                    --isLUI := '0';
                    SignZero := '1';
                    -- EX signals
                    ALUSrc := '0';
                    ALUOp := "00";
                    AddSub := '0';
                    SignUnsign := '1';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "11";
                    ZRNGMask := "11";
                    OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when "000001" =>
                    case rt is
                        when "00000" =>
                            -- BLTZ --
                            -- ID signals
                            RtZero := '0';
                            RegDst := "11";
                            --isLUI := '0';
                            SignZero := '1';
                            -- EX signals
                            ALUSrc := '0';
                            ALUOp := "00";
                            AddSub := '0';
                            SignUnsign := '1';
                            --LogicOp := "00";
                            --HiLoWE := "00";
                            --ShiftOp := "00";
                            --VarShift := '0';
                            BranchType := "11";
                            ZRNGMask := "01";
                            OneZero := '1';
                            -- MEM Signals
                            MemRead := '0';
                            MemWrite := '0';        
                            --SignZeroLoad := '0';
                            --isWord := '0';
                            --ByteHalf := '0';
                            -- WB Signals
                            --HiLo := '0';
                            --WriteBack := "00";
                            RegWrite := '0';
                        when "00001" =>
                            -- BGEZ --
                            -- ID signals
                            RtZero := '0';
                            RegDst := "11";
                            --isLUI := '0';
                            SignZero := '1';
                            -- EX signals
                            ALUSrc := '0';
                            ALUOp := "00";
                            AddSub := '0';
                            SignUnsign := '1';
                            --LogicOp := "00";
                            --HiLoWE := "00";
                            --ShiftOp := "00";
                            --VarShift := '0';
                            BranchType := "11";
                            ZRNGMask := "01";
                            OneZero := '0';
                            -- MEM Signals
                            MemRead := '0';
                            MemWrite := '0';        
                            --SignZeroLoad := '0';
                            --isWord := '0';
                            --ByteHalf := '0';
                            -- WB Signals
                            --HiLo := '0';
                            --WriteBack := "00";
                            RegWrite := '0';
                        when "10000" =>
                            -- BLTZAL --
                            -- ID signals
                            RtZero := '0';
                            RegDst := "10";
                            --isLUI := '0';
                            SignZero := '1';
                            -- EX signals
                            ALUSrc := '0';
                            ALUOp := "00";
                            AddSub := '0';
                            SignUnsign := '1';
                            --LogicOp := "00";
                            --HiLoWE := "00";
                            --ShiftOp := "00";
                            --VarShift := '0';
                            BranchType := "11";
                            ZRNGMask := "01";
                            OneZero := '1';
                            -- MEM Signals
                            MemRead := '0';
                            MemWrite := '0';        
                            --SignZeroLoad := '0';
                            --isWord := '0';
                            --ByteHalf := '0';
                            -- WB Signals
                            --HiLo := '0';
                            WriteBack := "00";
                            RegWrite := '0';
                        when "10001" =>
                            -- BGEZAL --
                            -- ID signals
                            RtZero := '0';
                            RegDst := "10";
                            --isLUI := '0';
                            SignZero := '1';
                            -- EX signals
                            ALUSrc := '0';
                            ALUOp := "00";
                            AddSub := '0';
                            SignUnsign := '1';
                            --LogicOp := "00";
                            --HiLoWE := "00";
                            --ShiftOp := "00";
                            --VarShift := '0';
                            BranchType := "11";
                            ZRNGMask := "01";
                            OneZero := '0';
                            -- MEM Signals
                            MemRead := '0';
                            MemWrite := '0';        
                            --SignZeroLoad := '0';
                            --isWord := '0';
                            --ByteHalf := '0';
                            -- WB Signals
                            --HiLo := '0';
                            WriteBack := "00";
                            RegWrite := '1';
                        when others => null;
                    end case;
                when i_j =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "11";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "01";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    --WriteBack := "00";
                    RegWrite := '0';
                when i_jal =>
                    -- ID signals
                    --RtZero := '0';
                    RegDst := "10";
                    --isLUI := '0';
                    --SignZero := '0';
                    -- EX signals
                    --ALUSrc := '0';
                    --ALUOp := "00";
                    --AddSub := '0';
                    --SignUnsign := '0';
                    --LogicOp := "00";
                    --HiLoWE := "00";
                    --ShiftOp := "00";
                    --VarShift := '0';
                    BranchType := "01";
                    --ZRNGMask := "00";
                    --OneZero := '0';
                    -- MEM Signals
                    MemRead := '0';
                    MemWrite := '0';        
                    --SignZeroLoad := '0';
                    --isWord := '0';
                    --ByteHalf := '0';
                    -- WB Signals
                    --HiLo := '0';
                    WriteBack := "00";
                    RegWrite := '1';
                when others => null;
            end case;
        end if;

        s_IFIDWrite <= '1';
        s_PCWrite <= '1';
        s_IFIDFlush <= '1';
        s_IDEXFlush <= '1';
        s_EXMEMFlush <= '1';
        s_IDEXFlushCtrl <= '1';
        s_EXMEMFlushCtrl <= '1';

        s_IDEX_WBSignals(3 downto 2) <= WriteBack;
        s_IDEX_WBSignals(1) <= HiLo;
        s_IDEX_WBSignals(0) <= RegWrite;

        s_IDEX_MEMSignals(4) <= ByteHalf;
        s_IDEX_MEMSignals(3) <= isWord;
        s_IDEX_MEMSignals(2) <= SignZeroLoad;
        s_IDEX_MEMSignals(1) <= MemWrite;
        s_IDEX_MEMSignals(0) <= MemRead;

        s_IDEX_EXSignals(16) <= OneZero;
        s_IDEX_EXSignals(15 downto 14) <= ZRNGMask;
        s_IDEX_EXSignals(13 downto 12) <= BranchType;
        s_IDEX_EXSignals(11) <= VarShift;
        s_IDEX_EXSignals(10 downto 9) <= ShiftOp;
        s_IDEX_EXSignals(8 downto 7) <= HiLoWE;
        s_IDEX_EXSignals(6 downto 5) <= LogicOp;
        s_IDEX_EXSignals(4) <= SignUnsign;
        s_IDEX_EXSignals(3) <= AddSub;
        s_IDEX_EXSignals(2 downto 1) <= ALUOp;
        s_IDEX_EXSignals(0) <= ALUSrc;

        s_IDSignals(4) <= SignZero;
        s_IDSignals(3) <= isLUI;
        s_IDSignals(2 downto 1) <= RegDst;
        s_IDSignals(0) <= RtZero;

        if (Branch = '1') then
            -- insert bubbles (nop instruction) for branch taken
            s_IFIDFlush <= '0';
            s_IDEXFlush <= '0';
            s_EXMEMFlush <= '1';
            s_IDEXFlushCtrl <= '0';
            s_EXMEMFlushCtrl <= '1';
        elsif (Stall = '1') then
            -- insert bubble
            s_IDEXFlushCtrl <= '0';
            -- stall
            s_IFIDWrite <= '0';
            s_PCWrite <= '0';
        end if;
    end process;
    
    ACLRL <= s_ACLRL;
    IFIDWrite <= s_IFIDWrite;
    PCWrite <= s_PCWrite;
    IFIDFlush <= s_IFIDFlush;
    IDEXFlush <= s_IDEXFlush;
    EXMEMFlush <= s_EXMEMFlush;

    IDSignals <= s_IDSignals;

    -- ID/EX control pipeline registers
IDEX_WBSignals: REG_N_wSACLRL
    generic map (N => 4)
    port map (
        CLK => CLK,
        D => s_IDEX_WBSignals,
        SCLRL => s_IDEXFlushCtrl,
        ACLRL => s_ACLRL,
        Q => s_EXMEM_WBSignals
    );

IDEX_MEMSignals: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => s_IDEX_MEMSignals,
        SCLRL => s_IDEXFlushCtrl,
        ACLRL => s_ACLRL,
        Q => s_EXMEM_MEMSignals
    );

    IDEX_MemRead <= s_EXMEM_MEMSignals(0);
    IDEX_MemWrite <= s_EXMEM_MEMSignals(1);

IDEX_EXSignals: REG_N_wSACLRL
    generic map (N => 17)
    port map (
        CLK => CLK,
        D => s_IDEX_EXSignals,
        SCLRL => s_IDEXFlushCtrl,
        ACLRL => s_ACLRL,
        Q => EXSignals
    );

    -- EX/MEM control pipeline registers
EXMEM_WBSignals: REG_N_wSACLRL
    generic map (N => 4)
    port map (
        CLK => CLK,
        D => s_EXMEM_WBSignals,
        SCLRL => s_EXMEMFlushCtrl,
        ACLRL => s_ACLRL,
        Q => s_MEMWB_WBSignals
    );

    EXMEM_RegWrite <= s_MEMWB_WBSignals(0);
    EXMEM_HiLo <= s_MEMWB_WBSignals(1);
    EXMEM_WriteBack <= s_MEMWB_WBSignals(3 downto 2);

EXMEM_MEMSignals: REG_N_wSACLRL
    generic map (N => 5)
    port map (
        CLK => CLK,
        D => s_EXMEM_MEMSignals,
        SCLRL => s_EXMEMFlushCtrl,
        ACLRL => s_ACLRL,
        Q => MEMSignals
    );

    -- MEM/WB control pipeline registers
MEMWB_WBSignals: REG_N_wACLRL
    generic map (N => 4)
    port map (
        CLK => CLK,
        D => s_MEMWB_WBSignals,
        ACLRL => s_ACLRL,
        Q => WBSignals
    );

end CTRL_FSM_HYBRID;

