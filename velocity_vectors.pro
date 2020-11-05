dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

flows = readfits(dpath+'out.fits')

Veloc = fltarr(1000,1000,424)

for i =0, 423 do begin

  V_x = reform(flows[0,*,*,i])*1.265

  V_y = reform(flows[1,*,*,i])*1.265
  
  Veloc[*,*,i] = sqrt(V_x^2+V_y^2)

endfor

end

