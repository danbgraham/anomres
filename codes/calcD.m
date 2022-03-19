function [D,Dplus,Dminus] = calcD(varargin)
%CALCD Summary of this function goes here
%   Detailed explanation goes here

ic = 1:4;

flf = 5;
fhf = 5;

Units = irf_units;
e = Units.e;

c_eval('E?=evalin(''base'',irf_ssub(varargin{1},?));',ic);
c_eval('ner?=evalin(''base'',irf_ssub(varargin{2},?));',ic);
c_eval('ne?=evalin(''base'',irf_ssub(varargin{3},?));',ic);
c_eval('neerr?=evalin(''base'',irf_ssub(varargin{4},?));',ic);
dt = varargin{5};

dtmean = mean(dt);

dfE = 1/median(diff(E1.time.epochUnix));
dfn = 1/median(diff(ne1.time.epochUnix));
dfnr = 1/median(diff(ner1.time.epochUnix));

c_eval('nelf? = ne?.filt(0,flf,dfn,5);',ic);
c_eval('nelf?.time = nelf?.time+[-dt(?)];',ic);
c_eval('nelf? = nelf?.resample(ner1);',ic);

neback = irf.ts_scalar(ner1.time,(nelf1.data+nelf2.data+nelf3.data+nelf4.data)/4);

c_eval('dE? = E?.filt(fhf,0,dfE,5);',ic);
c_eval('dn? = ner?.filt(fhf,0,dfnr,5);',ic);

%% Resample fluctuating components
c_eval('dE? = dE?.resample(ner?);',ic)

%% Anomalous resistivity
c_eval('D? = -dE?*dn?;',ic);
c_eval('D?.time = D?.time+[-dt(?)];',ic);
c_eval('D? = D?.resample(ner1);',ic);
D = irf.ts_vec_xyz(D1.time,(D1.data+D2.data+D3.data+D4.data)/4);
D = D.filt(0,fhf,dfnr,5);
D = D/neback;

%% Anomalous resistivity error
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

Derrorl = D.x.data.*(dneerror.data+0.1);
Derrorm = D.y.data.*(dneerror.data+0.1);
Derrorn = D.z.data.*(dneerror.data+0.1);

Dplus = irf.ts_vec_xyz(D.time,[D.x.data+Derrorl D.y.data+Derrorm D.z.data+Derrorn]);
Dminus = irf.ts_vec_xyz(D.time,[D.x.data-Derrorl D.y.data-Derrorm D.z.data-Derrorn]);


end

