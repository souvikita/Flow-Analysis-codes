dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

flows = readfits(dpath+'out.fits')

div = fltarr(1000,1000,424)


for i =0, 423 do begin

  V_x = reform(flows[0,*,*,i])*1.265

  V_y = reform(flows[1,*,*,i])*1.265

  div[*,*,i] = divergence(V_x,V_y)

 ; print, string((i/423.)*100) +'% completed'
endfor

save, div, filename='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/divergence.sav'

end

