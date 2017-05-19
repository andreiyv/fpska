#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
#SetMTMode(5)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\Beach_4K.mp4")
ConvertToYV12()

# https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow

super_params="{pel:1,gpu:0}"

analyse_params="""{gpu:0,vectors:3,block:{w:16,h:16,overlap:2},
        levels:3,
	main:{search:{type:4,sort:true,distance:64,satd:true,coarse:{distance:64},trymany:true},bad:{sad:1000,range:-24}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=1)


smooth

#BilinearResize(960, 540)

