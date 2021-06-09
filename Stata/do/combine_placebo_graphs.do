**Data setup
clear matrix
clear
set more off


**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

////////////////////////////////
*Remake and combine graphs: all the main graphs
////////////////////////////////////

foreach name in "oldage_inkind" "oldage_inkind_pc" ///
				"soexp_health" "soexp_health_pc" ///
				"lfp_40to44_fe" "lfp_45to49_fe" /// LFP level, interval 5 years
				"lfp_50to54_fe" "lfp_55to59_fe" /// LFP level, interval 5 years
				"d_lfp_50to54_fe" "d_lfp_55to59_fe" { /// diff 

				
*date setup
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup/synth_`name'.do"

***make title labels

*LFP level, intervel 5 years
if "`name'" == "oldage_inkind"{
	local title "In-kind benefits for the elderly (% of GDP)"
	local ylabel ""

}

else if "`name'" == "oldage_inkind_pc"{ 
	local title "In-kind benefits for the elderly (per head)"
	local ylabel "-2000(2000)2000"
}

else if "`name'" == "soexp_health"{ 
	local title "Public health expenditure (% of GDP)"
	local ylabel ""

}

else if "`name'" == "soexp_health_pc"{ 
	local title "Public health expenditure (per capita)"
	local ylabel "-1500(1500)1500"
	}

else if "`name'" == "lfp_40to44_fe"{ 
	local title "LFP (ages 40-44)"
	local ylabel ""
}

else if "`name'" == "lfp_45to49_fe"{ 
	local title "LFP (ages 45-49)"
	local ylabel ""

}

else if "`name'" == "lfp_50to54_fe"{ 
	local title "LFP (ages 50-54)"
	local ylabel ""

}

else if "`name'" == "lfp_55to59_fe"{ 
	local title "LFP (ages 55-59)"
	local ylabel ""

}

*LFP level, diff
else if "`name'" == "d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
	local ylabel ""

}

else if "`name'" == "d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
	local ylabel ""

}

*donor pool setting
global donor "basic_placebo"

use "post_synth/_$donor/_$outcome/basic_plcb_$outcome", replace

tsset _time

*placebo graph
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title("`title'")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2015) ylabel(`ylabel')

graph save Graph "graph/_basic_placebo/combined/placebo_`name'",replace
*graph export  "graph/_basic_placebo/combined/placebo_`name'.pdf",replace


}
  
*combine 
graph combine "graph/_basic_placebo/combined/placebo_oldage_inkind" "graph/_basic_placebo/combined/placebo_oldage_inkind_pc" ///
        "graph/_basic_placebo/combined/placebo_soexp_health" "graph/_basic_placebo/combined/placebo_soexp_health_pc" ///
		"graph/_basic_placebo/combined/placebo_lfp_40to44_fe" "graph/_basic_placebo/combined/placebo_lfp_45to49_fe" ///
		"graph/_basic_placebo/combined/placebo_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_lfp_55to59_fe" ///
		"graph/_basic_placebo/combined/placebo_d_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_d_lfp_55to59_fe", ///
		saving(graph/_basic_placebo/combined/combined_basic_plcb, replace) iscale(0.5) xsize(10) ysize(13) /*ycommon xcommon*/ rows(5)  graphregion(color(white)) 
graph export  "graph/_basic_placebo/combined/combined_basic_plcb.pdf",replace



////////////////////////////////
*Remake and combine graphs, demeaned LFP graphs, 30s-50s, combine 40-50s
////////////////////////////////////

foreach name in  "demean_oldage_inkind" "demean_soexp_health" /// inkind and health
				"demean_lfp_30to34_fe" "demean_lfp_35to39_fe" /// 30s
				"demean_lfp_40to44_fe" "demean_lfp_45to49_fe" /// 40s
				"demean_lfp_50to54_fe" "demean_lfp_55to59_fe" /// 50s
				"demean_d_lfp_50to54_fe" "demean_d_lfp_55to59_fe" { /// demeaned diff 

				
*date setup
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup/synth_`name'.do"

***make title labels

if "`name'" == "demean_oldage_inkind"{
	local title "In-kind benefits for the elderly (% of GDP)"
	local ylabel ""

}


else if "`name'" == "demean_soexp_health"{ 
	local title "Public health expenditure (% of GDP)"
	local ylabel ""

}

if "`name'" == "demean_lfp_30to34_fe"{ 
	local title "LFP (ages 30-34)"
	local ylabel ""

}

else if "`name'" == "demean_lfp_35to39_fe"{ 
	local title "LFP (ages 34-39)"
	local ylabel ""

}

else if "`name'" == "demean_lfp_40to44_fe"{ 
	local title "LFP (ages 40-44)"
	local ylabel ""

}


else if "`name'" == "demean_lfp_45to49_fe"{ 
	local title "LFP (ages 45-49)"
	local ylabel ""

}

else if "`name'" == "demean_lfp_50to54_fe"{ 
	local title "LFP (ages 50-54)"
	local ylabel ""

}

else if "`name'" == "demean_lfp_55to59_fe"{ 
	local title "LFP (ages 55-59)"
	local ylabel ""

}

*LFP level, diff
else if "`name'" == "demean_d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
	local ylabel ""

}

else if "`name'" == "demean_d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
	local ylabel ""

}

*donor pool setting
global donor "basic_placebo"

use "post_synth/_$donor/_$outcome/basic_plcb_$outcome", replace

tsset _time

