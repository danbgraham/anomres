%% Script to plot Figure 3
% load data for figure
% Written by D. B. Graham

load('Figure3data.mat');

ic = 1:4;
c_eval('Exyz? = Figure3data.Exyz?',ic);
Epar1 = Figure3data.Epar1;
c_eval('ne? = Figure3data.ne?',ic);
c_eval('Ve? = Figure3data.Ve?',ic);
c_eval('ner? = Figure3data.ner?',ic);
c_eval('Ver? = Figure3data.Ver?',ic);
c_eval('Veerr? = Figure3data.Veerr?',ic);
c_eval('neerr? = Figure3data.neerr?',ic);
c_eval('Bxyz? = Figure3data.Bxyz?',ic);
c_eval('Bscm? = Figure3data.Bscm?',ic);
c_eval('Rxyz? = Figure3data.Rxyz?',ic);

%% Data analysis
fhf = 5;
flf = 5;

Units = irf_units;
e = Units.e;

dt = [0.0000    0.3055    0.5375    0.5298];

% LMN coordinates from GSE coordinates
Lvec = [0.0169   -0.5167    0.8560];
Mvec = [-0.5071    -0.7422    -0.4381];
Nvec = [0.8617    -0.4267    -0.2746];

c_eval('Elmn? = irf_newxyz(Exyz?,Lvec,Mvec,Nvec);',ic);
c_eval('Bscmlmn? = irf_newxyz(Bscm?,Lvec,Mvec,Nvec);',ic);
c_eval('Velmnr? = irf_newxyz(Ver?,Lvec,Mvec,Nvec);',ic);
c_eval('Velmn? = irf_newxyz(Ve?,Lvec,Mvec,Nvec);',ic);
c_eval('Velmnerr? = irf_newxyz(Veerr?,Lvec,Mvec,Nvec);',ic);
c_eval('Blmn? = irf_newxyz(Bxyz?,Lvec,Mvec,Nvec);',ic);
c_eval('Rlmn? = irf_newxyz(Rxyz?,Lvec,Mvec,Nvec);',ic);

[D,Dplus,Dminus] = calcD('Elmn?','ner?','ne?','neerr?',dt);
[T,Tplus,Tminus] = calcT('Elmn?','ner?','ne?','neerr?','Velmnr?','Velmn?','Velmnerr?','Bscmlmn?','Blmn?',dt);
[Vanom,Vanomplus,Vanomminus,Dperp,Dperpplus,Dperpminus] = calcVn('ner?','ne?','neerr?','Velmnr?','Velmnerr?','Rlmn?','Blmn?',dt);

%%
h=irf_plot(5,'newfigure'); 
%h=irf_figure(540+ic,8);
xSize=600; ySize=500;
set(gcf,'Position',[10 10 xSize ySize]);

[~,Eperp1]=irf_dec_parperp(Blmn1,Elmn1);

Epp = irf.ts_scalar(Eperp1.time,[Eperp1.data Epar1.data(:,2)]);

tint1 = irf.tint('2015-12-06T23:38:28.0Z/2015-12-06T23:38:35.0Z');
Epp = Epp.tlim(tint1);
D = D.tlim(tint1);
Dminus = Dminus.tlim(tint1);
Dplus = Dplus.tlim(tint1);
T = T.tlim(tint1);
Tminus = Tminus.tlim(tint1);
Tplus = Tplus.tlim(tint1);

xwidth = 0.90;
ywidth = 0.175;
yst = 0.08;
set(h(1),'position',[yst 0.99-ywidth xwidth ywidth]);
set(h(2),'position',[yst 0.99-2*ywidth xwidth ywidth]);
set(h(3),'position',[yst 0.99-3*ywidth xwidth ywidth]);
set(h(4),'position',[yst 0.99-4*ywidth xwidth ywidth]);
set(h(5),'position',[yst 0.96-5*ywidth xwidth ywidth-0.05]);

tintX = irf_time('2015-12-06T23:38:30.680Z','utc>epochtt');
tintY = irf_time('2015-12-06T23:38:31.061Z','utc>epochtt');

tint2 = irf.tint('2015-12-06T23:38:30.9Z/2015-12-06T23:38:34.2Z');
c_eval('irf_pl_mark(h(?),irf_time(tint2,''epochtt>epoch'')'',[255 255 120]/255)',1:4);

Dperp = Dperp.tlim(tint2);
Dperpminus = Dperpminus.tlim(tint2);
Dperpplus = Dperpplus.tlim(tint2);

