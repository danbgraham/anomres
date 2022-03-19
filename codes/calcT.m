function [T,Tplus,Tminus] = calcT(varargin)
%CALCT Summary of this function goes here
%   Detailed explanation goes here

ic = 1:4;
fhf = 5;
flf = 5;

Units = irf_units;
e = Units.e;
me = Units.me;
mi = Units.mp;
eps0 = Units.eps0;
c = Units.c;

c_eval('Elmn?=evalin(''base'',irf_ssub(varargin{1},?));',ic);
c_eval('ner?=evalin(''base'',irf_ssub(varargin{2},?));',ic);
c_eval('ne?=evalin(''base'',irf_ssub(varargin{3},?));',ic);
c_eval('neerr?=evalin(''base'',irf_ssub(varargin{4},?));',ic);
c_eval('Velmnr?=evalin(''base'',irf_ssub(varargin{5},?));',ic);
c_eval('Velmn?=evalin(''base'',irf_ssub(varargin{6},?));',ic);
c_eval('Velmnerr?=evalin(''base'',irf_ssub(varargin{7},?));',ic);
c_eval('Bscmlmn?=evalin(''base'',irf_ssub(varargin{8},?));',ic);
c_eval('Blmn?=evalin(''base'',irf_ssub(varargin{9},?));',ic);

dt = varargin{10};

dtmean = mean(dt);

dfE = 1/median(diff(Elmn1.time.epochUnix));
dfn = 1/median(diff(ne1.time.epochUnix));
dfnr = 1/median(diff(ner1.time.epochUnix));
dfB = 1/median(diff(Blmn1.time.epochUnix));

c_eval('nelf? = ne?.filt(0,flf,dfn,5);',ic);
c_eval('nelf?.time = nelf?.time+[-dt(?)];',ic);
c_eval('nelf? = nelf?.resample(ner1);',ic);

neback = irf.ts_scalar(ner1.time,(nelf1.data+nelf2.data+nelf3.data+nelf4.data)/4);

c_eval('Blmnlf? = Blmn?.filt(0,flf,dfB,5);',ic);
c_eval('Blmnlf?.time = Blmnlf?.time+[-dt(?)];',ic);
c_eval('Blmnlf? = Blmnlf?.resample(ner1);',ic);
Blmnback = irf.ts_vec_xyz(ner1.time,(Blmnlf1.data+Blmnlf2.data+Blmnlf3.data+Blmnlf4.data)/4);

c_eval('Velmnlf? = Velmn?.filt(0,flf,dfn,5);',ic);
c_eval('Velmnlf?.time = Velmnlf?.time+[-dt(?)];',ic);
c_eval('Velmnlf? = Velmnlf?.resample(ner1);',ic);
Velmnback = irf.ts_vec_xyz(ner1.time,(Velmnlf1.data+Velmnlf2.data+Velmnlf3.data+Velmnlf4.data)/4);

%%
c_eval('dB? = Bscmlmn?.filt(fhf,0,dfE,5);',ic);
c_eval('dE? = Elmn?.filt(fhf,0,dfE,5);',ic);
c_eval('dn? = ner?.filt(fhf,0,dfnr,5);',ic);
c_eval('dV? = Velmnr?.filt(fhf,0,dfnr,5);',ic);

c_eval('dB? = dB?.resample(ner?);',ic)
c_eval('dE? = dE?.resample(ner?);',ic)

%% Anomalous momentum transport
c_eval('TLa? = dV?.z*dB?.y;',ic); 
c_eval('TLa?.time = TLa?.time+[-dt(?)];',ic);
c_eval('TLa? = TLa?.resample(ner1);',ic)
TLa = irf.ts_scalar(TLa1.time,(TLa1.data+TLa2.data+TLa3.data+TLa4.data)/4000);
TLa = TLa.filt(0,fhf,dfnr,5);

c_eval('TLb? = -dV?.y*dB?.z;',ic); 
c_eval('TLb?.time = TLb?.time+[-dt(?)];',ic);
c_eval('TLb? = TLb?.resample(ner1);',ic)
TLb = irf.ts_scalar(TLb1.time,(TLb1.data+TLb2.data+TLb3.data+TLb4.data)/4000);
TLb = TLb.filt(0,fhf,dfnr,5);

c_eval('TLc? = dn?*dV?.z;',ic); 
c_eval('TLc?.time = TLc?.time+[-dt(?)];',ic);
c_eval('TLc? = TLc?.resample(ner1);',ic)
TLc = irf.ts_scalar(TLc1.time,(TLc1.data+TLc2.data+TLc3.data+TLc4.data)/4000);
TLc = TLc.filt(0,fhf,dfnr,5);
TLc = TLc*Blmnback.y/neback;

c_eval('TLd? = dn?*dB?.y;',ic); 
c_eval('TLd?.time = TLd?.time+[-dt(?)];',ic);
c_eval('TLd? = TLd?.resample(ner1);',ic)
TLd = irf.ts_scalar(TLd1.time,(TLd1.data+TLd2.data+TLd3.data+TLd4.data)/4000);
TLd = TLd.filt(0,fhf,dfnr,5);
TLd = TLd*Velmnback.z/neback;

