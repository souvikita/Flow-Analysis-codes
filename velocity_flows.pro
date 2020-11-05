; Description: THIS PIECE OF CODE OBTAINS THE CORKS (LAGRANGE TRACERS) OVERPLOTTED ON THE CORRESPONDING INTENSITY IMAGES. THE CORKS ARE GENERATED BY THE STEPS DESCRIBED IN THE LINES 31-43. ;I HAVE USED PLOT_IMAGE ROUTINE TO SHOW THE IMAGES AND OPLOT PROCEDURE TO OVERPLOT THE CORKS ON THE IMAGES. THE CORK PORITON OF THE CODE HAS BEEN MODIFIED EXTENSIVELY FROM THE OLDER ;(1992) VERSION OF THE CODE, CORK_MAP.PRO by Roberto Molowny Horas, UiO.

;The most important part of the code is the conversion of the velocities from km/s obtained from DeepVel to pixel/t_step, because the corks are overlaid on the intensity images on each
; pixel location. 1 t_step is 13.65 s


;dpath ='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/deepvel/'

;flows = readfits(dpath+'out.fits')

;Veloc = fltarr(1000,1000,424)

chromis_vel = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube')


ncorks =200.

folder = '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/'

;########## From the DeepVel code #################

;V_x = (reform(flows[0,0:199,0:199,0]))*(13.65/27.6)*1.265

;V_y = (reform(flows[1,0:199,0:199,0]))*(13.65/27.6)*1.265

;V_x = transpose(reverse(reverse(V_x,2)))

;V_y = transpose(reverse(reverse(V_y,2)))
;V_y_t = V_x

;V_x_t = V_y
;-----------------------Ends-----------------------

;restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Corrected_velocities.sav', /v ; V_x_new, V_y_new from the deepvel code

restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Corrected_vel_Luc.sav'
;restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/LCT_velocities_Welsch.idlsav',/v ; V_x, V_y for the entire time series using LCT technique

V_x_t = V_x_luc[0:199,0:199,0]*(13.65/27.6)*1.265

V_y_t = V_y_luc[0:199,0:199,0]*(13.65/27.6)*1.265
;V_x1 = V_x[0:199,0:199,0]*(13.65/27.6)between images in idl

;V_x1 = V_x[*,*,0]*(13.65/27.6)*(-4)
;V_y1 = V_y[0:199,0:199,0]*(13.65/27.6)

;V_y1 = V_y[*,*,0]*(13.65/27.6)*(-4)

s = SIZE(V_x_t)

cx = LINDGEN(ncorks,ncorks) MOD ncorks

cx = FLOAT(cx) / ncorks * s(1)

cx = FIX(ROUND(cx))

cy = LINDGEN(ncorks,ncorks) / ncorks

cy = FLOAT(cy) / ncorks * s(2)

cy = FIX(ROUND(cy))

xsize=1500 & ysize=550

window, 0, xs = xsize, ys =ysize

!p.multi =[0,3,1]

load,0

plot_image, histo_opt(chromis_vel[0:199,0:199,0]), title='Cont. Intensity', color=255, charsize=2.0, charthick=2.,origin=[0,0], scale=[0.0376,0.0376],xtitle='arcsec',ytitle='arcsec'

load,3

oplot, CX*0.0376,CY*0.0376, psym=3, color=180


load,10

plot_image,divergence(V_x_t,V_y_t), max=0.5, min=-0.5,title='Divergence[/t_step]', xstyle=5,ystyle=5, color=255, charsize=2.0, charthick=2

cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-0.5,0.5], bottom =1, position =[0.40,0.04,0.63,0.07]

load,0

oplot, CX,CY, psym=3, color=255


load,33

plot_image,vorticity(V_x_t,V_y_t), max=0.5, min=-0.5,title='Vorticity[/t_step]', xstyle=5,ystyle=5, color=130, charsize=2.0, charthick=2

cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-0.5,0.5], bottom =1, position =[0.73,0.04,0.96,0.07]

load,0

oplot, CX,CY, psym=3, color=180

