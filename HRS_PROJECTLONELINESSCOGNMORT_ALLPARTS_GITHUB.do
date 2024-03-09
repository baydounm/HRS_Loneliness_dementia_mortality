**************************************************************LONELINESS SCALE*******************************************************

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\DATA_MANAGEMENT_LONELINESS.smcl",replace


cd "E:\HRS_MANUSCRIPT_MICHAEL\FINAL_DATA"



*****STEP -1: LONELINESS DATA, 2006 & 2008: MERGE AND CREATE THE LONELINESS VARIABLE**

***2006***
*KLB020A "How often do you feel you lack companionship?"
*KLB020B "How often do you feel left out?"
*KLB020C "How often do you feel isolated from others?"

***2008***
*LLB020A "You lack companionship?"
*LLB020B "Left out?"
*LLB020C "Isolated from others?"
*LLB020D "That you are "in tune" with the people around you?"
*LLB020E "Alone?"
*LLB020F "That there are people you can talk to?"
*LLB020G "That there are people you can turn to?"
*LLB020H "That there are people who really understand you?"
*LLB020I "That there are people you feel close to?"
*LLB020J "Part of a group of friends?"
*LLB020K "That you have a lot in common with the people around you?"

use H06LB_R,clear
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save H06LB_Rfin, replace


use H08LB_R,clear
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save H08LB_Rfin, replace

use H06LB_Rfin,clear
merge HHIDPN using H08LB_Rfin

save H06LB_R_H08LB_R, replace

keep HHIDPN KLB020A KLB020B KLB020C LLB020A LLB020B LLB020C
save Loneliness_data2006_2008, replace

use Loneliness_data2006_2008,clear

tab1 KLB020A KLB020B KLB020C LLB020A LLB020B LLB020C   

save Loneliness_data2006_2008, replace


******************************Create a loneliness variable********************************************************
 use Loneliness_data2006_2008, clear


**Your lack of companionship? 1: Often, 2: Some of the time, 3: Hardly ever or never**
*LLB020A & KLB020A merged*

**2006**
tab KLB020A, missing
capture drop lackcomp_2006
gen lackcomp_2006 = KLB020A

replace lackcomp_2006=1 if KLB020A==3
replace lackcomp_2006=2 if KLB020A==2
replace lackcomp_2006=3 if KLB020A==1

tab1 lackcomp_2006

**2008**
tab LLB020A, missing
capture drop lackcomp_2008
gen lackcomp_2008 = LLB020A

replace lackcomp_2008=1 if LLB020A==3
replace lackcomp_2008=2 if LLB020A==2
replace lackcomp_2008=3 if LLB020A==1

tab1 lackcomp_2008


**Left out? 1: Often, 2: Some of the time, 3: Hardly ever or never**

*LLB020B & KLB020B merged*

**2006**
tab KLB020B, missing
capture drop leftout_2006
gen leftout_2006 = KLB020B

replace leftout_2006=1 if KLB020B==3
replace leftout_2006=2 if KLB020B==2
replace leftout_2006=3 if KLB020B==1

tab1 leftout_2006


**2008**
tab LLB020B, missing
capture drop leftout_2008
gen leftout_2008 = LLB020B

replace leftout_2008=1 if LLB020B==3
replace leftout_2008=2 if LLB020B==2
replace leftout_2008=3 if LLB020B==1

tab1 leftout_2008



**Isolated from others? 1: Often, 2: Some of the time, 3: Hardly ever or never**
*LLB020C & KLB020C merged*

**2006**
tab LLB020C, missing
capture drop Iso_2006
gen Iso_2006 = KLB020C

replace Iso_2006=1 if KLB020C==3
replace Iso_2006=2 if KLB020C==2
replace Iso_2006=3 if KLB020C==1

tab1 Iso_2006

**2008**
tab LLB020C, missing
capture drop Iso_2008
gen Iso_2008 = LLB020C

replace Iso_2008=1 if LLB020C==3
replace Iso_2008=2 if LLB020C==2
replace Iso_2008=3 if LLB020C==1

tab1 Iso_2008


capture rename HHIDPN, lower


*********Combined 2006-2008 items*********************
capture drop lackcomp_2006_2008
gen lackcomp_2006_2008=.
replace lackcomp_2006_2008=lackcomp_2006 if lackcomp_2006~=.
replace lackcomp_2006_2008=lackcomp_2008 if lackcomp_2008~=.


capture drop leftout_2006_2008
gen leftout_2006_2008=.
replace leftout_2006_2008=leftout_2006 if leftout_2006~=.
replace leftout_2006_2008=leftout_2008 if leftout_2008~=.

capture drop Iso_2006_2008
gen Iso_2006_2008=.
replace Iso_2006_2008=Iso_2006 if Iso_2006~=.
replace Iso_2006_2008=Iso_2008 if Iso_2008~=.


***total loneliness score, scaled from 1 - 3***

capture drop loneliness_tot_miss
egen loneliness_tot_miss=rowmiss(lackcomp_2006_2008 leftout_2006_2008 Iso_2006_2008)
tab loneliness_tot_miss

capture drop loneliness_tot_rmean
egen loneliness_tot_rmean=rmean(lackcomp_2006_2008 leftout_2006_2008 Iso_2006_2008) if loneliness_tot_miss<1

capture drop loneliness_tot
gen loneliness_tot=loneliness_tot_rmean*3-3

su loneliness_tot, detail
histogram loneliness_tot
graph save loneliness_tot.gph,replace

sort hhidpn

save, replace


*********************************************************************************************************************************************

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\DATA_MANAGEMENT.smcl",replace

**STEP 0: OPEN FILES AND CREATE HHIDPN VARIABLE, SORT BY THIS VARIABLE**

cd "E:\HRS_MANUSCRIPT_MICHAEL\FINAL_DATA"

use randhrs1992_2018v2,clear


capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

use trk2020tr_r,clear
capture rename HHID-VERSION,lower
save, replace

capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

**STEP 1: REDUCE RAND FILE TO RESPONDENT VARIABLE FILE****

use randhrs1992_2018v2,clear
 
keep HHIDPN r* inw* h*

save randhrs1992_2018v2_resp, replace



**STEP 2: MERGE REDUCED RAND FILE WITH TRACKER FILE****

use randhrs1992_2018v2_resp,clear
capture drop _merge
merge HHIDPN using trk2020tr_r
tab _merge
capture drop _merge
sort HHIDPN
save randhrs1992_2018v2_resp_tracker, replace




**STEP 3: DESCRIBE AND SUMMARIZE THE FILE****

describe 

su 

**STEP 4: IDENTIFY THE REQUIRED VARIABLES USING RAND AND TRACKER FILE DOCUMENTATION AND LIST THEM ****
use randhrs1992_2018v2_resp_tracker,clear


**LIST OF AGE VARIABLES (2006-2018):
**2006 is r8: r8agey_e
**2008 is r9: r9agey_e
**2010 is r10: r10agey_e
**2012 is r11: r11agey_e
**2014 is r12: r12agey_e
**2016 is r13: r13agey_e
**2018 is r14: r14agey_e

su r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e


**LIST OF VARIABLES NEEDED TO CREATE THE RACE/ETHNICITY (fixed):

**RACE: need to impute, n=5 missing**

capture drop RACE
gen RACE=rarace

tab RACE 

**Ethnicity: 1=Hispanic, 0=Non-Hispanic: n=1 missing

capture drop ETHNICITY
gen ETHNICITY=rahispan

tab ETHNICITY 

**RACE/ETHNICITY: 

capture drop RACE_ETHN
gen RACE_ETHN=.
replace RACE_ETHN=1 if RACE==1 & ETHNICITY==0
replace RACE_ETHN=2 if RACE==2 & ETHNICITY==0
replace RACE_ETHN=3 if ETHNICITY==1 & RACE~=.
replace RACE_ETHN=4 if RACE==3 & ETHNICITY==0

tab RACE_ETHN,missing
tab RACE_ETHN 


**GENDER (fixed):

capture drop SEX
gen SEX=ragender

tab SEX 


**EDUCATION (fixed):

tab raeduc, missing 

capture drop education
gen education = .
replace education = 1 if raeduc == 1 /*< HS*/
replace education = 2 if raeduc == 2 /*GED*/
replace education = 3 if raeduc == 3 /*HS GRADUATE*/
replace education = 4 if raeduc == 4 /*SOME COLLEGE*/
replace education = 5 if raeduc == 5 /*COLLEGE AND ABOVE*/

tab education , missing
tab education 

************************************************************2006*************************************************************


**INCOME VARIABLE (2006):

tab h8itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2006
gen totwealth_2006 = .
replace totwealth_2006 = 1 if h8itot < 25000
replace totwealth_2006 = 2 if h8itot >= 25000 & h8itot < 125000
replace totwealth_2006 = 3 if h8itot >= 125000 & h8itot < 300000
replace totwealth_2006 = 4 if h8itot >= 300000 & h8itot < 650000
replace totwealth_2006 = 5 if h8itot >= 650000 & h8itot ~= .


tab totwealth_2006 , missing
tab totwealth_2006 

save, replace

**MARITAL STATUS (2006)**

tab r8mstat, missing

