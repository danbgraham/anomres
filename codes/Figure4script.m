%% Script to plot Figure 4
% Written by D. B. Graham

ic = 1:4;

%% Load and analyse 2015 Dec 02 data
Lveca = [0.1302   -0.4846    0.8650];
Mveca = [-0.4756  -0.7961    -0.3744];
Nveca = [0.8701   -0.3626    -0.3341];

dta = [0.0000   -0.6241   -1.0297   -1.0599];

tinta = irf.tint('2015-12-02T01:14:45.0Z/2015-12-02T01:15:04.0Z');

load('Figure4data20151202.mat');

c_eval('Exyza? = Figure4data20151202.Exyz?',ic);
c_eval('nea? = Figure4data20151202.ne?',ic);
c_eval('Vea? = Figure4data20151202.Ve?',ic);
c_eval('nera? = Figure4data20151202.ner?',ic);
c_eval('Vera? = Figure4data20151202.Ver?',ic);
c_eval('Veerra? = Figure4data20151202.Veerr?',ic);
c_eval('neerra? = Figure4data20151202.neerr?',ic);
c_eval('Bxyza? = Figure4data20151202.Bxyz?',ic);
c_eval('Bscma? = Figure4data20151202.Bscm?',ic);
c_eval('Rxyza? = Figure4data20151202.Rxyz?',ic);

c_eval('Elmna? = irf_newxyz(Exyza?,Lveca,Mveca,Nveca);',ic);
c_eval('Bscmlmna? = irf_newxyz(Bscma?,Lveca,Mveca,Nveca);',ic);
c_eval('Velmnra? = irf_newxyz(Vera?,Lveca,Mveca,Nveca);',ic);
c_eval('Velmna? = irf_newxyz(Vea?,Lveca,Mveca,Nveca);',ic);
c_eval('Velmnerra? = irf_newxyz(Veerra?,Lveca,Mveca,Nveca);',ic);
c_eval('Blmna? = irf_newxyz(Bxyza?,Lveca,Mveca,Nveca);',ic);
c_eval('Rlmna? = irf_newxyz(Rxyza?,Lveca,Mveca,Nveca);',ic);

[Da,Dplusa,Dminusa] = calcD('Elmna?','nera?','nea?','neerra?',dta);
[Ta,Tplusa,Tminusa] = calcT('Elmna?','nera?','nea?','neerra?','Velmnra?','Velmna?','Velmnerra?','Bscmlmna?','Blmna?',dta);
[Vanoma,Vanomplusa,Vanomminusa,Dperpa,Dperpplusa,Dperpminusa] = calcVn('nera?','nea?','neerra?','Velmnra?','Velmnerra?','Rlmna?','Blmna?',dta);

%% Load and analyse 2015 Dec 14 data
Lvecb = [0.0169   -0.5167    0.8560];
Mvecb = [-0.5071  -0.7422    -0.4381];
Nvecb = [0.8617   -0.4267    -0.2746];

dtb = [0.0000    0.4095    0.3315    0.4654];

tintb = irf.tint('2015-12-14T01:17:37.0Z/2015-12-14T01:17:43.0Z');

load('Figure4data20151214.mat');

c_eval('Exyzb? = Figure4data20151214.Exyz?',ic);
c_eval('neb? = Figure4data20151214.ne?',ic);
c_eval('Veb? = Figure4data20151214.Ve?',ic);
c_eval('nerb? = Figure4data20151214.ner?',ic);
c_eval('Verb? = Figure4data20151214.Ver?',ic);
c_eval('Veerrb? = Figure4data20151214.Veerr?',ic);
c_eval('neerrb? = Figure4data20151214.neerr?',ic);
c_eval('Bxyzb? = Figure4data20151214.Bxyz?',ic);
c_eval('Bscmb? = Figure4data20151214.Bscm?',ic);
c_eval('Rxyzb? = Figure4data20151214.Rxyz?',ic);

c_eval('Elmnb? = irf_newxyz(Exyzb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Bscmlmnb? = irf_newxyz(Bscmb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Velmnrb? = irf_newxyz(Verb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Velmnb? = irf_newxyz(Veb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Velmnerrb? = irf_newxyz(Veerrb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Blmnb? = irf_newxyz(Bxyzb?,Lvecb,Mvecb,Nvecb);',ic);
c_eval('Rlmnb? = irf_newxyz(Rxyzb?,Lvecb,Mvecb,Nvecb);',ic);

[Db,Dplusb,Dminusb] = calcD('Elmnb?','nerb?','neb?','neerrb?',dtb);
[Tb,Tplusb,Tminusb] = calcT('Elmnb?','nerb?','neb?','neerrb?','Velmnrb?','Velmnb?','Velmnerrb?','Bscmlmnb?','Blmnb?',dtb);
[Vanomb,Vanomplusb,Vanomminusb,Dperpb,Dperpplusb,Dperpminusb] = calcVn('nerb?','neb?','neerrb?','Velmnrb?','Velmnerrb?','Rlmnb?','Blmnb?',dtb);

