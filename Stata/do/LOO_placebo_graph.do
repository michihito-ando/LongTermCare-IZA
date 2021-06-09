

foreach name in oldage_inkind  oldage_inkind_pc soexp_health soexp_health_pc lfp_40to44_fe lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe d_lfp_50to54_fe d_lfp_55to59_fe{
 
global outcome "`name'" 

***Choose outcomevar
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

/////////////////
*placebo Graph
///////////////////

**redefine global 
global donor "LOO_placebo"
global treated "$treated_id" // Japan, Original treated number I

**Check 
use "post_synth/_$donor/gap_$outcome", clear

sort id_treated id_drop

*four statistics
sum gap_mean_post pre_post_diff pre_post_diff2 mspe_ratio

gen y_for_gap = .  // Y position for circles

**graph setting for each outcome

global y_for_gap = 30
global ylabel "0(10)30"

if "$outcome" == "oldage_inkind"{
global start "-1.05"
global width "0.1"
global xlabel "-1(0.2)1"
}

else if "$outcome" == "soexp_health"{
global start "-3.9"
global width "0.2"
global xlabel "-2(1)2"
}  

else if "$outcome" == "lfp_40to44_fe"{
global start "-15"
global width "2"
global xlabel "-14(2)10"
}  


else if "$outcome" == "lfp_45to49_fe"{
global start "-15"
global width "2"
global xlabel "-14(2)10"
} 

else if "$outcome" == "lfp_50to54_fe"{
global start "-15"
global width "2"
global xlabel "-14(2)10"
} 

else if "$outcome" == "lfp_55to59_fe"{
global start "-15"
global width "2"
global xlabel "-14(2)10"
} 


else if "$outcome" == "d_lfp_50to54_fe"{
global start "-7.25"
global width "0.5"
global xlabel "-6(2)4"
} 

else if "$outcome" == "d_lfp_55to59_fe"{
global start "-13"
global width "2"
global xlabel "-12(2)10"
} 

if "$outcome" == "oldage_inkind_pc"{ // 190705
global start ""
global width ""
global xlabel ""
}

else if "$outcome" == "soexp_health_pc"{  // 190705
global start ""
global width ""
global xlabel ""
}  

replace y_for_gap = $y_for_gap  // Y position for circles

*scatter y_for_gap gap_mean_post if id_treated == 10 & id_drop == 0

** PDF not used in the paper

*test statistic 1, auto-made
twoway (hist gap_mean_post if id_treated != $treated_id, percent)  ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large)  mcolor(black)) ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)),  ///
 legend(lab(1 "Placebo distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny)) ///
ytitle(Percent) xtitle(Test statistic 1)  xline(0)  graphregion(color(white))  

*test statistic 1  gap_mean_post
twoway (hist gap_mean_post if id_treated != $treated_id, percent start($start) width($width)) ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large)  mcolor(black)) ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle(Percent) xtitle(Test statistic 1)  xline(0) ylabel($ylabel) xlabel($xlabel) graphregion(color(white))  saving($pc/graph/_$donor/_$outcome/test1,replace)

*test statistic 2 pre_post_diff
twoway (hist pre_post_diff if id_treated != $treated_id, percent  start($start) width($width))  ///
 (scatter y_for_gap pre_post_diff if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap pre_post_diff if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle(Percent) xtitle(Test statistic 2)  xline(0) ylabel($ylabel) xlabel($xlabel) graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/test2,replace)

*test statistic 3 pre_post_diff2 
twoway (hist pre_post_diff2 if id_treated != $treated_id, percent start($start) width($width))  ///
 (scatter y_for_gap pre_post_diff2 if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap pre_post_diff2 if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle(Percent) xtitle(Test statistic 3) xline(0) ylabel($ylabel) xlabel($xlabel) graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/test3,replace)