capture drop marital_2006
gen marital_2006 = .
replace marital_2006 = 1 if r8mstat == 8 /*never married*/
replace marital_2006 = 2 if (r8mstat == 1 | r8mstat == 2 | r8mstat == 3) /*married / partnered*/
replace marital_2006 = 3 if (r8mstat == 4 | r8mstat == 5 | r8mstat == 6) /*separated / divorced*/
replace marital_2006 = 4 if (r8mstat == 7) /*widowed*/

tab marital_2006, missing
tab marital_2006

**EMPLOYMENT (2006):

tab r8work, missing

capture drop work_st_2006
gen work_st_2006 = .
replace work_st_2006 = 0 if r8work == 0
replace work_st_2006 = 1 if r8work == 1

tab work_st_2006, missing
tab work_st_2006


**CIGARETTE SMOKING (2006): 
tab r8smokev, missing
tab r8smoken, missing

capture drop smoking_2006
gen smoking_2006 = .
replace smoking_2006 = 1 if r8smokev == 0
replace smoking_2006 = 2 if r8smokev == 1 & r8smoken == 0
replace smoking_2006 = 3 if r8smokev == 1 & r8smoken == 1

tab smoking_2006, missing
tab smoking_2006 

save, replace


**PHYSICAL ACTIVITY (2006):
tab r8vgactx, missing
tab r8mdactx, missing

capture drop physic_act_2006
gen physic_act_2006 = .
replace physic_act_2006 = 1 if (r8vgactx ==  5 & r8mdactx == 5)
replace physic_act_2006 = 2 if (r8vgactx ==  3 | r8mdactx == 3 | r8vgactx ==  4 | r8mdactx == 4)
replace physic_act_2006 = 3 if (r8vgactx ==  1 | r8mdactx == 1 | r8vgactx ==  2 | r8mdactx == 2)

tab physic_act_2006, missing
tab physic_act_2006


**SELF-RATED HEALTH (2006):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r8shlt, missing

capture drop srh_2006
gen srh_2006 = .
replace srh_2006 = 1 if (r8shlt == 1 | r8shlt == 2 | r8shlt == 3)
replace srh_2006 = 2 if (r8shlt == 4 | r8shlt == 5)

tab srh_2006, missing
tab srh_2006 

save, replace


**WEIGTH STATUS, 2006**
/*body mass index*/

/*2006*/

*<25 
**  25-29.9
**  ≥30


tab r8pmbmi, missing
tab r8bmi, missing
tab r8bmi , missing
tab r8bmi 
su r8bmi ,det


capture drop bmi_2006
gen bmi_2006 = r8pmbmi if r8pmbmi < 100
else replace bmi_2006 = r8bmi if r8bmi < 100

tab bmi_2006, missing
tab bmi_2006 , missing
tab bmi_2006 
su bmi_2006 , det



capture drop bmibr_2006
gen bmibr_2006 = 1 if bmi_2006 < 25
replace bmibr_2006 = 2 if bmi_2006 >= 25 & bmi_2006 < 30
replace bmibr_2006 = 3 if bmi_2006 >= 30 & bmi_2006 ~= .

tab bmibr_2006, missing


/*cardiometabolic risk factors and chronic conditions, 2006*/

/*HYPERTENSION*/

tab r8hibpe, missing

capture drop hbp_ever_2006sv
gen hbp_ever_2006 = .
replace hbp_ever_2006 = 0 if r8hibpe == 0
replace hbp_ever_2006 = 1 if r8hibpe == 1

tab hbp_ever_2006, missing
tab hbp_ever_2006 


/*DIABETES*/

tab r8diabe, missing

capture drop diab_ever_2006
gen diab_ever_2006 = .
replace diab_ever_2006 = 0 if r8diabe == 0
replace diab_ever_2006 = 1 if r8diabe == 1

tab diab_ever_2006, missing
tab diab_ever_2006 


/*HEART PROBLEMS*/

tab r8hearte, missing

capture drop heart_ever_2006
gen heart_ever_2006 = .
replace heart_ever_2006 = 0 if r8hearte == 0
replace heart_ever_2006 = 1 if r8hearte == 1

tab heart_ever_2006, missing
tab heart_ever_2006 


/*STROKE*/

tab r8stroke, missing

capture drop stroke_ever_2006
gen stroke_ever_2006 = .
replace stroke_ever_2006 = 0 if r8stroke == 0
replace stroke_ever_2006 = 1 if r8stroke == 1

tab stroke_ever_2006, missing
tab stroke_ever_2006 , missing
tab stroke_ever_2006 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2006
gen cardiometcond_2006 = .
replace cardiometcond_2006 = hbp_ever_2006 + diab_ever_2006 + heart_ever_2006 + stroke_ever_2006

tab cardiometcond_2006, missing
tab cardiometcond_2006 , missing
tab cardiometcond_2006 


capture drop cardiometcondbr_2006
gen cardiometcondbr_2006 = .
replace cardiometcondbr_2006 = 1 if cardiometcond_2006 ==0
replace cardiometcondbr_2006 = 2 if (cardiometcond_2006 == 1 | cardiometcond_2006 == 2)
replace cardiometcondbr_2006 = 3 if (cardiometcond_2006 == 3 | cardiometcond_2006 == 4)

tab cardiometcondbr_2006, missing
tab cardiometcondbr_2006 

**2006 CESD**
capture drop cesd_2006
gen cesd_2006=r8cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2006-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum kwgtr


************************************************2008****************************************************************************************************

**INCOME VARIABLE (2008):

tab h9itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2008
gen totwealth_2008 = .
replace totwealth_2008 = 1 if h9itot < 25000
replace totwealth_2008 = 2 if h9itot >= 25000 & h9itot < 125000
replace totwealth_2008 = 3 if h9itot >= 125000 & h9itot < 300000
replace totwealth_2008 = 4 if h9itot >= 300000 & h9itot < 650000
replace totwealth_2008 = 5 if h9itot >= 650000 & h9itot ~= .


tab totwealth_2008 , missing
tab totwealth_2008 

save, replace

**MARITAL STATUS (2008)**

tab r9mstat, missing

capture drop marital_2008
gen marital_2008 = .
replace marital_2008 = 1 if r9mstat == 8 /*never married*/
replace marital_2008 = 2 if (r9mstat == 1 | r9mstat == 2 | r9mstat == 3) /*married / partnered*/
replace marital_2008 = 3 if (r9mstat == 4 | r9mstat == 5 | r9mstat == 6) /*separated / divorced*/
replace marital_2008 = 4 if (r9mstat == 7) /*widowed*/

tab marital_2008, missing
tab marital_2008

**EMPLOYMENT (2008):

tab r9work, missing

capture drop work_st_2008
gen work_st_2008 = .
replace work_st_2008 = 0 if r9work == 0
replace work_st_2008 = 1 if r9work == 1

tab work_st_2008, missing
tab work_st_2008


**CIGARETTE SMOKING (2008): 
tab r9smokev, missing
tab r9smoken, missing

capture drop smoking_2008
gen smoking_2008 = .
replace smoking_2008 = 1 if r9smokev == 0
replace smoking_2008 = 2 if r9smokev == 1 & r9smoken == 0
replace smoking_2008 = 3 if r9smokev == 1 & r9smoken == 1

tab smoking_2008, missing
tab smoking_2008 

save, replace


**PHYSICAL ACTIVITY (2008):
tab r9vgactx, missing
tab r9mdactx, missing

capture drop physic_act_2008
gen physic_act_2008 = .
replace physic_act_2008 = 1 if (r9vgactx ==  5 & r9mdactx == 5)
replace physic_act_2008 = 2 if (r9vgactx ==  3 | r9mdactx == 3 | r9vgactx ==  4 | r9mdactx == 4)
replace physic_act_2008 = 3 if (r9vgactx ==  1 | r9mdactx == 1 | r9vgactx ==  2 | r9mdactx == 2)

tab physic_act_2008, missing
tab physic_act_2008


**SELF-RATED HEALTH (2008):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r9shlt, missing

capture drop srh_2008
gen srh_2008 = .
replace srh_2008 = 1 if (r9shlt == 1 | r9shlt == 2 | r9shlt == 3)
replace srh_2008 = 2 if (r9shlt == 4 | r9shlt == 5)

tab srh_2008, missing
tab srh_2008 

save, replace


**WEIGTH STATUS, 2008**
/*body mass index*/

/*2008*/

*<25 
**  25-29.9
**  ≥30


tab r9pmbmi, missing
tab r9bmi, missing
tab r9bmi , missing
tab r9bmi 
su r9bmi ,det


capture drop bmi_2008
gen bmi_2008 = r9pmbmi if r9pmbmi < 100
else replace bmi_2008 = r9bmi if r9bmi < 100

tab bmi_2008, missing
tab bmi_2008 , missing
tab bmi_2008 
su bmi_2008 , det



capture drop bmibr_2008
gen bmibr_2008 = 1 if bmi_2008 < 25
replace bmibr_2008 = 2 if bmi_2008 >= 25 & bmi_2008 < 30
replace bmibr_2008 = 3 if bmi_2008 >= 30 & bmi_2008 ~= .

tab bmibr_2008, missing


/*cardiometabolic risk factors and chronic conditions, 2008*/

/*HYPERTENSION*/

tab r9hibpe, missing

capture drop hbp_ever_2008
gen hbp_ever_2008 = .
replace hbp_ever_2008 = 0 if r9hibpe == 0
replace hbp_ever_2008 = 1 if r9hibpe == 1

