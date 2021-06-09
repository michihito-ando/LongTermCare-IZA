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

foreach name in "oldage_inkind" "soexp_health"  /// Benefits
				 "lfp_50to54_fe" "lfp_55to59_fe" /// LFP level, interval 5 years
				"d_lfp_50to54_fe" "d_lfp_55to59_fe" /// diff => NOT USED DUE TO ERROR
				"demean_lfp_50to54_fe" "demean_lfp_55to59_fe" /// demeaned
				"demean_d_lfp_50to54_fe" "demean_d_lfp_55to59_fe" {  // demeaned diff
***make title labels

*LFP level, intervel 5 years
if "`name'" == "oldage_inkind"{
	local title "In-kind benefits for the elderly (% of GDP)"
}

if "`name'" == "soexp_health"{
	local title "Public health expenditure (% of GDP)"
}

else if "`name'" == "lfp_50to54_fe"{ 
	local title "LFP (ages 50-54)"
}

else if "`name'" == "lfp_55to59_fe"{ 
	local title "LFP (ages 55-59)"
}

else if "`name'" == "d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
}

else if "`name'" == "d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
}

else if "`name'" == "demean_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54): demeaned"
}

else if "`name'" == "demeaned_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59): demeaned"
}

else if "`name'" == "demean_d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49): demeaned"
}

else if "`name'" == "demeaned_d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49): demeaned"
}

***Import data
import excel using "post_synth/twoway/post_synth_RR2_`name'.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph, legend off
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(off) ///
 tline(2000)  title(`title')  xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white))
 
graph save Graph "graph/twoway/gph/synth_RR2_`name'",replace
graph export  "graph/twoway/pdf/synth_RR2_`name'.pdf",replace

}


////////////////////////////////
*Combine graphs
////////////////////////////////////

*combine benefits graphs
graph combine "graph/twoway/gph/synth_RR2_oldage_inkind"  "graph/twoway/gph/synth_RR2_soexp_health",  ///
			saving(graph/twoway/gph/combined_RR2_benefits, replace) iscale(0.5) /*xsize(5) ysize(30)*/ /*ycommon*/  rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_RR2_benefits.pdf",replace

*combine 50s cohort LFP
graph combine "graph/twoway/gph/synth_RR2_lfp_50to54_fe"  "graph/twoway/gph/synth_RR2_lfp_55to59_fe", ///
		saving(graph/twoway/gph/combined_RR2_lfp_50s_fe, replace) iscale(0.5) /*xsize(5) ysize(30)*/ ycommon  rows(1) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_RR2_lfp_50s_fe.pdf",replace

*combine two age cohort flp (demeaned)
graph combine "graph/twoway/gph/synth_RR2_demean_lfp_50to54_fe"  "graph/twoway/gph/synth_RR2_demean_lfp_55to59_fe",  ///
		/*title("(b) Demeaned outcomes") */ ///
		saving(graph/twoway/gph/combined_RR2_demean_lfp_50s_fe, replace) iscale(0.5)  /*xsize(16) ysize(10)*/ ycommon rows(1) graphregion(color(white))
graph export  "graph/twoway/pdf/combined_RR2_demean_lfp_50s_fe.pdf",replace


*combine two age cohort flp (demeaned diff)
graph combine "graph/twoway/gph/synth_RR2_demean_d_lfp_50to54_fe"  "graph/twoway/gph/synth_RR2_demean_d_lfp_55to59_fe",  ///
		/*title("(b) Demeaned outcomes") */ ///
		saving(graph/twoway/gph/combined_RR2_demean_d_lfp_50s_fe, replace) iscale(0.5)  /*xsize(16) ysize(10)*/ ycommon rows(1) graphregion(color(white))
graph export  "graph/twoway/pdf/combined_RR2_demean_d_lfp_50s_fe.pdf",replace


*combine benefits and LFP
graph combine "graph/twoway/gph/combined_RR2_benefits"  ///
         "graph/twoway/gph/combined_RR2_lfp_50s_fe"  ///
		  "graph/twoway/gph/combined_RR2_demean_lfp_50s_fe"  "graph/twoway/gph/combined_RR2_demean_d_lfp_50s_fe", ///
		saving(graph/twoway/gph/combined_RR2_all, replace) iscale(0.7) xsize(10) ysize(13) /*ycommon*/ rows(5) graphregion(color(white)) 
graph export  "graph/twoway/pdf/combined_RR2_all.pdf",replace

