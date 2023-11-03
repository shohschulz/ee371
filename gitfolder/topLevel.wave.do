onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group topLevel {/topLeveltb/LEDR[9]}
add wave -noupdate -expand -group topLevel /topLeveltb/KEY
add wave -noupdate -expand -group topLevel /topLeveltb/HEX0
add wave -noupdate -expand -group topLevel /topLeveltb/SW
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/start
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/reset
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/clk
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/rShift
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/result
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/done
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/increment
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/loadReady
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/ps
add wave -noupdate -expand -group cntrl /topLeveltb/dut/cntrl/ns
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/clk
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/rShift
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/result
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/done
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/increment
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/A
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/loadReady
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/sum
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/Awire
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/test
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/sumToBoard
add wave -noupdate -expand -group dp /topLeveltb/dut/dp/finished
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1684 ps} {2386 ps}