tab hbp_ever_2008, missing
tab hbp_ever_2008 


/*DIABETES*/

tab r9diabe, missing

capture drop diab_ever_2008
gen diab_ever_2008 = .
replace diab_ever_2008 = 0 if r9diabe == 0
replace diab_ever_2008 = 1 if r9diabe == 1

tab diab_ever_2008, missing
tab diab_ever_2008 


/*HEART PROBLEMS*/

tab r9hearte, missing

capture drop heart_ever_2008
gen heart_ever_2008 = .
replace heart_ever_2008 = 0 if r9hearte == 0
replace heart_ever_2008 = 1 if r9hearte == 1

tab heart_ever_2008, missing
tab heart_ever_2008 


/*STROKE*/

tab r9stroke, missing

capture drop stroke_ever_2008
gen stroke_ever_2008 = .
replace stroke_ever_2008 = 0 if r9stroke == 0
replace stroke_ever_2008 = 1 if r9stroke == 1

tab stroke_ever_2008, missing
tab stroke_ever_2008 , missing
tab stroke_ever_2008 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2008
gen cardiometcond_2008 = .
replace cardiometcond_2008 = hbp_ever_2008 + diab_ever_2008 + heart_ever_2008 + stroke_ever_2008

tab cardiometcond_2008, missing
tab cardiometcond_2008 , missing
tab cardiometcond_2008 


capture drop cardiometcondbr_2008
gen cardiometcondbr_2008 = .
replace cardiometcondbr_2008 = 1 if cardiometcond_2008 ==0
replace cardiometcondbr_2008 = 2 if (cardiometcond_2008 == 1 | cardiometcond_2008 == 2)
replace cardiometcondbr_2008 = 3 if (cardiometcond_2008 == 3 | cardiometcond_2008 == 4)

tab cardiometcondbr_2008, missing
tab cardiometcondbr_2008 

**2008 CESD**
capture drop cesd_2008
gen cesd_2008=r9cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2008-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum lwgtr


**********************************************2010***************************************************************


**INCOME VARIABLE (2010):

tab h10itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2010
gen totwealth_2010 = .
replace totwealth_2010 = 1 if h10itot < 25000
replace totwealth_2010 = 2 if h10itot >= 25000 & h10itot < 125000
replace totwealth_2010 = 3 if h10itot >= 125000 & h10itot < 300000
replace totwealth_2010 = 4 if h10itot >= 300000 & h10itot < 650000
replace totwealth_2010 = 5 if h10itot >= 650000 & h10itot ~= .


tab totwealth_2010 , missing
tab totwealth_2010 

save, replace

**MARITAL STATUS (2010)**

tab r10mstat, missing

capture drop marital_2010
gen marital_2010 = .
replace marital_2010 = 1 if r10mstat == 8 /*never married*/
replace marital_2010 = 2 if (r10mstat == 1 | r10mstat == 2 | r10mstat == 3) /*married / partnered*/
replace marital_2010 = 3 if (r10mstat == 4 | r10mstat == 5 | r10mstat == 6) /*separated / divorced*/
replace marital_2010 = 4 if (r10mstat == 7) /*widowed*/

tab marital_2010, missing
tab marital_2010

**EMPLOYMENT (2010):

tab r10work, missing

capture drop work_st_2010
gen work_st_2010 = .
replace work_st_2010 = 0 if r10work == 0
replace work_st_2010 = 1 if r10work == 1

tab work_st_2010, missing
tab work_st_2010


**CIGARETTE SMOKING (2010): 
tab r10smokev, missing
tab r10smoken, missing

capture drop smoking_2010
gen smoking_2010 = .
replace smoking_2010 = 1 if r10smokev == 0
replace smoking_2010 = 2 if r10smokev == 1 & r10smoken == 0
replace smoking_2010 = 3 if r10smokev == 1 & r10smoken == 1

tab smoking_2010, missing
tab smoking_2010 

save, replace


**PHYSICAL ACTIVITY (2010):
tab r10vgactx, missing
tab r10mdactx, missing

capture drop physic_act_2010
gen physic_act_2010 = .
replace physic_act_2010 = 1 if (r10vgactx ==  5 & r10mdactx == 5)
replace physic_act_2010 = 2 if (r10vgactx ==  3 | r10mdactx == 3 | r10vgactx ==  4 | r10mdactx == 4)
replace physic_act_2010 = 3 if (r10vgactx ==  1 | r10mdactx == 1 | r10vgactx ==  2 | r10mdactx == 2)

tab physic_act_2010, missing
tab physic_act_2010


**SELF-RATED HEALTH (2010):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r10shlt, missing

capture drop srh_2010
gen srh_2010 = .
replace srh_2010 = 1 if (r10shlt == 1 | r10shlt == 2 | r10shlt == 3)
replace srh_2010 = 2 if (r10shlt == 4 | r10shlt == 5)

tab srh_2010, missing
tab srh_2010 

save, replace


**WEIGTH STATUS, 2010**
/*body mass index*/

/*2010*/

*<25 
**  25-29.9
**  ≥30


tab r10pmbmi, missing
tab r10bmi, missing
tab r10bmi , missing
tab r10bmi 
su r10bmi ,det


capture drop bmi_2010
gen bmi_2010 = r10pmbmi if r10pmbmi < 100
else replace bmi_2010 = r10bmi if r10bmi < 100

tab bmi_2010, missing
tab bmi_2010 , missing
tab bmi_2010 
su bmi_2010 , det



capture drop bmibr_2010
gen bmibr_2010 = 1 if bmi_2010 < 25
replace bmibr_2010 = 2 if bmi_2010 >= 25 & bmi_2010 < 30
replace bmibr_2010 = 3 if bmi_2010 >= 30 & bmi_2010 ~= .

tab bmibr_2010, missing


/*cardiometabolic risk factors and chronic conditions, 2010*/

/*HYPERTENSION*/

tab r10hibpe, missing

capture drop hbp_ever_2010
gen hbp_ever_2010 = .
replace hbp_ever_2010 = 0 if r10hibpe == 0
replace hbp_ever_2010 = 1 if r10hibpe == 1

tab hbp_ever_2010, missing
tab hbp_ever_2010 


/*DIABETES*/

tab r10diabe, missing

capture drop diab_ever_2010
gen diab_ever_2010 = .
replace diab_ever_2010 = 0 if r10diabe == 0
replace diab_ever_2010 = 1 if r10diabe == 1

tab diab_ever_2010, missing
tab diab_ever_2010 


/*HEART PROBLEMS*/

tab r10hearte, missing

capture drop heart_ever_2010
gen heart_ever_2010 = .
replace heart_ever_2010 = 0 if r10hearte == 0
replace heart_ever_2010 = 1 if r10hearte == 1

tab heart_ever_2010, missing
tab heart_ever_2010 


/*STROKE*/

tab r10stroke, missing

capture drop stroke_ever_2010
gen stroke_ever_2010 = .
replace stroke_ever_2010 = 0 if r10stroke == 0
replace stroke_ever_2010 = 1 if r10stroke == 1

tab stroke_ever_2010, missing
tab stroke_ever_2010 , missing
tab stroke_ever_2010 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2010
gen cardiometcond_2010 = .
replace cardiometcond_2010 = hbp_ever_2010 + diab_ever_2010 + heart_ever_2010 + stroke_ever_2010

tab cardiometcond_2010, missing
tab cardiometcond_2010 , missing
tab cardiometcond_2010 


capture drop cardiometcondbr_2010
gen cardiometcondbr_2010 = .
replace cardiometcondbr_2010 = 1 if cardiometcond_2010 ==0
replace cardiometcondbr_2010 = 2 if (cardiometcond_2010 == 1 | cardiometcond_2010 == 2)
replace cardiometcondbr_2010 = 3 if (cardiometcond_2010 == 3 | cardiometcond_2010 == 4)

tab cardiometcondbr_2010, missing
tab cardiometcondbr_2010 

**2010 CESD**
capture drop cesd_2010
gen cesd_2010=r10cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2010-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum mwgtr

save,replace


*****************************************************************************************************************

**STEP 5: GENERATE THE MAIN VARIABLES NEEDED FOR THE ANALYSIS, CHANGE THEIR NAMES FOR EASE OF USE**



**AGE VARIABLES**

su r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e 


**REMAINING COVARIATES**

tab1 SEX RACE_ETHN education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 cesd_2010

save, replace





**STEP 6: LONELINESS DATA, 2006-2008**

***2006***
*KLB020A "How often do you feel you lack companionship?"
*KLB020B "How often do you feel left out?"
*KLB020C "How often do you feel isolated from others?"

***2008***
*LLB020A "You lack companionship?"
*LLB020B "Left out?"
*LLB020C "Isolated from others?"
*LLB020D "That you are "in tune" with the people around you?"
*LLB020E "Alone?"
*LLB020F "That there are people you can talk to?"
*LLB020G "That there are people you can turn to?"
*LLB020H "That there are people who really understand you?"
*LLB020I "That there are people you feel close to?"
*LLB020J "Part of a group of friends?"
*LLB020K "That you have a lot in common with the people around you?"

use H06LB_R,clear
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save H06LB_Rfin, replace


use H08LB_R,clear
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save H08LB_Rfin, replace

