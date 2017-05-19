SetMemoryMax(1024)

LoadPlugin("svpflow1.dll")
LoadPlugin("svpflow2.dll")

threads=9

SetMTMode(3,threads)
DirectShowSource("C:\Users\admin\Downloads\60fps\sample1_x264.avi")
SetMTMode(2)
ConvertToYV12()

super_params="{pel:2,gpu:1}"

analyse_params="""{block:{w:16,h:16}, 
	main:{search:{coarse:{distance:-10}}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:5,den:2},algo:21,cubic:1,light:{aspect:1.33}}"

SetMTMode(1)

super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=threads)

SetMTMode(2)

smooth
