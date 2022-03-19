% Script to produce Figure 1b
load('Figure1data.mat');
rho02_Alfven_norm_slice = Figure1data.rho02_Alfven_norm_slice;
n = Figure1data.n;
Lx = Figure1data.Lx;
Ly = Figure1data.Ly;
dp = Figure1data.dp;
ay = Figure1data.ay;
xx = Figure1data.xx;
yy = Figure1data.yy;

fn=figure;

set(fn,'Position',[10 10 300 450])
h=axes('position',[0.17 0.09 0.75 0.85]);

ud=get(fn,'userdata');
ud.subplot_handles=h;
set(fn,'userdata',ud);
set(fn,'defaultLineLineWidth',2);  

h = coplot((yy-3*Ly/4)*dp/1000,(xx-Lx/2)*dp/1000,rho02_Alfven_norm_slice*n,ay,'N (km)','L (km)','test',1,'w.-',[0.5 0.5 0.5],100);
c=colorbar('ver');
colormap('parula');
ylabel(c, 'n_e (cm^{-3})')

title('Electron number density')
hold on;
p2 = [-130 -200];                         % First Point
p1 = [150 -200];                         % Second Point
dp2 = p2-p1;                         % Difference
quiver(p1(1),p1(2),dp2(1),dp2(2),0,'color','k','linewidth',2,'MaxHeadSize',0.5)
hold off;
set(gca,'XDir','reverse');
irf_legend('(b)',[0.98 0.99],'color','w','fontsize',14)
axis(gca,[-150 200 -700 600])
set(gca,'fontsize',14)
set(gcf,'color','w')