use H06LB_Rfin,clear
merge HHIDPN using H08LB_Rfin

save H06LB_R_H08LB_R, replace

keep HHIDPN KLB020A KLB020B KLB020C LLB020A LLB020B LLB020C
save Loneliness_data2006_2008, replace

use Loneliness_data2006_2008,clear

tab1 KLB020A KLB020B KLB020C LLB020A LLB020B LLB020C   

save Loneliness_data2006_2008, replace


******************************Create a loneliness variable********************************************************
 use Loneliness_data2006_2008, clear


**Your lack of companionship? 1: Often, 2: Some of the time, 3: Hardly ever or never**
*LLB020A & KLB020A merged*

**2006**
tab KLB020A, missing
capture drop lackcomp_2006
gen lackcomp_2006 = KLB020A

replace lackcomp_2006=1 if KLB020A==3
replace lackcomp_2006=2 if KLB020A==2
replace lackcomp_2006=3 if KLB020A==1

tab1 lackcomp_2006

**2008**
tab LLB020A, missing
capture drop lackcomp_2008
gen lackcomp_2008 = LLB020A

replace lackcomp_2008=1 if LLB020A==3
replace lackcomp_2008=2 if LLB020A==2
replace lackcomp_2008=3 if LLB020A==1

tab1 lackcomp_2008


**Left out? 1: Often, 2: Some of the time, 3: Hardly ever or never**

*LLB020B & KLB020B merged*

**2006**
tab KLB020B, missing
capture drop leftout_2006
gen leftout_2006 = KLB020B

replace leftout_2006=1 if KLB020B==3
replace leftout_2006=2 if KLB020B==2
replace leftout_2006=3 if KLB020B==1

tab1 leftout_2006


**2008**
tab LLB020B, missing
capture drop leftout_2008
gen leftout_2008 = LLB020B

replace leftout_2008=1 if LLB020B==3
replace leftout_2008=2 if LLB020B==2
replace leftout_2008=3 if LLB020B==1

tab1 leftout_2008



**Isolated from others? 1: Often, 2: Some of the time, 3: Hardly ever or never**
*LLB020C & KLB020C merged*

**2006**
tab LLB020C, missing
capture drop Iso_2006
gen Iso_2006 = KLB020C

replace Iso_2006=1 if KLB020C==3
replace Iso_2006=2 if KLB020C==2
replace Iso_2006=3 if KLB020C==1

tab1 Iso_2006

**2008**
tab LLB020C, missing
capture drop Iso_2008
gen Iso_2008 = LLB020C

replace Iso_2008=1 if LLB020C==3
replace Iso_2008=2 if LLB020C==2
replace Iso_2008=3 if LLB020C==1

tab1 Iso_2008


*********Combined 2006-2008 items*********************
capture drop lackcomp_2006_2008
gen lackcomp_2006_2008=.
replace lackcomp_2006_2008=lackcomp_2006 if lackcomp_2006~=.
replace lackcomp_2006_2008=lackcomp_2008 if lackcomp_2008~=.


capture drop leftout_2006_2008
gen leftout_2006_2008=.
replace leftout_2006_2008=leftout_2006 if leftout_2006~=.
replace leftout_2006_2008=leftout_2008 if leftout_2008~=.

capture drop Iso_2006_2008
gen Iso_2006_2008=.
replace Iso_2006_2008=Iso_2006 if Iso_2006~=.
replace Iso_2006_2008=Iso_2008 if Iso_2008~=.


***total loneliness score, scaled from 1 - 3***

capture drop loneliness_tot_miss
egen loneliness_tot_miss=rowmiss(lackcomp_2006_2008 leftout_2006_2008 Iso_2006_2008)
tab loneliness_tot_miss

capture drop loneliness_tot_rmean
egen loneliness_tot_rmean=rmean(lackcomp_2006_2008 leftout_2006_2008 Iso_2006_2008) if loneliness_tot_miss<1

capture drop loneliness_tot
gen loneliness_tot=loneliness_tot_rmean*3-3

su loneliness_tot, detail
histogram loneliness_tot
graph save loneliness_tot.gph, replace



save, replace

*********************SLEEP VARIABLE IN 2006********************

use H06C_R,clear

tab1 KC083 KC084 KC085 KC086 KC232U2 

capture rename HHID-KVERSION, lower

save H06C_R_fin, replace


capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

******************************Create a poorsleep variable**********************************************************

**Trouble fall asleep: 1: most of the time; 2:sometimes; 3:rarely or never (reverse code); 8/9 change to missing**
capture drop kc083r
gen kc083r=.
replace kc083r=3 if kc083==1
replace kc083r=2 if kc083==2
replace kc083r=1 if kc083==3
replace kc083r=. if kc083==8 | kc083==9


**Trouble waking up during the night: 1: most of the time; 2:sometimes; 3:rarely or never (reverse code); 8/9 change to missing**

capture drop kc084r
gen kc084r=.
replace kc084r=3 if kc084==1
replace kc084r=2 if kc084==2
replace kc084r=1 if kc084==3
replace kc084r=. if kc084==8 | kc084==9

**Trouble waking up too early: 1: most of the time; 2:sometimes; 3:rarely or never (reverse code); 8/9 change to missing**
capture drop kc085r
gen kc085r=.
replace kc085r=3 if kc085==1
replace kc085r=2 if kc085==2
replace kc085r=1 if kc085==3
replace kc085r=. if kc085==8 | kc085==9


**Feel rested in the morning: 1: most of the time; 2:sometimes; 3:rarely or never;  8/9 change to missing**

capture drop kc086r
gen kc086r=.
replace kc086r=3 if kc086==3
replace kc086r=2 if kc086==2
replace kc086r=1 if kc086==1
replace kc086r=. if kc086==8 | kc086==9


**Medications to sleep: 1: yes; 5:no; 8/9 change to missing**

capture drop kc232u2r
gen kc232u2r=.
replace kc232u2r=1 if kc232u2==1
replace kc232u2r=0 if kc232u2==5
replace kc232u2r=. if kc232u2==8 | kc232u2==9


**Poor sleep score, re-scaled to range from 0 to 9**
capture drop poorsleep_2006
gen poorsleep_2006=.
replace poorsleep_2006=(kc083r+kc084r+kc085r+kc086r+kc232u2r)-4

su poorsleep_2006,detail
histogram poorsleep_2006

save, replace

sort HHIDPN
save, replace

use Loneliness_data2006_2008
capture drop _merge
sort HHIDPN
save, replace

use H06C_R_fin,clear
capture drop _merge
sort HHIDPN
save, replace


merge HHIDPN using Loneliness_data2006_2008
tab _merge
capture drop _merge
sort HHIDPN
save, replace

merge HHIDPN using  randhrs1992_2018v2_resp_tracker
tab _merge
capture drop _merge
sort HHIDPN

save HRS_PROJECTLONELINESSCONGMORT_fin, replace




***********************************************************************************************************

**STEP 7: DEMENTIA PROBABILITY DATA 2006 THROUGH 2010*****

use HRS_PROJECTLONELINESSCONGMORT_fin,clear

sort HHIDPN
capture drop _merge

use Dementia_prob2000_2016,clear

destring HHID, replace
destring PN, replace

capture rename HHID-HRS_year,lower
save, replace

capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace


capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN



sort HHIDPN
save, replace

**HRS year 2010**
keep if hrs_year==2010

save Dementia_prob2010, replace


use HRS_PROJECTLONELINESSCONGMORT_fin,clear
sort HHIDPN
capture drop _merge
save, replace


merge HHIDPN using Dementia_prob2010

save HRS_PROJECTLONELINESSCONGMORT_finLONG, replace

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE1.smcl",replace


**STEP 8: DETERMINE SAMPLE WITH COMPLETE DATA ON LONELINESS IN 2006-2008, DEMENTIA PROBABILITY DATA AT 2010, AND WHERE RESPONDENT'S AGE IS >50 IN 2010**

use HRS_PROJECTLONELINESSCONGMORT_finLONG,clear


capture drop sample50plus2010
gen sample50plus2010=.
replace sample50plus2010=1 if r10agey_e>50 & r10agey_e~=.
replace sample50plus2010=0 if sample50plus2010~=1 & r10agey_e~=.

tab sample50plus2010

capture drop samplealivein2010
gen samplealivein2010=.
replace samplealivein2010=1 if inw10==1
replace samplealivein2010=0 if samplealivein2010~=1

tab samplealivein2010

capture drop samplepoorsleep2006
gen samplepoorsleep2006=.
replace samplepoorsleep2006=1 if poorsleep_2006~=. 
replace samplepoorsleep2006=0 if samplepoorsleep2006~=1

tab samplepoorsleep2006 


capture drop sampleLoneliness2006_2008
gen sampleLoneliness2006_2008=.
replace sampleLoneliness2006_2008=1 if loneliness_tot~=. 
replace sampleLoneliness2006_2008=0 if sampleLoneliness2006_2008~=1

tab sampleLoneliness2006_2008


capture drop sampledementia
gen sampledementia=.
replace sampledementia=1 if hrs_year==2010 & hurd_p!=. & expert_p!=. & lasso_p!=. 
replace sampledementia=0 if sampledementia~=1

tab sampledementia

save, replace

