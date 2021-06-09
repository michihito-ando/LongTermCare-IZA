
**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"


////////////////
*Remake graphs
////////////////

***oldage_inkind (% of GDP)***
 
**Import data
import excel using "post_synth/twoway/post_synth_oldage_inkind.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 title("A: % of GDP") tline(2000) xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white)) ylabel(0(0.25)1.75) 

graph save Graph "graph/twoway/gph/synth_oldage_inkind",replace
graph export  "graph/twoway/pdf/synth_oldage_inkind.pdf",replace

***oldage_inkind_pc (per capita)***
 
**Import data
import excel using "post_synth/twoway/post_synth_oldage_inkind_pc.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 title("B: per elderly person (USD, PPP 2010)") tline(2000) xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white)) /*ylabel(0(100)550)*/

graph save Graph "graph/twoway/gph/synth_oldage_inkind_pc",replace
graph export  "graph/twoway/pdf/synth_oldage_inkind_pc.pdf",replace


***soexp_health (% of GDP)***
 
**Import data
import excel using "post_synth/twoway/post_synth_soexp_health.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 title("A: % of GDP") tline(2000) xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white)) /*ylabel(0(100)550)*/

graph save Graph "graph/twoway/gph/synth_soexp_health",replace
graph export  "graph/twoway/pdf/synth_soexp_health.pdf",replace


***soexp_health_pc (per capita)***
 
**Import data
import excel using "post_synth/twoway/post_synth_soexp_health_pc.xlsx", firstrow  clear
destring Year, generate(year)

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 title("B: per capita (USD, PPP 2010)") tline(2000) xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white)) /*ylabel(0(100)550)*/

graph save Graph "graph/twoway/gph/synth_soexp_health_pc",replace
graph export  "graph/twoway/pdf/synth_soexp_health_pc.pdf",replace

////////////////////////////////
*Combine graphs
////////////////////////////////////


**Data setup
clear matrix
clear
set more off

**CD seting
global pc "D:/Dropbox/2016LTCI_FISS/STATA"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 
cd "$pc"

*oldage inkind 
graph combine "graph/twoway/gph/synth_oldage_inkind"  "graph/twoway/gph/synth_oldage_inkind_pc" , ///
		saving(graph/twoway/gph/combined_oldage_inkind, replace) iscale(0.5) xsize(3) ysize(3) /*xcommon*/ rows(2) graphregion(color(white)) 

/*
grc1leg "graph/twoway/gph/synth_oldage_inkind"  "graph/twoway/gph/synth_oldage_inkind_pc" , ///
		saving(graph/twoway/gph/combined_oldage_inkind, replace) iscale(0.5) xsize(3) ysize(6) xcommon rows(2) graphregion(color(white)) 
*/

graph export  "graph/twoway/pdf/combined_oldage_inkind.pdf",replace


*health
graph combine "graph/twoway/gph/synth_soexp_health"  "graph/twoway/gph/synth_soexp_health_pc" , ///
		saving(graph/twoway/gph/combined_soexp_health, replace) iscale(0.5) xsize(3) ysize(3) /*xcommon*/ rows(2) graphregion(color(white)) 

graph export  "graph/twoway/pdf/combined_soexp_health.pdf",replace