c_eval('TLe? = -dn?*dV?.y;',ic); 
c_eval('TLe?.time = TLe?.time+[-dt(?)];',ic);
c_eval('TLe? = TLe?.resample(ner1);',ic)
TLe = irf.ts_scalar(TLe1.time,(TLe1.data+TLe2.data+TLe3.data+TLe4.data)/4000);
TLe = TLe.filt(0,fhf,dfnr,5);
TLe = TLe*Blmnback.z/neback;

c_eval('TLf? = -dn?*dB?.z;',ic); 
c_eval('TLf?.time = TLf?.time+[-dt(?)];',ic);
c_eval('TLf? = TLf?.resample(ner1);',ic)
TLf = irf.ts_scalar(TLf1.time,(TLf1.data+TLf2.data+TLf3.data+TLf4.data)/4000);
TLf = TLf.filt(0,fhf,dfnr,5);
TLf = TLf*Velmnback.y/neback;

TL = TLa.data+TLb.data+TLc.data+TLd.data+TLe.data+TLf.data;
TL = irf.ts_scalar(ner1.time,TL);

c_eval('TMa? = dV?.x*dB?.z;',ic); 
c_eval('TMa?.time = TMa?.time+[-dt(?)];',ic);
c_eval('TMa? = TMa?.resample(ner1);',ic)
TMa = irf.ts_scalar(TMa1.time,(TMa1.data+TMa2.data+TMa3.data+TMa4.data)/4000);
TMa = TMa.filt(0,fhf,dfnr,5);

c_eval('TMb? = -dV?.z*dB?.x;',ic); 
c_eval('TMb?.time = TMb?.time+[-dt(?)];',ic);
c_eval('TMb? = TMb?.resample(ner1);',ic)
TMb = irf.ts_scalar(TMb1.time,(TMb1.data+TMb2.data+TMb3.data+TMb4.data)/4000);
TMb = TMb.filt(0,fhf,dfnr,5);

c_eval('TMc? = dn?*dV?.x;',ic); 
c_eval('TMc?.time = TMc?.time+[-dt(?)];',ic);
c_eval('TMc? = TMc?.resample(ner1);',ic)
TMc = irf.ts_scalar(TMc1.time,(TMc1.data+TMc2.data+TMc3.data+TMc4.data)/4000);
TMc = TMc.filt(0,fhf,dfnr,5);
TMc = TMc*Blmnback.z/neback;

c_eval('TMd? = dn?*dB?.z;',ic); 
c_eval('TMd?.time = TMd?.time+[-dt(?)];',ic);
c_eval('TMd? = TMd?.resample(ner1);',ic)
TMd = irf.ts_scalar(TMd1.time,(TMd1.data+TMd2.data+TMd3.data+TMd4.data)/4000);
TMd = TMd.filt(0,fhf,dfnr,5);
TMd = TMd*Velmnback.x/neback;

c_eval('TMe? = -dn?*dV?.z;',ic); 
c_eval('TMe?.time = TMe?.time+[-dt(?)];',ic);
c_eval('TMe? = TMe?.resample(ner1);',ic)
TMe = irf.ts_scalar(TMe1.time,(TMe1.data+TMe2.data+TMe3.data+TMe4.data)/4000);
TMe = TMe.filt(0,fhf,dfnr,5);
TMe = TMe*Blmnback.x/neback;

c_eval('TMf? = -dn?*dB?.x;',ic); 
c_eval('TMf?.time = TMf?.time+[-dt(?)];',ic);
c_eval('TMf? = TMf?.resample(ner1);',ic)
TMf = irf.ts_scalar(TMf1.time,(TMf1.data+TMf2.data+TMf3.data+TMf4.data)/4000);
TMf = TMf.filt(0,fhf,dfnr,5);
TMf = TMf*Velmnback.z/neback;

TM = TMa.data+TMb.data+TMc.data+TMd.data+TMe.data+TMf.data;
TM = irf.ts_scalar(ner1.time,TM);

c_eval('TNa? = dV?.y*dB?.x;',ic); 
c_eval('TNa?.time = TNa?.time+[-dt(?)];',ic);
c_eval('TNa? = TNa?.resample(ner1);',ic)
TNa = irf.ts_scalar(TNa1.time,(TNa1.data+TNa2.data+TNa3.data+TNa4.data)/4000);
TNa = TNa.filt(0,fhf,dfnr,5);

c_eval('TNb? = -dV?.x*dB?.y;',ic); 
c_eval('TNb?.time = TNb?.time+[-dt(?)];',ic);
c_eval('TNb? = TNb?.resample(ner1);',ic)
TNb = irf.ts_scalar(TNb1.time,(TNb1.data+TNb2.data+TNb3.data+TNb4.data)/4000);
TNb = TNb.filt(0,fhf,dfnr,5);

c_eval('TNc? = dn?*dV?.y;',ic); 
c_eval('TNc?.time = TNc?.time+[-dt(?)];',ic);
c_eval('TNc? = TNc?.resample(ner1);',ic)
TNc = irf.ts_scalar(TNc1.time,(TNc1.data+TNc2.data+TNc3.data+TNc4.data)/4000);
TNc = TNc.filt(0,fhf,dfnr,5);
TNc = TNc*Blmnback.x/neback;

