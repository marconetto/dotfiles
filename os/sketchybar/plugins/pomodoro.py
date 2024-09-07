#!/usr/bin/env python3

import datetime
import os
import pathlib
import sys

NAME = "pomodoro"
#NAME = os.getenv("NAME")
FILE = "/tmp/pomo"
POMO = 30 * 60

label = ""
bg_color = "0x00000000"
file_exists = pathlib.Path(FILE).exists()

draw_on=True
if len(sys.argv) == 2:
    arg = sys.argv[1]
    if arg == "start":
            with open(FILE, "wt") as f:
                f.write(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
                label = "30:00"
    elif arg == "stop":
        if file_exists:
            os.remove(FILE)
            label = ""
        draw_on=False
elif file_exists:
    with open(FILE, "rt") as f:
        ts = f.read()
    start = datetime.datetime.fromisoformat(ts)
    delta = (datetime.datetime.now() - start).total_seconds()
    if delta < POMO:
        time_left = datetime.timedelta(seconds=POMO - delta).total_seconds()
        m, s = divmod(time_left, 60)
        label = f"{int(m+1):02}"
        # label = f"{int(m):02}:{int(s):02}"
    else:
        os.remove(FILE)
        label = ""
else:
    draw_on=False

if draw_on:
    os.system(f"sketchybar --set {NAME} label={label} label.drawing=on icon.drawing=on ")
else:
    os.system(f"sketchybar --set {NAME} label.drawing=off icon.drawing=off ")