h(1)=irf_panel('Elmn');
irf_plot(h(1),Epp);
irf_zoom(h(1),'y',[-60 60]);
hold(h(1),'on');
irf_plot(h(1),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(1),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
hold(h(1),'off');
ylabel(h(1),{'E (mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(1),{'E_{L\perp} ','E_{M\perp} ','E_{N\perp} ','E_{||}'},[0.01 0.1])
irf_legend(h(1),{'MMS1'},[0.01 0.95])
irf_legend(h(1),'(a)',[0.99 0.95],'color','k','fontsize',12);
irf_legend(h(1),'Lower hybrid waves',[0.95 0.10],'color','k');

ts = double((Dminus.time(1).epochUnix));
h(2)=irf_panel('D');
irf_plot(h(2),D);
hold(h(2),'on');
irf_plot(h(2),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(2),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
patch(h(2),[Dminus.time.epochUnix-ts; flip(Dminus.time.epochUnix-ts)],[Dminus.x.data; flip(Dplus.x.data)],[0.8 0.8 0.8],'edgecolor','none')
patch(h(2),[Dminus.time.epochUnix-ts; flip(Dminus.time.epochUnix-ts)],[Dminus.y.data; flip(Dplus.y.data)],[0.7 0.7 1],'edgecolor','none')
patch(h(2),[Dminus.time.epochUnix-ts; flip(Dminus.time.epochUnix-ts)],[Dminus.z.data; flip(Dplus.z.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(2),D.x,'k');
irf_plot(h(2),D.y,'b');
irf_plot(h(2),D.z,'r');
hold(h(2),'off');
ylabel(h(2),{'D (mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(2),{'D_{L} ','D_{M} ','D_{N} '},[0.01 0.1])
irf_zoom(h(2),'y',[-1.1 1.1])
irf_legend(h(2),'(b)',[0.99 0.95],'color','k','fontsize',12);
irf_legend(h(2),'Anomalous drag',[0.95 0.10],'color','k');

h(3)=irf_panel('T');
irf_plot(h(3),T);
hold(h(3),'on');
irf_plot(h(3),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(3),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
patch(h(3),[Tminus.time.epochUnix-ts; flip(Tminus.time.epochUnix-ts)],[Tminus.x.data; flip(Tplus.x.data)],[0.8 0.8 0.8],'edgecolor','none')
patch(h(3),[Tminus.time.epochUnix-ts; flip(Tminus.time.epochUnix-ts)],[Tminus.y.data; flip(Tplus.y.data)],[0.7 0.7 1],'edgecolor','none')
patch(h(3),[Tminus.time.epochUnix-ts; flip(Tminus.time.epochUnix-ts)],[Tminus.z.data; flip(Tplus.z.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(3),T.x,'k');
irf_plot(h(3),T.y,'b');
irf_plot(h(3),T.z,'r');
hold(h(3),'off');
irf_legend(h(3),{'T_{L} ','T_{M} ','T_{N} '},[0.01 0.1])
ylabel(h(3),{'T (mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(3),'y',[-1.1 1.1])
irf_legend(h(3),'(c)',[0.99 0.95],'color','k','fontsize',12);
irf_legend(h(3),'Anomalous viscosity',[0.95 0.10],'color','k');

h(4)=irf_panel('Vnanom');
irf_plot(h(4),Vanom);
hold(h(4),'on');
irf_plot(h(4),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(4),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
patch(h(4),[Vanomminus.time.epochUnix-ts; flip(Vanomminus.time.epochUnix-ts)],[Vanomminus.data; flip(Vanomplus.data)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(4),Vanom,'k');
hold(h(4),'off');
ylabel(h(4),{'V_{N,anom} (km s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(4),'y',[-25 25])
irf_legend(h(4),'(d)',[0.99 0.95],'color','k','fontsize',12);
irf_legend(h(4),'Anomalous flow',[0.95 0.10],'color','k');

h(5)=irf_panel('Dperp');
irf_plot(h(5),Dperp/1e9);
hold(h(5),'on');
irf_plot(h(5),[[tintX.epochUnix tintX.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
irf_plot(h(5),[[tintY.epochUnix tintY.epochUnix]' [-1e2 1e2]'],'c--','linewidth',1.5);
patch(h(5),[Dperpminus.time.epochUnix-ts; flip(Dperpminus.time.epochUnix-ts)],[Dperpminus.data/1e9; flip(Dperpplus.data/1e9)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(5),Dperp/1e9,'k');
hold(h(5),'off');
ylabel(h(5),{'D_{\perp} (10^9 m^{2} s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(5),'y',[-2.2 2.2])
irf_legend(h(5),'Diffusion coefficient',[0.95 0.10],'color','k');
irf_legend(h(5),'(e)',[0.99 0.95],'color','k','fontsize',12);

irf_plot_axis_align(h(1:4));
irf_zoom(h(1:4),'x',tint1);
irf_timeaxis(h(1:4),'nodate');
irf_zoom(h(5),'x',tint2);
irf_plot_axis_align(h(5))
irf_plot_zoomin_lines_between_panels(h(4),h(5));
c_eval('irf_pl_mark(h(?),irf_time(tint2,''epochtt>epoch'')'',[255 255 100]/255)',1:4);
set(h(1:5),'fontsize',12)
