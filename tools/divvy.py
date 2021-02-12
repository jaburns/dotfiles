#!/usr/bin/env python3
import subprocess
import re
import os
import time
import sys

MINIMIZE_BG_PAD = 32

TASK_BAR_HEIGHT = 24
LAYOUTS = [
    #/ x, y, w, h
    [[     0, 0, 1.0/4, 1 ], [     0, 0, 3.0/4, 1 ]],
    [[ 1.0/4, 0, 1.0/2, 1 ], [ 1.0/4, 0, 1.0/4, 1 ], [ 1.0/2, 0, 1.0/4, 1 ]],
    [[ 3.0/4, 0, 1.0/4, 1 ], [ 1.0/4, 0, 3.0/4, 1 ]],

    [[     0, 0, 1.0/3, 1 ], [     0, 0, 2.0/3, 1 ]],
    [[ 1.0/3, 0, 1.0/3, 1 ]],
    [[ 2.0/3, 0, 1.0/3, 1 ], [ 1.0/3, 0, 2.0/3, 1 ]],

    [[ 3.0/10, 1.0/6, 4.0/10, 4.0/6 ]],
]

g_monitor_whxys = []

def run(cmd):
    lines = subprocess.check_output(cmd, shell=True).decode('utf-8').strip().split('\n')
    return [re.sub(r'\s+', ' ', l.strip()).split(' ') for l in lines]

def get_global_monitor_whxys():
    global g_monitor_whxys
    vals = run(r"xrandr | grep ' connected' | grep -v 'connected (' | sed 's/primary //g'")
    g_monitor_whxys = [[int(x) for x in re.sub(r'[x+]', ' ', val[2]).split(' ')] for val in vals]

def get_active_win_id():
    return int(re.sub(',', '', run('xprop -root _NET_ACTIVE_WINDOW')[0][4]), 16)

def get_vdesktop_id(win_id):
    return int(run("wmctrl -l | grep "+format(win_id,'x'))[0][1])

def get_all_win_ids():
    return [int(x[0], 16) for x in run("wmctrl -l")]

def is_window_minimized(win_id):
    return run('xwininfo -id '+hex(win_id)+' | grep "Map State:"')[0][2] == 'IsUnMapped'

def minimize_window(win_id):
    run('xdotool windowminimize ' + hex(win_id))

def get_monitor_index_for_point(x, y):
    for i in range(len(g_monitor_whxys)):
        mw, mh, mx, my = g_monitor_whxys[i]
        if x >= mx and x <= mx + mw and y >= my and y <= my + mh:
            return i
    return 0

def get_monitor_index_for_win_id(win_id):
    dims = get_win_dimensions(win_id)
    x = dims['cx']
    y = dims['cy']
    for i in range(len(g_monitor_whxys)):
        mw, mh, mx, my = g_monitor_whxys[i]
        if x >= mx and x <= mx + mw and y >= my and y <= my + mh:
            return i
    return 0

def get_win_dimensions(id):
    lines = run('xwininfo -id '+hex(id)+' | grep -E "upper-left|Width:|Height:"')
    win = [int(x[-1]) for x in lines]
    woff = 2 * win[2]
    hoff = win[2] + win[3]
    ox = win[0] - win[2]
    oy = win[1] - win[3]
    ow = win[4] + woff
    oh = win[5] + hoff
    cx = ox + ow / 2
    cy = oy + oh / 2
    return { "woff":woff, "hoff":hoff, "ox":ox, "oy":oy, "ow":ow, "oh":oh, "cx":cx, "cy":cy }

def convert_dims_to_layout(dims, mw, mh, mx, my):
    return [ float(dims['ox']-mx)/mw, float(dims['oy']-my)/mh, float(dims['ow'])/mw, float(dims['oh'])/mh ]

def win_dimensions_intersect(dims0, dims1, padding):
    l0 = dims0['ox'] + padding
    r0 = dims0['ox'] + dims0['ow'] - padding
    t0 = dims0['oy'] + padding
    b0 = dims0['oy'] + dims0['oh'] - padding
    l1 = dims1['ox'] + padding
    r1 = dims1['ox'] + dims1['ow'] - padding
    t1 = dims1['oy'] + padding
    b1 = dims1['oy'] + dims1['oh'] - padding
    if r0 < l1 or r1 < l0: return False
    if b0 < t1 or b1 < t0: return False
    return True

