#SetMemoryMax(1024)
LoadPlugin("..\svpflow\svpflow1.dll")
LoadPlugin("..\svpflow\svpflow2.dll")
LoadPlugin("..\FFMS2\ffms2.dll")
LoadPlugin("..\fft3d\FFT3dFilter.dll")
SetMTMode(1,0)
Import("..\FFMS2\FFMS2.avsi")
ffmpegsource2("..\CAM01142.mp4")
ConvertToYV12()


FFT3DFilter(sigma=2, bt=5, bw=32, bh=32, ow=16, oh=16, plane=0, interlaced=false, sharpen=0.4)


# https://www.svp-team.com/w/index.php?title=Plugins:_SVPflow

super_params="{pel:1,gpu:0}"

analyse_params="""{gpu:0,vectors:3,block:{w:16,h:16,overlap:2},
        levels:3,
	main:{search:{type:4,sort:true,distance:32,satd:true,coarse:{distance:32},trymany:true},bad:{sad:1000,range:-24}},
	refine:[{thsad:200}]}"""

smoothfps_params="{rate:{num:2,den:1},algo:23}"


super = SVSuper(super_params)
vectors = SVAnalyse(super, analyse_params)
smooth = SVSmoothFps(super, vectors, smoothfps_params, mt=1)


smooth

BilinearResize(960, 540)

