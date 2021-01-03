# SuperDeclarative FFMPEG

## Notes

### Timing

Modern video containers do not store a constant frame rate. They store a timestamp for
each frame:

**Conceptual frame times (not quite accurate, read further):**
Frame       Frame Time
0           0.00
1           0.04
2           0.08
3           0.12

In practice, rather than store the explicit timestamp of a given frame, two numbers
are taken together to synthesize a frame time: the **Presentation TimeStamp (pts)**, and
the **timebase (tb)**.

**The timebase is a fundamental unit of time**, such that every frame appears on a
multiple of the timebase. Or, said differently, the timebase is the greatest common
denominator of all frame times.

**The presentation timestamp refers to a specific frame's time as a multiple of
the timebase**. Therefore, a given frame's actual time is: **pst * tb**.

**Example:**

Timebase = 1/75; Timescale = 75

Frame       pts        pts_time
0           0           0 x 1/75 = 0.00
1           3           3 x 1/75 = 0.04
2           6           6 x 1/75 = 0.08
3           9           9 x 1/75 = 0.12

**Using a timebase and presentation timestamps allows videos to encode variable
frame rates, rather than limiting the entire video to a static frame rate.**


