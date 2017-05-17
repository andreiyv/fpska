#SetMemoryMax(1024)
LoadPlugin("svpflow1.dll")
LoadPlugin("svpflow2.dll")
LoadPlugin("ffms2.dll")
#SetMTMode(3,6)
Import("FFMS2.avsi")
ffmpegsource2("CAM01576_filtered.avi")
#SetMTMode(2)
ConvertToYV12()

super_params="{pel:1,gpu:1}"

analyse_params="""{block:{w:8,h:8}, 
	main:{search:{type:4,sort:true,distance:64,satd:true,coarse:{distance:16},trymany:true},bad:{sad:1000,range:-24}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23,cubic:1}"

#SetMTMode(1)

super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=1)

#SetMTMode(2)

smooth
