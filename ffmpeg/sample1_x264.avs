Cores=1
SetMemoryMax(1024)
SetMTMode(3,Cores)
PluginPath = "C:\Program Files (x86)\MeGUI\tools\avisynth_plugin\"
LoadPlugin(PluginPath+"svpflow1.dll")
LoadPlugin(PluginPath+"svpflow2.dll")
Import(PluginPath+"InterFrame2.avsi")
AVISource("C:\Users\admin\Downloads\60fps\sample1_x264.avi", audio=false).ConvertToYV12()
SetMTMode(2)
#deinterlace
#crop
#denoise
#resize
InterFrame(Preset="Medium",Tuning="Smooth",OverrideAlgo=23,Cores=Cores)