*placebo graph
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title("`title'")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2015) ylabel(`ylabel')

graph save Graph "graph/_basic_placebo/combined/placebo_`name'",replace
*graph export  "graph/_basic_placebo/combined/placebo_`name'.pdf",replace


}
  
*combine 
graph combine "graph/_basic_placebo/combined/placebo_demean_oldage_inkind" "graph/_basic_placebo/combined/placebo_demean_soexp_health" ///
			  /*"graph/_basic_placebo/combined/placebo_demean_lfp_30to34_fe" "graph/_basic_placebo/combined/placebo_demean_lfp_35to39_fe"*/ ///
			  "graph/_basic_placebo/combined/placebo_demean_lfp_40to44_fe" "graph/_basic_placebo/combined/placebo_demean_lfp_45to49_fe" ///
			  "graph/_basic_placebo/combined/placebo_demean_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_demean_lfp_55to59_fe" ///
			  "graph/_basic_placebo/combined/placebo_demean_d_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_demean_d_lfp_55to59_fe",  ///
		saving(graph/_basic_placebo/combined/combined_demean_plcb, replace) iscale(0.5) xsize(10) ysize(15) /*ycommon*/ /*xcommon*/ rows(4)  graphregion(color(white)) 
graph export  "graph/_basic_placebo/combined/combined_demean_plcb.pdf",replace

/*

////////////////////////////////
*Remake graphs (Main expenditure results)
////////////////////////////////////

foreach name in "oldage_inkind" "oldage_inkind_pc" "soexp_health" "soexp_health_pc"{
				
*date setup
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup/synth_`name'.do"

***make title labels

*LFP level, intervel 5 years
if "`name'" == "oldage_inkind"{
	local title "In-kind benefits for the elderly (% of GDP) "
}

else if "`name'" == "oldage_inkind_pc"{ 
	local title "In-kind benefits for the elderly (per elderly person)"
}

else if "`name'" == "soexp_health"{ 
	local title "Public health expenditure (% of GDP)"
}

else if "`name'" == "soexp_health_pc"{ 
	local title "Public health expenditure (per capita)"
}

*donor pool setting
global donor "basic_placebo"

use "post_synth/_$donor/_$outcome/basic_plcb_$outcome", replace

tsset _time

*placebo graph
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title("`title'")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)

graph save Graph "graph/_basic_placebo/combined/placebo_`name'",replace
*graph export  "graph/_basic_placebo/combined/placebo_`name'.pdf",replace

}
  
*combine 
graph combine "graph/_basic_placebo/combined/placebo_oldage_inkind" ///
				"graph/_basic_placebo/combined/placebo_oldage_inkind_pc" ///
				"graph/_basic_placebo/combined/placebo_soexp_health" ///
				"graph/_basic_placebo/combined/placebo_soexp_health_pc", ///
		saving(graph/_basic_placebo/combined/combined_basic_plcb_main, replace) iscale(0.5) xsize(10) ysize(13) /*ycommon xcommon*/ rows(2)  graphregion(color(white)) 
graph export  "graph/_basic_placebo/combined/combined_basic_plcb_main.pdf",replace



////////////////////////////////
*Remake graphs　(LFP)
////////////////////////////////////

foreach name in "lfp_40to44_fe" "lfp_45to49_fe" /// LFP level, interval 5 years
				"lfp_50to54_fe" "lfp_55to59_fe" /// LFP level, interval 5 years
				"d_lfp_50to54_fe" "d_lfp_55to59_fe" { /// diff 
				
*date setup
do "do/data_setup.do"

*synth outcome setup
do "do/synth_y_setup/synth_`name'.do"

***make title labels

*LFP level, intervel 5 years
if  "`name'" == "lfp_40to44_fe"{ 
	local title "LFP(ages 40-44)"
}

else if "`name'" == "lfp_45to49_fe"{ 
	local title "LFP(ages 45-49)"
}

else if "`name'" == "lfp_50to54_fe"{ 
	local title "LFP(ages 50-54)"
}

else if "`name'" == "lfp_55to59_fe"{ 
	local title "LFP(ages 55-59)"
}

*LFP level, diff
else if "`name'" == "d_lfp_50to54_fe"{ 
	local title "LFP(ages 50-54) - LFP(ages 45-49)"
}

else if "`name'" == "d_lfp_55to59_fe"{ 
	local title "LFP(ages 55-59) - LFP(ages 45-49)"
}

*donor pool setting
global donor "basic_placebo"

use "post_synth/_$donor/_$outcome/basic_plcb_$outcome", replace

tsset _time

*placebo graph
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title("`title'")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)

graph save Graph "graph/_basic_placebo/combined/placebo_`name'",replace
*graph export  "graph/_basic_placebo/combined/placebo_`name'.pdf",replace

}
  
*combine 
graph combine "graph/_basic_placebo/combined/placebo_lfp_40to44_fe" "graph/_basic_placebo/combined/placebo_lfp_45to49_fe" ///
		"graph/_basic_placebo/combined/placebo_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_lfp_55to59_fe" ///
		"graph/_basic_placebo/combined/placebo_d_lfp_50to54_fe" "graph/_basic_placebo/combined/placebo_d_lfp_55to59_fe", ///
		saving(graph/_basic_placebo/combined/combined_basic_plcb_lfp, replace) iscale(0.5) xsize(10) ysize(13) /*ycommon xcommon*/ rows(4) graphregion(color(white)) 
graph export  "graph/_basic_placebo/combined/combined_basic_plcb_lfp.pdf",replace

*/