capture drop sample_final
gen sample_final=.
replace sample_final=1 if sample50plus2010==1 & samplealivein2010==1 & sampleLoneliness2006_2008==1 & sampledementia==1 & mwgtr~=. 
replace sample_final=0 if sample_final~=1

tab sample_final

save HRS_PROJECTSLEEPCONGMORT_finWIDE, replace


**STEP 9: MORTALITY VARIABLES FROM 2008 THROUGH 2020: TRACKER FILE INW**

**dead vs. alive: 2008-2020

capture drop died
gen died=.
replace died=1 if (sample_final==1 & knowndeceasedyr~=. & knowndeceasedmo~=.)
replace died=0 if died!=1 & sample_final==1

tab died if sample_final==1


**Date of death: dod**

su knowndeceasedmo knowndeceasedyr if sample_final==1
tab1 knowndeceasedmo knowndeceasedyr if sample_final==1

capture drop deathmonth
gen deathmonth=knowndeceasedmo if knowndeceasedmo~=98

capture drop deathyear
gen deathyear=knowndeceasedyr

capture drop deathday
gen deathday=14

capture drop dod
gen dod=mdy(deathmonth, deathday, deathyear)

**Date of entry: doenter**
capture drop doenter
gen doenter=mdy(01,01,2010)

**Date of exit if still alive: doexit**
capture drop doexit
gen doexit=mdy(12,31,2020) 

**Date of exit for censor or dead**
capture drop doevent
gen doevent=.
replace doevent=dod if died==1 & sample_final==1
replace doevent=doexit if died==0 & sample_final==1

su doevent

***Estimated birth date**

capture drop dob
gen dob=mdy(birthmo,14,birthyr)



capture drop ageevent
gen ageevent=(doevent-dob)/365.5

capture drop ageenter
gen ageenter=r10agey_e

save, replace

**STEP 10: STSET FOR MORTALITY OUTCOME***

capture drop AGE2010
gen AGE2010=ageenter

save, replace

stset ageevent if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) scale(1)


stdescribe if sample_final==1
stsum if sample_final==1
strate if sample_final==1

save, replace

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\IMPUTATION.smcl",replace


**STEP 12: MULTIPLE IMPUTATION FOR COVARIATES: MARCH 14TH: USE THE AD PGS PAPER********************** 

**//RUN IMPUTATIONS FOR 2006 COVARIATE DATA: 


**DESIGN VARIABLES**
**svyset secu [pweight=mwgtr], strata(stratum) 

**SAMPLING VARIABLES**
**sample*

**OUTCOME AND OTHER RELATED VARIABLES**
**died  doexit doevent doenter dob _t _st _d _t0 

**EXPOSURE AND MEDIATOR VARIABLES**
**poorsleep_2006  hurd_p hurd_dem expert_p expert_dem lasso_p lasso_dem 

**Year variable and age variables**
**hrs_year r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e 


**COVARIATES USED FOR OR REQUIRING IMPUTATION:
**marital_2010 education work_st_2010 totwealth_2010 smoking_2010 alcohol_2010 physic_act_2010 bmi_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 srh_2010 cesd_2010

**OTHER COVARIATES:
**AGE2006 SEX RACE ETHNICITY RACE_ETHN

**--> re-compute categorical BMI and cardiometabolic risk variables after imputation

use HRS_PROJECTLONELINESSCONGMORT_finWIDE,clear

capture drop AGE2010
gen AGE2010=r10agey_e

save, replace

keep HHIDPN HHID hhid pn mwgtr stratum secu sample* died  doexit doevent doenter dob _t _st _d _t0 poorsleep_2006 loneliness_tot  hurd_p hurd_dem expert_p expert_dem lasso_p lasso_dem hrs_year AGE2010 SEX RACE ETHNICITY RACE_ETHN marital_2010 education work_st_2010 totwealth_2010 smoking_2010 physic_act_2010 bmi_2010 bmibr_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 cardiometcond_2010 cardiometcondbr_2010 srh_2010 cesd_2010  r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e ageevent ageenter


save finaldata_unimputed, replace

sort HHIDPN 

save, replace

set matsize 11000

capture mi set, clear

mi set flong

capture mi svyset, clear

mi svyset secu [pweight=mwgtr], strata(stratum) vce(linearized) singleunit(missing)

mi stset ageevent if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) scale(1)


mi unregister HHIDPN HHID hhid pn mwgtr stratum secu sample* died  doexit doevent doenter dob _t _st _d _t0 poorsleep_2006 loneliness_tot  hurd_p hurd_dem expert_p expert_dem lasso_p lasso_dem hrs_year AGE2010 SEX RACE ETHNICITY RACE_ETHN marital_2010 education work_st_2010 totwealth_2010 smoking_2010 physic_act_2010 bmi_2010 bmibr_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 cardiometcond_2010 cardiometcondbr_2010 srh_2010 cesd_2010  r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e ageevent ageenter


mi register imputed  marital_2010 education work_st_2010 totwealth_2010 smoking_2010 physic_act_2010 bmi_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 srh_2010 cesd_2010

mi register passive loneliness_tot poorsleep_2006  hurd_p hurd_dem expert_p expert_dem lasso_p lasso_dem hrs_year

tab1 marital_2010 education work_st_2010 totwealth_2010 smoking_2010 physic_act_2010 bmi_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 srh_2010

mi impute chained (mlogit) marital_2010 education work_st_2010  totwealth_2010 smoking_2010 physic_act_2010 hbp_ever_2010 diab_ever_2010 heart_ever_2010 stroke_ever_2010 srh_2010 (regress) bmi_2010 cesd_2010 = AGE2010 SEX i.RACE_ETHN  if AGE2010>=50 , force augment noisily  add(5) rseed(1234) savetrace(tracefile, replace) 



save finaldata_imputed, replace

sort HHIDPN


capture drop male
mi passive: gen male=.
mi passive: replace male=1 if SEX==1 & sample_final==1
mi passive: replace male=0 if SEX==2 & sample_final==1

capture drop female
mi passive: gen female=.
mi passive: replace female=1 if SEX==2 & sample_final==1
mi passive: replace female=0 if SEX==1 & sample_final==1



capture drop cardiometcond_2010
mi passive: gen cardiometcond_2010 = .
mi passive: replace cardiometcond_2010 = hbp_ever_2010 + diab_ever_2010 + heart_ever_2010 + stroke_ever_2010


capture drop bmibr_2010
mi passive: gen bmibr_2010 = 1 if bmi_2010 < 25
mi passive: replace bmibr_2010 = 2 if bmi_2010 >= 25 & bmi_2010 < 30
mi passive: replace bmibr_2010 = 3 if bmi_2010 >= 30 & bmi_2010 ~= .


capture drop NonWhite
mi passive: gen NonWhite=0 if RACE_ETHN==1 & sample_final==1
mi passive: replace NonWhite=1 if RACE_ETHN!=1 & RACE_ETHN!=. & sample_final==1

save finaldata_imputed_FINAL, replace


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLE1.smcl",replace



**STEP 13: DESCRIPTIVE TABLE BY SEX AND RACE/ETHNICITY, WITHOUT TAKING INTO ACCOUNT SAMPLING DESIGN COMPLEXITY, ON UNIMPUTED DATA***

use finaldata_imputed_FINAL,clear

***********UNIMPUTED DATA ANALYSIS***************************************
mi extract 0

save finaldata_unimputed_FINAL, replace

su AGE2010 if sample_final==1 

tab1 SEX RACE_ETHN education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 if sample_final==1 

reg AGE2010 i.SEX if sample_final==1 
tab SEX RACE_ETHN if sample_final==1 , row col chi
tab SEX education if sample_final==1 , row col chi
tab SEX totwealth_2010 if sample_final==1 , row col chi
tab SEX marital_2010 if sample_final==1 , row col chi
tab SEX work_st_2010 if sample_final==1 , row col chi
tab SEX smoking_2010 if sample_final==1 , row col chi
tab SEX physic_act_2010 if sample_final==1 , row col chi
tab SEX srh_2010 if sample_final==1, row col chi
tab SEX bmibr_2010 if sample_final==1, row col chi
tab SEX cardiometcondbr_2010 if sample_final==1, row col chi

reg AGE2010 i.RACE_ETHN if sample_final==1
reg cesd_2010 i.RACE_ETHN if sample_final==1
tab RACE_ETHN SEX if sample_final==1, row col chi


**TAKE INTO ACCOUNT SAMPLING DESIGN COMPLEXITY, ON IMPUTED DATA*** 
use finaldata_imputed_FINAL,clear

mi svyset secu [pweight=mwgtr], strata(stratum)
 
foreach x1 of varlist SEX RACE_ETHN NonWhite education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(sample_final): prop `x1'
}
 

foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p  {
	mi estimate: svy, subpop(sample_final): mean `x2'
}


mi xeq 0: strate if sample_final==1  

capture drop Men
mi passive: gen Men=1 if SEX==1 & sample_final==1
mi passive: replace Men=0 if Men~=1 & SEX~=. & sample_final==1

capture drop Women
mi passive: gen Women=1 if SEX==2 & sample_final==1
mi passive: replace Women=0 if Women~=1 & SEX~=. & sample_final==1

capture drop NHW
mi passive: gen NHW=1 if RACE_ETHN==1 & sample_final==1
mi passive: replace NHW=0 if NHW~=1 & RACE_ETHN~=. & sample_final==1

