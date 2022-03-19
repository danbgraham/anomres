% Script to plot figure 2.
load('Figure2data.mat');
ic = 3; % Spacecraft number

Exyz = Figure2data.Exyz; % From mms3_edp_brst_l2_dce_20151206233734_v2.2.0.cdf
Epar = Figure2data.Epar; % From mms3_edp_brst_l2_dce_20151206233734_v2.2.0.cdf
Bxyz = Figure2data.Bxyz; % From mms3_fgm_brst_l2_20151206233734_v4.18.0.cdf
ne = Figure2data.ne; % From mms3_fpi_brst_l2_des-moms_20151206233734_v3.3.0.cdf
ner = Figure2data.ner; % From mms3_fpi_brst_l2_des-moms_20151206233734_v3.1.0.cdf - high-resolution data product
Ver = Figure2data.Ver; % From mms3_fpi_brst_l2_des-moms_20151206233734_v3.1.0.cdf - high-resolution data product
Vir = Figure2data.Vir; % From mms3_fpi_brst_l2_dis-moms_20151206233734_v3.1.0.cdf - high-resolution data product

% LMN coordinates from GSE coordinates
Lvec = [0.0169   -0.5167    0.8560];
Mvec = [-0.5071    -0.7422    -0.4381];
Nvec = [0.8617    -0.4267    -0.2746];

Elmn = irf_newxyz(Exyz,Lvec,Mvec,Nvec);
Velmnr = irf_newxyz(Ver,Lvec,Mvec,Nvec);
Vilmnr = irf_newxyz(Vir,Lvec,Mvec,Nvec);
Blmn = irf_newxyz(Bxyz,Lvec,Mvec,Nvec);
Bmag = Blmn.abs;
Blmnmag = irf.ts_scalar(Blmn.time,[Blmn.data Bmag.data]);

[Veparr,Veperpr]=irf_dec_parperp(Blmn,Velmnr);

[~,Eperp]=irf_dec_parperp(Blmn,Elmn);
Epp = irf.ts_scalar(Eperp.time,[Eperp.data Epar.data(:,2)]);

VixB = cross(Blmn.resample(Vir),Vilmnr)*1e-3;
VexB = cross(Blmn.resample(Ver),Velmnr)*1e-3;

%% 
dfE = 1/median(diff(Exyz.time.epochUnix));
dfB = 1/median(diff(Bxyz.time.epochUnix));
dfn = 1/median(diff(ne.time.epochUnix));
dfnr = 1/median(diff(ner.time.epochUnix));

% Lowpass filter - background terms
ne = ne.filt(0,5,dfB,5);

% Highpass filter - fluctuating terms
fhf = 5;
dE = Elmn.filt(fhf,0,dfE,5);
dn = ner.filt(fhf,0,dfnr,5);

Elmnr = Elmn.resample(ner);
nelf = ne.resample(ner);
dnne = dn/nelf;
%%

tintX = irf_time('2015-12-06T23:38:30.680Z','utc>epochtt');
tintY = irf_time('2015-12-06T23:38:31.149Z','utc>epochtt');

tintX = tintX+0.4503;
tintY = tintY+0.4503;

h=irf_plot(6,'newfigure'); 
xSize=600; ySize=600;
set(gcf,'Position',[10 10 xSize ySize]);

xwidth = 0.89;
ywidth = 0.145;
yst = 0.1;
set(h(1),'position',[yst 0.97-ywidth xwidth ywidth]);
set(h(2),'position',[yst 0.97-2*ywidth xwidth ywidth]);
set(h(3),'position',[yst 0.97-3*ywidth xwidth ywidth]);
set(h(4),'position',[yst 0.93-4*ywidth xwidth ywidth]);
set(h(5),'position',[yst 0.93-5*ywidth xwidth+0.02 ywidth]);
set(h(6),'position',[yst 0.93-6*ywidth xwidth+0.02 ywidth]);

h(1)=irf_panel('Bxyz');
irf_plot(h(1),Blmnmag);
hold(h(1),'on');
irf_plot(h(1),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(1),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(1),'off');
irf_zoom(h(1),'y',[-50 60]);
ylabel(h(1),{'B (nT)'},'Interpreter','tex','fontsize',12);
irf_legend(h(1),{'B_{L} ','B_{M} ','B_{N} ','|B|'},[0.18 0.8])
irf_legend(h(1),'(a)',[0.99 0.95],'color','k','fontsize',12);
c_eval('title(h(1),''MMS?'');',ic)

h(2)=irf_panel('ne');
irf_plot(h(2),ner);
hold(h(2),'on');
irf_plot(h(2),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(2),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(2),'off');
irf_zoom(h(2),'y',[0 20]);
ylabel(h(2),{'n_e (cm^{-3})'},'Interpreter','tex','fontsize',12);
irf_legend(h(2),'(b)',[0.99 0.95],'color','k','fontsize',12);

h(3)=irf_panel('Exyz');
irf_plot(h(3),Epp);
hold(h(3),'on');
irf_plot(h(3),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(3),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(3),'off');
irf_zoom(h(3),'y',[-60 70]);
ylabel(h(3),{'E (mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(3),{'E_{L\perp} ','E_{M\perp} ','E_{N\perp}','E_{||}'},[0.01 0.95])
irf_legend(h(3),'(c)',[0.99 0.95],'color','k','fontsize',12);

tintLH = irf.tint('2015-12-06T23:38:31.50Z/2015-12-06T23:38:33.90Z');
c_eval('irf_pl_mark(h(?),irf_time(tintLH,''epochtt>epoch'')'',[255 255 100]/255)',1:4);

tint3 = irf.tint('2015-12-06T23:38:28.50Z/2015-12-06T23:38:35.00Z');

h(4)=irf_panel('Ver');
irf_plot(h(4),Veperpr);
hold(h(4),'on')
irf_plot(h(4),Veparr);
irf_plot(h(4),[[tintY.epochUnix tintY.epochUnix]' [-1e5 1e5]'],'c--','linewidth',1.5);
hold(h(4),'off')
irf_zoom(h(4),'y',[-2200 1700]);
ylabel(h(4),{'V_{e} (km s^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(4),{'V_{L\perp}','V_{M\perp}','V_{N\perp}','V_{||}'},[0.85 0.15])
irf_legend(h(4),'(d)',[0.99 0.95],'color','k','fontsize',12);

h(5)=irf_panel('Ey');
irf_plot(h(5),{Elmnr.y,VixB.y,VexB.y},'comp');
hold(h(5),'on')
irf_plot(h(5),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(5),'off')
irf_zoom(h(5),'y',[-55 40]);
ylabel(h(5),{'E_M (mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(5),{'E','-V_i \times B','-V_e \times B'},[0.85 0.15])
irf_legend(h(5),'(e)',[0.99 0.95],'color','k','fontsize',12);

h(6)=irf_panel('dne');
irf_plot(h(6),dnne);
hold(h(6),'on')
irf_plot(h(6),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(6),'off')
irf_zoom(h(6),'y',[-0.17 0.17]);
ylabel(h(6),{'\delta n_e/n_e'},'Interpreter','tex','fontsize',12);
irf_legend(h(6),'(f)',[0.99 0.95],'color','k','fontsize',12);

irf_plot_axis_align(h(1:3));
irf_zoom(h(1:3),'x',tint3);
irf_timeaxis(h(1:3),'nodate');
irf_zoom(h(4:6),'x',tintLH);
irf_plot_axis_align(h(4:6))
irf_plot_zoomin_lines_between_panels(h(3),h(4));
set(h(1:6),'fontsize',12)
