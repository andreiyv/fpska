#SetMemoryMax(1024)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
SetMTMode(1,0)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\video.mp4")
ConvertToYV12()
# https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow


super_params="{pel:1,gpu:0}"

analyse_params="""{gpu:0,vectors:3,block:{w:8,h:8,overlap:3},
        levels:3,
	main:{search:{type:4,sort:true,distance:64,satd:true,coarse:{distance:32},trymany:true},bad:{sad:1000,range:-24}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=1)


smooth
