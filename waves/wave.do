onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_datapath/clk
add wave -noupdate -format Logic /tb_datapath/reset
add wave -noupdate -format Logic /tb_datapath/ov
add wave -noupdate -format Logic /tb_datapath/e
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/branch
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/stall
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/ifidwrite
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/pcwrite
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/ifidflush
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/idexflush
add wave -noupdate -format Logic /tb_datapath/uut/controlunit/exmemflush
add wave -noupdate -group IF
add wave -noupdate -group IF -format Literal -radix decimal /tb_datapath/uut/instructionfetch/brtrgt
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/ifidout_n
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/ifidout_ir
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_npcmuxout
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_pcout
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_incout
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_imemout
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_imemsout
add wave -noupdate -group IF -format Logic -radix hexadecimal /tb_datapath/uut/instructionfetch/s_ifidwritesout
add wave -noupdate -group IF -format Literal -radix hexadecimal /tb_datapath/uut/instructionfetch/s_imemmuxout
add wave -noupdate -expand -group ID
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/n
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/ir
add wave -noupdate -group ID -format Literal -radix binary /tb_datapath/uut/instructiondecode/ctrlsignals
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/idexflush
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/memwb_regwrite
add wave -noupdate -group ID -format Literal -radix unsigned /tb_datapath/uut/instructiondecode/wr
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/wd
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_n
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_d
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_a
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_b
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_wr
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_shamt
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_i
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_rs
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/idexout_rt
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/rs
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/rt
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/regwrite
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/rtzero
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/regdst
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/islui
add wave -noupdate -group ID -format Logic -radix hexadecimal /tb_datapath/uut/instructiondecode/signzero
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_psdout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_rtmuxout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_dataaout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_databout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_destregmuxout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_shamtmuxout
add wave -noupdate -group ID -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/s_szextout
add wave -noupdate -format Literal -radix hexadecimal /tb_datapath/uut/instructiondecode/registerfile/regfile
add wave -noupdate -group EX
add wave -noupdate -group EX -group ALU
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/a
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/b
add wave -noupdate -group ALU -format Literal /tb_datapath/uut/execute/arithmeticlogicunit/shamt
add wave -noupdate -group ALU -format Literal /tb_datapath/uut/execute/arithmeticlogicunit/aluop
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/addsub
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/signunsign
add wave -noupdate -group ALU -format Literal /tb_datapath/uut/execute/arithmeticlogicunit/logicop
add wave -noupdate -group ALU -format Literal /tb_datapath/uut/execute/arithmeticlogicunit/hilowe
add wave -noupdate -group ALU -format Literal /tb_datapath/uut/execute/arithmeticlogicunit/shiftop
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/varshift
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/zr
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/ng
add wave -noupdate -group ALU -format Logic /tb_datapath/uut/execute/arithmeticlogicunit/ov
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/aluo
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/hi
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/lo
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/s_addsubout
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/s_logicout
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/s_shamtmuxout
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/s_shiftout
add wave -noupdate -group ALU -format Literal -radix hexadecimal /tb_datapath/uut/execute/arithmeticlogicunit/s_sltout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/n
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/d
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/a
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/b
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/i
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/shamt
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/wr
add wave -noupdate -group EX -format Literal -radix binary /tb_datapath/uut/execute/ctrlsignals
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/exmemflush
add wave -noupdate -group EX -format Literal -radix binary /tb_datapath/uut/execute/forwarda
add wave -noupdate -group EX -format Literal -radix binary /tb_datapath/uut/execute/forwardb
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/forwardmem
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/fw_wd
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/fw_alu
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/fw_mdro
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_n
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/exmemout_ov
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_aluo
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_hi
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_lo
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_mdri
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/exmemout_wr
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/brtrgt
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/alusrc
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/aluop
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/addsub
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/signunsign
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/logicop
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/hilowe
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/shiftop
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/varshift
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/branchtype
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/zrngmask
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/onezero
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_pcrout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_fwmuxaout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_fwmuxbout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_alusrcmuxout
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/s_zrout
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/s_ngout
add wave -noupdate -group EX -format Logic -radix hexadecimal /tb_datapath/uut/execute/s_ovout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_aluout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_hiout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_loout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_fwmuxmemout
add wave -noupdate -group EX -format Literal -radix hexadecimal /tb_datapath/uut/execute/s_targetout
add wave -noupdate -format Literal /tb_datapath/uut/memoryaccess/datamemory/dmem
add wave -noupdate -expand -group MEM
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/aluo
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/mdri
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/hi
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/lo
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/dread
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/dwrite
add wave -noupdate -group MEM -format Literal -radix binary /tb_datapath/uut/memoryaccess/ctrlsignals
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/exmem_hilo
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/exmem_writeback
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/fw_alu
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/err
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/memread
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/memwrite
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/signzeroload
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/isword
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/bytehalf
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/s_dmweout
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/s_dmaout
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/s_errwe
add wave -noupdate -group MEM -format Logic -radix hexadecimal /tb_datapath/uut/memoryaccess/s_errout
add wave -noupdate -group MEM -format Literal -radix hexadecimal /tb_datapath/uut/memoryaccess/s_fwalusel
add wave -noupdate -group WB
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/n
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/hi
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/lo
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/aluo
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/mdro
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/ctrlsignals
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/wd
add wave -noupdate -group WB -format Logic -radix hexadecimal /tb_datapath/uut/writeback/hilo
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/writeback
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/s_rfout
add wave -noupdate -group WB -format Literal -radix hexadecimal /tb_datapath/uut/writeback/s_hiloout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15226610 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 140
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {11418925 ps} {17985324 ps}
