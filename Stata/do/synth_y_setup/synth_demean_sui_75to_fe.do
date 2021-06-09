***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"
* excluding Canada 4, Luxembourg 10, Netherland 11,  Germany 20

////////////////////
*Common global settings
////////////////////

*outcome
global outcome "demean_sui_75to_fe" // oldage_inkind 

*country
global country "Japan" // graph title

*year settings
global first_year "1980" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2011" // main
global t_year "2000" // Japan
global pre_t_year "1999" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1980) $outcome(1981) $outcome(1982) $outcome(1983) $outcome(1984) $outcome(1985) $outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992) $outcome(1993) $outcome(1994) $outcome(1995) $outcome(1996) $outcome(1997) $outcome(1998) $outcome(1999)"  

*normal covariates
global pred_covar "gdp_pc child elderly agriculture industry services"

*covariates growth
global pred_covar_gr "gr_gdp_pc gr_pop gr_child gr_elderly"

list idn Country year $outcome inkind_sum 
list idn Country year $outcome inkind_sum  if year == 1980
list idn Country year $outcome inkind_sum  if year == 1985
list idn Country year $outcome inkind_sum  if year == 1995
list idn Country year $outcome inkind_sum  if year == 2001
list idn Country year $outcome inkind_sum  if year == 2004
list idn Country year $outcome inkind_sum  if year == 2011
list idn Country year $outcome inkind_sum  if year == 2012

/* Drop the following countries
     | idn          Country    id |
 203. |   4           Canada   CAN |
 527. |  10       Luxembourg   LUX |
 592. |  11      Netherlands   
1067. |  20          Germany   DEU |
1121. |  21            Japan   JPN |
*/

st

xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 

/*
xtline  sui_35to54fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  sui_35to54male if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  sui_55to74fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  sui_55to74male  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  sui_75to_fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  sui_75to_male if year>=1980 & year<=2015,  i(Country) t(year) 

xtline  d_sui_55to74fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  d_sui_55to74male  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  d_sui_75to_fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  d_sui_75to_male if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  d_sui_55to74gender  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  d_sui_75to_gender if year>=1980 & year<=2015,  i(Country) t(year) 

xtline  demean_sui_55to74fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  demean_sui_55to74male  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  demean_sui_75to_fe if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  demean_sui_75to_male if year>=1980 & year<=2015,  i(Country) t(year) 

xtline  hospital_stay  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  beds_rltcf_65over  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  ALOS_ac  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  hospital_beds  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  good_health_feold  if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  EHII_gini  if year>=1980 & year<=2015,  i(Country) t(year) 
*/



*reset id number and panel setting
drop if idn == 10 | idn == 11 | idn == 20 // excluding  Luxembourg 10, Netherland 11,  Germany 20 (LTCI countries)
drop if idn == 5 |  idn == 6 | idn == 13 | idn == 16| idn == 17 // excluding nordic countries and swizerland

egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global donor "donors_all"  // just labelling
global treated "13" // Japan
global counit "1(1)12"


*define treated id number and related numbers for LOO placebo
global treated_id "13"
global treated_id_minus1 "12"
global treated_id_minus2 "11"
global treated_id_minus3 "10"

