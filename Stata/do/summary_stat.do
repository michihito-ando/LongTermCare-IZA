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
list Country if year == 2000 & (idn == 10 | idn == 11 | idn == 20)

*outcome 
*sum  inkind_sum cash_sum  soexp_health total_soexp  sstaxes  LFP_25to54_fe LFP_55to64_fe partemp_w_pc if idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

*Outcomes(1980-2013)
**Japan
sum  oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc /*lfp_30to34_fe lfp_35to39_fe*/  lfp_40to44_fe ///
	lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe if year >= 1980 & year <= 2013 & Country == "Japan"

**donor pool
sum  oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc /* lfp_30to34_fe lfp_35to39_fe*/  lfp_40to44_fe ///
	lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe if idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013 ///
	& Country != "Japan"

	
*predictor(180-1999)
**Japan
sum gdp_pc child elderly agriculture industry services gr_gdp_pc gr_pop gr_child gr_elderly ///
 if year >= 1980 & year <= 1999 & Country == "Japan"


sum gdp_pc child elderly agriculture industry services gr_gdp_pc gr_pop gr_child gr_elderly ///
 if idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 1999 & Country != "Japan"

 
stop
*check outcome == 0

keep if Country == "France" | Country == "Norway"

keep if oldage_inkind == 0  | oldage_inkind_pc == 0  | soexp_health == 0 | soexp_health_pc == 0
keep Country year id idn oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc 
order Country year id idn oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc 
save "temp/outcomes_zero_modified.dta", replace