capture drop NHB
mi passive: gen NHB=1 if RACE_ETHN==2 & sample_final==1
mi passive: replace NHB=0 if NHB~=1 & RACE_ETHN~=. & sample_final==1


capture drop HISP
mi passive: gen HISP=1 if RACE_ETHN==3 & sample_final==1
mi passive: replace HISP=0 if HISP~=1 & RACE_ETHN~=. & sample_final==1 


capture drop OTHER
mi passive: gen OTHER=1 if RACE_ETHN==4 & sample_final==1
mi passive: replace OTHER=0 if OTHER~=1 & RACE_ETHN~=. & sample_final==1


capture drop NonWhite
mi passive: gen NonWhite=0 if RACE_ETHN==1 & sample_final==1
mi passive: replace NonWhite=1 if RACE_ETHN!=1 & RACE_ETHN!=. & sample_final==1


save, replace



**************STRATIFIED ANALYSIS***************************

**Men**

foreach x1 of varlist SEX RACE_ETHN NonWhite education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(Men): prop `x1' 
}
 

foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(Men): mean `x2'
}


mi xeq 0: strate if Men==1  

**Women**


foreach x1 of varlist SEX RACE_ETHN NonWhite education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(Women): prop `x1' 
}
 

foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(Women): mean `x2'
}


mi xeq 0: strate  if Women==1


**NHW**

foreach x1 of varlist SEX education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(NHW): prop `x1' 
}
 

foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(NHW): mean `x2'
}


mi xeq 0: strate if NHW==1 


**NonWhite**

foreach x1 of varlist SEX  education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(NonWhite): prop `x1' 
}
 

foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(NonWhite): mean `x2'
}


mi xeq 0: strate  if NonWhite==1


save, replace


************************DIFFERENCES BY SEX AND BY RACE**************************

foreach x1 of varlist RACE_ETHN NonWhite education  totwealth_2010 marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem  {
	mi estimate: svy, subpop(sample_final): mlogit `x1' SEX
}

 
foreach x1 of varlist SEX education   marital_2010 work_st_2010 smoking_2010 physic_act_2010 srh_2010  bmibr_2010 cardiometcondbr_2010 hurd_dem expert_dem lasso_dem {
	mi estimate: svy, subpop(sample_final): mlogit `x1' NonWhite
}


foreach x2 of varlist AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(sample_final): reg `x2' SEX
}


foreach x2 of varlist totwealth_2010 AGE2010 cesd_2010 loneliness_tot  hurd_p expert_p  lasso_p {
	mi estimate: svy, subpop(sample_final): reg `x2' NonWhite
}


save, replace


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE2.smcl",replace

use finaldata_imputed_FINAL,clear


**STEP 14: FIGURE 2: COMPARE SURVIVAL PROBABILITIES ACROSS EXPOSURE (loneliness_tot, create tertiles) AND MEDIATOR LEVELS (hurd_dem expert_dem lasso_dem)**

mi extract 0

save finaldata_unimputed_FINAL, replace


stset ageevent if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) scale(1)


stdescribe if sample_final==1
stsum if sample_final==1
strate if sample_final==1

save, replace


capture drop loneliness_tottert
xtile loneliness_tottert=loneliness_tot if sample_final==1,nq(3)

bysort loneliness_tottert: su loneliness_tot if sample_final==1,detail

save, replace

sts test loneliness_tottert if sample_final==1, logrank
sts graph if sample_final==1, by(loneliness_tottert) 

graph save "FIGURE2A.gph", replace

sts test hurd_dem if sample_final==1, logrank
sts graph if sample_final==1, by(hurd_dem) 


graph save "FIGURE2B.gph", replace


sts test expert_dem if sample_final==1, logrank
sts graph if sample_final==1, by(expert_dem) 


graph save "FIGURE2C.gph", replace


sts test lasso_dem if sample_final==1, logrank
sts graph if sample_final==1, by(lasso_dem) 


graph save "FIGURE2D.gph", replace

graph combine "FIGURE2A.gph" "FIGURE2B.gph" "FIGURE2C.gph" "FIGURE2D.gph"
graph save "FIGURE2.gph", replace

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE3.smcl",replace

use finaldata_imputed_FINAL,clear


**STEP 14: FIGURE 2: COMPARE SURVIVAL PROBABILITIES ACROSS EXPOSURE (loneliness_tot, create tertiles) AND MEDIATOR LEVELS (hurd_dem expert_dem lasso_dem)**

mi extract 0

save finaldata_unimputed_FINAL, replace


stset ageevent if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) scale(1)


stdescribe if sample_final==1
stsum if sample_final==1
strate if sample_final==1

save, replace


capture drop loneliness_tottert
xtile loneliness_tottert=loneliness_tot if sample_final==1,nq(3)

bysort loneliness_tottert: su loneliness_tot if sample_final==1,detail

save, replace

*************LOWEST TERTILE OF LONELINESS***********************

sts test hurd_dem if sample_final==1 & loneliness_tottert==1, logrank
sts graph if sample_final==1 & loneliness_tottert==1, by(hurd_dem) 

graph save "FIGURE3A1.gph", replace



sts test expert_dem if sample_final==1 & loneliness_tottert==1, logrank
sts graph if sample_final==1 & loneliness_tottert==1, by(expert_dem) 

graph save "FIGURE3A2.gph", replace


sts test lasso_dem if sample_final==1 & loneliness_tottert==1, logrank
sts graph if sample_final==1 & loneliness_tottert==1, by(lasso_dem) 

graph save "FIGURE3A3.gph", replace

graph combine "FIGURE3A1.gph" "FIGURE3A2.gph" "FIGURE3A3.gph"
graph save "FIGURE3A.gph", replace



*************MIDDLE TERTILE OF LONELINESS***********************

sts test hurd_dem if sample_final==1 & loneliness_tottert==2, logrank
sts graph if sample_final==1 & loneliness_tottert==2, by(hurd_dem) 

graph save "FIGURE3B1.gph", replace



sts test expert_dem if sample_final==1 & loneliness_tottert==2, logrank
sts graph if sample_final==1 & loneliness_tottert==2, by(expert_dem) 

graph save "FIGURE3B2.gph", replace


sts test lasso_dem if sample_final==1 & loneliness_tottert==2, logrank
sts graph if sample_final==1 & loneliness_tottert==2, by(lasso_dem) 

graph save "FIGURE3B3.gph", replace

graph combine "FIGURE3B1.gph" "FIGURE3B2.gph" "FIGURE3B3.gph"
graph save "FIGURE3B.gph", replace


*******************UPPERMOST TERTILE OF LONELINESS*********************

sts test hurd_dem if sample_final==1 & loneliness_tottert==3, logrank
sts graph if sample_final==1 & loneliness_tottert==3, by(hurd_dem) 

graph save "FIGURE3C1.gph", replace



sts test expert_dem if sample_final==1 & loneliness_tottert==3, logrank
sts graph if sample_final==1 & loneliness_tottert==3, by(expert_dem) 

graph save "FIGURE3C2.gph", replace


sts test lasso_dem if sample_final==1 & loneliness_tottert==3, logrank
sts graph if sample_final==1 & loneliness_tottert==3, by(lasso_dem) 

graph save "FIGURE3C3.gph", replace

graph combine "FIGURE3C1.gph" "FIGURE3C2.gph" "FIGURE3C3.gph"
graph save "FIGURE3C.gph", replace


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLE2.smcl",replace

use finaldata_imputed_FINAL,clear


capture drop loneliness_tottert
xtile loneliness_tottert=loneliness_tot if sample_final==1,nq(3)

bysort loneliness_tottert: su loneliness_tot if sample_final==1,detail

save finaldata_imputed_FINAL, replace



**STEP 15: TABLE 2: COX PH MODELS FOR EXPOSURE (LONELINESS and dementia probabilities, loge transformed) VS. OUTCOME AND MEDIATOR VS. OUTCOME, OVERALL AND STRATIFIED BY SEX AND RACE: REDUCE AND FULL MODELS; INTERACTION BY SEX AND BY RACE*******


capture drop lnhurd_odds
mi passive: gen lnhurd_odds=ln((hurd_p)/(1-hurd_p))

capture drop lnexpert_odds
mi passive: gen lnexpert_odds=ln((expert_p)/(1-expert_p))


capture drop lnlasso_odds
mi passive: gen lnlasso_odds=ln((lasso_p)/(1-lasso_p))


capture drop Men
mi passive: gen Men=1 if SEX==1 & sample_final==1
mi passive: replace Men=0 if Men~=1 & SEX~=. & sample_final==1

capture drop Women
mi passive: gen Women=1 if SEX==2 & sample_final==1
mi passive: replace Women=0 if Women~=1 & SEX~=. & sample_final==1

capture drop NHW
mi passive: gen NHW=1 if RACE_ETHN==1 & sample_final==1
mi passive: replace NHW=0 if NHW~=1 & RACE_ETHN~=. & sample_final==1

capture drop NHB
mi passive: gen NHB=1 if RACE_ETHN==2 & sample_final==1
mi passive: replace NHB=0 if NHB~=1 & RACE_ETHN~=. & sample_final==1


capture drop HISP
mi passive: gen HISP=1 if RACE_ETHN==3 & sample_final==1
mi passive: replace HISP=0 if HISP~=1 & RACE_ETHN~=. & sample_final==1 


