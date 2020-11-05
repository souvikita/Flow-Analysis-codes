; Simple code for the EST science Nuggets/posts.
;Requested by Ada
;Date of creation: 07.03.2019 T18:19:00

;;#### Code to create a cork movie where the corks are obtained from deepvel.

chromis_vel = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube')

ncorks =800.

folder = '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/'

restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Corrected_vel_Luc.sav'
restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/tseries_3950_2017-05-25T09:12:00_scans=0-424_calib.sav'; restores most importantly time

V_x_t = V_x_luc[0:799,0:799,0]*(13.65/27.6);*1.265

V_y_t = V_y_luc[0:799,0:799,0]*(13.65/27.6);*1.265

s = SIZE(V_x_t)

cx = LINDGEN(ncorks,ncorks) MOD ncorks

cx = FLOAT(cx) / ncorks * s(1)

cx = FIX(ROUND(cx))

cy = LINDGEN(ncorks,ncorks) / ncorks

cy = FLOAT(cy) / ncorks * s(2)

cy = FIX(ROUND(cy))

;xsize=900 & ysize=750

;window, 2, xs = xsize, ys =ysize,retain=2

SET_PLOT, 'ps',/copy,/interpolate
!p.font =0
DEVICE, ENCAPSUL=1,portrait=1,/isolatin1, BITS_PER_PIXEL=12., /COLOR, FILENAME='/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-0000.eps', XSIZE=14., YSIZE=12.

load,0

;DEVICE, SET_FONT='TIMES BOLD',/tt_font

plot_image,histo_opt(chromis_vel[0:799,0:799,0]), title='SST CHROMIS WB at 395 nm. Date: 25.05.2017', color=0,background=255, charsize=.9, origin=[0,0], scale=[0.0376*722/1000.,0.0376*722/1000.],xtitle='X-[1000 km]',ytitle='Y-[1000 km]',xticklen=-0.015,yticklen=-0.015,charthick=3.,max =2200,min=750,position=[0.19,0.1,0.99,0.9],xtickformat='(I3.0)',ytickformat='(I3.0)'

load,3

oplot, CX*0.0376*722/1000,CY*0.0376*722/1000, psym=3, color=180
clock, time[0], /col, size=0.15

;load,0
load,0,/silent
;!p.multi =0

DEVICE, /CLOSE ; Close the file.
SET_PLOT, 'x' ; Finished

;stop
;write_png, '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-0000.png', tvrd(/true)

for i =1, 139 do begin

   V_y_t = V_y_luc[0:799,0:799,i]*(13.65/27.6);*1.265

   V_x_t = V_x_luc[0:799,0:799,i]*(13.65/27.6);*1.265

;  IF (i MOD 50 EQ 0) THEN BEGIN

    ;ncorks=1000

 ;   s = SIZE(V_x_t)
;
  ;  cx = LINDGEN(ncorks,ncorks) MOD ncorks

   ; cx = FLOAT(cx) / ncorks * s(1)

    ;cx = FIX(ROUND(cx))

 ;   cy = LINDGEN(ncorks,ncorks) / ncorks
;
  ;  cy = FLOAT(cy) / ncorks * s(2)

  ;  cy = FIX(ROUND(cy))

  ;  CX = CX + V_X_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1.

  ;  CX = CX > 0 < 799.                                ; Change based on the ncorks. The number is ncorks-1.

  ;  CY = CY + V_Y_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1

  ;  CY = CY > 0 < 799.
   ; Change based on the ncorks. The number is ncorks-1.

  ;  CX = CX >0

  ;  CY = CY >0

 ; ENDIF ELSE BEGIN

  CX = CX + V_X_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1.

  CX = CX > 0 < 799.

  CY = CY + V_Y_t[FIX(ROUND(CX)),FIX(ROUND(CY))]*1.

  CY = CY > 0 < 799.

  CX = CX >0

  CY = CY >0

  ;ENDELSE

SET_PLOT, 'ps',/copy,/interpolate
!p.font =0
DEVICE, ENCAPSUL=1,portrait=1,/isolatin1, BITS_PER_PIXEL=12., /COLOR, FILENAME='/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-'+string(i, format='(I04)')+'.eps', XSIZE=14., YSIZE=12.

load,0

plot_image,histo_opt(chromis_vel[0:799,0:799,i]), title='SST CHROMIS WB at 395 nm. Date: 25.05.2017', color=0,background=255, charsize=.9, origin=[0,0], scale=[0.0376*722/1000,0.0376*722/1000],xtitle='X-[1000 km]',ytitle='Y-[1000 km]',xticklen=-0.015,yticklen=-0.015,charthick=3.,max =2200,min=750,position=[0.19,0.1,0.99,0.9],xtickformat='(I3.0)',ytickformat='(I3.0)'


load,3

oplot, CX*0.0376*722/1000.,CY*0.0376*722/1000., psym=3, color=180
clock, time[i], /col,size=0.15

;stop

load,0

DEVICE, /CLOSE ; Close the file.
SET_PLOT, 'x' ; Finished

;  write_png, '/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/image_corks-'+string(i, format='(I04)')+'.png', tvrd(/true)

endfor
MakeMovie =1.

if MakeMovie then begin  ; set-up script for converting the .eps files to .png
     movxsize=1280 & movysize=fix(float(movxsize)*13./float(14.))
     if movysize mod 2 ne 0 then movysize=movysize+1  ; force even dimension
     idir='/mn/stornext/u3/souvikb/souvik/CORK_IMAGES/'
     odir=strmid(idir, 0, strlen(idir)-1)+'_png/'
     file_mkdir, odir
     fl=file_search(idir+'image_corks-*.eps', count=nf)
     if nf eq 0 then stop
     openw, luw, odir+'cvrt.txt', /get_lun
     for i=0, nf-1 do begin
         ifile=fl[i]
         t=strsplit(ifile,'/',/extract)
         ofile=odir+strmid(t[-1],0,strlen(t[-1])-3)+'png'
         cmd='convert -colorspace rgb -resize '+strtrim(movxsize,2)+'x'+strtrim(movysize,2)+'! -density 300 -alpha remove -background white '+ifile+' '+ofile
         print, cmd
         printf, luw, cmd
     endfor
     printf, luw, 'ffmpeg -i image_corks-0%03d.png -vcodec h264 -pix_fmt yuv420p -y EST_science_movie'+'3'+'.mp4'
     free_lun, luw
     spawn, 'chmod a+x '+odir+'cvrt.txt'
     print, odir
     print, 'ffmpeg -i image_corks-0%03d.png -vcodec h264 -pix_fmt yuv420p -y EST_science_movie'+'3'+'.mp4'
 endif

end
