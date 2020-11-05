
chromis_vel = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube')


dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

flows = readfits(dpath+'out.fits')

load,0

fps =6

folder = '/mn/stornext/u3/souvikb/souvik/flow_images/'

device, decomposed=0, retain=2

xsize=1500 & ysize=550

window,1, xs = xsize, ys =ysize	

;!p.background=255

;!p.font =0

video=IDLffVideoWrite(folder+'flow_movie_scale.mp4')

stream=video.AddVideoStream(xsize,ysize,fps,BIT_RATE=24E5)

x_scale =findgen(80)

y_scale = x_scale

x_scale = x_scale*0.0376

y_scale = y_scale*0.0376

!p.multi =[0,3,1]

for i =0,423 do begin

  V_x = reform(flows[0,130:209,130:209,i])*1.265 ; (27.6/13.65) comes from converting 1 px/step = 27.6/13.65 km/s and 1.265 is the factor which needs to be multiplied
                                                  ; to take care of the differences in the velocities between deepvel and CHROMIS

  V_y = reform(flows[1,130:209,130:209,i])*1.265 

  Vor = vorticity(V_x, V_y) ; Calculating again, because here we will obtain the quants in /tstep instead of /s.

  Div = divergence(V_x,V_y)
 
  


;  !p.multi =[0,3,1]

 load,3

  plot_image, chromis_vel[130:209,130:209,i], title='Cont. Intensity', color=0, charsize=2.0, charthick=2., scale=[0.0376,0.0376],xtitle='arcsec',ytitle='arcsec'

load,49 

  velovect, v_x, v_y,x_scale,y_scale, length =5,/overplot, color = 70
  load,10

  
  plot_image, div,max=2, min=-2.0, title='Divergence[/s]', xstyle=5,ystyle=5, color=0, charsize=2.0, charthick=2. ;Check the maximum and the minimum range of the Div!!!

  velovect, v_x, v_y, length =5,/overplot
   
  cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-2, 2], bottom =1, position =[0.4,0.05,0.63,0.1]
  
  plot_image, vor,max=2, min=-2, title='Vorticity[/s]', xstyle=5,ystyle=5., color=0, charsize=2.0, charthick=2.

  velovect, v_x, v_y, length =5,/overplot

  cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-2, 2], bottom =1, position =[0.74,0.05,0.97,0.1]
 
  load,0

  makingmp4=video.Put(stream,TVRD(TRUE=1))


  ;stop

  ;write_png, '/mn/stornext/u3/souvikb/souvik/flow_images/image_combined_1-'+string(i, format='(I04)')+'.png', tvrd(/true)

endfor
!p.multi =0

video.cleanup
end