capture drop OTHER
mi passive: gen OTHER=1 if RACE_ETHN==4 & sample_final==1
mi passive: replace OTHER=0 if OTHER~=1 & RACE_ETHN~=. & sample_final==1


capture drop NonWhite
mi passive: gen NonWhite=0 if RACE_ETHN==1 & sample_final==1
mi passive: replace NonWhite=1 if RACE_ETHN!=1 & RACE_ETHN!=. & sample_final==1

save, replace




****************OVERALL*********************

***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite
	
}


***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


*****************MEN************************


***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(Men): stcox `x' AGE2010 SEX NonWhite
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(Men): stcox `x' AGE2010 SEX NonWhite
	
}


***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(Men): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(Men): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


*****************WOMEN**********************

***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(Women): stcox `x' AGE2010 SEX NonWhite
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(Women): stcox `x' AGE2010 SEX NonWhite
	
}

***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(Women): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(Women): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010

	
}

****************NHW*************************


***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NHW): stcox `x' AGE2010 SEX NonWhite
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NHW): stcox `x' AGE2010 SEX NonWhite
	
}

***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NHW): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NHW): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


****************NHB*************************


***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NHB): stcox `x' AGE2010 SEX NonWhite
	
}



foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NHB): stcox `x' AGE2010 SEX NonWhite
	
}

***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NHB): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NHB): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}



****************HISP************************



***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(HISP): stcox `x' AGE2010 SEX NonWhite
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(HISP): stcox `x' AGE2010 SEX NonWhite
	
}

***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(HISP): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(HISP): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


**************NonWhite*************************

***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NonWhite): stcox `x' AGE2010 SEX NonWhite
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NonWhite): stcox `x' AGE2010 SEX NonWhite
	
}

***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(NonWhite): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}



foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(NonWhite): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

****************INTERACTION BY SEX*********

***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.SEX AGE2010 SEX NonWhite
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.SEX AGE2010 SEX NonWhite
	
}



***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.SEX AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}


foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.SEX AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

****************INTERACTION BY RACE*********


***MODEL 1****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##NonWhite AGE2010 SEX 
	
}

foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##NonWhite AGE2010 SEX 
	
}



***MODEL 2****
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##NonWhite AGE2010 SEX  i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}



foreach x of varlist loneliness_tottert hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##NonWhite AGE2010 SEX  i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010
	
}

save, replace


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLE3.smcl",replace


**STEP 16: COX PH MODEL OF DEMENTIA STATUS VS. MORTALITY BY LONELINESS TERTILE****

capture drop loneliness_tottert
xtile loneliness_tottert=loneliness_tot if sample_final==1,nq(3)

save, replace

************************FIRST LONELINESS TERTILE***************************************

***MODEL 1****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==1
	
}

foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==1
	
}


***MODEL 2****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==1
	
}


foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==1
	
}



************************SECOND LONELINESS TERTILE***************************************

***MODEL 1****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==2
	
}


foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==2
	
}


***MODEL 2****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==2
	
}


foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==2
	
}


************************THIRD LONELINESS TERTILE***************************************

***MODEL 1****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==3
	
}


foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite if loneliness_tottert==3
	
}

***MODEL 2****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==3
	
}


foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox `x' AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 if loneliness_tottert==3
	
}

**************************************INTERACTION WITH LONELINESS TERTILE**********************************


***MODEL 1****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.loneliness_tottert AGE2010 SEX NonWhite 
	
}


***MODEL 1****
foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.loneliness_tottert AGE2010 SEX NonWhite 
	
}

***MODEL 2****
foreach x of varlist  lnhurd_odds lnexpert_odds lnlasso_odds {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.loneliness_tottert AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 
	
}



foreach x of varlist  hurd_dem expert_dem lasso_dem {
mi estimate: svy, subpop(sample_final): stcox c.`x'##c.loneliness_tottert AGE2010 SEX NonWhite i.education  i.totwealth_2010 i.marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010 cesd_2010 
	
}

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLE4.smcl",replace


**STEP 17: TABLE 3: MED4WAY FOR LONELINESS AS EXPOSURE, DIFFERENT PROBABILITIES OF DEMENTIA AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: FULL MODEL; OVERALL AND STRATIFIED BY SEX AND BY RACE/ETHNICITY***

**COVARIATES: NonWhite AGE2010 SEX  i.education  i.totwealth_2010 marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010

use finaldata_imputed_FINAL,clear



capture drop lnhurd_odds
mi passive: gen lnhurd_odds=ln((hurd_p)/(1-hurd_p))

capture drop lnexpert_odds
mi passive: gen lnexpert_odds=ln((expert_p)/(1-expert_p))


capture drop lnlasso_odds
mi passive: gen lnlasso_odds=ln((lasso_p)/(1-lasso_p))


capture drop Men
mi passive: gen Men=1 if SEX==1 & sample_final==1
mi passive: replace Men=0 if Men~=1 & SEX~=. & sample_final==1

capture drop Women
mi passive: gen Women=1 if SEX==2 & sample_final==1
mi passive: replace Women=0 if Women~=1 & SEX~=. & sample_final==1

capture drop NHW
mi passive: gen NHW=1 if RACE_ETHN==1 & sample_final==1
mi passive: replace NHW=0 if NHW~=1 & RACE_ETHN~=. & sample_final==1

capture drop NHB
mi passive: gen NHB=1 if RACE_ETHN==2 & sample_final==1
mi passive: replace NHB=0 if NHB~=1 & RACE_ETHN~=. & sample_final==1


capture drop HISP
mi passive: gen HISP=1 if RACE_ETHN==3 & sample_final==1
mi passive: replace HISP=0 if HISP~=1 & RACE_ETHN~=. & sample_final==1 


capture drop OTHER
mi passive: gen OTHER=1 if RACE_ETHN==4 & sample_final==1
mi passive: replace OTHER=0 if OTHER~=1 & RACE_ETHN~=. & sample_final==1


capture drop NonWhite
mi passive: gen NonWhite=0 if RACE_ETHN==1 & sample_final==1
mi passive: replace NonWhite=1 if RACE_ETHN!=1 & RACE_ETHN!=. & sample_final==1

save, replace

capture mi stset ageevent [pweight = kwgtr] if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) id(HHIDPN) scale(1)

capture drop educationg* totalwealth_2010g* marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g*

tab education,generate(educationg)

tab totwealth_2010, generate(totalwealth_2010g)

tab marital_2010, generate(marital_2010g)

tab smoking_2010, generate(smoking_2010g)

tab physic_act_2010, generate(physic_act_2010g)

tab srh_2010, generate(srh_2010g)

tab bmibr_2010, generate(bmibr_2010g)
 
tab cardiometcondbr_2010, generate(cardiometcondbr_2010g)



***************************TABLE 4: MODEL 2*********************************

