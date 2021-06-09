**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

////////////////////////////////
*Remake graphs
////////////////////////////////////

foreach name in "lfp_30to34_fe" "lfp_35to39_fe" "lfp_40to44_fe" /// LFP level, interval 5 years
				"lfp_45to49_fe" "lfp_50to54_fe" "lfp_55to59_fe" /// LFP level, interval 5 years
				"lfp_35to44_fe" "lfp_45to54_fe" "lfp_55to64_fe" /// LEP level,  interval 10 years
				"d_lfp_50to54_fe" "d_lfp_55to59_fe" "d_lfp_55to64_fe" /*"d_lfp_50to54_v2_fe" "d_lfp_55to59_v2_fe"*/ /// diff
				/*"emp_pop_25to54_fe" "emp_pop_55to64_fe"*/ { /// employment rate
				
***make title labels

*LFP level, intervel 5 years
if "`name'" == "lfp_30to34_fe"{
	local title "LFP (ages 30-34)"
}

else if "`name'" == "lfp_35to39_fe"{ 
	local title "LFP (ages 35-39)"
}

else if "`name'" == "lfp_40to44_fe"{ 
	local title "LFP (ages 40-44)"
}

else if "`name'" == "lfp_45to49_fe"{ 
	local title "LFP (ages 45-49)"
}

else if "`name'" == "lfp_50to54_fe"{ 
	local title "LFP (ages 50-54)"
}

else if "`name'" == "lfp_55to59_fe"{ 
	local title "LFP (ages 55-59)"
}

*LFP level, intervel 10 years
else if "`name'" == "lfp_35to44_fe"{ 
	local title "LFP (ages 35-44)"
}

else if "`name'" == "lfp_45to54_fe"{ 
	local title "LFP (ages 45-54)"
}

else if "`name'" == "lfp_55to64_fe"{ 
	local title "LFP (ages 55-64)"
}

*LFP level, diff
else if "`name'" == "d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
}

else if "`name'" == "d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
}

else if  "`name'" == "d_lfp_50to54_v2_fe"{
	local title "LFP(ages 50-54) - LFP(ages 40-44)"
}

else if  "`name'" == "d_lfp_55to59_v2_fe"{
	local title "LFP(ages 55-59) - LFP(ages 40-44)"
}
/*
*Employment rate
else if  "`name'" == "emp_pop_25to54_fe"{
	local title "Employment rate (ages 25-54)"
}
	
else if "`name'" == "emp_pop_55to64_fe"{
	local title "Employment rate (ages 55-64)"
}
*/
***Import data
import excel using "post_synth/twoway/post_synth_`name'.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3") size(small)) ///
 tline(2000) title(`title')  xtitle("Year")  xlabel(1985(5)2015)  graphregion(color(white))  

graph save Graph "graph/twoway/gph/synth_`name'",replace
graph export  "graph/twoway/pdf/synth_`name'.pdf",replace

}

