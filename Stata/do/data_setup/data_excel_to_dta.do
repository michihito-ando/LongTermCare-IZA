***********************
*** 目的：Excelをdtaに変換。これまでのファイルの整理
*** 2019年12月9日
*** 2020

/// 古市の環境///

global pc "C:\Users\rethink\Dropbox"

global cd_raw ""$pc\LTCI_FISS2016\Excel\raw""
global cd_save ""$pc\LTCI_FISS2016\STATA\raw\201911""

/// 後で修正


program rec_id_OECD
gen id_n = 0
 recode id_n 0=1  if Country=="Australia"
 recode id_n 0=2  if Country=="Austria"
 recode id_n 0=3  if Country=="Belgium"	
 recode id_n 0=4  if Country=="Canada"	
 recode id_n 0=5  if Country=="Chile"	
 recode id_n 0=6  if Country=="Czech Republic"	
 recode id_n 0=7  if Country=="Denmark"	
 recode id_n 0=8  if Country=="Estonia"	
 recode id_n 0=9  if Country=="Finland"	
 recode id_n 0=10  if Country=="France"	
 recode id_n 0=11 if Country=="Germany"	
 recode id_n 0=12  if Country=="Greece"	
 recode id_n 0=13  if Country=="Hungary"	
 recode id_n 0=14  if Country=="Iceland"	
 recode id_n 0=15  if Country=="Ireland"	
 recode id_n 0=16  if Country=="Israel"	
 recode id_n 0=17  if Country=="Italy"	
 recode id_n 0=18  if Country=="Japan"	
 recode id_n 0=19  if Country=="Korea"	
 recode id_n 0=20  if Country=="Luxembourg"	
 recode id_n 0=21  if Country=="Mexico"	
 recode id_n 0=22  if Country=="Netherlands"	
 recode id_n 0=23  if Country=="New Zealand"	
 recode id_n 0=24  if Country=="Norway"	
 recode id_n 0=25  if Country=="Poland"	
 recode id_n 0=26  if Country=="Portugal"	
 recode id_n 0=27  if Country=="Slovak Republic"	
 recode id_n 0=28  if Country=="Slovenia"	
 recode id_n 0=29  if Country=="Spain"	
 recode id_n 0=30  if Country=="Sweden"	
 recode id_n 0=31  if Country=="Switzerland"	
 recode id_n 0=32  if Country=="Turkey"	
 recode id_n 0=33  if Country=="United Kingdom"	
 recode id_n 0=34  if Country=="United States"	
end