grc1leg  "$pc/graph/_$donor/_$outcome/test1.gph" "$pc/graph/_$donor/_$outcome/test2.gph" ///
"$pc/graph/_$donor/_$outcome/test3.gph", col(1) iscale(0.6) fxsize(80) ycommon xcommon graphregion(color(white)) 
graph save    "$pc/graph/_$donor/_$outcome/LOO_plcb_$outcome",replace
graph export  "$pc/graph/_$donor/pdf/LOO_plcb_$outcome.pdf",replace

*test statistic 4 mspe ratio 
twoway (hist mspe_ratio if id_treated != $treated_id, percent bin(20) /*start($start) width($width)*/ )  ///
 (scatter y_for_gap mspe_ratio if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap mspe_ratio if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle(Percent) xtitle(Test statistic 4 (MSPE ratio))/*ylabel($ylabel) xlabel($xlabel)*/ graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/mspe_ratio,replace)

graph export  "$pc/graph/_$donor/pdf/LOO_plcb_mspe_r_$outcome.pdf",replace

***CDF used in the paper
replace y_for_gap = 1  // Y position for circles

cumul gap_mean_post if id_treated != $treated_id, gen(gap_mean_post_cum)
cumul pre_post_diff if id_treated != $treated_id, gen(pre_post_diff_cum)
cumul pre_post_diff2 if id_treated != $treated_id, gen(pre_post_diff2_cum)
cumul mspe_ratio if id_treated != $treated_id, gen(mspe_ratio_cum)

*test statistic 1  gap_mean_post
twoway (line gap_mean_post_cum gap_mean_post if id_treated != $treated_id, sort) ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large)  mcolor(black)) ///
 (scatter y_for_gap gap_mean_post if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo cumulative distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle() xtitle(Test statistic 1)  xline(0) /*ylabel($ylabel) xlabel($xlabel)*/ graphregion(color(white))  saving($pc/graph/_$donor/_$outcome/test1_cum,replace)

*test statistic 2 pre_post_diff
twoway (line pre_post_diff_cum pre_post_diff if id_treated != $treated_id, sort)  ///
 (scatter y_for_gap pre_post_diff if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap pre_post_diff if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo cumulative distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle() xtitle(Test statistic 2)  xline(0) /*ylabel($ylabel) xlabel($xlabel)*/  graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/test2_cum,replace)


*test statistic 3 pre_post_diff2 
twoway (line pre_post_diff2_cum pre_post_diff2 if id_treated != $treated_id, sort)  ///
 (scatter y_for_gap pre_post_diff2 if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap pre_post_diff2 if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo cumulative distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle() xtitle(Test statistic 3) xline(0) /*ylabel($ylabel) xlabel($xlabel)*/  graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/test3_cum,replace)

*test statistic 4 mspe ratio 
twoway (line mspe_ratio_cum mspe_ratio if id_treated != $treated_id, sort)  ///
 (scatter y_for_gap mspe_ratio if id_treated == $treated_id & id_drop == 0, mfcolor(none) msize(large) mcolor(black)) ///
 (scatter y_for_gap mspe_ratio if id_treated == $treated_id & id_drop != 0, mfcolor(none) msize(small) mcolor(gs5)), ///
 legend(lab(1 "Placebo cumulative distribution") lab(2 "Baseline estimate") lab(3 "Leave-one-out estimate") row(1) size(tiny))  ///
ytitle() xtitle(Test statistic 4 (MSPE ratio)) /*ylabel($ylabel) xlabel($xlabel)*/  graphregion(color(white)) saving($pc/graph/_$donor/_$outcome/test4_cum,replace)


grc1leg  "$pc/graph/_$donor/_$outcome/test1_cum.gph" "$pc/graph/_$donor/_$outcome/test2_cum.gph" ///
"$pc/graph/_$donor/_$outcome/test3_cum.gph" "$pc/graph/_$donor/_$outcome/test4_cum.gph", col(2) iscale(0.7) fxsize(120) ycommon /*xcommon*/ graphregion(color(white)) 
graph save    "$pc/graph/_$donor/_$outcome/LOO_plcb_cum_$outcome",replace
graph export  "$pc/graph/_$donor/pdf/LOO_plcb_cum_$outcome.pdf",replace


}
