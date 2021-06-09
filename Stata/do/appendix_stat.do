/* Appendix

Furuichi

aim:

*/

global outcome "oldage_inkind_pc" //  in-kind benefits for elderly


**Data setup
clear matrix
clear
set more off

**CD seting
global pc "C:\Users\rethink\Dropbox\LTCI_FISS2016\STATA\"
*global pc "/Users/Michi/Dropbox/2016LTCI_FISS/STATA" 

cd "$pc"

*

use "raw\LTCI20160731_stata14", clear

///以下　data_setup 124148行目からのコピペ（


**merge 1:1 id_n year using "raw/inkind_health_per_capita.dta" // 190701 **

drop oldage_inkind
merge 1:1 id_n year using "do\data_setup\old_benefits_health_exp" //  202012データ改訂 20201218データ追加

rename p_bene_inkind_old_per_old_c oldage_inkind_pc // benefits in kind for old per 65 over, constant price
rename socx_t_health_pc_constantPPP soexp_health_pc // government_current expenditure on health per pop(aged 65over),constant prices,co
tsset id_n year
drop if _merge == 2 // drop "using only"
drop _merge

tsset id_n year

*Merge OECD datasets
merge 1:1  id_n year using "raw/pop_oecd_st14"
drop _merge
merge 1:1  id_n year using "raw/oecd_lfp_empr_st14"
drop _merge
merge 1:1  id_n year using "raw/oecd_lfp_add_v2" // Add additional labor force participation data based on age cohort
drop _merge
merge 1:1  id_n year using "raw/health_social_emp" // Add total health and social employment, 2020.3.12
drop _merge


*rename and tsset
rename id_n idn
tsset idn year

***Some DATA generation

**Suiside rate by age cohort, based on WHO suiside and population data
replace sui_25to34fe = sui_25to34fe / pop_25to34fe * 10000
replace sui_25to34male = sui_25to34fe / (pop_25to34all - pop_25to34fe) * 10000
replace sui_35to54fe = sui_35to54fe  /  pop_35to54fe * 10000
replace sui_35to54male =  sui_35to54male / (pop_35to54all - pop_35to54fe) * 10000
replace sui_55to74fe  = sui_55to74fe / pop_55to74fe * 10000
replace sui_55to74male = sui_55to74male / (pop_55to74all - pop_55to74fe) * 10000
replace sui_75to_fe  = sui_75to_fe / pop_75to_fe * 10000
replace sui_75to_male =  sui_75to_male / (pop_75to_all - pop_75to_fe) * 10000

*Female employment rate by age cohort, OECD data?
gen emp_fe_full_25_54 = wtf_25to54age * 1000 / (pop_25to29fe_oecd + pop_30to34fe_oecd + pop_35to39fe_oecd + pop_40to44fe_oecd + pop_45to49fe_oecd + pop_50to54fe_oecd) 
gen emp_fe_full_55_64 = wtf_55to64age * 1000 / (pop_55to59fe_oecd + pop_60to64fe_oecd) 
gen emp_fe_part_25_54 = wtp_25to54age * 1000 / (pop_25to29fe_oecd + pop_30to34fe_oecd + pop_35to39fe_oecd + pop_40to44fe_oecd + pop_45to49fe_oecd + pop_50to54fe_oecd) 
gen emp_fe_part_55_64 = wtp_55to64age * 1000 / (pop_55to59fe_oecd + pop_60to64fe_oecd) 
gen emp_fe_total_25_54 = emp_fe_full_25_54 + emp_fe_part_25_54
gen emp_fe_total_55_64 = emp_fe_full_55_64 + emp_fe_part_55_64

//////////////////
**label**
///////////////////

label var idn "Country ID"
label var year "Year"

**outcome var
*taxes 
label var sstaxes "Social security taxes / GDP"
label var ctaxgdp "Central Government Tax Revenue \ GDP"
label var staxgdp "State/regional gov tax revenue / GDP"
label var ltaxgdp "Local gov tax revenue /GDP"
label var ctaxrev "Central tax revenue as percentage of total general government tax revenue"
label var staxrev	 "State/regional tax revenue as percentage of total general government tax" 	
label var ltaxrev	"Local tax revenue as percentage of total general government tax revenue"

