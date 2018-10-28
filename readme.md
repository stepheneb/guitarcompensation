Calculation of saddle and nut compensation.

Two collections of Audacity audio samples for five
sets of strings measured at 650 and 325 scale lengths.

- Daddario-EJ17-medium:
- Martin-M540-light:
- Daddario-EJ16-light:
- Daddario-EJ15-extra-light:
- Daddario-EJ40-silk-and-steel:

Output from running Audacity plugin pitch-report
see: https://github.com/stepheneb/pitch-report

Calculation of longitudinal string stiffness for each string.

Guitar and neck specifications

Calculate intonation errors for each fret for each string in each string set.

Calculate nut and saddle offsets for each string in each string set.

See Gore V1:4-104

Example:

```
$ ruby process.rb ./1-experiments-20180731/experiment-20180731.yml

experiment      20180731
date    2018-07-31 14:06:14
description     interface: Tascam US-122, microphone: NADY CM90
scalelength-open        650
scalelength-fretted     325
fretted-depression      4.88
change-in-fretted-string-length 0.0733

Daddario-EJ40-silk-and-steel-2-650mm-9070g
pitch   freq    open    fretted %sharp
E4      329.63  336.79  678.07  0.67
B3      246.94  267.38  536.77  0.38
G3      196.00  174.97  351.26  0.37
D3      146.83  146.35  296.58  1.33
A2      110.00  105.57  214.46  1.58
E2      82.41   85.30   173.76  1.85

Daddario-EJ15-extra-light-650mm-9070g
pitch   freq    open    fretted %sharp
E4      329.63  364.63  733.50  0.58
B3      246.94  263.45  535.89  1.71
G3      196.00  165.02  334.96  1.49
D3      146.83  127.46  258.33  1.34
A2      110.00  98.91   201.36  1.79
E2      82.41   83.93   169.76  1.12

Daddario-EJ16-2-light-650mm-9070g
pitch   freq    open    fretted %sharp
E4      329.63  307.30  620.69  0.99
B3      246.94  229.45  467.77  1.93
G3      196.00  156.73  320.66  2.30
D3      146.83  118.13  240.82  1.93
A2      110.00  90.03   182.64  1.43
E2      82.41   70.00   142.54  1.82

Daddario-EJ17-2-medium-650mm-9070g
pitch   freq    open    fretted %sharp
E4      329.63  284.52  574.25  0.91
B3      246.94  215.97  440.41  1.96
G3      196.00  147.98  297.27  0.44
D3      146.83  110.44  224.54  1.65
A2      110.00  85.12   173.69  2.03
E2      82.41   69.64   141.86  1.85

Martin-M540-2-650mm-9070g
pitch   freq    open    fretted %sharp
E4      329.63  306.65  616.67  0.55
B3      246.94  228.49  465.15  1.79
G3      196.00  154.42  314.25  1.75
D3      146.83  117.37  236.76  0.86
A2      110.00  89.75   186.75  4.04
E2      82.41   72.95   150.17  2.92

also copied to clipboard ...
```
