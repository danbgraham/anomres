function [I1,I1plus,I1minus,I2,I2plus,I2minus,IdVMdVN,IdVMdVNp,IdVMdVNm,IdndVN,IdndVNp,IdndVNm,Itot1,Itot1p,Itot1m] = calcI(varargin)
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
c_eval('Blmn?=evalin(''base'',irf_ssub(varargin{8},?));',ic);

dt = varargin{9};
vt = varargin{10};

c_eval('[Vpar?,Vperp?]=irf_dec_parperp(Blmn?,Velmnr?);',ic);

c_eval('neplus?=ne?+neerr?;',ic);
c_eval('neminus?=ne?+-neerr?;',ic);

c_eval('Velmnplus?=Velmn?+Velmnerr?;',ic);
c_eval('Velmnminus?=Velmn?+-Velmnerr?;',ic);

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
c_eval('dE? = Elmn?.filt(fhf,0,dfE,5);',ic);
c_eval('dn? = ner?.filt(fhf,0,dfnr,5);',ic);
c_eval('dV? = Vperp?.filt(fhf,0,dfnr,5);',ic);

c_eval('dE? = dE?.resample(ner?);',ic)

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
c_eval('dVHm? = imag(hilbert(dV?.y.data));',ic);
c_eval('dVHn? = imag(hilbert(dV?.z.data));',ic);

c_eval('dVenvm? = sqrt(dV?.y.data.^2 + dVHm?.^2);',ic);
c_eval('dVenvn? = sqrt(dV?.z.data.^2 + dVHn?.^2);',ic);

c_eval('dVenvm? = smooth(dVenvm?,4);',ic);
c_eval('dVenvn? = smooth(dVenvn?,4);',ic);

c_eval('dVenvm? = irf.ts_scalar(dV?.time,dVenvm?);',ic);
c_eval('dVenvn? = irf.ts_scalar(dV?.time,dVenvn?);',ic);

c_eval('erroverdVm? = Veerr?.y.abs.resample(dVenvm?)/dVenvm?;',ic);
c_eval('erroverdVn? = Veerr?.z.abs.resample(dVenvn?)/dVenvn?;',ic);

c_eval('erroverdVm?.time = erroverdVm?.time+[-dt(?)];',ic);
c_eval('erroverdVn?.time = erroverdVn?.time+[-dt(?)];',ic);

c_eval('erroverdVm? = erroverdVm?.resample(ner1);',ic);
c_eval('erroverdVn? = erroverdVn?.resample(ner1);',ic);

erroverdVm = irf.ts_scalar(erroverdVm1.time,smooth(erroverdVm1.data+erroverdVm2.data+erroverdVm3.data+erroverdVm4.data,10)/4);
erroverdVn = irf.ts_scalar(erroverdVn1.time,smooth(erroverdVn1.data+erroverdVn2.data+erroverdVn3.data+erroverdVn4.data,10)/4);

%% Calculate Vn
c_eval('dndV? = dn?*dV?.z;',ic)
c_eval('dndV?.time = dndV?.time+[-dt(?)];',ic)
c_eval('dndV? = dndV?.resample(ner1);',ic)
dndV = irf.ts_scalar(dndV1.time,(dndV1.data+dndV2.data+dndV3.data+dndV4.data)/4);
dndV = dndV.filt(0,fhf,dfnr,5);
Vanom = dndV/neback;

%% Calculate I 
c_eval('I? = dV?.y*dV?.z*1e6;',ic)
c_eval('I?.time = I?.time+[-dt(?)];',ic)
c_eval('I? = I?.resample(ner1);',ic)
IdVMdVN = irf.ts_scalar(I1.time,(I1.data+I2.data+I3.data+I4.data)/4);
IdVMdVN = IdVMdVN.filt(0,5,dfnr,5);
IdVMdVN = IdVMdVN*neback*1e6;

IdVMdVNerror = IdVMdVN.data.*(erroverdVm.data + erroverdVn.data);
IdVMdVNp = irf.ts_scalar(IdVMdVN.time,IdVMdVN.data+IdVMdVNerror);
IdVMdVNm = irf.ts_scalar(IdVMdVN.time,IdVMdVN.data-IdVMdVNerror);

c_eval('I? = dn?*dV?.z*1e9;',ic)
c_eval('I?.time = I?.time+[-dt(?)];',ic)
c_eval('I? = I?.resample(ner1);',ic)
IdndVN = irf.ts_scalar(I1.time,(I1.data+I2.data+I3.data+I4.data)/4);
IdndVN = IdndVN.filt(0,5,dfnr,5);
IdndVN = IdndVN*Velmnback.y*1e3;

IdndVNerror = IdndVN.data.*(erroverdVn.data + dneerror.data);
IdndVNp = irf.ts_scalar(IdndVN.time,IdndVN.data+IdndVNerror);
IdndVNm = irf.ts_scalar(IdndVN.time,IdndVN.data-IdndVNerror);

Itot2 = irf.ts_scalar(IdVMdVN.time,IdVMdVN.data+IdndVN.data);
Itot1 = irf.ts_scalar(IdVMdVN.time,IdVMdVN.data+IdndVN.data);

Itot2 = Itot2.filt(0,1,dfnr,5);

Itot1error = IdVMdVNerror + IdndVNerror;
Itot1p = irf.ts_scalar(Itot1.time,Itot1.data+Itot1error);
Itot1m = irf.ts_scalar(Itot1.time,Itot1.data-Itot1error);

% Take gradients
dN = -norm(vt)*1/dfnr*1e3;
diffI1 = diff(Itot1.data);
diffI2 = diff(Itot2.data);
timediff = Itot1.time(1:end-1)+1/(2*dfnr);
nebackre = neback.resample(timediff);

EI1 = me./(e*nebackre.data*1e6).*diffI1/dN*1e3;
EI2 = me./(e*nebackre.data*1e6).*diffI2/dN*1e3;

I1 = irf.ts_scalar(timediff,EI1);
I2 = irf.ts_scalar(timediff,EI2);

I1error = I1.data.*(erroverdVm.resample(I1).data+erroverdVn.resample(I1).data);
I2error = I2.data.*(erroverdVm.resample(I2).data+erroverdVn.resample(I2).data);

I1plus = irf.ts_scalar(I1.time,I1.data+I1error);
I1minus = irf.ts_scalar(I1.time,I1.data-I1error);

I2plus = irf.ts_scalar(I2.time,I2.data+I2error);
I2minus = irf.ts_scalar(I2.time,I2.data-I2error);

end