*expenditure
label var sstran "Public expenditure on cash social benefits / GDP"
label var hlpub "Public expenditure on healthcare, national currency units"
label var totheal "Totla expenditure on healthcare, national currency units"
label var total_soexp  "Total public social expenditure / GDP"
label var soexp_health "Total public expenditure on health care / GDP"
label var Incapacity_related_cash "Public expenditure on Incapacity related cash benefits / GDP" 
label var Incapacity_related_inkind "Public expenditure on Incapacity related inkind benefits / GDP" 
label var oldage_cash "Public expenditure on old-age cash benefits / GDP"
label var oldage_inkind "Public expenditure on old-age benefits in kind / GDP"

label var oldage_inkind_pc "Public expenditure on old-age benefits in kind / elderly population" // 190701
label var soexp_health_pc "Total public expenditure on health care / poulation" // 190701

**social outcomes
*birth related outcome
label var tfr "total fertility rate, births per woman"

*Death related outcomes
label var suicide "Suicide rates"
label var lifexp "Life expectancy at  birth for total population"
label var flifexp "female life expectancy at birth"
label var mlifexp "Male life expectancy at birth"
label var lifeexpf65 "Female life expectancy at age 65"
label var lifeexpm65	"Male life expectancy at age 65"
label var deathall	"Deaths from all causes, per 100,000 people"
label var cerevasc "Deaths per 100,000 population caused by cerebrovascular diseases"
label var ischaemic "Deaths caused by ischaemic heart disease, per 100,000 people"
label var neoplasm "Deaths caused by malignant neoplasms of the trachea, bronchus and lung, per 100,000 people"


*inequality
label var EHII_gini "Estimated Household Income Inequality"

*hospital supply/utilization
label var beds_rltcf_65over "Beds in residential LTC facil /1000 (65 years old and over)"
label var ALOS_ac "Length of hospital stay Acute care, Days"

*subjective health
label var good_health_feold " 'good/very good',  females aged 65 years old and over"
label var good_health_maold "good/very good',  men aged 65 years old and over."
label var good_health_totold "good/very good', total aged 65 years old and over."

**covariates (predictors)
*demography
label var agriculture "Civilian employment in agriculture as % of civilian"
label var industry "Civilian employment in industry as % of civilian employment"
label var services  "Civilian employment in services as % of civilian employment"
label var pop "population"
label var female "female population"
label var tlabfo "Size of civilian labor force, in thousands"
label var flabfo "Female labor force, in thousands"
label var fcvemp "Female civilian employment, in thousands"
label var child_persons "Population aged under 15 years, in thousands"
label var child "Population under 15 as % population"
label var elderly_persons  "Population aged 65 and older, in thousands"
label var elderly "Population 65 and over as % population"
label var urban "Population in urban agglomerations of more than 1 millions"

*GDP and employment
label var rgdpe "Expenditure-side real GDP"
label var rgdpo "Output-side real GDP"
label var cgdpe "Expenditure-side real GDP at current PPPs"
label var cgdpo "Output-side real GDP at current PPPs"
label var emp "emp	Number of persons engaged (in millions)"
label var avh "Average annual hours worked by persons engaged"
label var hc "Index of human capital per person, based on years of schooling" 

*other economic indicators
label var tradeopen "Trade openness: as a percentage change in consumer prices from the prior year to the current year"
label var cpi "Inflation rate"
label var cpi2 "Consumer price index"

label var ccon	"Real consumption of households and government"
label var cda "Real domestic absorption"
label var ck "Capital stock at current PPPs"
label var ctfp "TFP level at current PPPs (USA=1)"
label var cwtfp "Welfare-relevant TFP levels at current PPPs (USA=1)"

**New data added in 160731
*Suicide rate
label var sui_25to34fe  "No. of deaths - Intentional self-harm, female, 25-34 years"
label var sui_25to34male "No. of deaths - Intentional self-harm, male, 25-34 years"
label var sui_35to54fe  "No. of deaths - Intentional self-harm, female, 35-54 years"
label var sui_35to54male  "No. of deaths - Intentional self-harm, male, 35-54 years"
label var sui_55to74fe  "No. of deaths - Intentional self-harm, female, 55-74 years"
label var sui_55to74male  "No. of deaths - Intentional self-harm, male, 55-74 years"
label var sui_75to_fe "No. of deaths - Intentional self-harm, female, 75- years"
label var sui_75to_male "No. of deaths - Intentional self-harm, male, 75- years"

