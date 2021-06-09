
////////////////////////////////////////
***Choose outcomevar
*(NOT USED as "global" but keep it as a list of outcomes)
* in-kind benefits and health 
global outcome "oldage_inkind" //  in-kind benefits for elderly
global outcome "soexp_health" //  social expenditure for health

* LFP for 50-59
global outcome "lfp_50to54_fe" // labor force participation 50-54, female
global outcome "lfp_55to59_fe" // labor force participation 55-59, female
global outcome "d_lfp_50to54_fe" //  diff of labor force participation 50-54 - 45-49, female
global outcome "d_lfp_55to59_fe" //  diff of labor force participation 55-59 - 45-49, female
global outcome "demean_lfp_50to54_fe" // demeaned
global outcome "demean_lfp_55to59_fe" // demeaned
global outcome "demean_d_lfp_55to59_fe" //  diff of demeaned labor force participation 55-59 - 45-49, female
global outcome "demean_d_lfp_50to54_fe" //  diff of demeaned labor force participation 50-54 - 45-49, female
////////////////////////////////////////

foreach name in /* oldage_inkind soexp_health lfp_50to54_fe lfp_55to59_fe*/ /*d_lfp_50to54_fe d_lfp_55to59_fe demean_lfp_50to54_fe demean_lfp_55to59_fe  demean_d_lfp_50to54_fe*/ demean_d_lfp_55to59_fe{
 
global outcome "`name'" 

**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

*date setup: how to construct dataset depends on missing values in each outcome variables. 
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup_RR2/synth_$outcome.do"


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
 putexcel set "post_synth/twoway/post_synth_RR2_$outcome.xlsx", replace
 putexcel A1 = ("Year") B1 = ("Y_treated") C1 = ("Y_synth") D1 = ("Y_synth_dr1") E1 = ("Y_synth_dr2")
*Y trated
 putexcel A2 = matrix(e(Y_treated)), rownames
*Y synth
 putexcel C2 = matrix(e(Y_synthetic))

 **save post synth results
 do "do/post_synth_RR2.do"
 
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
global treated "$treated_id_minus1" // Japan  -1
global counit "1(1)$treated_id_minus2" // -2

*log using log/_$donor/_$outcome.log, overwrite

*synth
 synth $outcome $pred_lag $pred_covar $pred_covar_gr, xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/synth_$outcome, replace) 

*save Y_synth for graph
 putexcel set "post_synth/twoway/post_synth_RR2_$outcome.xlsx", modify
 putexcel D2=matrix(e(Y_synthetic)) 

*save tables and graphs
do "do/post_synth_RR2.do"

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
global treated "$treated_id_minus2" // Japan -2
global counit "1(1)$treated_id_minus3" // -3

*log using log/_$donor/_$outcome.log, overwrite

*synth 
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/synth_$outcome, replace) 
 
*save Y_synth for graph
putexcel set "post_synth/twoway/post_synth_RR2_$outcome.xlsx", modify
putexcel E2=matrix(e(Y_synthetic)) 

*save tables and graphs
do "do/post_synth_RR2.do"

////////////////////////////////////////////////////////////////////
 *Graph Case 1-3
////////////////////////////////////////////////////////////////////

do "do/twoway_graph_RR2.do"
}