** 5-year intervals
*combine six age cohort flp (5-year intervals)
grc1leg "graph/twoway/gph/synth_lfp_30to34_fe"  "graph/twoway/gph/synth_lfp_35to39_fe"  "graph/twoway/gph/synth_lfp_40to44_fe" "graph/twoway/gph/synth_lfp_45to49_fe" ///
		"graph/twoway/gph/synth_lfp_50to54_fe"  "graph/twoway/gph/synth_lfp_55to59_fe" , ///
		saving(graph/twoway/gph/combined_lfp_age5_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_age5_fe.pdf",replace

*combine four age cohort flp (5-year intervals)
grc1leg "graph/twoway/gph/synth_lfp_40to44_fe" "graph/twoway/gph/synth_lfp_45to49_fe" ///
		"graph/twoway/gph/synth_lfp_50to54_fe"  "graph/twoway/gph/synth_lfp_55to59_fe" , ///
		saving(graph/twoway/gph/combined_lfp_middle_fe, replace) iscale(0.5) xsize(10) ysize(15) ycommon rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_middle_fe.pdf",replace

*combine two age cohort flp (5-year intervals, 30-34, 35-39)
grc1leg "graph/twoway/gph/synth_lfp_30to34_fe"  "graph/twoway/gph/synth_lfp_35to39_fe", ///
		saving(graph/twoway/gph/combined_lfp_young_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_young_fe.pdf",replace


*combine two age cohort flp (diff)
grc1leg   "graph/twoway/gph/synth_d_lfp_50to54_fe"  "graph/twoway/gph/synth_d_lfp_55to59_fe" , ///
saving(graph/twoway/gph/combined_d_lfp_fe, replace) iscale(0.6)   xsize(5) ysize(2) ycommon rows(1) graphregion(color(white))
graph export  "graph/twoway/pdf/combined_d_lfp_fe.pdf",replace

**longer intervals
*combine three age cohort flp (10-year intervals)
grc1leg   "graph/twoway/gph/synth_lfp_35to44_fe"  "graph/twoway/gph/synth_lfp_45to54_fe" "graph/twoway/gph/synth_lfp_55to64_fe" , ///
	saving(graph/twoway/gph/combined_lfp_age10_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_age10_fe.pdf",replace


*combine two age cohort emp rate
grc1leg   "graph/twoway/gph/synth_emp_pop_25to54_fe"  "graph/twoway/gph/synth_emp_pop_55to64_fe", ///
	saving(graph/twoway/gph/combined_emp_rates_fe, replace) iscale(0.6) /*xsize(5) ysize(30)*/ ycommon rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_emp_rates_fe.pdf",replace



/*
***editing and combine three expenditure graphs
*In-kind benefits
grc1leg   "graph/twoway_Germany/synth_inkind_sum"  "graph/twoway_Japan/synth_inkind_sum" , title("A: In-kind benefits for the elderly and the disabled") ///
saving(graph/combined/combined_inkind_sum_t, replace) fxsize(100) fysize(100) ycommon graphregion(color(white)) graphregion(margin(zero)) 
*Cash benefits
grc1leg   "graph/twoway_Germany/synth_cash_sum"  "graph/twoway_Japan/synth_cash_sum" , title("B: Cash benefits for the elderly and the disabled") ///
saving(graph/combined/combined_cash_sum_t, replace)  fxsize(100) fysize(100) ycommon graphregion(color(white))  graphregion(margin(zero)) 
*Total public social expenditure
grc1leg   "graph/twoway_Germany/synth_total_soexp"  "graph/twoway_Japan/synth_total_soexp", title("C: Total social expenditures") ///
saving(graph/combined/combined_total_soexp_t, replace)   fxsize(100) fysize(100)  ycommon graphregion(color(white))   graphregion(margin(zero)) 
*Combine three graphs // not sucessful...
grc1leg   "graph/combined/combined_inkind_sum_t"  "graph/combined/combined_inkind_sum_t"   "graph/combined/combined_total_soexp_t"  , ///
saving(graph/combined/combined_three_exp, replace) col(1)  fysize(120)  graphregion(color(white))   graphregion(margin(zero)) 

 fysize(200)  
 iscale(0.6) fxsize(100) fysize(150) 
/*
*synth graph(from 1980)
twoway (tsline _Y_treated , lpattern(solid) lcolor(black)) (tsline _Y_synthetic, lpattern(dash) lcolor(black)),  ///
legend(off) tline($t_year) title("$country")  xtitle("Year")  xlabel(1980(10)2010) graphregion(color(white))
graph save Graph "graph/_$country/synth_$outcome",replace

 *gap graph (from 1980)
twoway (tsline sc_est, lpattern(solid) lwidth(thick) lcolor(black)),   ///
tline($t_year) yline(0) title("$country")  xtitle("Year") ytitle("Estimate")   xlabel(1980(10)2010)  graphregion(color(white))
graph save Graph "graph/_$country/gap_$outcome",replace
*/

gr combine  "graph/_Germany/synth_$outcome" "graph/_Japan/synth_$outcome", saving(graph/combined/combined__$outcome, replace) ///
 iscale(1.1) xsize(16) ysize(10) ycommon graphregion(color(white))
