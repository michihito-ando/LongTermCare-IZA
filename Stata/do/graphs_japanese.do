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

*summary stat

*summary, excluding  Greece idn == 10 | idn == 11 | idn == 20 // excluding Luxembourg 10, Netherland 11,  Germany 20
*outcome 
sum  inkind_sum cash_sum  soexp_health total_soexp  sstaxes  LFP_25to54_fe LFP_55to64_fe partemp_w_pc if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

sum  oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc lfp_30to34_fe lfp_35to39_fe  lfp_40to44_fe ///
	lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

xtset Country year 
twoway (tsline lfp_45to54_fe if Country == "Japan" & year >= 1980 & year <= 2013, lpattern(solid) lwidth(thick) lcolor(black))  ///
 (tsline lfp_45to54_fe if Country != "Japan" & year >= 1980 & year <= 2013, lpattern(solid) lwidth(medium) lcolor(gs10)), ///
   legend(off) tline($t_year) title(" ")  xtitle("Year") graphregion(color(white)) xlabel(1980(5)2010)
 
 tsset _time
global selected_placebo "gap1-gap$treated_id_minus1" //  - 1
twoway (tsline $selected_placebo, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline gap_treated, lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline($t_year) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)
  
  
xtline oldage_inkind if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

*predictor
sum gdp_pc child elderly agriculture industry services gr_gdp_pc gr_pop gr_child gr_elderly ///
 if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

stop
*check outcome == 0

keep if Country == "France" | Country == "Norway"

keep if oldage_inkind == 0  | oldage_inkind_pc == 0  | soexp_health == 0 | soexp_health_pc == 0
keep Country year id idn oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc 
order Country year id idn oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc 
save "temp/outcomes_zero_modified.dta", replace

