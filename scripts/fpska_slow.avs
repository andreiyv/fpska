#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
threads=nthreads
SetMTMode(3,threads)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("fullhd.mkv")
ConvertToYV12()

super_params="{pel:2,gpu:0}"

analyse_params="""{gpu:0,vectors:3,block:{block:{w:16}, refine:[{thsad:1000}],overlap:2},
        levels:3,
	main:{search:{type:4,sort:true,distance:32,satd:true,coarse:{type:4,distance:32},trymany:true},bad:{sad:1000,range:-32}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=threads)


smooth
