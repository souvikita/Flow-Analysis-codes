Fe_Los = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Blos_6302_aligned_3950_2017-05-25T09:12:00_deepVel_corrected.fcube')

restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Flow_dynamics.sav',/v  ; divergence_maps, vorticity_maps

chromis_vel = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube')

contrast = fltarr(424)

tot_vor= fltarr(424)

tot_b = fltarr(424)


for i=0,423 do begin

    i1 = reform(chromis_vel[200:299,0:99,i])

    contrast[i] = stddev(i1)/mean(i1)
 
    vor = abs(vorticity_maps[200:299,0:99,i])

    mask = fltarr(100,100)

    w = where(vor ge 0.6)

    mask[w] =1.

    pdt1 = mask*vor

    B_los = abs(Fe_Los[200:299,0:99,i])/(1e3)

    pdt2 = mask*B_los

    tot_vor[i] = total(pdt1[w])
  
    tot_b[i] = total(pdt2[w])

endfor


!p.multi=[0,1,3]

cgplot, contrast, xtitle='Frames', ytitle='Contrast', title='Contrast of CHROMIS WB', color='red', thick=2,ysty=1,xsty=1, charsize=2.

cgplot, tot_vor, xtitle='Frames', ytitle='[/s]', title='Total vorticity', color='black', thick=2,ysty=1,xsty=1, charsize=2.

cgplot, tot_b, xtitle='Frames', ytitle='kG', title='Total magnetic field', color='blue', thick=2,ysty=1,xsty=1, charsize=2.

!p.multi=0

write_png, '/mn/stornext/u3/souvikb/souvik/flow_images/contrast_all.png', tvrd(/true)

window, 2

cgscatter2d, reform(abs(vorticity_maps[200:*,0:849,0])), reform(abs(Fe_Los[200:*,0:849,0]/1e3)), xtitle ='Vorticity[/s]', ytitle='Magnetic Field[kG]',xsty=1,ysty=1, fit=0, /nodisplay

write_png, '/mn/stornext/u3/souvikb/souvik/flow_images/scatter.png', tvrd(/true)
end


