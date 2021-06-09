*start
***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"

*Additional missing countries: Austria Ireland Switzerland Finland


**Data setup
clear matrix
clear
set more off

**CD seting
*global pc "D:/Dropbox/2016LTCI_FISS/STATA"
global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

do "do/data_setup.do"

////////////////////
*Common global settings
////////////////////

*outcome
global outcome "lfp_35to39_fe"

*country
global country "Japan" // graph title

*year settings
global first_year "1986" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2013" // main
global t_year "2000" // Japan
global pre_t_year "1999" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992) $outcome(1993) $outcome(1994) $outcome(1995) $outcome(1996) $outcome(1997) $outcome(1998) $outcome(1999)"  

*normal covariates
global pred_covar "gdp_pc child elderly agriculture industry services"

*covariates growth
global pred_covar_gr "gr_gdp_pc gr_pop gr_child gr_elderly"

*check missing data 
list idn Country year $outcome inkind_sum 
list idn Country year $outcome /*inkind_sum*/  if year == 1980
list idn Country year $outcome /*inkind_sum*/  if year == 1984
list idn Country year $outcome /*inkind_sum*/  if year == 1985
list idn Country year $outcome /*inkind_sum*/  if year == 1986
list idn Country year $outcome /*inkind_sum*/  if year == 1987
list idn Country year $outcome /*inkind_sum*/  if year == 1990
list idn Country year $outcome inkind_sum  if year == 1993
list idn Country year $outcome inkind_sum  if year == 2001
list idn Country year $outcome /*inkind_sum*/  if year == 2011
list idn Country year $outcome /*inkind_sum*/  if year == 2012
list idn Country year $outcome /*inkind_sum*/  if year == 2013
xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 

/* Drop the following countries
     | idn          Country    id |
 527. |  10       Luxembourg   LUX |
 592. |  11      Netherlands 
  669. |  13           Norway
1067. |  20          Germany   DEU |
*/


*reset id number and panel setting
drop if idn == 10 | idn == 11 |  idn == 20 // excluding Luxembourg 10, Netherland 11,  Germany 20
drop if idn == 2 | idn == 6 | idn == 8 /*| idn == 12*/ | idn == 17 // Austria Ireland Finland (missing in 1980s) /*Newzeland start from 1986*/ Switzerland
egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global treated "14" // Japan
global counit "1(1)13"

stop

*=> Jump to Case 1~6

////////////////////
*Case 1: Full donor pool
////////////////////

*define donor pool
global donor "donors_all"  // just labelling


*log using log/_$donor/_$outcome.log, replace

**synth**
*allopt: full optimization
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/synth_$outcome, replace) 

**save Y_treated and Y_synth for graph
 putexcel set "post_synth/twoway/post_synth_$outcome.xlsx", replace
 putexcel A1 = ("Year") B1 = ("Y_treated") C1 = ("Y_synth") D1 = ("Y_synth_dr1") E1 = ("Y_synth_dr2")
*Y trated
 putexcel A2 = matrix(e(Y_treated)), rownames
*Y synth
 putexcel C2 = matrix(e(Y_synthetic))

 **save post synth results
 do "do/post_synth.do"
 
 *log close

////////////////////
*Case 2: Drop the hightest-weight control country in the 1st trial
////////////////////

*pick up and drop the highest-weight country in the case 1
matrix list e(W_weights)
matrix w_case1_ = e(W_weights)
matrix list w_case1_
svmat w_case1_   // put id and weights into dataset
egen max_w_case1 = max(w_case1_2) // copy max weight to all obs
gen max_id_case1_temp = w_case1_1 if w_case1_2 == max_w_case1 // identify id with max weight
egen max_id_case1 = max(max_id_case1_temp)  // copy id with max weight to all obs.
drop if id_case1 == max_id_case1  // *drop the highest-weight country in the case 1

*reset id number and panel setting
egen id_case2 = group(idn)
list Country idn id_case1 id_case2 if year == 2000
tsset id_case2 year

*redefine SC settings
global donor "donors_drop1"
global treated "13" // Japan
global counit "1(1)12"

*log using log/_$donor/_$outcome.log, overwrite

*synth no nested allopt
 synth $outcome $pred_lag $pred_covar $pred_covar_gr, xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/synth_$outcome, replace) 

*save Y_synth for graph
 putexcel set "post_synth/twoway/post_synth_$outcome.xlsx", modify
 putexcel D2=matrix(e(Y_synthetic)) 

*save tables and graphs
do "do/post_synth.do"

 ////////////////////////////////////////////////////////////////////
 *Case 3: Drop also the highest-weight control country in the 2nd trial
  ////////////////////////////////////////////////////////////////////

*pick up and drop the highest-weight country in the case 2
matrix list e(W_weights)
matrix w_case2_ = e(W_weights)
matrix list w_case2_
svmat w_case2_   // put id and weights into dataset
egen max_w_case2 = max(w_case2_2) // copy max weight to all obs
gen max_id_case2_temp = w_case2_1 if w_case2_2 == max_w_case2 // identify id with max weight
egen max_id_case2 = max(max_id_case2_temp)  // copy id with max weight to all obs.
drop if id_case2 == max_id_case2  // *drop the highest-weight country in the case 1

*reset id number and panel setting
egen id_case3 = group(idn)
list Country idn id_case1 id_case2 id_case3 if year == 2000
tsset id_case3 year
  
*redefine SC settings
global donor "donors_drop2"
global treated "12" // Japan
global counit "1(1)11"

*log using log/_$donor/_$outcome.log, overwrite

*synth no nested allopt
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/synth_$outcome, replace) 
 
*save Y_synth for graph
putexcel set "post_synth/twoway/post_synth_$outcome.xlsx", modify
putexcel E2=matrix(e(Y_synthetic)) 

*save tables and graphs
do "do/post_synth.do"

////////////////////////////////////////////////////////////////////
 *Graph Case 1-3
////////////////////////////////////////////////////////////////////

do "do/twoway_graph.do"

stop