label var pop_25to34all  "Population - numbers, 25-34 years taken from WHO"
label var pop_25to34fe  "Population - numbers, female, 25-34 years taken from WHO"
label var pop_35to54all  "Population - numbers, 35-54 years taken from WHO"
label var pop_35to54fe "Population - numbers, female, 35-54 years taken from WHO"
label var pop_55to74all "Population - numbers, 25-34 years taken from WHO"
label var pop_55to74fe  "Population - numbers, female, 55-74 years taken from WHO"
label var pop_75to_all  "Population - numbers, 75+ years taken from WHO"
label var pop_75to_fe  "Population - numbers, female, 75+ years taken from WHO" 

**Employment rate, female => cannot be used due to breaks in 2002 in Japan Use LFP?*
label var emp_fe_full_25_54	"Full-time employment for women, age group 25 - 54"	
label var emp_fe_full_55_64 "Full-time employment for women, age group 55 - 64"
label var emp_fe_part_25_54 "Partl-time employment for women, age group 25 - 54"
label var emp_fe_full_55_64 "Full-time employment for women, age group 55 - 64"

*Hospital stay
label var hospital_stay "Length of hospital stay Acute care, Days"
 // The average length of stay In hospitals (ALOS) refers to the average number of days that patients spend in hospital. It is generally measured by dividing the total number of days stayed by all inpatients during a year by the number of admissions or discharges. Day cases are excluded. 

*Hospital beds
label var hospital_beds "Hospital beds (per 1,000 people)"	
// Definition: Hospital beds include inpatient beds available in public,	private, general, and specialized hospitals and rehabilitation centers. In most cases beds for both acute and chronic care are included.	

/////////////////////////////////////////
*choose observations in sample and RENEW ID, DROP CANADA AND LUX HERE*
///////////////////////////////////////

**drop countries that do not have population data
*xtline pop if year>=1980 & year<=2015,  i(id) t(year) 
list idn Country if pop ==. & year == 2000
/*
      +-----------------------+
      | idn           Country |
      |-----------------------|
 257. |   5             Chile |
 311. |   6    Czech Republic |
 419. |   8           Estonia |
 689. |  13           Hungary |
 743. |  14           Iceland |
      |-----------------------|
 851. |  16            Israel |
1013. |  19             Korea |
1121. |  21            Mexico |
1337. |  25            Poland |
1445. |  27   Slovak Republic |
      |-----------------------|
1499. |  28          Slovenia |
1715. |  32            Turkey |
      +-----------------------+
*/
drop if idn == 5 | idn == 6 | idn == 8 | idn == 13 | idn == 14 | idn == 16 ///
 | idn == 19 | idn == 21 | idn == 25 | idn == 27 |idn == 28 | idn == 32
 
 drop if idn == 12 // Drop Greece due to its financial crisis
 
**renew country ID*

egen new_id = group(idn) if (idn != 18 & idn != 11) // idn 18 = Japan, idn 11 = Germany
replace new_id = 20 if idn == 11 // Germany
replace new_id = 21 if idn == 18 // Japan

gen original_id = idn  /*preserve original ID in tha back side of the table*/
replace idn = new_id    /*just in order to check easily on the table*/

label values idn  id 

**redefine panel**
tsset idn year

list idn Country id if year == 2000
/*
       | idn          Country    id |
      |----------------------------|
  41. |   1        Australia   AUS |
  95. |   2          Austria   AUT |
 149. |   3          Belgium   BEL |
 203. |   4           Canada   CAN |
 257. |   5          Denmark   DNK |
      |----------------------------|
 311. |   6          Finland   FIN |
 365. |   7           France   FRA |
 419. |   8          Ireland   IRL |
 473. |   9            Italy   ITA |
 527. |  10       Luxembourg   LUX |
      |----------------------------|
 581. |  11      Netherlands   NLD |
 635. |  12      New Zealand   NZL |
 689. |  13           Norway   NOR |
 743. |  14         Portugal   PRT |
 797. |  15            Spain   ESP |
      |----------------------------|
 851. |  16           Sweden   SWE |
 905. |  17      Switzerland   CHE |
 959. |  18   United Kingdom   UKM |
1013. |  19    United States   USA |
1067. |  20          Germany   DEU |
      |----------------------------|
1121. |  21            Japan   JPN |


*/

**Graph trends of oldage benefits in kind **

