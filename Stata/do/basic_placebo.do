***Memo
*Only baseline SC estimation adopt "nested allopt", in order to avoid estimation time and optimization errors


foreach name in oldage_inkind oldage_inkind_pc soexp_health  soexp_health_pc /*lfp_40to44_fe lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe d_lfp_50to54_fe d_lfp_55to59_fe*/{
 
global outcome "`name'" 

***Choose outcome var
*global outcome "oldage_inkind" // 
*global outcome "soexp_health" // 
*global outcome "lfp_40to44_fe" // 
*global outcome "lfp_45to49_fe" // 
*global outcome "lfp_50to54_fe" // 
*global outcome "lfp_55to59_fe" // 
*global outcome "d_lfp_50to54_fe" // 
*global outcome "d_lfp_55to59_fe" // 

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

 //////////////////////////////////////////////////////////////
*Case 6.Basic Placebo test with graphs:
////////////////////////////////////////////////////////////

*Do from the begining then stop 

**redefine global
*log using log/_$donor/basic_plcb_$outcome.log, replace

global donor "basic_placebo"

*stop //=> Impement step1-step6 for placebo graphs. Implement step7 for pre/post mspe graphs

***step1: synth for "real treated"*

**baseline case: use full donor pool, not Jacknife-type

*redefine global
global treated "$treated_id" // Japan
*global counit => all the others

*synth
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  unitnames(Country)  fig nested allopt ///
 keep(post_synth/_$donor/_$outcome/treated, replace) 

***step2:synthetic control methods for all the municipalities in the donor pool*
*=>re-implement "redefine global" part  in case of synth optimication error

drop if id_case1 == $treated_id // drop Japan

forvalues i = 1(1)$treated_id_minus1 { // - 1

*redefine global
global treated "`i'" // 'tr_i' country
*global counit => all the others

*synth: controls are the other units than tr_i
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) ///
 resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)    unitnames(Country)  fig /*nested allopt*/ ///
 keep(post_synth/_$donor/_$outcome/control`i', replace) 
 }
		
***setp3: generate income gap of "real treated"*
use "post_synth/_$donor/_$outcome/treated", clear
        gen gap_treated=_Y_treated-_Y_synthetic
		drop _Co_Number _W_Weight _Y_treated _Y_synthetic
		drop if _time==.
        save "post_synth/_$donor/_$outcome/treated_gap", replace
	
*step4:calculate income gaps between a treated unit and a synthetic control unit*
 foreach i of numlist 1(1)$treated_id_minus1{ //  - 1
	    clear
        use "post_synth/_$donor/_$outcome/control`i'", clear
        gen gap`i'=_Y_treated-_Y_synthetic
		drop  _Co_Number _W_Weight _Y_treated _Y_synthetic
		drop if _time==.
        save "post_synth/_$donor/_$outcome/control_gap`i'", replace
		}
		
*step5:merge all the gaps*
 foreach i of numlist 1(1)$treated_id_minus1{ //  - 1
	  use "post_synth/_$donor/_$outcome/treated_gap", clear
      merge 1:1 _time using "post_synth/_$donor/_$outcome/control_gap`i'"
      drop _merge 
	  save "post_synth/_$donor/_$outcome/treated_gap", replace
	   }
save "post_synth/_$donor/_$outcome/basic_plcb_$outcome", replace

*step6: make a graph: select placebo becasue gap43 is not available*
tsset _time
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)
  
/*xlabel(1975(5)2000 1972) ylabel(-400(200)600) yscale(r(-400 600))*/

graph save Graph "graph/_$donor/basic_plcb_$outcome",replace
graph export  "graph/_$donor/basic_plcb_$outcome.pdf",replace


*step7: post/pre mspe graph

*data => need if you start from here
*use "post_synth/_$donor/_$outcome/basic_plcb_$outcome", clear

*check graph (again)
tsset _time
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)

*gen pre and post MSPE for placebo (NOT USED IN THE PAPER. We use only MSPE ratios with LOO placebo)
egen pre_mspe_treated_temp = mean(gap_treated^2) if _time < 2000
egen pre_mspe_treated = max(pre_mspe_treated_temp) 
drop pre_mspe_treated_temp

egen post_mspe_treated_temp = mean(gap_treated^2) if _time >= 2000
egen post_mspe_treated = max(post_mspe_treated_temp)
drop post_mspe_treated_temp

gen mspe_ratio_treated = post_mspe_treated / pre_mspe_treated

*gen pre and post MSPE for placebo (NOT USED IN THE PAPER. We use only MSPE ratios with LOO placebo)

foreach var of varlist gap1-gap$treated_id_minus1{
egen pre_mspe_`var'_temp = mean(`var'^2) if _time < 2000
egen pre_mspe_`var' = max(pre_mspe_`var'_temp) 
drop pre_mspe_`var'_temp

egen post_mspe_`var'_temp = mean(`var'^2) if _time >= 2000
egen post_mspe_`var' = max(post_mspe_`var'_temp)
drop post_mspe_`var'_temp

gen mspe_ratio_`var' = post_mspe_`var' / pre_mspe_`var'
}

keep _time mspe_ratio_treated mspe_ratio_gap*
keep if _time == 2011
drop _time
xpose, clear varname 
rename v1 mspe_ratio

export delimited "post_synth/_$donor/mspe_ratio/`name'.csv", replace

*graph

hist mspe_ratio, width(5) xlabel(0(50)350) ylabel(1(1)10) freq xtitle("post/pre-MSPE")  graphregion(color(white))
graph save Graph "graph/_$donor/mspe_ratio/mspe_r_$outcome",replace
graph export  "graph/_$donor/mspe_ratio/mspe_r_$outcome.pdf",replace
}


/*
*check MSPE
gen temp = gap_treated^2 
egen temp2 = mean(temp) if _time < 2000
egen temp3 = mean(temp) if _time >= 2000
drop temp*



