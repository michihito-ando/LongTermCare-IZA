**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

////////////////////////////////
*Remake each graph with titles
////////////////////////////////////

foreach name in /*"demean_lfp_30to34_fe" "demean_lfp_35to39_fe" "demean_lfp_40to44_fe" /// LFP level, interval 5 years
				"demean_lfp_45to49_fe" "demean_lfp_50to54_fe" "demean_lfp_55to59_fe"*/ /// employment rate
				"demean_d_lfp_50to54_fe" "demean_d_lfp_55to59_fe" {  // diff
***make title labels

*LFP level, intervel 5 years
if "`name'" == "demean_lfp_30to34_fe"{
	local title "Ages 30-34"
}

else if "`name'" == "demean_lfp_35to39_fe"{ 
	local title "Ages 35-39"
}

else if "`name'" == "demean_lfp_40to44_fe"{ 
	local title "Ages 40-44"
}

else if "`name'" == "demean_lfp_45to49_fe"{ 
	local title "Ages 45-49"
}

else if "`name'" == "demean_lfp_50to54_fe"{ 
	local title "Ages 50-54"
}

else if "`name'" == "demean_lfp_55to59_fe"{ 
	local title "Ages 55-59"
}

else if "`name'" == "demean_d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
}

else if "`name'" == "demean_d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
}

***Import data
import excel using "post_synth/twoway/post_synth_`name'.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 tline(2000) title(`title')  xtitle("Year")  xlabel(1985(5)2015)  graphregion(color(white))

graph save Graph "graph/twoway/gph/synth_`name'",replace
graph export  "graph/twoway/pdf/synth_`name'.pdf",replace

}


////////////////////////////////
*Combine graphs
////////////////////////////////////

** Combine all or middle cohorts **

*combine six age cohort flp (not used in the latest paper 20.2.23)
grc1leg "graph/twoway/gph/synth_demean_lfp_30to34_fe"  "graph/twoway/gph/synth_demean_lfp_35to39_fe"  ///
		"graph/twoway/gph/synth_demean_lfp_40to44_fe" "graph/twoway/gph/synth_demean_lfp_45to49_fe" ///
		"graph/twoway/gph/synth_demean_lfp_50to54_fe"  "graph/twoway/gph/synth_demean_lfp_55to59_fe" , ///
		saving(graph/twoway/gph/combined_demean_lfp_age5_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon  rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_demean_lfp_age5_fe.pdf",replace


*combine four age cohort flp
grc1leg "graph/twoway/gph/synth_demean_lfp_40to44_fe" "graph/twoway/gph/synth_demean_lfp_45to49_fe" ///
		"graph/twoway/gph/synth_demean_lfp_50to54_fe"  "graph/twoway/gph/synth_demean_lfp_55to59_fe" , ///
		saving(graph/twoway/gph/combined_demean_lfp_middle_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon  rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_demean_lfp_middle_fe.pdf",replace


**combine yonger cohorts, original and demeaned **

*combine two age cohort flp (younger cohort, original)
grc1leg "graph/twoway/gph/synth_lfp_30to34_fe"  "graph/twoway/gph/synth_lfp_35to39_fe", ///
		title("(a) Original outcomes") ///
		saving(graph/twoway/gph/combined_lfp_young_fe, replace) iscale(1) ///
		/*xsize(5) ysize(30)*/ ycommon rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_young_fe.pdf",replace

*combine two age cohort flp (younger cohort, demeaned)
grc1leg "graph/twoway/gph/synth_demean_lfp_30to34_fe"  "graph/twoway/gph/synth_demean_lfp_35to39_fe", ///
		title("(b) Demeaned outcomes") ///
		saving(graph/twoway/gph/combined_demean_lfp_young_fe, replace) iscale(1) ///
		/*xsize(5) ysize(30)*/ ycommon rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_demean_lfp_young_fe.pdf",replace


*combine four age cohort flp (younger cohort, original and demeaned)
grc1leg"graph/twoway/gph/combined_lfp_young_fe"  "graph/twoway/gph/combined_demean_lfp_young_fe", ///
		saving(graph/twoway/gph/combined_lfp_young_fe_both, replace) iscale(0.5) ///
		/*xsize(5) ysize(30)*/ /*ycommon*/  rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_lfp_young_fe_both.pdf",replace

**combine DDD synth, original and demeaned **

*combine two age cohort flp (diff, original)
grc1leg   "graph/twoway/gph/synth_d_lfp_50to54_fe"  "graph/twoway/gph/synth_d_lfp_55to59_fe", ///
			title("(a) Original outcomes") ///
			saving(graph/twoway/gph/combined_d_lfp_50s_fe, replace) iscale(1)  ///
			/*xsize(16) ysize(10) */ ycommon rows(1) graphregion(color(white))
graph export  "graph/twoway/pdf/combined_d_lfp_50s_fe.pdf",replace

*combine two age cohort flp (diff, demeaned)
grc1leg "graph/twoway/gph/synth_demean_d_lfp_50to54_fe"  "graph/twoway/gph/synth_demean_d_lfp_55to59_fe",  ///
		title("(b) Demeaned outcomes") ///
		saving(graph/twoway/gph/combined_demean_d_lfp_50s_fe, replace) iscale(1)  ///
		/*xsize(16) ysize(10)*/ ycommon rows(1) graphregion(color(white))
graph export  "graph/twoway/pdf/combined_demean_d_lfp_50s_fe.pdf",replace

*combine four graphs

*combine four age cohort flp (younger cohort, original and demeaned)
grc1leg"graph/twoway/gph/combined_d_lfp_50s_fe"  "graph/twoway/gph/combined_demean_d_lfp_50s_fe", ///
		saving(graph/twoway/gph/combined_d_lfp_50s_fe_both, replace) iscale(0.5) ///
		/*xsize(5) ysize(30)*/ /*ycommon*/  rows(2) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_d_lfp_50s_fe_both.pdf",replace