drop if oldage_inkind==. | oldage_inkind==0

////やりなおし 1999→2005 1999→2010 1999→2013

keep if year==1999|year==2005| year==2010|year==2013

save "do\data_setup\append_oldage_diff",replace

//////////

use "do\data_setup\append_oldage_diff",clear
drop if year ==2010 |year==2013

bys idn: gen oldage_inkind1999diff2005 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind1999diff2005
keep if year==2005
drop year oldage_inkind

save  "do\data_setup\append_oldage_1999diff2005",replace

//// 1999-2010

use "do\data_setup\append_oldage_diff",clear
drop if year ==2005 |year==2013

bys idn: gen oldage_inkind1999diff2010 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind1999diff2010
keep if year==2010
drop year oldage_inkind

save  "do\data_setup\append_oldage_1999diff2010",replace

///1999 2005


use "do\data_setup\append_oldage_diff",clear
drop if year ==2013 | drop if year==2010


bys idn: gen oldage_inkind1999diff2010 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind1999diff2010
keep if year==2010
drop year oldage_inkind


//// 1999-2013

use "do\data_setup\append_oldage_diff",clear
drop if year ==2005 |year==2010

bys idn: gen oldage_inkind1999diff2013 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind1999diff2013
keep if year==2013
drop year 

save  "do\data_setup\append_oldage_1999diff2013",replace

///merge 

use  "do\data_setup\append_oldage_1999diff2013",replace

merge 1:m idn using  "do\data_setup\append_oldage_1999diff2005"
drop _merge

merge 1:m idn using  "do\data_setup\append_oldage_1999diff2010"
drop _merge
order Country id idn oldage_inkind oldage_inkind1999diff2005 oldage_inkind1999diff2010 oldage_inkind1999diff2013
save  "do\data_setup\append_oldage_1999diff2005_2010_2013",replace



