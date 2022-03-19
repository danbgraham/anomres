function [Vanom,Vanomplus,Vanomminus,Dperp,Dperpplus,Dperpminus] = calcVn(varargin)
% [Vanom,Vanomplus,Vanomminus,Dperp,Dperpplus,Dperpminus] = calcVn('ner?','ne?','neerr?','Velmnr?','Velmnerr?','Rlmn?','Blmn?',dt);
%
% Function to calculate anomalous flows and diffusion coefficient using the 
% particle moments and magnetic field from the four MMS spacecraft. 
% Written by D. B. Graham
% 
% Input:
%     ner? - high-resolution electron number densities from the four
%       spacecraft (TSeries)
%     ne? - electron number densities from the four spacecraft (TSeries)
%     neerr? - error of the electron number densities from the four
%       spacecraft (TSeries)
%     Velmnr? - high-resolution electron bulk velocities from the four spacecraft (TSeries)
%     Velmn? - electron bulk velocities from the four spacecraft (TSeries)
%     Velmnerr? - error of the electron bulk velocities from the four spacecraft (TSeries)
%     Rlmn? - Positions of the four spacecraft (TSeries)
%     Blmn? - Magnetic field from FGM from the four spacecraft (TSeries)
%     dt - time delays between the four spacecraft (array of four numbers)
%     
% Output:
%     Vanom - anomalous flow in the normal direction (TSeries)
%     Vanomplus - Vanom + error in Vanom (TSeries)
%     Vanomminus - Vanom - error in Vanom (TSeries)
%     Dperp - anomalous cross-field diffusion coefficient (TSeries)
%     Dperpplus - Dperp + error in Dperp (TSeries)
%     Dperpminus - Dperp - error in Dperp (TSeries)

% ----------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <dgraham@irfu.se> wrote this file.  As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return.   
% Daniel B. Graham
% ----------------------------------------------------------------------------

ic = 1:4;
fhf = 5;
flf = 5;

c_eval('ner?=evalin(''base'',irf_ssub(varargin{1},?));',ic);
c_eval('ne?=evalin(''base'',irf_ssub(varargin{2},?));',ic);
c_eval('neerr?=evalin(''base'',irf_ssub(varargin{3},?));',ic);
c_eval('Velmnr?=evalin(''base'',irf_ssub(varargin{4},?));',ic);
c_eval('Velmnerr?=evalin(''base'',irf_ssub(varargin{5},?));',ic);
c_eval('Rlmn?=evalin(''base'',irf_ssub(varargin{6},?));',ic);
c_eval('Blmn?=evalin(''base'',irf_ssub(varargin{7},?));',ic);

dt = varargin{8};

c_eval('[Vpar?,Vperp?]=irf_dec_parperp(Blmn?,Velmnr?);',ic);
dtmean = mean(dt);
%%

dfn = 1/median(diff(ne1.time.epochUnix));
dfnr = 1/median(diff(ner1.time.epochUnix));

c_eval('nelf? = ne?.filt(0,flf,dfn,5);',ic);
c_eval('nelf?.time = nelf?.time+[-dt(?)];',ic);
c_eval('nelf? = nelf?.resample(ner1);',ic);

neback = irf.ts_scalar(ner1.time,(nelf1.data+nelf2.data+nelf3.data+nelf4.data)/4);

c_eval('dn? = ner?.filt(fhf,0,dfnr,5);',ic);
c_eval('dV? = Vperp?.filt(fhf,0,dfnr,5);',ic);

%% Compute gradient terms
gradnelmn = c_4_grad('Rlmn?','ne?.filt(0,flf,dfn,5);','grad');
gradnelmn.time = gradnelmn.time+[-dtmean];

c_eval('dndV? = dn?*dV?.z;',ic)
c_eval('dndV?.time = dndV?.time+[-dt(?)];',ic)
c_eval('dndV? = dndV?.resample(ner1);',ic)
dndV = irf.ts_scalar(dndV1.time,(dndV1.data+dndV2.data+dndV3.data+dndV4.data)/4);
dndV = dndV.filt(0,fhf,dfnr,5);
Vanom = dndV/neback;

gradnormal = irf.ts_scalar(gradnelmn.time,gradnelmn.z.data);
gradn = gradnormal.resample(dndV);
Dperp = -dndV/gradn*1e6;
Dperp.data(gradn.abs.data < 2e-3) = NaN;

%% Calculate errors
c_eval('neerr? = neerr?*4;',ic);
c_eval('dnH? = imag(hilbert(dn?.data));',ic);
c_eval('dnenv? = sqrt(dn?.data.^2 + dnH?.^2);',ic);
c_eval('dnenv? = smooth(dnenv?,4);',ic);
c_eval('dnenv? = irf.ts_scalar(dn?.time,dnenv?);',ic);
c_eval('dnH? = irf.ts_scalar(dn?.time,dnH?);',ic);
c_eval('erroverdn? = neerr?.resample(dnenv?)/dnenv?;',ic);

c_eval('erroverdn?.time = erroverdn?.time+[-dt(?)];',ic);
c_eval('erroverdn? = erroverdn?.resample(ner1);',ic);
dneerror = irf.ts_scalar(erroverdn1.time,smooth(erroverdn1.data+erroverdn2.data+erroverdn3.data+erroverdn4.data,10)/4);

c_eval('Veerr? = Velmnerr?*4;',ic);
c_eval('dVHn? = imag(hilbert(dV?.z.data));',ic);
c_eval('dVenvn? = sqrt(dV?.z.data.^2 + dVHn?.^2);',ic);
c_eval('dVenvn? = smooth(dVenvn?,4);',ic);
c_eval('dVenvn? = irf.ts_scalar(dV?.time,dVenvn?);',ic);
c_eval('erroverdVn? = Veerr?.z.abs.resample(dVenvn?)/dVenvn?;',ic);
c_eval('erroverdVn?.time = erroverdVn?.time+[-dt(?)];',ic);
c_eval('erroverdVn? = erroverdVn?.resample(ner1);',ic);
erroverdVn = irf.ts_scalar(erroverdVn1.time,smooth(erroverdVn1.data+erroverdVn2.data+erroverdVn3.data+erroverdVn4.data,10)/4);

Vanomerror = Vanom.data.*(dneerror.data+erroverdVn.data);
Dperperror = Dperp.data.*(dneerror.data+erroverdVn.data);

Vanomplus = irf.ts_scalar(Vanom.time,Vanom.data+Vanomerror);
Vanomminus = irf.ts_scalar(Vanom.time,Vanom.data-Vanomerror);

Dperpplus = irf.ts_scalar(Dperp.time,Dperp.data+Dperperror);
Dperpminus = irf.ts_scalar(Dperp.time,Dperp.data-Dperperror);

end

