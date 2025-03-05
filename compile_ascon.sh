# Remove existing librairies
vdel -lib LIB_RTL -all
vdel -lib LIB_BENCH -all

# Build librairies
vlib LIB/LIB_RTL
vmap LIB_RTL LIB/LIB_RTL
vlib LIB/LIB_BENCH
vmap LIB_BENCH LIB/LIB_BENCH

# Define compilation options	
VLOG_OPTS="-sv +acc -svinputport=net"

# Compile all RTL sources
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/ascon_pack.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/oconstant_adder.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/sbox.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/substitution_layer.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/diffusion_layer.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/register_state.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/register_state_we.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/permutator.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/xor_up.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/xor_down.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/permutator_xor.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/counter_double_init.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/fsm.sv
vlog $VLOG_OPTS -work LIB_RTL ./SRC/RTL/ascon_top.sv

# Compile all BENCH sources
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/oconstant_adder_tb.sv;
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/substitution_layer_tb.sv
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/diffusion_layer_tb.sv
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/permutator_tb.sv
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/permutator_xor_tb.sv
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/permutator_and_ocounter_tb.sv
vlog $VLOG_OPTS -work LIB_BENCH -L LIB_RTL SRC/BENCH/fsm_tb.sv

# Simulation
# /!\ Uncomment only one vsim command below
# vsim -L LIB_RTL LIB_BENCH.oconstant_adder_tb &
# vsim -L LIB_RTL LIB_BENCH.substitution_layer_tb &
# vsim -L LIB_RTL LIB_BENCH.diffusion_layer_tb &
# vsim -L LIB_RTL LIB_BENCH.permutator_tb &
# vsim -L LIB_RTL LIB_BENCH.permutator_xor_tb &
# vsim -L LIB_RTL LIB_BENCH.permutator_and_ocounter_tb &
vsim -L LIB_RTL LIB_BENCH.fsm_tb &
