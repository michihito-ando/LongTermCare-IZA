***Memo
*no "nested allopt" is used to avoid error and minimize estimation time
*set "graph" folder > "_LOO_placebo" folder > "_`outcome`" folders.

foreach name in oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc /*lfp_40to44_fe lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe d_lfp_50to54_fe d_lfp_55to59_fe*/{

global outcome "`name'" 

**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

*date setup
do "do/data_setup.do"  

*synth outcome setup
do "do/synth_y_setup/synth_$outcome.do" 

////////////////////////////////////////////////////////////////////
 *Case 4: Leave-one-out synth for Japan
 *not use nested and allopt due to save time and avoid opt. error
////////////////////////////////////////////////////////////////////

*Do from the begining then stop 

*log using log/_$donor/_$outcome.log, replace

*define donor pool setting
global donor "LOO_placebo"  // changed from Case 1: leave one out placebo

save "post_synth/_$donor/id_case1_$outcome", replace // baseline sample used for permutation and resampling

**baseline case: use full (case1) donor pool, not Jacknife-type

*synth, no nested and allopt
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig /*nested allopt*/ ///
 keep(post_synth/_$donor/synth_$outcome, replace) 

*gen gap data
use "post_synth/_$donor/synth_$outcome",clear
tsset _time
drop _Co_Number _W_Weight
gen gap = _Y_treated - _Y_synthetic 

*gen average gap
egen gap_mean_pre = mean(gap) if _time < $t_year // average gap before intervention
egen gap_mean_post = mean(gap) if _time >=  $t_year // average gap after intervention
replace gap_mean_post = f.gap_mean_post if _time == $pre_t_year // put the value of gap_mean_post into $pre_t_year (later we keep only $pre_t_year)

*gen gap just before intervention
gen gap_pre_year = gap if _time == $pre_t_year // gap just before intervention

*gen MSPE (mean squared prediction error
egen mspe_pre = mean(gap^2) if _time < $t_year // MSPE before intervention
egen mspe_post =mean(gap^2) if _time >= $t_year // MSPE after intervention
replace mspe_post = f.mspe_post if _time == $pre_t_year // put the value of mspe_post into $pre_t_year (later we keep only $pre_t_year)

*gen id and dropped_id variables
gen id_treated = $treated_id // Japan
gen id_drop = 0  // dropped country

*keep only $pre_t_year
keep if _time == $pre_t_year   // keep only one row
drop _Y_treated _Y_synthetic gap _time // drop unnecessry variables

*gen three test statistics
gen pre_post_diff = gap_mean_post - gap_mean_pre
gen pre_post_diff2 = gap_mean_post - gap_pre_year
gen mspe_ratio = mspe_post / mspe_pre

*save
save  "post_synth/_$donor/gap_$outcome", replace // Generate the "gap" file to which the permutation results are appended. 

**Permutation: drop one donor

	forvalues dr_i = 1(1)$treated_id_minus1{ //  -1
*data
use "post_synth/_$donor/id_case1_$outcome",clear // Use the baseline sample for Leave-one-out resampling
*drop one country and regenerate id (perm_id)
drop if id_case1 == `dr_i'
egen perm_id = group(idn) // based on idn, Japan gets the last number of perm_id = 13
list perm_id Country year $outcome if year == 2001
tsset perm_id year

*redefine global
global treated "$treated_id_minus1" // Japan,  - 1 
global counit "1(1)$treated_id_minus2" //   - 2

*synth
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig /*nested allopt*/ ///
 keep(post_synth/_$donor/synth_$outcome, replace) 
 
  graph save "graph/_$donor/_$outcome/synth_drop_`dr_i'.gph", replace

*gen gap data
use "post_synth/_$donor/synth_$outcome",clear
tsset _time
drop _Co_Number _W_Weight
gen gap = _Y_treated - _Y_synthetic 

*gen average gap
egen gap_mean_pre = mean(gap) if _time < $t_year // average gap before intervention
egen gap_mean_post = mean(gap) if _time >=  $t_year // average gap after intervention
replace gap_mean_post = f.gap_mean_post if _time == $pre_t_year // put the value of gap_mean_post into $pre_t_year (later we keep only $pre_t_year)

*gen gap just before intervention
gen gap_pre_year = gap if _time == $pre_t_year // gap just before intervention

*gen MSPE (mean squared prediction error
egen mspe_pre = mean(gap^2) if _time < $t_year // MSPE before intervention
egen mspe_post =mean(gap^2) if _time >= $t_year // MSPE after intervention
replace mspe_post = f.mspe_post if _time == $pre_t_year // put the value of mspe_post into $pre_t_year (later we keep only $pre_t_year)

*gen id and dropped_id variables
gen id_treated = $treated_id // Japan,  15th countries in the full sample
gen id_drop = `dr_i'  // dropped country

*keep only $pre_t_year
keep if _time == $pre_t_year   // keep only one row
drop _Y_treated _Y_synthetic  gap _time // drop unnecessry variables

*gen three test statistics
gen pre_post_diff = gap_mean_post - gap_mean_pre
gen pre_post_diff2 = gap_mean_post - gap_pre_year
gen mspe_ratio = mspe_post / mspe_pre

*Append
append using "post_synth/_$donor/gap_$outcome"
save  "post_synth/_$donor/gap_$outcome", replace
}

*log close

**Check 
sort id_drop
twoway (scatter gap_mean_pre id_drop) (scatter gap_pre_year id_drop) ///
			(scatter gap_mean_post id_drop), yline(0)
twoway (scatter pre_post_diff id_drop) (scatter pre_post_diff2 id_drop) 

			
 ////////////////////////////////////////////////////////////////////
 *Case 5: LOO (leave-one-out) synth for the other countries
  ////////////////////////////////////////////////////////////////////

 ****************************OLD MEMOS*********************************
 ***NOTICE In Case 5, post-synth results are directly appended to the results of Case 4. 
 ***So any mistakes in Case 5 contaminates the appended file. 
 ***Hence in case of re-analysis of the same tr_i and dr_i in Case 5,  delete all the results with id_treated != 17
 ***To delete, use the following commands carefully:
	*use  "post_synth/_$donor/gap_$outcome", clear
	*keep if id_treated == 17 // Japan,  17th countries in the full sample
	*save  "post_synth/_$donor/gap_$outcome", replace


*Do from the begining then stop 
*log using log/_$donor/no_japan_$outcome.log, replace
 ****************************OLD MEMOS*********************************


*date setup
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup/synth_$outcome.do"
*drop Japan for LOO placebo
drop if idn == 21

*define donor pool setting
global donor "LOO_placebo"  // changed from Case 1: leave one out placebo

save "post_synth/_$donor/no_japan_$outcome", replace // Baseline sample used for permucation and resampling

**Permutation: decide  a treated country

forvalues tr_i = 1(1)$treated_id_minus1 { // Last tr_i,  -1
	forvalues dr_i = 1(1)$treated_id_minus2 {  // Last dr_i , -2
*data
use "post_synth/_$donor/no_japan_$outcome",clear // Use the baseline sample for jacknife-type resampling
*set aside treated unit
egen synth_id = group(idn) if id_case1!=`tr_i'   // idn `tr_i' = treated unit
replace synth_id = $treated_id_minus1 if id_case1 == `tr_i'  // Set the synth_id of the treated unit as the last ID. ,  $treated - 1
label values synth_id id

**redefine panel**
tsset synth_id year

*replace idn = synth_id    /*just in order to check easily on the table*/
*label values idn  id 

**redefine panel**
*tsset idn year

list synth_id idn Country id if year == 2000

**Leave one out: drop one country and regenerate id (perm_id)

drop if synth_id == `dr_i'
egen perm_id = group(synth_id) // generate new ID for synth after dropping one country of `dr_i' based on the order of synth_id, where the treated country `tr_i' has the last ID.
list perm_id synth_id idn Country year $outcome  if year == 2001
tsset perm_id year

*redefine global
global treated "$treated_id_minus2" // 'tr_i' country  - 2 
global counit "1(1)$treated_id_minus3" ///  - 3

*synth
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  fig /*nested allopt*/ ///
 keep(post_synth/_$donor/synth_$outcome, replace) 
 
graph save "graph/_$donor/_$outcome/synth_`tr_i'_`dr_i'.gph", replace

*gen gap data
use "post_synth/_$donor/synth_$outcome",clear
tsset _time
drop _Co_Number _W_Weight
gen gap = _Y_treated - _Y_synthetic 

*gen average gap
egen gap_mean_pre = mean(gap) if _time < $t_year // average gap before intervention
egen gap_mean_post = mean(gap) if _time >=  $t_year // average gap after intervention
replace gap_mean_post = f.gap_mean_post if _time == $pre_t_year // put the value of gap_mean_post into $pre_t_year (later we keep only $pre_t_year)

*gen gap just before intervention
gen gap_pre_year = gap if _time == $pre_t_year // gap just before intervention

*gen MSPE (mean squared prediction error
egen mspe_pre = mean(gap^2) if _time < $t_year // MSPE before intervention
egen mspe_post =mean(gap^2) if _time >= $t_year // MSPE after intervention
replace mspe_post = f.mspe_post if _time == $pre_t_year // put the value of mspe_post into $pre_t_year (later we keep only $pre_t_year)

*gen id and dropped_id variables
gen id_treated = `tr_i'  // dropped country based on id_case1
gen id_drop = `dr_i'  // dropped country based on synth_id

*keep only $pre_t_year
keep if _time == $pre_t_year   // keep only one row
drop _Y_treated _Y_synthetic  gap _time // drop unnecessry variables

*gen three test statistics
gen pre_post_diff = gap_mean_post - gap_mean_pre
gen pre_post_diff2 = gap_mean_post - gap_pre_year
gen mspe_ratio = mspe_post / mspe_pre

*Append
append using "post_synth/_$donor/gap_$outcome"
save  "post_synth/_$donor/gap_$outcome", replace
  }
 }
}