*****************************OVERALL*******************************
capture drop zloneliness_tot 
capture drop zlnhurd_odds 
capture drop zlnexpert_odds 
capture drop zlnlasso_odds 
capture drop zcesd_2010
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds cesd_2010 {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



*****************************MEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if SEX==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


*****************************WOMEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if SEX==2 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***************************NHW*****************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if NonWhite==0 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



***************************Non-White*************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if NonWhite==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

save finaldata_imputed_FINAL, replace




capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLE5.smcl",replace


**STEP 17: TABLE 5: MED4WAY FOR DIFFERENT PROBABILITIES OF DEMENTIA AS EXPOSURE, LONELINESS AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: FULL MODEL BY SEX AND BY RACE/ETHNICITY***


use finaldata_imputed_FINAL,clear

*****************************OVERALL*******************************
capture drop zloneliness_tot 
capture drop zlnhurd_odds 
capture drop zlnexpert_odds 
capture drop zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



*****************************MEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if SEX==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


*****************************WOMEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if SEX==2 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***************************NHW*****************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if NonWhite==0 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



***************************Non-White*************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg* totwealth_2010 marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g* zcesd_2010 if NonWhite==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


save, replace

capture log close


********************************************************SENSITIVITY ANALYSIS: REDUCED MODELS***********************************************

capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLES3.smcl",replace


**STEP 18: TABLE 3: MED4WAY FOR LONELINESS AS EXPOSURE, DIFFERENT PROBABILITIES OF DEMENTIA AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: FULL MODEL; OVERALL AND STRATIFIED BY SEX AND BY RACE/ETHNICITY***

**COVARIATES: NonWhite AGE2010 SEX  i.education  i.totwealth_2010 marital_2010 work_st_2010 i.smoking_2010 physic_act_2010 i.srh_2010  i.bmibr_2010 cardiometcondbr_2010

use finaldata_imputed_FINAL,clear


capture drop lnhurd_odds
mi passive: gen lnhurd_odds=ln((hurd_p)/(1-hurd_p))

capture drop lnexpert_odds
mi passive: gen lnexpert_odds=ln((expert_p)/(1-expert_p))


capture drop lnlasso_odds
mi passive: gen lnlasso_odds=ln((lasso_p)/(1-lasso_p))


capture drop Men
mi passive: gen Men=1 if SEX==1 & sample_final==1
mi passive: replace Men=0 if Men~=1 & SEX~=. & sample_final==1

capture drop Women
mi passive: gen Women=1 if SEX==2 & sample_final==1
mi passive: replace Women=0 if Women~=1 & SEX~=. & sample_final==1

capture drop NHW
mi passive: gen NHW=1 if RACE_ETHN==1 & sample_final==1
mi passive: replace NHW=0 if NHW~=1 & RACE_ETHN~=. & sample_final==1

capture drop NHB
mi passive: gen NHB=1 if RACE_ETHN==2 & sample_final==1
mi passive: replace NHB=0 if NHB~=1 & RACE_ETHN~=. & sample_final==1


capture drop HISP
mi passive: gen HISP=1 if RACE_ETHN==3 & sample_final==1
mi passive: replace HISP=0 if HISP~=1 & RACE_ETHN~=. & sample_final==1 


capture drop OTHER
mi passive: gen OTHER=1 if RACE_ETHN==4 & sample_final==1
mi passive: replace OTHER=0 if OTHER~=1 & RACE_ETHN~=. & sample_final==1


capture drop NonWhite
mi passive: gen NonWhite=0 if RACE_ETHN==1 & sample_final==1
mi passive: replace NonWhite=1 if RACE_ETHN!=1 & RACE_ETHN!=. & sample_final==1

save, replace



capture mi stset ageevent [pweight = kwgtr] if sample_final==1, failure(died==1) enter(AGE2010) origin(AGE2010) id(HHIDPN) scale(1)

capture drop educationg* totalwealth_2010g* marital_2010g* smoking_2010g* physic_act_2010g* srh_2010g* bmibr_2010g*  cardiometcondbr_2010g*

tab education,generate(educationg)

tab totwealth_2010, generate(totalwealth_2010g)

tab marital_2010, generate(marital_2010g)

tab smoking_2010, generate(smoking_2010g)

tab physic_act_2010, generate(physic_act_2010g)

tab srh_2010, generate(srh_2010g)

tab bmibr_2010, generate(bmibr_2010g)
 
tab cardiometcondbr_2010, generate(cardiometcondbr_2010g)



***************************TABLE S3: MODEL 1*********************************

*****************************OVERALL*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds 
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite   if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



*****************************MEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite   if SEX==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


*****************************WOMEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite   if SEX==2 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***************************NHW*****************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite   if NonWhite==0 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



***************************Non-White*************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way zloneliness_tot `m' AGE2010 SEX NonWhite   if NonWhite==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

save finaldata_imputed_FINAL, replace

capture log close

**STEP 19: TABLE S4: MED4WAY FOR DIFFERENT PROBABILITIES OF DEMENTIA AS EXPOSURE, LONELINESS AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: FULL MODEL BY SEX AND BY RACE/ETHNICITY***

**************MODEL 1*****************************

capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\TABLES4.smcl",replace

use finaldata_imputed_FINAL,clear



*****************************OVERALL*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



*****************************MEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   if SEX==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


*****************************WOMEN*******************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   if SEX==2 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***************************NHW*****************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}



foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   if NonWhite==0 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}



***************************Non-White*************************************
capture drop zloneliness_tot zlnhurd_odds zlnexpert_odds zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   if NonWhite==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


save, replace

capture log close


*******************************************************************************************


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE3A_SENSITIVITY.smcl",replace


**MED4WAY FOR DIFFERENT PROBABILITIES OF DEMENTIA AS EXPOSURE, LONELINESS AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: REDUCED MODEL + EACH SES, LIFESTYLE AND HEALTH-RELATED FACTORS***


use finaldata_imputed_FINAL,clear

*****************************OVERALL*******************************
capture drop zloneliness_tot 
capture drop zlnhurd_odds 
capture drop zlnexpert_odds 
capture drop zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


***MODEL 1A************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  educationg*  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***MODEL 1B************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  totwealth_2010  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***MODEL 1C************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  marital_2010g*  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1D************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  smoking_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1E************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  physic_act_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1F************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  srh_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1G************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite   bmibr_2010g*   if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1H************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  cardiometcondbr_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1I************

foreach x of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way `x' zloneliness_tot  AGE2010 SEX NonWhite  zcesd_2010 if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}




capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE3B_SENSITIVITY.smcl",replace


**MED4WAY FOR DIFFERENT PROBABILITIES OF DEMENTIA AS EXPOSURE, LONELINESS AS MEDIATORS, AND ALL-CAUSE DEATH AS OUTCOME: REDUCED MODEL + EACH SES, LIFESTYLE AND HEALTH-RELATED FACTORS***


use finaldata_imputed_FINAL,clear

*****************************OVERALL*******************************
capture drop zloneliness_tot 
capture drop zlnhurd_odds 
capture drop zlnexpert_odds 
capture drop zlnlasso_odds
foreach x of varlist loneliness_tot lnhurd_odds lnexpert_odds lnlasso_odds {
	mi passive: egen z`x'=std(`x') if sample_final==1
}


***MODEL 1A************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'  AGE2010 SEX NonWhite  educationg*  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***MODEL 1B************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'   AGE2010 SEX NonWhite  totwealth_2010  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


***MODEL 1C************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'  AGE2010 SEX NonWhite  marital_2010g*  if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1D************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'   AGE2010 SEX NonWhite  smoking_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1E************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'   AGE2010 SEX NonWhite  physic_act_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1F************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'  AGE2010 SEX NonWhite  srh_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1G************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'   AGE2010 SEX NonWhite   bmibr_2010g*   if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1H************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'   AGE2010 SEX NonWhite  cardiometcondbr_2010g* if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}

***MODEL 1I************

foreach m of varlist zlnhurd_odds zlnexpert_odds zlnlasso_odds {
mi estimate, cmdok esampvaryok: med4way  zloneliness_tot `m'  AGE2010 SEX NonWhite  zcesd_2010 if sample_final==1 , a0(0) a1(1) m(0) yreg(cox) mreg(linear) 
}


capture log close
capture log using "E:\HRS_MANUSCRIPT_MICHAEL\OUTPUT\FIGURE3A_SENSITIVITY_FIG.smcl",replace

use FIGURE3A_DEMENTIA_TE,clear

************************************FIGURE 3*****************************************************************

**1=Reduced
**2=Reduced+Education
**3=Reduced+Wealth/Income
**4=Reduced+Marital Status
**5=Reduced+Smoking Status
**6=Reduced+Physical Activity
**7=Reduced+Self-Rated Health 2010
**8=Reduced+BMIBR 2010
**9=Reduced+cardiometcondbr_2010
**10=Reduced+zcesd_2010


capture label drop MODELlab
label define MODELlab 1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010" 

capture drop algorithm_num
gen algorithm_num=.
replace algorithm_num=1 if algorithm=="Hurd"
replace algorithm_num=2 if algorithm=="Expert"
replace algorithm_num=3 if algorithm=="LASSO"

capture drop ID
gen ID=.
replace ID=algorithm_num*100+model_num

**Hurd algorithm**

twoway rcap te_lcl	te_ucl model_num if algorithm_num==1,  title("TE") ytitle(TE OF DEMENTIA) xtitle("Model/Hurd") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==1 

graph save FIGURE3A1_DEMENTIAHURD.gph,replace



**Expert**
twoway rcap te_lcl	te_ucl model_num if algorithm_num==2, title("TE") ytitle(TE OF DEMENTIA) xtitle("Model/Expert") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==2 

graph save FIGURE3A2_DEMENTIAEXPERT.gph,replace


**LASSO**
twoway rcap te_lcl	te_ucl model_num if algorithm_num==3, title("TE") ytitle(TE OF DEMENTIA) xtitle("Model/LASSO") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==3

graph save FIGURE3A3_DEMENTIALASSO.gph,replace

save, replace


***********************TOTAL EFFECT OF LONELINESS****************************

use FIGURE3B_LONELINESS_TE,clear


**Hurd algorithm**

twoway rcap te_lcl	te_ucl model_num if algorithm_num==1,  title("TE") ytitle(TE OF LONELINESS) xtitle("Model/Hurd") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==1 

graph save FIGURE3A1_LONELINESSHURD.gph,replace


**Expert**
twoway rcap te_lcl	te_ucl model_num if algorithm_num==2, title("TE") ytitle(TE OF LONELINESS) xtitle("Model/Expert") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==2 

graph save FIGURE3A2_LONELINESSEXPERT.gph,replace


**LASSO**
twoway rcap te_lcl	te_ucl model_num if algorithm_num==3, title("TE") ytitle(TE OF LONELINESS) xtitle("Model/LASSO") xlab(1 "Reduced" 2 "Reduced+Education" 3 "Reduced+Wealth/Income" 4 "Reduced+Marital Status" 5 "Reduced+Smoking Status" 6 "Reduced+Physical Activity" 7 "Reduced+Self-Rated Health 2010" 8 "Reduced+BMIBR 2010" 9 "Reduced+cardiometcondbr_2010" 10 "Reduced+zcesd_2010", angle(90))  || scatter te_estimate model_num if algorithm_num==3

graph save FIGURE3A3_LONELINESSLASSO.gph,replace



cd "E:\HRS_MANUSCRIPT_MICHAEL\FINAL_DATA"

************************REVISION****************************

use HRS_PROJECTSLEEPCONGMORT_finWIDE,clear

svyset secu [pweight=mwgtr], strata(stratum) 

svy, subpop(sample_final): prop r10nrshom 