%% Plot Figure

h=irf_plot(8,'newfigure'); 
%h=irf_figure(540+ic,8);
xSize=600; ySize=700;
set(gcf,'Position',[10 10 xSize ySize]);

xwidth = 0.865;
ywidth = 0.102;
yst = 0.12;
set(h(1),'position',[yst 0.99-ywidth xwidth ywidth]);
set(h(2),'position',[yst 0.99-2*ywidth xwidth ywidth]);
set(h(3),'position',[yst 0.99-3*ywidth xwidth ywidth]);
set(h(4),'position',[yst 0.96-4*ywidth xwidth ywidth]);
set(h(5),'position',[yst 0.90-5*ywidth xwidth ywidth]);
set(h(6),'position',[yst 0.90-6*ywidth xwidth ywidth]);
set(h(7),'position',[yst 0.90-7*ywidth xwidth ywidth]);
set(h(8),'position',[yst 0.87-8*ywidth xwidth ywidth]);

tint1a = irf.tint('2015-12-02T01:14:46.0Z/2015-12-02T01:15:03.0Z');
tint2a = irf.tint('2015-12-02T01:14:48.5Z/2015-12-02T01:14:56.5Z');

tintXa = irf_time('2015-12-02T01:14:58.270Z','utc>epochtt');
c_eval('irf_pl_mark(h(?),irf_time(tint2a,''epochtt>epoch'')'',[255 255 100]/255)',1:3);

