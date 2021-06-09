***Synth Analysis
*oldage_inkind,  Japan
*First implement do files until "stop" then move to each "Case"
* excluding Canada 4, Luxembourg 10, Netherland 11,  Germany 20

////////////////////
*Common global settings
////////////////////

*outcome
global outcome "share_hours_worked_female" // oldage_inkind 

*country
global country "Japan" // graph title

*year settings
global first_year "1982" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2005" // main
global t_year "2000" // Japan
global pre_t_year "1999" //Japan

**predictors**
*lagged outcomes
*global  pred_lag "$outcome $outcome($first_year) $outcome($pre_t_year) "  
*global  pred_lag "$outcome($first_year(1)$pre_t_year)"  
global  pred_lag "$outcome(1982) $outcome(1983) $outcome(1984) $outcome(1985) $outcome(1986) $outcome(1987) $outcome(1988) $outcome(1989) $outcome(1990) $outcome(1991) $outcome(1992) $outcome(1993) $outcome(1994) $outcome(1995) $outcome(1996) $outcome(1997) $outcome(1998) $outcome(1999)"  

*normal covariates
global pred_covar "gdp_pc child elderly agriculture industry services"

*covariates growth
global pred_covar_gr "gr_gdp_pc gr_pop gr_child gr_elderly"

list idn Country year $outcome inkind_sum 
list idn Country year $outcome inkind_sum  if year == 1980
list idn Country year $outcome inkind_sum  if year == 1982 // Australia from here
list idn Country year $outcome inkind_sum  if year == 1985
list idn Country year $outcome inkind_sum  if year == 1990
list idn Country year $outcome inkind_sum  if year == 1995
list idn Country year $outcome inkind_sum  if year == 2004
list idn Country year $outcome inkind_sum  if year == 2005
list idn Country year $outcome inkind_sum  if year == 2006

/* Drop the following countries
       +---------------------------------------------------+
      | idn          Country   year   share_~e   inkind~m |
      |---------------------------------------------------|
 188. |   4           Canada   1982          .          . |
 353. |   7           France   1982          .      .6252 |
 408. |   8          Ireland   1982          .       .515 |
 518. |  10       Luxembourg   1982          .       .237 |
      |---------------------------------------------------|
 573. |  11      Netherlands   1982   24.89161       .616 |
 628. |  12      New Zealand   1982          .       .044 |
 683. |  13           Norway   1982          .     1.2322 |
 738. |  14         Portugal   1982          .       .015 |
      |---------------------------------------------------|
 848. |  16           Sweden   1982          .      1.667 |
 903. |  17      Switzerland   1982          .        .17 |
1068. |  20          Germany   1982          .        .36 |
      |---------------------------------------------------|

*/

xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 


*reset id number and panel setting
drop if idn == 10 | idn == 11 | idn == 20 // excluding  Luxembourg 10, Netherland 11,  Germany 20 (LTCI countries)
drop if idn == 4 |  idn == 7 | idn == 8 | idn == 12| idn == 13 | idn == 14 | idn == 16 | idn == 17  // excluding the above missing countries

egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global donor "donors_all"  // just labelling
global treated "10" // Japan
global counit "1(1)9"


*define treated id number and related numbers for LOO placebo
global treated_id "10"
global treated_id_minus1 "9"
global treated_id_minus2 "8"
global treated_id_minus3 "7"

