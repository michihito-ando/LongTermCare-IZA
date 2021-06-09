/*
clear matrix
clear
set more off

**CD seting
global pc "D:\Dropbox\2016LTCI_FISS\STATA"
*global pc "Users/Michi/Dropbox/2016LTCI_FISS/STATA"

cd "$pc"
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*Get database*
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

*use "raw\LTCI_FISS20160524(stata14)"
*saveold raw\LTCI_FISS20160524, version(13) // convert data from Stata 14 format to Stata 13 format because some of Ando's PC have only Stata 13.
*use "raw\LTCI20160731(stata14)"
*saveold raw\LTCI20160731, version(13) // convert data from Stata 14 format to Stata 13 format because some of Ando's PC have only Stata 13.
*use "raw\pop_oecd(stata14)"
*saveold raw\pop_oecd, version(13) // convert data from Stata 14 format to Stata 13 format because some of Ando's PC have only Stata 13.

*merge and make one OECD lfp data set
/*
use "raw\oecd_lfp_add"
tsset id_n year
merge 1:1  id_n year using "raw\lfp_35to44_fe"
drop _merge
merge 1:1  id_n year using "raw\lfp_35to44_men"
drop _merge
merge 1:1  id_n year using "raw\lfp_45to54_fe"
drop _merge
merge 1:1  id_n year using "raw\lfp_45to54_men"
drop _merge
save "raw\oecd_lfp_add_v2", replace
*/

***Modify datasets***

*Change Olivetti 2016 Annul Review of Econ data for merging
use "raw/shares_tot_hours_worked", clear
replace Country = "USA" if Country == "USA-SIC"
replace Country = "UKM" if Country == "UK"
replace Country = "DEU" if Country == "GER"
replace Country = "CZH" if Country == "CZE"

drop if Country == "POL" // Poland not used

rename Country id
drop id_n
save "raw/shares_tot_hours_worked_v2", replace

*Change Olivetti 2017 JEP data for merging
use "raw/Olivetti2017/Table3", clear
replace country = "CZH" if country == "CZE"
replace country = "UKM" if country == "GBR"

drop if country == "LTU" // L Lietuvos , not used
drop if country == "POL" // Poland not used

rename country id
save "raw/olivetti2017_table3", replace

*Change benefits per capita data 190703
use "raw/old_benefits_health_exp.dta", clear
keep id_n year p_bene_inkind_old_per_old_c socx_t_health_pc_constantPPP oldage_inkind soexp_health //  oldage_inkind soexp_health are newly added in 201216 
rename p_bene_inkind_old_per_old_c oldage_inkind_pc // benefits in kind for old per 65 over, constant price
rename socx_t_health_pc_constantPPP soexp_health_pc // government_current expenditure on health per pop(aged 65over),constant prices,co
tsset id_n year
save "raw/inkind_health_updated201216.dta", replace

***Merge datasets***

*Use baseline data
use "raw/LTCI20160731_st14", clear

*Drop old inkind and health data that were obtained in 2016: We updated data and include them to "old_benefits_health_exp.dta" 
drop oldage_inkind soexp_health

/* Not used since LTCI20160731 because the data already contains id_n, not idn.
tsset idn year
*label idn
egen id_n = group(idn), label lname(id)
reg idn id_n
replace idn = id_n
*/

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

/*
*Merge two Olivetti datasets
merge 1:1  id year using "raw/shares_tot_hours_worked_v2" // Add additional labor force participation data based on age cohort
drop if _merge == 2 // drop "using only"
drop _merge
merge 1:1  id year using "raw/olivetti2017_table3" // Add additional labor force participation data based on age cohort
drop if _merge == 2 // drop "using only"
drop _merge
*/

/* NOT USED because we drop _merge == 2 190703
*put id_n to olivetti2017's year-2014 dataW
bysort id: replace id_n = id_n[1]

*put Country name to olivetti2017's year-2014 data
bysort id: replace Country = Country[1]
*/
tsset id_n year

***************************************************
* 190701>201216 Add new data of inkind benefits per elderly

*merge 1:1 id_n year using "raw/inkind_health_per_capita.dta" // 190701
merge 1:1 id_n year using "raw/inkind_health_updated201216.dta" // 201216

drop if _merge == 2 // drop "using only"
drop _merge
***************************************************

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

/*
*den demeaned variables > MOVED TO EACH OUTCOME SETUP DO FILE (in the synth_y_setup folder) 
*demeaning by pre-intervention level

foreach var of varlist  sstaxes sstran hlpub totheal tfr urban tradeopen cpi cpi2 tlabfo flabfo pop ///
female fcvemp lifexp flifexp mlifexp lifeexpf65 lifeexpm65 deathall cerevasc neoplasm suicide ///
 rgdpe rgdpo emp avh hc ccon cda cgdpe cgdpo ck ctfp cwtfp rgdpna rconna rdana rkna rtfpna ///
 rwtfpna labsh delta agriculture industry services child child_persons elderly elderly_persons EHII_gini ///
 total_soexp Incapacity_related_cash Incapacity_related_inkind oldage_cash oldage_inkind soexp_health ///
 ctaxgdp staxgdp ltaxgdp ctaxrev staxrev ltaxrev gdp_pc fem_labor fem_labor2  fem_labor3  fem_labor4 ///
 beds_rltcf_65over ALOS_ac good_health_feold  good_health_maold good_health_totold  ///
 partemp_pc partemp_w_pc cash_sum inkind_sum ///
 sui_25to34fe sui_25to34male sui_35to54fe sui_35to54male /// suisaide variables
 sui_55to74fe sui_55to74male sui_75to_fe sui_75to_male{

by idn, sort: egen temp_`var' = mean(`var') if inrange(year, 1990, 1999)
by idn, sort: gen mean_`var' = temp_`var'[1] 
gen demean_`var' = `var' - mean_`var' 
}
*/

*summary, excluding  Greece idn == 10 | idn == 11 | idn == 20 // excluding Luxembourg 10, Netherland 11,  Germany 20
*outcome 
sum  inkind_sum cash_sum  soexp_health total_soexp  sstaxes  LFP_25to54_fe LFP_55to64_fe partemp_w_pc if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013
sum  oldage_inkind soexp_health  total_soexp lfp_30to34_fe lfp_35to39_fe  lfp_40to44_fe ///
	lfp_45to49_fe lfp_50to54_fe lfp_55to59_fe if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013

*predictor
sum gdp_pc child elderly agriculture industry services gr_gdp_pc gr_pop gr_child gr_elderly ///
 if idn !=8 & idn != 10 & idn != 11 & idn != 20 & year >= 1980 & year <= 2013



/*
stop 








