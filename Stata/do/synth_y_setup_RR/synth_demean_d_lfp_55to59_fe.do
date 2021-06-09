*start
***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"

*Additional missing countries: Austria Ireland Switzerland Finland



////////////////////
*Common global settings
////////////////////

*outcome
global original_outcome "d_lfp_55to59_fe"
global outcome "demean_d_lfp_55to59_fe"

*country
global country "Japan" // graph title

*year settings
global first_year "1986" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2013" // main
global t_year "1993" // Japan
global pre_t_year "1992" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992)"  

*normal covariates
global pred_covar ""

*covariates growth
global pred_covar_gr ""

*gen demeaned outcome using $original_outcome
by idn, sort: egen temp_$original_outcome = mean($original_outcome) if inrange(year, $first_year, $pre_t_year)  // caclulate mean
by idn, sort: egen mean_$original_outcome = max(temp_$original_outcome) // expand mean to all rows
gen demean_$original_outcome = $original_outcome - mean_$original_outcome // gen demeaned variable

*check missing data 
list idn Country year $outcome inkind_sum 
list idn Country year $outcome /*inkind_sum*/  if year == 1980
list idn Country year $outcome /*inkind_sum*/  if year == 1984
list idn Country year $outcome /*inkind_sum*/  if year == 1985
list idn Country year $outcome /*inkind_sum*/  if year == 1986
list idn Country year $outcome /*inkind_sum*/  if year == 1987
list idn Country year $outcome /*inkind_sum*/  if year == 1990
list idn Country year $outcome inkind_sum  if year == 1993
list idn Country year $outcome inkind_sum  if year == 2001
list idn Country year $outcome /*inkind_sum*/  if year == 2011
list idn Country year $outcome /*inkind_sum*/  if year == 2012
list idn Country year $outcome /*inkind_sum*/  if year == 2013
*xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 

/* Drop the following countries
     | idn          Country    id |
 527. |  10       Luxembourg   LUX |
 592. |  11      Netherlands 
  669. |  13           Norway
1067. |  20          Germany   DEU |
*/


*reset id number and panel setting
drop if idn == 10 | idn == 11 |  idn == 20 // excluding Luxembourg 10, Netherland 11,  Germany 20
drop if idn == 2 | idn == 6 | idn == 8 /*| idn == 12*/ | idn == 17 // 2 Austria 6 Finland (missing in 1980s) 8 Ireland  /* 12 Newzeland start from 1986*/ 17 Switzerland
egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and donor pool
global treated "14" // Japan
global counit "1(1)13"

*define treated id number and related numbers for LOO placebo
global treated_id "14"
global treated_id_minus1 "13"
global treated_id_minus2 "12"
global treated_id_minus3 "11"