program rename_oecd

	
	quietly rename D `1'1980
	quietly rename E `1'1981
	quietly rename F `1'1982
	quietly rename G `1'1983
	quietly rename H `1'1984
	quietly rename I `1'1985
	quietly rename J `1'1986
	quietly rename K `1'1987
	quietly rename L `1'1988
	quietly rename M `1'1989
	quietly rename N `1'1990 
	quietly rename O `1'1991 
	quietly rename P `1'1992 
	quietly rename Q `1'1993 
	quietly rename R `1'1994 
	quietly rename S `1'1995
	quietly rename T `1'1996 
	quietly rename U `1'1997 
	quietly rename V `1'1998 
	quietly rename W `1'1999 
	
	quietly rename X `1'2000 
	quietly rename Y `1'2001 
	quietly rename Z `1'2002 
	quietly rename AA `1'2003 
	quietly rename AB `1'2004 
	quietly rename AC `1'2005
	quietly rename AD `1'2006 
	quietly rename AE `1'2007 
	quietly rename AF `1'2008 
	quietly rename AG `1'2009 
	quietly rename AH `1'2010
	quietly rename AI `1'2011 
	quietly rename AJ `1'2012 
	quietly rename AK `1'2013 
	quietly rename AL `1'2014 
	quietly rename AM `1'2015 
	quietly rename AN `1'2016 
	quietly rename AO `1'2017 
	quietly rename AP `1'2018 
	
end

\\\\

*********************
*** Excel data taken from World bank, World development indicators 

cd $cd_raw

import excel "female_labor_WDI.xlsx", sheet("Sheet2") firstrow clear
qui destring idn fe_pop_n**** lfpr_fe_of_fpop_ILO**** lfpr_fe_of_fpop_n**** flf_of_tlf**** fpop_of_tot**** fwsw_of_fe****,replace
reshape long fe_pop_ILO  fe_pop_n lfpr_fe_of_fpop_ILO lfpr_fe_of_fpop_n flf_of_tlf fpop_of_tot  fwsw_of_fe,i(idn) j(year)

cd $cd_save
save female_wdi.dta,replace


*OECD、病床数、
import excel "2016_04\beds in residential long term care facilities.xlsx", sheet("data") firstrow
destring idn beds_rltcf_n1960 beds_rltcf_n1961 beds_rltcf_n1962 beds_rltcf_n1963 beds_rltcf_n1964 beds_rltcf_n1965 beds_rltcf_n1966 beds_rltcf_n1967 beds_rltcf_n1968 beds_rltcf_n1969 beds_rltcf_n1970 beds_rltcf_n1971 beds_rltcf_n1972 beds_rltcf_n1973 beds_rltcf_n1974 beds_rltcf_n1975 beds_rltcf_n1976 beds_rltcf_n1977 beds_rltcf_n1978 beds_rltcf_n1979 beds_rltcf_n1980 beds_rltcf_n1981 beds_rltcf_n1982 beds_rltcf_n1983 beds_rltcf_n1984 beds_rltcf_n1985 beds_rltcf_n1986 beds_rltcf_n1987 beds_rltcf_n1988 beds_rltcf_n1989 beds_rltcf_n1990 beds_rltcf_n1991 beds_rltcf_n1992 beds_rltcf_n1993 beds_rltcf_n1994 beds_rltcf_n1995 beds_rltcf_n1996 beds_rltcf_n1997 beds_rltcf_n1998 beds_rltcf_n1999 beds_rltcf_n2000 beds_rltcf_n2001 beds_rltcf_n2002 beds_rltcf_n2003 beds_rltcf_n2004 beds_rltcf_n2005 beds_rltcf_n2006 beds_rltcf_n2007 beds_rltcf_n2008 beds_rltcf_n2009 beds_rltcf_n2010 beds_rltcf_n2011 beds_rltcf_n2012 beds_rltcf_n2013 beds_rltcf_pert1960 beds_rltcf_pert1961 beds_rltcf_pert1962 beds_rltcf_pert1963 beds_rltcf_pert1964 beds_rltcf_pert1965 beds_rltcf_pert1966 beds_rltcf_pert1967 beds_rltcf_pert1968 beds_rltcf_pert1969 beds_rltcf_pert1970 beds_rltcf_pert1971 beds_rltcf_pert1972 beds_rltcf_pert1973 beds_rltcf_pert1974 beds_rltcf_pert1975 beds_rltcf_pert1976 beds_rltcf_pert1977 beds_rltcf_pert1978 beds_rltcf_pert1979 beds_rltcf_pert1980 beds_rltcf_pert1981 beds_rltcf_pert1982 beds_rltcf_pert1983 beds_rltcf_pert1984 beds_rltcf_pert1985 beds_rltcf_pert1986 beds_rltcf_pert1987 beds_rltcf_pert1988 beds_rltcf_pert1989 beds_rltcf_pert1990 beds_rltcf_pert1991 beds_rltcf_pert1992 beds_rltcf_pert1993 beds_rltcf_pert1994 beds_rltcf_pert1995 beds_rltcf_pert1996 beds_rltcf_pert1997 beds_rltcf_pert1998 beds_rltcf_pert1999 beds_rltcf_pert2000 beds_rltcf_pert2001 beds_rltcf_pert2002 beds_rltcf_pert2003 beds_rltcf_pert2004 beds_rltcf_pert2005 beds_rltcf_pert2006 beds_rltcf_pert2007 beds_rltcf_pert2008 beds_rltcf_pert2009 beds_rltcf_pert2010 beds_rltcf_pert2011 beds_rltcf_pert2012 beds_rltcf_pert2013 beds_rltcf_65over1960 beds_rltcf_65over1961 beds_rltcf_65over1962 beds_rltcf_65over1963 beds_rltcf_65over1964 beds_rltcf_65over1965 beds_rltcf_65over1966 beds_rltcf_65over1967 beds_rltcf_65over1968 beds_rltcf_65over1969 beds_rltcf_65over1970 beds_rltcf_65over1971 beds_rltcf_65over1972 beds_rltcf_65over1973 beds_rltcf_65over1974 beds_rltcf_65over1975 beds_rltcf_65over1976 beds_rltcf_65over1977 beds_rltcf_65over1978 beds_rltcf_65over1979 beds_rltcf_65over1980 beds_rltcf_65over1981 beds_rltcf_65over1982 beds_rltcf_65over1983 beds_rltcf_65over1984 beds_rltcf_65over1985 beds_rltcf_65over1986 beds_rltcf_65over1987 beds_rltcf_65over1988 beds_rltcf_65over1989 beds_rltcf_65over1990 beds_rltcf_65over1991 beds_rltcf_65over1992 beds_rltcf_65over1993 beds_rltcf_65over1994 beds_rltcf_65over1995 beds_rltcf_65over1996 beds_rltcf_65over1997 beds_rltcf_65over1998 beds_rltcf_65over1999 beds_rltcf_65over2000 beds_rltcf_65over2001 beds_rltcf_65over2002 beds_rltcf_65over2003 beds_rltcf_65over2004 beds_rltcf_65over2005 beds_rltcf_65over2006 beds_rltcf_65over2007 beds_rltcf_65over2008 beds_rltcf_65over2009 beds_rltcf_65over2010 beds_rltcf_65over2011 beds_rltcf_65over2012 beds_rltcf_65over2013,replace
reshape long beds_rltcf_n beds_rltcf_pert beds_rltcf_65over,i(idn) j(year)

*oecd, OLD age care
cd $cd_raw

import excel "oldage_care_homehelp.xlsx", sheet("Sheet2") firstrow clear
qui destring recare_homehelp****,replace
reshape long recare_homehelp,i(idn) j(year)

cd $cd_save

save oldage_care_homehelp.dta,replace

/// 2020/03/12　OECD 

cd $cd_raw

import excel "total health and social employment.xlsx", sheet("Total health and social employm") clear
drop in 1/4
drop B C
drop in 39/44

rename_oecd to_health_social_emp
drop in 1/2

rename A Country

qui destring,replace

forvalues i = 1980/2012  {

	qui replace to_health_social_emp`i' = "." if to_health_social_emp`i' ==".."
}


forvalues i = 2014/2018  {

	qui replace to_health_social_emp`i' = "." if to_health_social_emp`i' ==".."
}

qui destring,replace

rec_id_OECD


/*
Latvia
Lithuania
drop
*/

drop if id_n==0
reshape long to_health_social_emp,i(id_n) j(year)

label vari to_health_social_emp "Total health and social employment(Density per 1 000 population (head counts))"
rename to_health_social_emp health_social_employ
cd "$pc\LTCI_FISS2016\STATA\raw"

save to_health_social_emp,replace

////
