#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
threads=nthreads
SetMTMode(2,threads)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\fullhd.mkv")
ConvertToYV12()

super_params="{pel:2,gpu:0}"

analyse_params="""{block:{w:32,h:32}, 
	main:{search:{coarse:{distance:-10}}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:5,den:2},algo:21}"

super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=threads)


smooth
