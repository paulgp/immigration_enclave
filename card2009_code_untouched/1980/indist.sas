*indist follows np2.sas ;

options ls=120 nocenter;
libname c90 '/var/tmp/card/';
libname here '.'; 


data one;
set c90.np80 (keep=rmsa ind wt imm female);

mfg=(100<=ind<=392);

proc freq;
tables mfg*imm mfg*female female*mfg*imm;
weight wt;


proc summary;
class rmsa;
var mfg;
output out=here.mfg
mean=;
weight wt;


proc print data=here.mfg;
var rmsa mfg;
