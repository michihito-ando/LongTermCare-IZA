***Choose outcomevar
/*
global outcome "oldage_inkind" //  in-kind benefits for elderly
global outcome "soexp_health" //  social expenditure for health
global outcome "lfp_40to44_fe" //   labor force participation 40-44, female
global outcome "lfp_45to49_fe" // 
global outcome "lfp_50to54_fe" // 
global outcome "lfp_55to59_fe" // 
global outcome "d_lfp_50to54_fe" //  diff of labor force participation 50-54 - 45-49, female
global outcome "d_lfp_55to59_fe" //  diff of labor force participation 55-59 - 45-49, female
global outcome "demean_sui_55to74fe" // suiside rate, 55-74 female
global outcome "demean_sui_75to_fe" // suiside rate, 75 female
*/

global outcome "oldage_inkind_pc" //  in-kind benefits for elderly


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

xtline  oldage_inkind if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  oldage_inkind_pc if year>=1980 & year<=2015,  i(Country) t(year) 
xtline  lfp_55to59_fe if year>=1980 & year<=2015,  i(Country) t(year) 

xtline  lfp_55to59_fe if year>=1980 & year<=2015,  i(Country) t(year) 

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

xtset idn year
xtline oldage_inkind if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black)) saving(graph/twoway/gph/oldage_inkind_trends, replace)

xtline lfp_40to44_fe if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black)) saving(graph/twoway/gph/lfp_40to44_fe_trends, replace)

xtline lfp_45to49_fe if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black)) saving(graph/twoway/gph/lfp_45to49_fe_trends, replace)

xtline lfp_50to54_fe if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black)) saving(graph/twoway/gph/lfp_50to54_fe_trends, replace)

xtline lfp_55to59_fe if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black)) saving(graph/twoway/gph/lfp_55to59_fe_trends, replace)
 
 graph combine "graph/twoway/gph/oldage_inkind_trends"  "graph/twoway/gph/lfp_55to59_fe_trends"

graph combine "graph/twoway/gph/oldage_inkind_trends"  "graph/twoway/gph/lfp_50to54_fe_trends" "graph/twoway/gph/lfp_55to59_fe_trends", col(3)

graph combine  "graph/twoway/gph/lfp_40to44_fe_trends" "graph/twoway/gph/lfp_45to49_fe_trends" ///
				"graph/twoway/gph/lfp_50to54_fe_trends" "graph/twoway/gph/lfp_55to59_fe_trends", col(2)
 
 xtline beds_rltcf_65over if year>=1980 & year<=2015, overlay i(idn) t(year) ///
 legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010) ///
 plot21opts(lwidth(vthick) lcolor(black))


xtline 
twoway (tsline oldage_inkind, lpattern(solid) lwidth(medium) lcolor(gs10)) (tsline oldage_inkind if id == "JPN" , lpattern(solid) lwidth(thick) lcolor(black)), ///
  legend(off) tline(2000) title(" ")  xtitle("Year")  graphregion(color(white)) xlabel(1980(5)2010)

line oldage_inkind year

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

