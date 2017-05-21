SetMemoryMax(1024)

LoadPlugin("svpflow1.dll")
LoadPlugin("svpflow2.dll")

threads=9

SetFilterMTMode("DEFAULT_MT_MODE",2)
SetFilterMTMode("DirectShowSource",3)
SetFilterMTMode("SVSuper",1)
SetFilterMTMode("SVAnalyse",1)
SetFilterMTMode("SVSmoothFps",1)

DirectShowSource("C:\Users\admin\Downloads\60fps\sample1_x264.avi")
ConvertToYV12()

super_params="{pel:2,gpu:1}"

analyse_params="""{block:{w:32,h:32}, 
	main:{search:{coarse:{distance:-10}}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:5,den:2},algo:21,cubic:1,light:{aspect:1.33}}"

super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)

SVSmoothFps(super, vectors, smoothfps_params, mt=threads)

Prefetch(threads)
