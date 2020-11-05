
chromis_vel = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube')

Fe_Los = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Blos_6302_aligned_3950_2017-05-25T09:12:00_deepVel_corrected.fcube')

;dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

;flows = readfits(dpath+'out.fits')

load,0

fps =6

folder = '/mn/stornext/u3/souvikb/souvik/flow_images/

device, decomposed=0, retain=2

xsize=1500 & ysize=1100

window,1, xs = xsize, ys =ysize	

;!p.background=255

;!p.font =0

video=IDLffVideoWrite(folder+'vorticity_magnetic_field.mp4')

stream=video.AddVideoStream(xsize,ysize,fps,BIT_RATE=24E5)

x_scale =findgen(100)

y_scale = x_scale


y_scale = y_scale+0.

!p.multi =[0,3,2]

restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Corrected_velocities.sav',/v;V_x_new, V_y_new

restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Flow_dynamics.sav',/v ; divergence_maps, vorticity_maps

for i =0,423 do begin

  V_x = reform(V_x_new[200:299,0:99,i])*1.265 ; (27.6/13.65) comes from converting 1 px/step = 27.6/13.65 km/s and 1.265 is the factor which needs to be multiplied
                                                  ; to take care of the differences in the velocities between deepvel and CHROMIS

  V_y = reform(V_y_new[200:299,0:99,i])*1.265 

  ;Vor = vorticity(V_x, V_y) ; Calculating again, because here we will obtain the quants in /tstep instead of /s.

  ;Div = divergence(V_x,V_y)
 
  
  ;stats, Div

  ;stop

;  !p.multi =[0,3,1]

  load,3

  plot_image, chromis_vel[200:299,0:99,i], title='WB Intensity', color=0, charsize=2.0, charthick=2., origin =[200,0],xtitle='acrsec', ytitle='acrsec',scale=[0.0376,0.0376]

  load,0

  xyouts, 0.05,0.5, 'FRAME No:' + strtrim(i), color =0, charsize =6.0, charthick=3., /normal
  
  load,49 

  velovect, V_x, V_y,x_scale*0.0376+200.,y_scale*0.0376, length =5,/overplot, color = 65
  load,33

  
  plot_image, vorticity_maps[200:299,0:99,i],max=1, min=-1, title='Vorticity[/s]', xstyle=5,ystyle=5, color=0, charsize=2.0, charthick=2. ;Check the maximum and the minimum range of the Div!!!

  cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-1,1], bottom =1, position =[0.4,0.02,0.63,0.05]

  load,0

  velovect, v_x, v_y, length =5,/overplot, color =35
   
  
  
  ;plot_image, vor,max_value=0.1, min_value=-0.1, title='Vorticity[/s]', xstyle=5,ystyle=5., color=0, charsize=2.0, charthick=2.
  load,25

  plot_image, Fe_Los[200:299,0:99,i]/(1e3),min=-1500./(1e3), max =40./(1e3), title='B_los[kG]', xstyle=5,ystyle=5, color =0, charsize=2.0, charthick=2.

  cgColorbar, Divisions=6, Minor=6, Format='(F0.2)', Range=[-1.5,0.04], bottom =1, position =[0.74,0.02,0.97,0.05]
 
  load,0

  velovect, v_x, v_y, length =5,/overplot, color=30

  
  load,3

  plot_image, chromis_vel[200:299,0:99,i], title='WB Intensity', color=0, charsize=2.0, charthick=2., origin =[200,0],scale=[0.0376,0.0376],xtitle='arcsec', ytitle='arcsec'

  load,33

  plot_image, vorticity_maps[200:299,0:99,i],max=1, min=-1, title='Vorticity[/s]', xstyle=5,ystyle=5, color=0, charsize=2.0, charthick=2. ;Check the maximum and the minimum range of the Div!!!

  load,25

  plot_image, Fe_Los[200:299,0:99,i]/(1e3),min=-1500./(1e3), max =40./(1e3), title='B_los[kG]', xstyle=5,ystyle=5, color =0, charsize=2.0, charthick=2.


  load,0

  makingmp4=video.Put(stream,TVRD(TRUE=1))


  ;stop

  ;write_png, '/mn/stornext/u3/souvikb/souvik/flow_images/image_combined_1-'+string(i, format='(I04)')+'.png', tvrd(/true)

endfor
!p.multi =0

video.cleanup
end