def move_window(id, xywh_args):
    run(r'wmctrl -i -r "'+hex(id)+'" -e "0,'+','.join([str(x) for x in xywh_args])+'"')

def get_visible_other_windows(this_win_id):
    this_vd_id = get_vdesktop_id(this_win_id)
    this_mon_index = get_monitor_index_for_win_id(this_win_id)
    ret = []
    for win_id in get_all_win_ids():
        if win_id == this_win_id or get_vdesktop_id(win_id) != this_vd_id or is_window_minimized(win_id):
            continue
        if this_mon_index != get_monitor_index_for_win_id(win_id):
            continue
        ret.append(win_id)
    return ret

def get_fill_layout(this_layout, other_layout):
    if other_layout[0] < this_layout[0]:
        return [0, 0, this_layout[0], 1]
    else:
        return [this_layout[0] + this_layout[2], 0, 1.0 - this_layout[0] - this_layout[2], 1]

def run_minimize_bg():
    this_win_id = get_active_win_id()
    this_dims = get_win_dimensions(this_win_id)
    for win_id in get_visible_other_windows(this_win_id):
        if win_dimensions_intersect(this_dims, get_win_dimensions(win_id), MINIMIZE_BG_PAD):
            minimize_window(win_id)

def run_fill_rest():
    this_win_id = get_active_win_id()
    this_dims = get_win_dimensions(this_win_id)
    monitor_index = get_monitor_index_for_point(this_dims['cx'], this_dims['cy'])
    mw, mh, mx, my = g_monitor_whxys[monitor_index]
    mh -= TASK_BAR_HEIGHT
    this_layout = convert_dims_to_layout(this_dims, mw, mh, mx, my)

    for win_id in get_visible_other_windows(this_win_id):
        other_dims = get_win_dimensions(win_id)
        other_layout = convert_dims_to_layout(other_dims, mw, mh, mx, my)
        layout = get_fill_layout(this_layout, other_layout)
        run_layout_or_next_monitor(win_id, layout)

def run_layout_or_next_monitor(win_id, maybe_layout):
    dims = get_win_dimensions(win_id)

    monitor_index = get_monitor_index_for_point(dims['cx'], dims['cy'])

    if maybe_layout == None:
        monitor_index = (monitor_index + 1) % len(g_monitor_whxys)

    mw, mh, mx, my = g_monitor_whxys[monitor_index]
    mh -= TASK_BAR_HEIGHT

    if maybe_layout == None:
        layout = convert_dims_to_layout(dims, mw, mh, mx, my)
    else:
        layout = maybe_layout

    nx = int( mx + layout[0] * mw )
    ny = int( my + layout[1] * mh )
    nw = int( layout[2] * mw ) - dims['woff']
    nh = int( layout[3] * mh ) - dims['hoff']
    move_window(win_id, [nx, ny, nw, nh])

def run_next_monitor():
    run_layout_or_next_monitor(get_active_win_id(), None)

def run_snap(new_index):
    new_time = time.time()
    new_subindex = 0
    last_time = 0
    last_index = 0
    last_subindex = 0

    if not os.path.exists('/tmp/divvy.state'):
        with open('/tmp/divvy.state', 'w') as writer:
            writer.write('0,-1,-1')

    with open('/tmp/divvy.state', 'r') as reader:
        parts = reader.read().split(',')
        last_time = float(parts[0])
        last_index = int(parts[1])
        last_subindex = int(parts[2])

    if new_index == last_index and new_time - last_time < 2:
        new_subindex = last_subindex + 1

    with open('/tmp/divvy.state', 'w') as writer:
        writer.write(','.join([ str(new_time), str(new_index), str(new_subindex) ]))

    layout = LAYOUTS[new_index][new_subindex % len(LAYOUTS[new_index])]

    run_layout_or_next_monitor(get_active_win_id(), layout)

def main():
    get_global_monitor_whxys()
    if sys.argv[1] == 'next-monitor':
        run_next_monitor()
    elif sys.argv[1] == 'minimize-bg':
        run_minimize_bg()
    elif sys.argv[1] == 'fill-rest':
        run_fill_rest()
    else:
        run_snap(int(sys.argv[1]))

if __name__ == "__main__":
    main()