/*やりなおし 1999→2005 1999→2010 1999→2013


* 2000-2005年というのもアドホックなので、2000-2010とか2000-2013
keep if year==2000| year==2010|year==2013

save "do\data_setup\append_oldage_diff",replace

use "do\data_setup\append_oldage_diff",clear
drop if year ==2010

bys idn: gen oldage_inkind2000diff2013 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind2000diff2013
keep if year==2013
drop year

save  "do\data_setup\append_oldage_2000diff2013",replace

//// 2000-2010と

use "do\data_setup\append_oldage_diff",clear
drop if year ==2013

bys idn: gen oldage_inkind2000diff2010 = oldage_inkind[_n] - oldage_inkind[_n-1]
keep Country year id idn  oldage_inkind oldage_inkind2000diff2010
keep if year==2010
drop year

save  "do\data_setup\append_oldage_2000diff2010",replace

merge 1:m idn using  "do\data_setup\append_oldage_2000diff2013"
drop _merge

save  "do\data_setup\append_oldage_2000diff2010_2013",replace

///

tsline oldage_inkind if year > 1980,by( Country ) xline(2000)


tsline oldage_inkind if idn== 1 | idn==9 | idn ==15 | idn==16 | idn==18 | idn==21 & year >1980,xline(1992 2000) by( Country )

tsline oldage_inkind_pc  if idn== 1 | idn==9 | idn ==15 | idn==16 | idn==18 | idn==21 & year >1980,xline(1992 2000) by( Country )

tsline oldage_inkind_pc if year > 1980,by( Country ) xline(2000)

/*
////synth 準備

////////////////////////////////////////////////////////////////////
**impute missing values by simple interpolation (linear projection) => Should move to each do fiels?
/////////////////////////////////////////////////////////////////////////

**suiside

**interpolation by ipolate: Australia 2005, Itally 2004-2005, Portugal 2004-2006, UK 2000, etc...
foreach name in suicide sui_25to34fe sui_25to34male sui_35to54fe sui_35to54male sui_55to74fe sui_55to74male sui_75to_fe sui_75to_male{
by idn: ipolate `name' year, generate(`name'_i)
replace  `name' = `name'_i
}


**oldage_inkind, oldage_cash, total_soexp: Austria 1981-1984, 1986-1989, Norway 1981-1984, 1986-1987
list  oldage_inkind oldage_cash  total_soexp idn id Country year if oldage_cash == . & year >=1980 & year <2012
list  Incapacity_related_inkind  idn id Country year if Incapacity_related_inkind == . & year >=1980 & year <2012
list  Incapacity_related_cash  idn id Country year if Incapacity_related_cash == . & year >=1980 & year <2012


**health expenditure = 0 in France and Norway should be missing values: added in 190707
list Country year id soexp_health if soexp_health == 0 
list Country year id soexp_health_pc if soexp_health_pc == 0 

replace soexp_health = . if soexp_health == 0
replace soexp_health_pc = . if soexp_health_pc == 0

**interpolation by ipolate: Austria 1981-1984, 1986-1989 and Norway 1981-1984, 1986-1987
*190707 soexp_health soexp_health_pc added
foreach name in oldage_inkind oldage_inkind_pc soexp_health soexp_health_pc oldage_cash  total_soexp Incapacity_related_inkind   Incapacity_related_cash {
by idn: ipolate `name' year, generate(`name'_i)
replace  `name' = `name'_i
}


**interpolation by ipolate: many missing values
foreach name in eduexp_all cerevasc  ischaemic neoplasm {
by idn: ipolate `name' year, generate(`name'_i)
replace  `name' = `name'_i
}


/*
**interpolation by hand
foreach name in oldage_inkind oldage_cash  total_soexp Incapacity_related_inkind   Incapacity_related_cash {
*Austria 1981-1984
replace  `name'  = l.`name' + (f4.`name' - l.`name')*1/5 if year == 1981 & idn == 2 // Austria 1981
replace  `name'  = l2.`name' + (f3.`name' - l2.`name')*2/5 if year == 1982 & idn == 2 // Austria 1982
replace  `name'  = l3.`name' + (f2.`name' - l3.`name')*3/5 if year == 1983 & idn == 2 // Austria 1983
replace  `name'  = l4.`name' + (f.`name' - l4.`name')*4/5 if year == 1984 & idn == 2 // Austria 1984
*Austria 1986-1989
replace  `name'  = l.`name' + (f4.`name' - l.`name')*1/5 if year == 1986 & idn == 2 // Austria 1986
replace  `name'  = l2.`name' + (f3.`name' - l2.`name')*2/5 if year == 1987 & idn == 2 // Austria 1987
replace  `name'  = l3.`name' + (f2.`name' - l3.`name')*3/5 if year == 1988 & idn == 2 // Austria 1988
replace  `name'  = l4.`name' + (f.`name' - l4.`name')*4/5 if year == 1989 & idn == 2 // Austria 1989
*Norway 1981-1984
replace  `name'  = l.`name' + (f4.`name' - l.`name')*1/5 if year == 1981 & idn == 14 // Norway 1981
replace  `name'  = l2.`name' + (f3.`name' - l2.`name')*2/5 if year == 1982 & idn == 14 // Norway 1982
replace  `name'  = l3.`name' + (f2.`name' - l3.`name')*3/5 if year == 1983 & idn == 14 // Norway 1983
replace  `name'  = l4.`name' + (f.`name' - l4.`name')*4/5 if year == 1984 & idn == 14 // Norway 1984
*Norway 1986-1987
replace  `name'  = l.`name' + (f2.`name' - l.`name')*1/3 if year == 1986 & idn == 14 // Austria 1986
replace  `name'  = l2.`name' + (f.`name' - l2.`name')*2/3 if year == 1987 & idn == 14  // Austria 1987
}

*check
foreach name in oldage_inkind oldage_cash  total_soexp Incapacity_related_inkind   Incapacity_related_cash {
reg  `name' `name'_i if year >=1980
}
*/
/*
**oldage_cash
list oldage_cash idn id Country year if oldage_cash == . & year >=1980 & year <2012
*Austrica 1981-1984
list oldage_cash  idn id Country year if idn == 2
replace  oldage_cash  = l.oldage_cash + (f4.oldage_cash - l.oldage_cash)*1/5 if year == 1981 & idn == 2 // Austria 1981
replace  oldage_cash  = l2.oldage_cash + (f3.oldage_cash - l2.oldage_cash)*2/5 if year == 1982 & idn == 2 // Austria 1982
replace  oldage_cash  = l3.oldage_cash + (f2.oldage_cash - l3.oldage_cash)*3/5 if year == 1983 & idn == 2 // Austria 1983
replace  oldage_cash  = l4.oldage_cash + (f.oldage_cash - l4.oldage_cash)*4/5 if year == 1984 & idn == 2 // Austria 1984
*Austria 1986-1989
replace  oldage_cash  = l.oldage_cash + (f4.oldage_cash - l.oldage_cash)*1/5 if year == 1986 & idn == 2 // Austria 1986
replace  oldage_cash  = l2.oldage_cash + (f3.oldage_cash - l2.oldage_cash)*2/5 if year == 1987 & idn == 2 // Austria 1987
replace  oldage_cash  = l3.oldage_cash + (f2.oldage_cash - l3.oldage_cash)*3/5 if year == 1988 & idn == 2 // Austria 1988
replace  oldage_cash  = l4.oldage_cash + (f.oldage_cash - l4.oldage_cash)*4/5 if year == 1989 & idn == 2 // Austria 1989
*Norway 1981-1984
list oldage_cash  idn id Country year if idn == 14
replace  oldage_cash  = l.oldage_cash + (f4.oldage_cash - l.oldage_cash)*1/5 if year == 1981 & idn == 14 // Norway 1981
replace  oldage_cash  = l2.oldage_cash + (f3.oldage_cash - l2.oldage_cash)*2/5 if year == 1982 & idn == 14 // Norway 1982
replace  oldage_cash  = l3.oldage_cash + (f2.oldage_cash - l3.oldage_cash)*3/5 if year == 1983 & idn == 14 // Norway 1983
replace  oldage_cash  = l4.oldage_cash + (f.oldage_cash - l4.oldage_cash)*4/5 if year == 1984 & idn == 14 // Norway 1984
*Norway 1986-1987
replace  oldage_cash  = l.oldage_cash + (f2.oldage_cash - l.oldage_cash)*1/3 if year == 1986 & idn == 14 // Austria 1986
replace  oldage_cash  = l2.oldage_cash + (f.oldage_cash - l2.oldage_cash)*2/3 if year == 1987 & idn == 14  // Austria 1987

list  total_soexp idn id Country year if  total_soexp == . & year >=1980 & year <2012
*/
////////////////////////////////
*generate some additonal var
//////////////////////////////////

