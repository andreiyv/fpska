#SetMemoryMax(4096)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
SetMTMode(2,4)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\fullhd.mkv")
ConvertToYV12()

# https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow

super_params="{pel:2,gpu:1}"

analyse_params="""{gpu:1,vectors:3,block:{block:{w:16}, refine:[{thsad:1000}],overlap:3},
        levels:3,
	main:{search:{type:4,sort:true,distance:64,satd:true,coarse:{type:4,distance:64},trymany:true},bad:{sad:1000,range:-24}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=4)


smooth

#BilinearResize(960, 540)

