***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"
* excluding Canada 4, Luxembourg 10, Netherland 11,  Germany 20

////////////////////
*Common global settings
////////////////////

*outcome
global outcome "health_social_emp" // oldage_inkind 

*country
global country "Japan" // graph title

*year settings
global first_year "1995" //
global last_year "2013" // main
global t_year "2000" // Japan
global pre_t_year "1999" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1995) $outcome(1996) $outcome(1997) $outcome(1998) $outcome(1999)"  

*normal covariates
global pred_covar "gdp_pc child elderly agriculture industry services"

*covariates growth
global pred_covar_gr "gr_gdp_pc gr_pop gr_child gr_elderly"

list idn Country year $outcome inkind_sum 
list idn Country year $outcome inkind_sum  if year == 1980
list idn Country year $outcome inkind_sum  if year == 1985
list idn Country year $outcome inkind_sum  if year == 1995
list idn Country year $outcome inkind_sum  if year == 2001
list idn Country year $outcome inkind_sum  if year == 2011
list idn Country year $outcome inkind_sum  if year == 2012



*reset id number and panel setting
drop if idn == 4 | idn == 10  | idn == 11 | idn == 12 | idn == 19| idn == 20 // excluding Canada 4, Luxembourg 10, Netherland 11, Newzealand 12 US 19 | Germany 20
egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global donor "donors_all"  // just labelling
global treated "15" // Japan
global counit "1(1)14"


*define treated id number and related numbers for LOO placebo
global treated_id "15"
global treated_id_minus1 "14"
global treated_id_minus2 "13"
global treated_id_minus3 "12"