*gen cash_total, inkind_total

gen cash_sum = Incapacity_related_cash +  oldage_cash
gen inkind_sum = Incapacity_related_inkind +  oldage_inkind

*gen social expenditure excluding health and LTC
gen other_soexp = total_soexp - soexp_health - oldage_inkind


*gen GDP per capita
gen gdp_pc = rgdpe/pop

*gen female labor participation rate (not used now)
gen fem_labor = flabfo / female  * 100  //need to be changed to female +15
gen fem_labor2 = fcvemp / (pop - child_persons - elderly_persons) * 100  //need to be changed to female +15
gen fem_labor3 = fcvemp / tlabfo  * 100  //need to be changed ?
gen fem_labor4 = fcvemp / female  * 100  //need to be changed to female +15

*gen part time ratio
gen partemp_pc = partemp_th/tlabfo 
gen partemp_w_pc =  partemp_w_th/tlabfo 
gen partemp_rate_w =  partemp_w_th/fcvemp 

*gen diff of labor force participation rate using the age cohort 45-49 as referece cohort
*Note that the age cohort 40-44 may be better for reference, but in Japan  d_lfp_45to49_fe_check =  lfp_45to49_fe - lfp_40to44_fe is positive,]
* implying that more females in this age cohort "return" to the labor market than "drop" from the labor market. Hence 45-49 age cohort may be better as a reference. 

*female
*gen d_lfp_45to49_fe =  lfp_45to49_fe - lfp_40to44_fe
gen d_lfp_50to54_fe =  lfp_50to54_fe - lfp_45to49_fe
gen d_lfp_55to59_fe =  lfp_55to59_fe - lfp_45to49_fe
gen d_lfp_50to54_v2_fe =  lfp_50to54_fe - lfp_40to44_fe
gen d_lfp_55to59_v2_fe =  lfp_55to59_fe - lfp_40to44_fe
gen d_LFP_55to64_fe = LFP_55to64_fe - lfp_45to54_fe

*men
gen d_lfp_50to54_men =  lfp_50to54_men - lfp_45to49_men
gen d_lfp_55to59_men =  lfp_55to59_men - lfp_45to49_men
gen d_lfp_50to54_v2_men =  lfp_50to54_men - lfp_40to44_men
gen d_lfp_55to59_v2_men =  lfp_55to59_men - lfp_40to44_men

