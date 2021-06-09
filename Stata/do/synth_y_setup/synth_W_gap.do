***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"
* excluding CanadaW
////////////////////
*Common global settings
////////////////////

*outcome
global outcome "W_gap" // Gender wage gap (%) (Olivetti 2017 JEP)

*country
global country "Japan" // graph title

*year settings
global first_year "1976" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2014" // main
global t_year "2000" // Japan
global pre_t_year "1999" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1976) $outcome(1977) $outcome(1978) $outcome(1979) $outcome(1980) $outcome(1981) $outcome(1982) $outcome(1983) $outcome(1984) $outcome(1985) $outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992) $outcome(1993) $outcome(1994) $outcome(1995) $outcome(1996) $outcome(1997) $outcome(1998) $outcome(1999)"  

*normal covariates
global pred_covar "gdp_pc child elderly agriculture industry services"

*covariates growth
global pred_covar_gr "gr_gdp_pc gr_pop gr_child gr_elderly"

list idn Country year $outcome inkind_sum 
list idn Country year $outcome inkind_sum  if year == 1970
list idn Country year $outcome inkind_sum  if year == 1972
list idn Country year $outcome inkind_sum  if year == 1975
list idn Country year $outcome inkind_sum  if year == 1976  // canada from here
list idn Country year $outcome inkind_sum  if year == 1980
list idn Country year $outcome inkind_sum  if year == 1995
list idn Country year $outcome inkind_sum  if year == 2004
list idn Country year $outcome inkind_sum  if year == 2005
list idn Country year $outcome inkind_sum  if year == 2006

/* Drop the following  (in addition to LTCI countries)
      +--------------------------------------------------+
      | idn          Country   year     E_gap   inkind~m |
      |--------------------------------------------------|
  72. |   2          Austria   1976         .          . |
 127. |   3          Belgium   1976         .          . |
 237. |   5          Denmark   1976         .          . |
      |--------------------------------------------------|
 347. |   7           France   1976         .          . |
 402. |   8          Ireland   1976         .          . |
      |--------------------------------------------------|
 622. |  12      New Zealand   1976         .          . |
      |--------------------------------------------------|
 897. |  17      Switzerland   1976         .          . |
 952. |  18   United Kingdom   1976         .          . |
      +--------------------------------------------------+

*/

xtline  $outcome if year>=1960 & year<=2015,  i(Country) t(year) 
st
*reset id number and panel setting
drop if idn == 10 | idn == 11 | idn == 20 // excluding  Luxembourg 10, Netherland 11,  Germany 20 (LTCI countries)
drop if idn == 2 |  idn == 3 | idn == 5 | idn == 7 | idn == 8 | idn == 12 | idn == 17 | idn == 18  // excluding the above missing countries

egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year
st
*define treated and control
global donor "donors_all"  // just labelling
global treated "10" // Japan
global counit "1(1)9"


*define treated id number and related numbers for LOO placebo
global treated_id "10"
global treated_id_minus1 "9"
global treated_id_minus2 "8"
global treated_id_minus3 "7"

