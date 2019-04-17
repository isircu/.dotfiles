#!/bin/sh

tmux split-window -h

tmux split-window -v
tmux select-pane -t:.0
tmux split-window -v

tmux send-keys -t:.0 "python tcp_dut.py" C-m
tmux send-keys -t:.2 "python tcp_coord.py" C-m

tmux send-keys -t:.1 "cdomni" C-m
tmux send-keys -t:.1 "omnicli" C-m
tmux send-keys -t:.1 "do init_dut" C-m

tmux send-keys -t:.3 "cdomni" C-m
tmux send-keys -t:.3 "omnicli" C-m
tmux send-keys -t:.3 "do init_coord" C-m
