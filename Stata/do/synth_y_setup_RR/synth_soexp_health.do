*start
***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"


////////////////////
*Common global settings
////////////////////

*outcome
global outcome "soexp_health"  //  "Total public expenditure on health care / GDP"

*country
global country "Japan" // graph title

*year settings
global first_year "1980" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2013" // main
global t_year "1993" // Japan
global pre_t_year "1992" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1980) $outcome(1981) $outcome(1982) $outcome(1983) $outcome(1984) $outcome(1985) $outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992)"  

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

*xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 

/* Drop the following countries
     | idn          Country    id |
 527. |  10       Luxembourg   LUX |
 592. |  11      Netherlands 
  669. |  13           Norway
1067. |  20          Germany   DEU |
*/



*reset id number and panel setting
drop if idn == 10 | idn == 11 | idn == 20 // excluding LTCI countries Luxembourg 10, Netherland 11,  Germany 20,
drop if  idn == 13  // Norway 13 missing or anomaly data
egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global treated "17" // Japan
global counit "1(1)16"


*define treated id number and related numbers for LOO placebo
global treated_id "17"
global treated_id_minus1 "16"
global treated_id_minus2 "15"
global treated_id_minus3 "14"