;load,0
xyouts, 0.04,0.95, 'FRAME No: 0', color =255, charsize =1.0, charthick=3., /normal
stop
;plot_image, histo_opt(chrohttps://www.finn.no/realestate/lettings/ad.html?finnkode=130094170mis_vel[0:199,0:199,0])

;velovect, v_x,v_y, length =10, /overplot, missing =5., /dots

;load,3

;oplot, CX,CY, psym=3, color=160

load,0

write_png, '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-0000.png', tvrd(/true)


;STOP

for i =1, 423 do begin

  ;V_x = (reform(flows[0,0:199,0:199,i-1]))*(13.65/27.6)*1.265 ; (13.65/27.6) comes from converting 1 px/step = 27.6/13.65 km/s and 1.265 is the factor which needs to be multiplied
                                                    ; to take care of the differences in the velocities between deepvel and CHROMIS
  ;V_x = transpose(reverse(reverse(V_x,2)))

  ;V_y = (reform(flows[1,0:199,0:199,i-1]))*(13.65/27.6)*1.265


  V_y_t = V_y_luc[0:199,0:199,i]*(13.65/27.6)*1.265

  V_x_t = V_x_luc[0:199,0:199,i]*(13.65/27.6)*1.265


  IF (i MOD 50 EQ 0) THEN BEGIN

    ;ncorks=1000

    s = SIZE(V_x_t)

    cx = LINDGEN(ncorks,ncorks) MOD ncorks

    cx = FLOAT(cx) / ncorks * s(1)

    cx = FIX(ROUND(cx))

    cy = LINDGEN(ncorks,ncorks) / ncorks

    cy = FLOAT(cy) / ncorks * s(2)

    cy = FIX(ROUND(cy))

    CX = CX + V_X_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1.

    CX = CX > 0 < 199.                                ; Change based on the ncorks. The number is ncorks-1.

    CY = CY + V_Y_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1

    CY = CY > 0 < 199.                                ; Change based on the ncorks. The number is ncorks-1.

    CX = CX >0

    CY = CY >0

  ENDIF ELSE BEGIN

  CX = CX + V_X_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1.

  CX = CX > 0 < 199.

  CY = CY + V_Y_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1

  CY = CY > 0 < 199.

  CX = CX >0

  CY = CY >0

  ENDELSE
  ;window,1, xs =1000, ys=1000
   load,0

   plot_image, histo_opt(chromis_vel[0:199,0:199,i]), title='Cont. Intensity', color=255, charsize=2.0, charthick=2.,origin=[0,0], scale=[0.0376,0.0376],xtitle='arcsec',ytitle='arcsec'
   ;tvscl, histo_opt(chromis_vel[*,*,i]),xsize=(dx[1]-dx[0]), ysize=(dy[1]-dy[0]), dx[0], dy[0], /normal

   load,3

   ;plot, CX,CY, psym=3, xstyle=1, ystyle=1,position = [dx[0], dy[0], dx[1], dy[1]], /normal, /noerase, color =130,xrange=[0,999]

   oplot, CX*0.0376,CY*0.0376, psym=3, color=180
  ;plots, CX1[*,*,I], CY1[*,*,I],color =190

   load,10

   plot_image, divergence(V_x_t,V_y_t), max=0.5, min=-0.5, title='Divergence[/t_step]', xstyle=5,ystyle=5, color=255, charsize=2.0, charthick=2

   ;velovect, v_x, v_y, length =10,/overplot, missing =5.,/dots
   cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-0.5,0.5], bottom =1, position =[0.40,0.04,0.63,0.07]
   load,0

   oplot, CX,CY, psym=3, color=255

   ;load,0oplot, CX, CY, psym=3, color=180

   load,33

   plot_image,vorticity(V_x_t,V_y_t), max=0.5, min=-0.5,title='Vorticity[/t_step]', xstyle=5,ystyle=5, color=130, charsize=2.0, charthick=2

   cgColorbar, Divisions=4, Minor=5, Format='(F0.2)', Range=[-0.5,0.5], bottom =1, position =[0.73,0.04,0.96,0.07]

   load,0

   oplot, CX,CY, psym=3, color=180

 stop


  load,0

  xyouts, 0.04,0.95, 'FRAME No:' + strtrim(i), color =255, charsize =1.0, charthick=3., /normal


  ;if (i mod 100 eq 0) then STOP

  write_png, '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-'+string(i, format='(I04)')+'.png', tvrd(/true)

endfor

;video.cleanup

end
