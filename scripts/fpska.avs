#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
threads=nthreads
SetMTMode(2,threads)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\fullhd.mkv")
ConvertToYV12()

# https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow

super_params="{pel:2,gpu:0}"

analyse_params="""{gpu:0,vectors:3,block:{block:{w:8}, refine:[{thsad:1000}],overlap:3},
        levels:5,
	main:{search:{type:4,sort:true,distance:128,satd:true,coarse:{type:4,distance:128},trymany:true},bad:{sad:1000,range:-128}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=threads)


smooth

#BilinearResize(960, 540)

