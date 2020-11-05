dpath1 = '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/'

wb_cube = lp_read(dpath1+'wb_3950_2017-05-25T09:12:00_scans=0-424_corrected.icube')

;Fe_LOS = lp_read('/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/crispex/09:12:00/Blos_6302_08:05:00_aligned_3950_2017-05-25T09:12:00_scans=0-424.icube')

;restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/vorticity.sav'; vor

;restore, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/divergence.sav'; div

V_X = fltarr(200,200,419)

V_Y = V_X

X_ROI = [150,1149]

Y_ROI = [150,1149]

!p.multi=[0,2,1]
;wb_cube_los = fltarr(1000,1000,424)
for j=0,418 do begin

 ;  wb_cube_los[*,*,j] = float(Fe_LOS[150:1149,150:1149,j])
  
    IM1 = WB_CUBE[X_ROI[0]:X_ROI[1],Y_ROI[0]:Y_ROI[1],J]

    IM2 = WB_CUBE[X_ROI[0]:X_ROI[1],Y_ROI[0]:Y_ROI[1],J+6]

    FLOW_NOVEMBER,IM1[0:199,0:199],IM2[0:199,0:199], VX, VY, FWHM=25.,/corr,/crossd  ;FWHM of 20*0.0376 arcsec

    vx = vx*0.0376*722                               ;converting from pixels/sec to km/sec

    vy = vy*0.0376*722			             ; do

    plot_image,vx

    plot_image,vy

;    stats, vx

 ;   stats,vy

    ;stop
    V_X[*,*,J] =vx>(-10)<(10) 

    V_Y[*,*,J] =vy>(-10)<(10)

    ;STOP    
  ; window,1
   
  ; plot_image, wb_cube_los[*,*,j],color=0

  ; window,2

  ; plot_image, wb_cube[150:1149,150:1149,j],color=0

   ;blink, [1,2],0.5

   ;stop


endfor


;lp_write, wb_cube_vel, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/wb_3950_2017-05-25T09:12:00_scans=0-423_deepVel_corrected.fcube'
;lp_write, wb_cube_los, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Blos_6302_aligned_3950_2017-05-25T09:12:00_deepVel_corrected.fcube'
;lp_write, vor, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Vorticity_deepVel_align_wb_3950_2017-05-25T09:12:00.fcube'

;lp_write, div, '/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/deepVel/Divergence_deepVel_align_wb_3950_2017-05-25T09:12:00.fcube
  
;save, V_x, V_y, filename='/mn/stornext/d11/lapalma/reduc/2017/2017-05-25/CHROMIS/calib_tseries/LCT_velocities.idlsav'
end