*gen diff of suiside rate: some suiside rates in Japan are the highest in OECD and cannot be directly used.

gen d_sui_75to_fe = sui_75to_fe - sui_35to54fe
gen d_sui_55to74fe = sui_55to74fe - sui_35to54fe
gen d_sui_75to_male = sui_75to_male - sui_35to54male
gen d_sui_55to74male = sui_55to74male - sui_35to54male
gen d_sui_75to_gender = sui_75to_fe - sui_75to_male
gen d_sui_55to74gender = sui_55to74fe - sui_55to74male


*OLD:den demeaned variables for suiside rates : some suiside rates in Japan are the highest in OECD and cannot be directly used.

*foreach var of varlist sui_25to34fe sui_25to34male sui_35to54fe sui_35to54male sui_55to74fe sui_55to74male sui_75to_fe sui_75to_male{

*by idn, sort: egen ave_`var' = mean(`var')
*gen demean_`var' = `var' - ave_`var' 

*}

***generate variables**
*gen lagged data and growth var*
foreach var of varlist  sstaxes sstran hlpub totheal tfr urban tradeopen cpi cpi2 tlabfo flabfo pop ///
female fcvemp lifexp flifexp mlifexp lifeexpf65 lifeexpm65 deathall cerevasc neoplasm suicide ///
 rgdpe rgdpo emp avh hc ccon cda cgdpe cgdpo ck ctfp cwtfp rgdpna rconna rdana rkna rtfpna ///
 rwtfpna labsh delta agriculture industry services child child_persons elderly elderly_persons EHII_gini ///
 total_soexp Incapacity_related_cash Incapacity_related_inkind oldage_cash oldage_inkind soexp_health ///
 ctaxgdp staxgdp ltaxgdp ctaxrev staxrev ltaxrev gdp_pc fem_labor fem_labor2  fem_labor3  fem_labor4 ///
 beds_rltcf_65over ALOS_ac good_health_feold  good_health_maold good_health_totold  ///
 partemp_pc partemp_w_pc cash_sum inkind_sum ///
 oldage_inkind_pc soexp_health_pc{  // added 190701
 gen l_`var' = l.`var'
 gen l2_`var' = l2.`var'
 gen gr_`var' = d.`var'/l.`var' *100
}

//// outcome 現物給付

///////////////////
*Common global settings
////////////////////

*outcome
global outcome "oldage_inkind" // oldage_inkind 

*country
global country "Japan" // graph title

*year settings
global first_year "1980" //health , sstaxes , labor force, old_inkind with inputed Austria and Norway
global last_year "2013" // main
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
*xtline  $outcome if year>=1980 & year<=2015,  i(Country) t(year) 


*reset id number and panel setting
drop if idn == 4 | idn == 10 | idn == 11 | idn == 20 // excluding Canada 4, Luxembourg 10, Netherland 11,  Germany 20
egen id_case1 = group(idn)
list Country idn id_case1 if year == 2000
tsset id_case1 year

*define treated and control
global donor "donors_all"  // just labelling
global treated "17" // Japan
global counit "1(1)16"


*define treated id number and related numbers for LOO placebo
global treated_id "17"
global treated_id_minus1 "16"
global treated_id_minus2 "15"
global treated_id_minus3 "14"

///synth
///////////////////
*Case 1: Full donor pool
////////////////////

*define donor pool
global donor "donors_all"  // just labelling

*log using log/_$donor/_$outcome.log, replace

**synth**
*allopt: full optimization
 synth $outcome $pred_lag $pred_covar $pred_covar_gr,  xperiod($first_year(1)$pre_t_year)  mspeperiod($first_year(1)$pre_t_year) resultsperiod($first_year(1)$last_year) trunit($treated) trperiod($t_year)  counit($counit)  unitnames(Country)  

**save Y_treated and Y_synth for graph
 */*putexcel set "post_synth/twoway/post_synth_$outcome.xlsx", replace
 **putexcel A1 = ("Year") B1 = ("Y_treated") C1 = ("Y_synth") D1 = ("Y_synth_dr1") E1 = ("Y_synth_dr2")
*Y trated
 putexcel A2 = matrix(e(Y_treated)), rownames
*Y synth
 putexcel C2 = matrix(e(Y_synthetic))

