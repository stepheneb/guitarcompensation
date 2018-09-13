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

$ ruby process.rb ./1-experiments-20180731/experiment-20180731.yml
experiment	20180731
date	2018-07-31 14:06:14
description	interface: Tascam US-122, microphone: NADY CM90
scalelength-open	650
scalelength-fretted	325

Daddario-EJ15-extra-light-650mm-9070g
string	frequency
E4-650	364.63
E4-325	733.50
B3-650	263.45
B3-325	535.89
G3-650	165.02
G3-325	334.96
D3-650	127.46
D3-325	258.33
A2-650	98.91
A2-325	201.36
E2-650	83.93
E2-325	169.76

Daddario-EJ40-silk-and-steel-2-650mm-9070g
string	frequency
E4-650	336.79
E4-325	678.07
B3-650	267.38
B3-325	536.77
G3-650	174.97
G3-325	351.26
D3-650	146.35
D3-325	296.58
A2-650	105.57
A2-325	214.46
E2-650	85.30
E2-325	173.76

Daddario-EJ16-2-light-650mm-9070g
string	frequency
E4-650	307.30
E4-325	620.69
B3-650	229.45
B3-325	467.77
G3-650	156.73
G3-325	320.66
D3-650	118.13
D3-325	240.82
A2-650	90.03
A2-325	182.64
E2-650	70.00
E2-325	142.54

Daddario-EJ17-2-medium-650mm-9070g
string	frequency
E4-650	284.52
E4-325	574.25
B3-650	215.97
B3-325	440.41
G3-650	147.98
G3-325	297.27
D3-650	110.44
D3-325	224.54
A2-650	85.12
A2-325	173.69
E2-650	69.64
E2-325	141.86

Martin-M540-2-650mm-9070g
string	frequency
E4-650	306.65
E4-325	616.67
B3-650	228.49
B3-325	465.15
G3-650	154.42
G3-325	314.25
D3-650	117.37
D3-325	236.76
A2-650	89.75
A2-325	186.75
E2-650	72.95
E2-325	150.17

also copied to clipboard ...
