rem mencoder.exe sample.avs -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=9000000:mbd=2:trell:v4mv:last_pred=3:predia=2:dia=2:vmax_b_frames=2:vb_strategy=1:precmp=2:cmp=2:subcmp=2:preme=2:keyint=30 -o CAM01576_60fps_mencoder.mkv
#ffmpeg -i 50_60fps.avs -c:v libx264 -preset slow -crf 15 -filter:v hqdn3d=5.0 -c:a copy 50_60fps.avi
%cd%/ffmpeg/ffmpeg.exe -i %cd%/scripts/50_60fps_no_GPU.avs -c:v libx264 -preset slow -crf 15 -c:a copy 50_60fps.avi