c_eval('TNd? = dn?*dB?.x;',ic); 
c_eval('TNd?.time = TNd?.time+[-dt(?)];',ic);
c_eval('TNd? = TNd?.resample(ner1);',ic)
TNd = irf.ts_scalar(TNd1.time,(TNd1.data+TNd2.data+TNd3.data+TNd4.data)/4000);
TNd = TNd.filt(0,fhf,dfnr,5);
TNd = TNd*Velmnback.y/neback;

c_eval('TNe? = -dn?*dV?.x;',ic); 
c_eval('TNe?.time = TNe?.time+[-dt(?)];',ic);
c_eval('TNe? = TNe?.resample(ner1);',ic)
TNe = irf.ts_scalar(TNe1.time,(TNe1.data+TNe2.data+TNe3.data+TNe4.data)/4000);
TNe = TNe.filt(0,fhf,dfnr,5);
TNe = TNe*Blmnback.y/neback;

c_eval('TNf? = -dn?*dB?.y;',ic); 
c_eval('TNf?.time = TNf?.time+[-dt(?)];',ic);
c_eval('TNf? = TNf?.resample(ner1);',ic)
TNf = irf.ts_scalar(TNf1.time,(TNf1.data+TNf2.data+TNf3.data+TNf4.data)/4000);
TNf = TNf.filt(0,fhf,dfnr,5);
TNf = TNf*Velmnback.x/neback;

TN = TNa.data+TNb.data+TNc.data+TNd.data+TNe.data+TNf.data;
TN = irf.ts_scalar(ner1.time,TN);

T = irf.ts_vec_xyz(TN.time,[TL.data TM.data TN.data]);

%% Anomalous momentum transport error
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
c_eval('dVHl? = imag(hilbert(dV?.x.data));',ic);
c_eval('dVHm? = imag(hilbert(dV?.y.data));',ic);
c_eval('dVHn? = imag(hilbert(dV?.z.data));',ic);

c_eval('dVenvl? = sqrt(dV?.x.data.^2 + dVHl?.^2);',ic);
c_eval('dVenvm? = sqrt(dV?.y.data.^2 + dVHm?.^2);',ic);
c_eval('dVenvn? = sqrt(dV?.z.data.^2 + dVHn?.^2);',ic);

c_eval('dVenvl? = smooth(dVenvl?,4);',ic);
c_eval('dVenvm? = smooth(dVenvm?,4);',ic);
c_eval('dVenvn? = smooth(dVenvn?,4);',ic);

c_eval('dVenvl? = irf.ts_scalar(dV?.time,dVenvl?);',ic);
c_eval('dVenvm? = irf.ts_scalar(dV?.time,dVenvm?);',ic);
c_eval('dVenvn? = irf.ts_scalar(dV?.time,dVenvn?);',ic);

c_eval('erroverdVl? = Veerr?.x.abs.resample(dVenvl?)/dVenvl?;',ic);
c_eval('erroverdVm? = Veerr?.y.abs.resample(dVenvm?)/dVenvm?;',ic);
c_eval('erroverdVn? = Veerr?.z.abs.resample(dVenvn?)/dVenvn?;',ic);

c_eval('erroverdVl?.time = erroverdVl?.time+[-dt(?)];',ic);
c_eval('erroverdVm?.time = erroverdVm?.time+[-dt(?)];',ic);
c_eval('erroverdVn?.time = erroverdVn?.time+[-dt(?)];',ic);

c_eval('erroverdVl? = erroverdVl?.resample(ner1);',ic);
c_eval('erroverdVm? = erroverdVm?.resample(ner1);',ic);
c_eval('erroverdVn? = erroverdVn?.resample(ner1);',ic);

erroverdVl = irf.ts_scalar(erroverdVl1.time,smooth(erroverdVl1.data+erroverdVl2.data+erroverdVl3.data+erroverdVl4.data,10)/4);
erroverdVm = irf.ts_scalar(erroverdVm1.time,smooth(erroverdVm1.data+erroverdVm2.data+erroverdVm3.data+erroverdVm4.data,10)/4);
erroverdVn = irf.ts_scalar(erroverdVn1.time,smooth(erroverdVn1.data+erroverdVn2.data+erroverdVn3.data+erroverdVn4.data,10)/4);

Terrorl = TLc.data.*(dneerror.data+erroverdVn.data)+TLe.data.*(dneerror.data+erroverdVm.data);
Terrorm = TMc.data.*(dneerror.data+erroverdVl.data)+TMe.data.*(dneerror.data+erroverdVn.data);
Terrorn = TNc.data.*(dneerror.data+erroverdVm.data)+TNe.data.*(dneerror.data+erroverdVl.data);

Tplus = irf.ts_vec_xyz(T.time,[T.x.data+Terrorl T.y.data+Terrorm T.z.data+Terrorn]);
Tminus = irf.ts_vec_xyz(T.time,[T.x.data-Terrorl T.y.data-Terrorm T.z.data-Terrorn]);

end

