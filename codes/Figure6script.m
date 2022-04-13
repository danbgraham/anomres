%% Script to plot Figure 6
% Written by D. B. Graham

% load data for figure. Same data used as Figure 3
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
dtmean = mean(dt);
vt = 35.8 * [0.85 -0.40 -0.34];
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
[I1,I1plus,I1minus,I2,I2plus,I2minus,IdVMdVN,IdVMdVNp,IdVMdVNm,IdndVN,IdndVNp,IdndVNm,Itot1,Itot1p,Itot1m] = calcI('Elmn?','ner?','ne?','neerr?','Velmnr?','Velmn?','Velmnerr?','Blmn?',dt,vt);
[Vanom,Vanomplus,Vanomminus,Dperp,Dperpplus,Dperpminus] = calcVn('ner?','ne?','neerr?','Velmnr?','Velmnerr?','Rxyz?','Blmn?',dt);

%%
tint1 = irf.tint('2015-12-06T23:38:28.0Z/2015-12-06T23:38:35.0Z');
Elmn1 = Elmn1.tlim(tint1);
IdVMdVN = IdVMdVN.tlim(tint1);
IdVMdVNm = IdVMdVNm.tlim(tint1);
IdVMdVNp = IdVMdVNp.tlim(tint1);
IdndVN = IdndVN.tlim(tint1);
IdndVNm = IdndVNm.tlim(tint1);
IdndVNp = IdndVNp.tlim(tint1);
Itot1 = Itot1.tlim(tint1);
Itot1p = Itot1p.tlim(tint1);
Itot1m = Itot1m.tlim(tint1);

I1 = I1.tlim(tint1);
I2 = I2.tlim(tint1);

I1plus = I1plus.tlim(tint1);
I2plus = I2plus.tlim(tint1);
I1minus = I1minus.tlim(tint1);
I2minus = I2minus.tlim(tint1);

D = D.tlim(tint1);
Dplus = Dplus.tlim(tint1);
Dminus = Dminus.tlim(tint1);
T = T.tlim(tint1);
Tplus = Tplus.tlim(tint1);
Tminus = Tminus.tlim(tint1);

ts = double((D.time(1).epochUnix));

h=irf_plot(4,'newfigure'); 
%h=irf_figure(540+ic,8);
xSize=900; ySize=700;
set(gcf,'Position',[10 10 xSize ySize]);

xwidth = 0.88;
ywidth = 0.23;
yst = 0.08;
set(h(1),'position',[yst 0.99-ywidth xwidth ywidth]);
set(h(2),'position',[yst 0.99-2*ywidth xwidth ywidth]);
set(h(3),'position',[yst 0.99-3*ywidth xwidth ywidth]);
set(h(4),'position',[yst 0.99-4*ywidth xwidth ywidth]);

h(1)=irf_panel('Elmn');
irf_plot(h(1),Elmn1);
ylabel(h(1),{'E (mV m^{-1})'},'Interpreter','tex','fontsize',18);
irf_legend(h(1),{'E_L ','E_M ','E_N '},[0.2 0.9],'fontsize',18)
irf_legend(h(1),{'MMS1'},[0.01 0.95],'fontsize',18)
irf_legend(h(1),'(a)',[0.99 0.95],'color','k','fontsize',18);
irf_legend(h(1),'Lower hybrid waves',[0.95 0.10],'color','k','fontsize',18);

h(2)=irf_panel('Iterms');
irf_plot(h(2),IdVMdVN*1e-17);
hold(h(2),'on')
patch(h(2),[IdVMdVNm.time.epochUnix-ts; flip(IdVMdVNm.time.epochUnix-ts)],[IdVMdVNm.data*1e-17; flip(IdVMdVNp.data*1e-17)],[0.8 0.8 0.8],'edgecolor','none')
patch(h(2),[IdndVNm.time.epochUnix-ts; flip(IdndVNm.time.epochUnix-ts)],[IdndVNm.data*1e-17; flip(IdndVNp.data*1e-17)],[0.7 0.7 1],'edgecolor','none')
patch(h(2),[Itot1m.time.epochUnix-ts; flip(Itot1m.time.epochUnix-ts)],[Itot1m.data*1e-17; flip(Itot1p.data*1e-17)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(2),IdVMdVN*1e-17,'k');
irf_plot(h(2),IdndVN*1e-17,'b');
irf_plot(h(2),Itot1*1e-17,'r');
hold(h(2),'off')
irf_zoom(h(2),'y',[-5.5 4.5])
ylabel(h(2),{'\Gamma (10^{17} m^{-1} s^{-2})'},'Interpreter','tex','fontsize',18);
irf_legend(h(2),'(b)',[0.99 0.95],'color','k','fontsize',18);
irf_legend(h(2),{'<n_e><\deltaV_{e,M} \deltaV_{e,N}>  '...
  '<V_{e,M}><\deltan_{e} \deltaV_{e,N}> ','\Gamma'},[0.01 0.10],'fontsize',18);

h(3)=irf_panel('EI');
irf_plot(h(3),I1,'k');
hold(h(3),'on')
patch(h(3),[I1plus.time.epochUnix-ts; flip(I1plus.time.epochUnix-ts)],[I1minus.data; flip(I1plus.data)],[0.8 0.8 0.8],'edgecolor','none')
patch(h(3),[I2plus.time.epochUnix-ts; flip(I2plus.time.epochUnix-ts)],[I2minus.data; flip(I2plus.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(3),I1,'k');
irf_plot(h(3),I2,'r');
hold(h(3),'off')
irf_zoom(h(3),'y',[-0.19 0.19])
ylabel(h(3),{'I_M (mV m^{-1})'},'Interpreter','tex','fontsize',18);
irf_legend(h(3),{'I_M: f < 5Hz',' ','I_M: f < 1Hz'},[0.05 0.9],'fontsize',18)
irf_legend(h(3),'(c)',[0.99 0.95],'color','k','fontsize',18);

h(4)=irf_panel('Anomterms');
irf_plot(h(4),D.y);
hold(h(4),'on');
patch(h(4),[Dminus.time.epochUnix-ts; flip(Dminus.time.epochUnix-ts)],[Dminus.y.data; flip(Dplus.y.data)],[0.8 0.8 0.8],'edgecolor','none')
patch(h(4),[Tminus.time.epochUnix-ts; flip(Tminus.time.epochUnix-ts)],[Tminus.y.data; flip(Tplus.y.data)],[0.7 0.7 1],'edgecolor','none')
patch(h(4),[I1minus.time.epochUnix-ts; flip(I1minus.time.epochUnix-ts)],[I1minus.data; flip(I1plus.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(4),D.y,'k');
irf_plot(h(4),T.y,'b');
irf_plot(h(4),I1,'r');
hold(h(4),'off')
irf_zoom(h(4),'y',[-1.1 1.1])
ylabel(h(4),{'D, T, I (mV m^{-1})'},'Interpreter','tex','fontsize',18);
irf_legend(h(4),'(d)',[0.99 0.95],'color','k','fontsize',18);
irf_legend(h(4),{'D_M ','T_M ','I_M: f<5Hz'},[0.05 0.10],'fontsize',18);
set(h(1:4),'fontsize',16)

irf_plot_axis_align(h(1:4));
irf_zoom(h(1:4),'x',tint1);
