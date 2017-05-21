#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
#SetMTMode(5)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\Beach_4K.mp4")
ConvertToYV12()

BilinearResize(2048,1080)

