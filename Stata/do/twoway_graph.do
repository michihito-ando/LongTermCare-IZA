*Use global settings of the do files where you implement synth

***Import data
import excel using "post_synth/twoway/post_synth_$outcome.xlsx", firstrow  clear
destring Year, generate(year)

////////////////////////////////
*Make graphs
////////////////////////////////////

tsset year

*synth graph
twoway (tsline Y_treated , lpattern(solid) lcolor(black) lwidth(thick)) (tsline Y_synth, lpattern(solid) lcolor(black)) ///
 (tsline Y_synth_dr1, lpattern(dash) lcolor(black)) (tsline Y_synth_dr2, lpattern(shortdash) lcolor(black)),  ///
legend(lab(1 "Japan") lab(2 "Synthetic control 1") lab(3 "Synthetic control 2") lab(4 "Synthetic control 3")) ///
 tline($t_year) /*title("$country")*/  xtitle("Year")  xlabel(1980(5)2015)  graphregion(color(white))

graph save Graph "graph/twoway/gph/synth_$outcome",replace
graph export  "graph/twoway/pdf/synth_$outcome.pdf",replace
