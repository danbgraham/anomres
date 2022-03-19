function [ym,hpcolor,ca] = coplot(x,y,f,ay,xlab,ylab,tit,width_contour,contour_line,contour_color,number_contours)
if (nargin<8)
    width_contour=0.5;
    contour_line='w';
end

if(nargin<11)
    number_contours=20;
end
%ym=max(y(:))/2;

%hold off
fmin1=min(f(:));
fmax1=max(f(:));
hpcolor=pcolor(x,y,f);%colorbar

 set(gca,'fontsize',12)
 title(tit,'fontsize',[14])
shading interp
%colorbar('fontsize',[12])
hold on
aymin=min((ay(:)));
aymax=max((ay(:)));
fmax=max(fmax1,fmin1);
fmin=min(fmin1,fmax1);
ay2=((ay-aymin)/(aymax-aymin)*(fmax-fmin)+fmin);

%[temp_var,ym]=contour(x,y,ay2,[linspace(     fmax - 0.01*(fmax-fmin),fmax,4),linspace(     fmin,fmax,30) ],'w','LineWidth',1);
if (nargin<10)
   [temp_var,ym]=contour(x,y,ay2,number_contours,contour_line,'LineWidth',width_contour,'Color',[1 1 1]);%,contour_color);
else
   [temp_var,ym]=contour(x,y,ay2,number_contours,contour_line,'LineWidth',width_contour,'Color',contour_color);
end

    set(gca,'fontsize',14)
 xlabel(xlab,'fontsize',[14])
 ylabel(ylab,'fontsize',[14])
 ca=gca;

end