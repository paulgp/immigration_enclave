clear
clear matrix
capture log close
set mem 2g
set more off
cd "/Users/victoriadequadros/projects/immigration_enclave/"

use data/2000/supp2000.dta 

keep if imm == 1

gen new = (yrsinus < 20)

gen rczone0 = (rczone==0)
gen rczone1 = (rczone==1)
gen male = 1 - female
gen native = 1 - imm

gen xclass2 = 1 if exp <= 10
replace xclass2 = 2 if 10 <= exp & exp <= 20
replace xclass2 = 3 if 20 <= exp & exp <= 30
replace xclass2 = 4 if xclass2 != 1 | xclass2 != 2 | xclass2 != 3

replace c = 1

gen havewage2 = 1 if logwage2 != .
gen cwagesal = incwage
replace cwagesal = . if incwage <= 0

gen cannhrs = . 
replace cannhrs = annhrs if annhrs > 0

gen hs = 1 - dropout - somecoll - collplus
gen college = 0
replace college = 1 if collplus == 1 & advanced == 0
gen x1 = (xclass2 == 1)
gen x2 = (xclass2 == 2)
gen x3 = (xclass2 == 3)
gen x4 = (xclass2 == 4)

gen hrswkly = .
replace hrswkly = annhrs / wkswork1 if annhrs > 0

gen ft = (hrswkly >= 35)

gen q1 = p1 + p2
gen q2 = p3 + p4
gen q3 = p5 + p6
gen q4 = p7 + p8
gen q5 = p9 + p10

gen q1c = .
gen q2c = .
gen q3c = .
gen q4c = .
gen q5c = .
replace q1c = q1 if logwage2 != .
replace q2c = q2 if logwage2 != .
replace q3c = q3 if logwage2 != .
replace q4c = q4 if logwage2 != .
replace q5c = q5 if logwage2 != .


gen ex11 = (eclass==1)*(xclass2==1)
gen ex12 = (eclass==1)*(xclass2==2)
gen ex13 = (eclass==1)*(xclass2==3)
gen ex14 = (eclass==1)*(xclass2==4)
gen ex21 = (eclass==2)*(xclass2==1)
gen ex22 = (eclass==2)*(xclass2==2)
gen ex23 = (eclass==2)*(xclass2==3)
gen ex24 = (eclass==2)*(xclass2==4)
gen ex31 = (eclass==3)*(xclass2==1)
gen ex32 = (eclass==3)*(xclass2==2)
gen ex33 = (eclass==3)*(xclass2==3)
gen ex34 = (eclass==3)*(xclass2==4)
gen ex41 = (eclass==4)*(xclass2==1)
gen ex42 = (eclass==4)*(xclass2==2)
gen ex43 = (eclass==4)*(xclass2==3)
gen ex44 = (eclass==4)*(xclass2==4)

forvalues i=1/38{
	gen ic`i' = 1 if ic == `i'
}


preserve 
# delim ; 
keep if new == 1;
collapse (sum) ic1-ic38 [fweight = wt], by(rczone);
save data/2000/czdist, replace;
#delim cr 
restore

/* We dont have any rczone missing, so I dont know what we are supposed to be doing here. */
preserve
clear
use data/2000/czdist
keep if rczone == .
forvalues i=1/38{
	gen sumic`i'= ic`i'
}
gen d = 1
keep d sumic1-sumic38
sort d
save data/2000/c1.dta, replace
restore

preserve 
clear
use data/2000/czdist
keep if rczone != .
gen d = 1
sort d 
save data/2000/c2.dta, replace
restore

clear
use data/2000/c1.dta
merge d using data/2000/c2.dta

forvalues i=1/38{
	gen shric`i' = ic`i'/sumic`i'
}

drop d sumic1-sumic38 ic1-ic38

summ shric1-shric7 shric37 shric38

/*
proc print data=here.ic_city;
var rmsa shric1-shric7 shric37 shric38;
format shric1-shric7 shric37 shric38 6.4;

proc means n mean sum min max data=here.ic_city;
var shric1-shric38;






