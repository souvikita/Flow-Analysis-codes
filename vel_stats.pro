dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

flows = readfits(dpath+'out.fits')

;Vor = fltarr(1000,1000,424)

fps =6

folder = '/mn/stornext/u3/souvikb/souvik/flow_images/'

device, decomposed=0, retain=2

xsize=1500 & ysize=1100

window,1, xs = xsize, ys =ysize	

video=IDLffVideoWrite(folder+'flow_stats.mp4')

stream=video.AddVideoStream(xsize,ysize,fps,BIT_RATE=24E5)

!p.multi =[0,3,2]

for i =0, 423 do begin

  V_x = reform(flows[0,*,*,i])

  V_y = reform(flows[1,*,*,i])

  ;Vor[*,*,i] = vorticity(V_x,V_y)

  ;print, string((i/423.)*100) +'% completed'
  V_x_correc = V_x*1.265

  V_y_correc = V_y*1.265

  V_mag = sqrt(V_x^2+V_y^2)

  V_mag_correc = sqrt(V_x_correc^2+V_y_correc^2)

  cghistoplot, V_x, title='V_x-DeepVel', /fill, maxinput =8., mininput = -8., binsize=0.4, max_value=120000

  cghistoplot, V_y, title='V_y-DeepVel', /fill,  maxinput=8., mininput=-8, binsize =0.4, max_value=120000
  
  cghistoplot, V_mag, title='V_mag-DeepVel', /fill,  maxinput=10., mininput=0, binsize=0.4, max_value=120000

  cghistoplot, V_x_correc, xtitle='km/s', title='V_x-corrected', /fill,  maxinput=8., mininput=-8, binsize = 0.4, max_value=120000

  cghistoplot, V_y_correc, xtitle='km/s', title='V_y-corrected', /fill,  maxinput=8., mininput=-8, binsize =0.4, max_value=120000

  cghistoplot, V_mag_correc, xtitle='km/s', title='V_mag-corrected', /fill, maxinput=10., mininput=0, binsize =0.4, max_value=120000

   load,0

  xyouts, 0.03,0.95, 'FRAME No:' + strtrim(i), color =0, charsize =6.0, charthick=3., /normal

  makingmp4=video.Put(stream,TVRD(TRUE=1))
 
  ;stop
endfor
!p.multi=0
;save, Vor, filename='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/vorticity.sav'
video.cleanup
end
