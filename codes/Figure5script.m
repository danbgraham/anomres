%% Plot Statistics Figure

load('Figure5data.mat');

Dmax = Figure5data.Dmax;
Dmaxerror = Figure5data.Dmaxerror;
Tmax = Figure5data.Tmax;
Tmaxerror = Figure5data.Tmaxerror;
VNanom = Figure5data.VNanom;
VNanomerror = Figure5data.VNanomerror;
Dperp = Figure5data.Dperp; 
Dperperror = Figure5data.Dperperror;
Eventtype = Figure5data.Eventtype;

%%
c_eval('idx? = Eventtype == ?;',1:3);
c_eval('Dmax? = Dmax(idx?);',1:3);
c_eval('Dmaxerror? = Dmaxerror(idx?);',1:3);
c_eval('Tmax? = Tmax(idx?);',1:3);
c_eval('Tmaxerror? = Tmaxerror(idx?);',1:3);
c_eval('VNanom? = VNanom(idx?);',1:3);
c_eval('VNanomerror? = VNanomerror(idx?);',1:3);
c_eval('Dperp? = Dperp(idx?);',1:3);
c_eval('Dperperror? = Dperperror(idx?);',1:3);

c_eval('Dmax?m = Dmax?-Dmaxerror?;',1:3);
c_eval('Dmax?p = Dmax?+Dmaxerror?;',1:3);

c_eval('Tmax?m = Tmax?-Tmaxerror?;',1:3);
c_eval('Tmax?p = Tmax?+Tmaxerror?;',1:3);

c_eval('VNanom?m = VNanom?-VNanomerror?;',1:3);
c_eval('VNanom?p = VNanom?+VNanomerror?;',1:3);

c_eval('Dperp?m = Dperp?-Dperperror?;',1:3);
c_eval('Dperp?p = Dperp?+Dperperror?;',1:3);

%% Plot figure
h=irf_plot(2,'newfigure'); 
%h=irf_figure(540+ic,8);
xSize=750; ySize=300;
set(gcf,'Position',[10 10 xSize ySize]);

xwidth = 0.40;
ywidth = 0.80;
set(h(1),'position',[0.08 0.18 xwidth ywidth]);
set(h(2),'position',[0.575 0.18 xwidth ywidth]);

plot(h(1),[0 2.5],[0 2.5],'k--','linewidth',1,'HandleVisibility','off')
hold(h(1),'on')
plot(h(1),Dmax1,Tmax1,'ko','linewidth',1,'markerface','k')
c_eval('plot(h(1),[Dmax1(?) Dmax1(?)],[Tmax1m(?) Tmax1p(?)],''k'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax1))
c_eval('plot(h(1),[Dmax1m(?) Dmax1p(?)],[Tmax1(?) Tmax1(?)],''k'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax1))
plot(h(1),Dmax2,Tmax2,'ro','linewidth',1,'markerface','r')
c_eval('plot(h(1),[Dmax2(?) Dmax2(?)],[Tmax2m(?) Tmax2p(?)],''r'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax2))
c_eval('plot(h(1),[Dmax2m(?) Dmax2p(?)],[Tmax2(?) Tmax2(?)],''r'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax2))
plot(h(1),Dmax3,Tmax3,'go','linewidth',1,'markerface','g')
c_eval('plot(h(1),[Dmax3(?) Dmax3(?)],[Tmax3m(?) Tmax3p(?)],''g'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax3))
c_eval('plot(h(1),[Dmax3m(?) Dmax3p(?)],[Tmax3(?) Tmax3(?)],''g'',''linewidth'',1,''HandleVisibility'',''off'')',1:length(Dmax3))
hold(h(1),'off')
axis(h(1),[0 2 0 2])
xlabel(h(1),'|D|_{max} (mV m^{-1})','fontsize',14)
ylabel(h(1),'|T|_{max} (mV m^{-1})','fontsize',14)
irf_legend(h(1),'(a)',[0.88 0.98],'fontsize',14)
legend(h(1),{'EDR','Reconnection','No Reconnection'},'Location','NorthWest')

plot(h(2),-VNanom1,Dperp1/1e9,'ko','linewidth',1,'markerface','k')
hold(h(2),'on')
c_eval('plot(h(2),-[VNanom1(?) VNanom1(?)],[Dperp1m(?) Dperp1p(?)]/1e9,''k'',''linewidth'',1)',1:length(Dperp1))
c_eval('plot(h(2),-[VNanom1m(?) VNanom1p(?)],[Dperp1(?) Dperp1(?)]/1e9,''k'',''linewidth'',1)',1:length(Dperp1))
plot(h(2),-VNanom2,Dperp2/1e9,'ro','linewidth',1,'markerface','r')
c_eval('plot(h(2),-[VNanom2(?) VNanom2(?)],[Dperp2m(?) Dperp2p(?)]/1e9,''r'',''linewidth'',1)',1:length(Dperp2))
c_eval('plot(h(2),-[VNanom2m(?) VNanom2p(?)],[Dperp2(?) Dperp2(?)]/1e9,''r'',''linewidth'',1)',1:length(Dperp2))
plot(h(2),-VNanom3,Dperp3/1e9,'go','linewidth',1,'markerface','g')
c_eval('plot(h(2),-[VNanom3(?) VNanom3(?)],[Dperp3m(?) Dperp3p(?)]/1e9,''g'',''linewidth'',1)',1:length(Dperp3))
c_eval('plot(h(2),-[VNanom3m(?) VNanom3p(?)],[Dperp3(?) Dperp3(?)]/1e9,''g'',''linewidth'',1)',1:length(Dperp3))
hold(h(2),'off')
ylabel(h(2),'D_{\perp}(10^9 m^2 s^{-1})','fontsize',14)
xlabel(h(2),'-V_{N,anom} (km s^{-1})','fontsize',14)
irf_legend(h(2),'(b)',[0.98 0.98],'fontsize',14)
axis(h(2),[0 50 0 2.5])

set(h(1:2),'fontsize',14)