h(1)=irf_panel('Elmna');
irf_plot(h(1),Elmna1);
irf_zoom(h(1),'y',[-80 80]);
hold(h(1),'on');
irf_plot(h(1),[[tintXa.epochUnix tintXa.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
hold(h(1),'off');
ylabel(h(1),{'E','(mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(1),{'E_L ','E_M ','E_N '},[0.01 0.15])
irf_legend(h(1),{'MMS1'},[0.01 0.95])
irf_legend(h(1),'(a)',[0.99 0.95],'color','k','fontsize',12);

ts = double((Dminusa.time(1).epochUnix));
h(2)=irf_panel('DTa');
irf_plot(h(2),Da.y);
hold(h(2),'on');
irf_plot(h(2),Ta.y,'r');
irf_plot(h(2),[[tintXa.epochUnix tintXa.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(2),[Dminusa.time.epochUnix-ts; flip(Dminusa.time.epochUnix-ts)],[Dminusa.y.data; flip(Dplusa.y.data)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(2),Da.y,'k');
patch(h(2),[Tminusa.time.epochUnix-ts; flip(Tminusa.time.epochUnix-ts)],[Tminusa.y.data; flip(Tplusa.y.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(2),Ta.y,'r');
hold(h(2),'off');
ylabel(h(2),{'D, T','(mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(2),{'D_M'},[0.01 0.15])
irf_legend(h(2),{'T_M'},[0.06 0.15],'color','r')
irf_zoom(h(2),'y',[-0.6 0.6])
irf_legend(h(2),'(b)',[0.99 0.95],'color','k','fontsize',12);

h(3)=irf_panel('Vnanoma');
irf_plot(h(3),Vanoma);
hold(h(3),'on');
irf_plot(h(3),[[tintXa.epochUnix tintXa.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(3),[Vanomminusa.time.epochUnix-ts; flip(Vanomminusa.time.epochUnix-ts)],[Vanomminusa.data; flip(Vanomplusa.data)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(3),Vanoma,'k');
hold(h(3),'off');
ylabel(h(3),{'V_{N,anom}','(km s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(3),'y',[-15 15])
irf_legend(h(3),'(c)',[0.99 0.95],'color','k','fontsize',12);

tint3a = tint2a+[-0.01 0.01];
Dperpa = Dperpa.tlim(tint3a);
Dperpminusa = Dperpminusa.tlim(tint3a);
Dperpplusa = Dperpplusa.tlim(tint3a);


h(4)=irf_panel('Dperpa');
irf_plot(h(4),Dperpa/1e9);
hold(h(4),'on');
irf_plot(h(4),[[tintXa.epochUnix tintXa.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(4),[Dperpminusa.time.epochUnix-ts; flip(Dperpminusa.time.epochUnix-ts)],[Dperpminusa.data/1e9; flip(Dperpplusa.data/1e9)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(4),Dperpa/1e9,'k');
hold(h(4),'off');
ylabel(h(4),{'D_{\perp}','(10^9 m^{2} s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(4),'y',[-1 1])
irf_legend(h(4),'(d)',[0.99 0.95],'color','k','fontsize',12);

irf_plot_axis_align(h(1:3));
irf_zoom(h(1:3),'x',tint1a);
irf_timeaxis(h(1:3),'nodate');
irf_zoom(h(4),'x',tint2a);
irf_plot_axis_align(h(4))
irf_plot_zoomin_lines_between_panels(h(3),h(4));
c_eval('irf_pl_mark(h(?),irf_time(tint2a,''epochtt>epoch'')'',[255 255 100]/255)',1:3);

tint1b = irf.tint('2015-12-14T01:17:38.5Z/2015-12-14T01:17:42.0Z');
tint2b = irf.tint('2015-12-14T01:17:39.8Z/2015-12-14T01:17:41.2Z');
tintXb = irf_time('2015-12-14T01:17:39.65Z','utc>epochtt');
c_eval('irf_pl_mark(h(?),irf_time(tint2b,''epochtt>epoch'')'',[255 255 100]/255)',5:7);

Elmnb3.time = Elmnb3.time+(-dtb(3));
h(5)=irf_panel('Elmnb');
irf_plot(h(5),Elmnb3);
irf_zoom(h(5),'y',[-60 60]);
hold(h(5),'on');
irf_plot(h(5),[[tintXb.epochUnix tintXb.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
hold(h(5),'off');
ylabel(h(5),{'E','(mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(5),{'E_L ','E_M ','E_N '},[0.01 0.15])
irf_legend(h(5),{'MMS3'},[0.01 0.95])
irf_legend(h(5),'(e)',[0.99 0.95],'color','k','fontsize',12);

h(6)=irf_panel('DTb');
irf_plot(h(6),Db.y);
hold(h(6),'on');
irf_plot(h(6),Tb.y,'r');
irf_plot(h(6),[[tintXb.epochUnix tintXb.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(6),[Dminusb.time.epochUnix-ts; flip(Dminusb.time.epochUnix-ts)],[Dminusb.y.data; flip(Dplusb.y.data)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(6),Db.y,'k');
patch(h(6),[Tminusb.time.epochUnix-ts; flip(Tminusb.time.epochUnix-ts)],[Tminusb.y.data; flip(Tplusb.y.data)],[1 0.7 0.7],'edgecolor','none')
irf_plot(h(6),Tb.y,'r');
hold(h(6),'off');
ylabel(h(6),{'D, T','(mV m^{-1})'},'Interpreter','tex','fontsize',12);
irf_legend(h(6),{'D_M'},[0.01 0.15])
irf_legend(h(6),{'T_M'},[0.06 0.15],'color','r')
irf_zoom(h(6),'y',[-0.7 0.7])
irf_legend(h(6),'(f)',[0.99 0.95],'color','k','fontsize',12);

h(7)=irf_panel('Vnanomb');
irf_plot(h(7),Vanomb);
hold(h(7),'on');
irf_plot(h(7),[[tintXb.epochUnix tintXb.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(7),[Vanomminusb.time.epochUnix-ts; flip(Vanomminusb.time.epochUnix-ts)],[Vanomminusb.data; flip(Vanomplusb.data)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(7),Vanomb,'k');
hold(h(7),'off');
ylabel(h(7),{'V_{N,anom}','(km s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(7),'y',[-50 50])
irf_legend(h(7),'(g)',[0.99 0.95],'color','k','fontsize',12);

tint3b = tint2b+[-0.01 0.01];
Dperpb = Dperpb.tlim(tint3b);
Dperpminusb = Dperpminusb.tlim(tint3b);
Dperpplusb = Dperpplusb.tlim(tint3b);

h(8)=irf_panel('Dperpb');
irf_plot(h(8),Dperpb/1e9);
hold(h(8),'on');
irf_plot(h(8),[[tintXb.epochUnix tintXb.epochUnix]' [-1e2 1e2]'],'m--','linewidth',1.5);
patch(h(8),[Dperpminusb.time.epochUnix-ts; flip(Dperpminusb.time.epochUnix-ts)],[Dperpminusb.data/1e9; flip(Dperpplusb.data/1e9)],[0.8 0.8 0.8],'edgecolor','none')
irf_plot(h(8),Dperpb/1e9,'k');
hold(h(8),'off');
ylabel(h(8),{'D_{\perp}','(10^9 m^{2} s^{-1})'},'Interpreter','tex','fontsize',12);
irf_zoom(h(8),'y',[-2 2])
irf_legend(h(8),'(h)',[0.99 0.95],'color','k','fontsize',12);

irf_plot_axis_align(h(5:7));
irf_zoom(h(5:7),'x',tint1b);
irf_timeaxis(h(5:7),'nodate');
irf_zoom(h(8),'x',tint2b);
irf_plot_axis_align(h(8))
%irf_timeaxis(h(5),'nodate');
irf_plot_zoomin_lines_between_panels(h(7),h(8));
c_eval('irf_pl_mark(h(?),irf_time(tint2b,''epochtt>epoch'')'',[255 255 100]/255)',5:7);
set(h(1:8),'fontsize',12)
