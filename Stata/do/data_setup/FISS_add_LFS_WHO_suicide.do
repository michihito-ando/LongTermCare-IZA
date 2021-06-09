/***************************************
作成日：2016/07/16、2016/07/31
目的：年齢別自殺率、年齢層別雇用率をdtaファイルに転換
/ FISS_add1.dtaファイル作成
/　ファイル名はどうするか？
/ FISS参加前後作成ファイル
/ 元doファイルにあったacuteデータやhospital bedsの変換はない
******************************************/


////cd 
//global pc1 "C:\Users\rethink\Dropbox\2016_with ando and kaneko"  /// Furuichi's PC

global pc "C:\Users\rethink\Dropbox\LTCI_FISS2016"

/// 共有フォルダ。古市の環境

* cd 

global death "$pc\Excel\No of deaths\"
global LFS "$pc\Excel\LFS\"
global raw "$pc\"

***********************************************************************************
**** suicide_all taken from WHO. excel to dta    *******************************
*********************************************************************************

program rename_sui_who
		
		quietly rename AI `1'1980
		quietly rename AH `1'1981
		quietly rename AG `1'1982
		quietly rename AF `1'1983
		quietly rename AE `1'1984
		quietly  rename AD `1'1985
		quietly  rename AC `1'1986
		quietly  rename AB `1'1987
		quietly  rename AA `1'1988
		quietly  rename Z `1'1989
		quietly  rename Y `1'1990
		quietly  rename X `1'1991
		quietly  rename W `1'1992
		quietly  rename V `1'1993
		quietly  rename U `1'1994
		quietly  rename T `1'1995
		quietly  rename S `1'1996
		quietly  rename R `1'1997
		quietly  rename Q `1'1998
		quietly  rename P `1'1999
		 quietly rename O `1'2000
		quietly  rename N `1'2001
		quietly  rename M `1'2002
		quietly  rename L `1'2003
		quietly  rename K `1'2004
		quietly  rename J `1'2005
		quietly  rename I `1'2006
		quietly  rename H `1'2007
		quietly  rename G `1'2008
		quietly  rename F `1'2009
		quietly  rename E `1'2010
		quietly  rename D `1'2011
		quietly  rename C `1'2012
		quietly  rename B `1'2013
end

program rec_id_WHO
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
		 recode id_n 0=19  if Country=="Republic of Korea"	
		 recode id_n 0=20  if Country=="Luxembourg"	
		 recode id_n 0=21  if Country=="Mexico"	
		 recode id_n 0=22  if Country=="Netherlands"	
		 recode id_n 0=23  if Country=="New Zealand"	
		 recode id_n 0=24  if Country=="Norway"	
		 recode id_n 0=25  if Country=="Poland"	
		 recode id_n 0=26  if Country=="Portugal"	
		 recode id_n 0=27  if Country=="Slovakia"	
		 recode id_n 0=28  if Country=="Slovenia"	
		 recode id_n 0=29  if Country=="Spain"	
		 recode id_n 0=30  if Country=="Sweden"	
		 recode id_n 0=31  if Country=="Switzerland"	
		 recode id_n 0=32  if Country=="Turkey"	
		 recode id_n 0=33  if Country=="United Kingdom"	
		 recode id_n 0=34  if Country=="United States of America"	
end


*************************
* suicide_all_25to34*
*********************

cd "$death"

///"C:\Users\rethink\Dropbox\2016_with ando and kaneko\No of deaths"

import excel "both_sex25to34.xlsx", sheet("data") firstrow clear
quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ"
quietly rename Countries Country
quietly destring `varlist',replace

quietly rename AJ sui_25to34_a1979 
quietly rename_sui_who sui_25to34_a
quietly rec_id_WHO

reshape long sui_25to34_a, i(id_n) j(year)
drop Country

save sui_all25to34.dta,replace

********************************************
*sui_all_35to54.excel to dta*
*******************************************

import excel "both_sex35to54.xlsx", sheet("data") firstrow clear

local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
rename Countries Country

quietly  destring `varlist',replace
quietly rename_sui_who sui_35to54_a
quietly rec_id_WHO

reshape long sui_35to54_a, i(id_n) j(year)
drop Country

save sui_all35to54.dta,replace

************************************
*sui_all_55to74.excel to dta*
************************************
import excel "both_sex55to74.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_55to74_a
quietly rec_id_WHO
reshape long sui_55to74_a, i(id_n) j(year)
drop Country

save sui_all55to74.dta,replace

*********************************
**** sui_all_74to.excel to dta*****
***********************************

import excel "both_sex75to.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_74to_a
quietly rec_id_WHO
reshape long sui_74to_a, i(id_n) j(year)
drop Country

save sui_all74to.dta,replace

***********************************************************************
****  the number of suicide(self-harm)_male                        *****
****   taken from WHO. excel to dta                               *****
***********************************************************************

**********************************************************************
** sui_25to34male
******************************************************************:
import excel "suicide_male25to34.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_25to34male
quietly rec_id_WHO

reshape long sui_25to34male, i(id_n) j(year)
drop Country
save sui_25to34male.dta,replace

*****************************************************************
***sui_35to54male
****************************************************************

import excel "sui_35to54male.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_35to54male
quietly rec_id_WHO

reshape long sui_35to54male, i(id_n) j(year)
drop Country

save sui_35to54male.dta,replace

***********************************************************************
***** sui_55to74male
**********************************************************************

import excel "sui_55to74male.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_55to74male
quietly rec_id_WHO

reshape long sui_55to74male, i(id_n) j(year)
drop Country

save sui_55to74male.dta,replace

****************************************************************
**** sui_75to_male
***************************************************************

import excel "suicide_male75to.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_75to_male

quietly rec_id_WHO

reshape long sui_75to_male, i(id_n) j(year)
drop Country

save sui_75to_male.dta,replace


************************************************
*** female suicide ( self-harm) by age-group  
************************************************

*************************************************
** suicide_female25to34
***********************************************

import excel "suicide_female25to34.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_25to34fe
quietly rec_id_WHO

reshape long sui_25to34fe, i(id_n) j(year)
drop Country

save sui_25to34fe.dta,replace


******************************
*** suicide_female35to54
******************************

import excel "suicide_female35to54.xlsx", sheet("data") firstrow clear


quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_35to54fe

quietly rec_id_WHO

reshape long sui_35to54fe, i(id_n) j(year)
drop Country

save sui_35to54fe.dta,replace


******************************
***  suicide. No. of deaths - Intentional self-harm, female, 55-74 years
******************************

import excel "sui_55to74fe.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_55to74fe
quietly rec_id_WHO

reshape long sui_55to74fe, i(id_n) j(year)
drop Country

save sui_55to74fe.dta,replace


*******************************************************
***suicide_female No. of deaths - Intentional self-harm, female, 75+ years
*********************************************************

import excel "suicide_female75to.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who sui_75to_fe
quietly rec_id_WHO

reshape long sui_75to_fe, i(id_n) j(year)
drop Country

save sui_75to_fe.dta,replace


***********************************************************
*****                                                 *****
*****    population_all taken from WHO excel to dta   *****
*****                                                 *****
***********************************************************

** pop_25to34all taken from WHO

import excel "pop_25to34.xlsx",sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_25to34all
quietly rec_id_WHO

reshape long pop_25to34all, i(id_n) j(year)
drop Country

save who_pop_25to34all.dta,replace


*******  pop_35to54all        ***********

import excel "pop_35to54.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_35to54all
quietly rec_id_WHO

reshape long pop_35to54all, i(id_n) j(year)
drop Country

save who_pop_35to54all.dta,replace

******pop_54to75all ***********

import excel pop_55to74.xlsx, sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_55to74all
quietly rec_id_WHO

reshape long pop_55to74all, i(id_n) j(year)
drop Country

save who_pop_55to74all.dta,replace

*********who_pop_75to***************

import excel "pop75to.xlsx", sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_75to_all

quietly rec_id_WHO

reshape long pop_75to_all, i(id_n) j(year)
drop Country

save who_pop_75to_all.dta,replace

**************************************************************
*****                                                    *****
*****    population_female taken from WHO excel to dta   *****
*****                                                    *****
**************************************************************

**********************************************
** pop_25to34fe taken from WHO            ****
** Population - numbers, female, 25-34 years**
**********************************************

////20191211

import excel "pop_female25to34.xlsx",sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_25to34fe

quietly rec_id_WHO

reshape long pop_25to34fe, i(id_n) j(year)
drop Country

*save *
save who_pop_25to34fe.dta,replace

**********************************************
** pop_35to54fe taken from WHO            ****
** Population - numbers, female, 35-54 years**
**********************************************
import excel "pop_female35to54.xlsx",sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_35to54fe

quietly rec_id_WHO

reshape long pop_35to54fe, i(id_n) j(year)
drop Country

*save *
save who_pop_35to54fe.dta,replace

**********************************************
** pop_55to74fe taken from WHO            ****
** Population - numbers, female, 55-74 years**
**********************************************

import excel "pop_female55to74.xlsx",sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_55to74fe

quietly rec_id_WHO

reshape long pop_55to74fe, i(id_n) j(year)
drop Country

*save *
save who_pop_55to74fe.dta,replace

**********************************************
** pop_75to_fe taken from WHO            ****
** Population - numbers, female, 75+ years ***
**********************************************

import excel "pop_female75to.xlsx",sheet("data") firstrow clear

quietly local varlist = "B C D E F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI "
quietly rename Countries Country

quietly destring `varlist',replace
quietly rename_sui_who pop_75to_fe


quietly rec_id_WHO

reshape long pop_75to_fe, i(id_n) j(year)
drop Country

*save *
save who_pop_75to_fe.dta,replace

***************************************************************************************************************
******                                                                                                *********
****** LFS by age group taken from OECD                                                               *********
******                                                                                                *********
***************************************************************************************************************

program rename_LFS_oecd
		quietly rename B `1'1976 
		quietly rename C `1'1977
		quietly rename D `1'1978
		quietly rename E `1'1979
		quietly rename F `1'1980
		quietly rename G `1'1981
		quietly rename H `1'1982
		quietly rename I `1'1983
		quietly rename J `1'1984
		quietly rename K `1'1985
		quietly rename L `1'1986
		quietly rename M `1'1987
		quietly rename N `1'1988
		quietly rename O `1'1989
		quietly rename P `1'1990
		quietly rename Q `1'1991
		quietly rename R `1'1992
		quietly rename S `1'1993
		quietly rename T `1'1994
		quietly rename U `1'1995
		quietly rename V `1'1996
		quietly rename W `1'1997
		quietly rename X `1'1998
		quietly rename Y `1'1999
		quietly rename Z `1'2000
		quietly rename AA `1'2001
		quietly rename AB `1'2002
		quietly rename AC `1'2003
		quietly rename AD `1'2004
		quietly rename AE `1'2005
		quietly rename AF `1'2006
		quietly rename AG `1'2007
		quietly rename AH `1'2008
		quietly rename AI `1'2009
		quietly rename AJ `1'2010
		quietly rename AK `1'2011
		quietly rename AL `1'2012
		quietly rename AM `1'2013
end

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

****************************************************************************************
**** Women																																					
**** 25 to 54																																					
**** Total employment																																					
**** Annual																																					
**** Full-time employment																																					
**** Persons, Thousands																																					
********************************************************************************************

cd $LFS

import excel "wtf_age25to54.xlsx", sheet("data") firstrow

***rename **
quietly rename_LFS_oecd wtf_25to54age
quietly rec_id_OECD

**********************************************************:
* reshape
* change ".." to missing value
*************************************************************
reshape long wtf_25to54age, i(id_n) j(year)
replace wtf_25to54age= "." if wtf_25to54age==".."
quietly destring wtf_25to54age,replace

quietly label variable wtf_25to54age "Full-time employment of women (aged 25-54),Thousands"

save wtf_25to54age.dta,replace

*********************************************************************************************
**** Women																																					
**** 55 to 64																																					
**** Total employment																																					
**** Annual																																					
**** Full-time employment																																					
**** Persons, Thousands																																					
*********************************************************************************************
import excel "wtf_age55to64.xlsx", sheet("data") firstrow clear

***rename **
quietly rec_id_OECD
quietly rename_LFS_oecd wtf_55to64age

reshape long wtf_55to64age, i(id_n) j(year)
replace wtf_55to64age= "." if wtf_55to64age==".."
quietly destring wtf_55to64age,replace

quietly label variable wtf_55to64age "Full-time employment of women (aged 55-64),Thousands"

save wtf_55to64age.dta,replace

*******************************************************************************************
*****    Women																																					
****    25 to 54																																					
****    Total employment																																					
****   Annual																																					
****   Part-time employment																																					
****   Persons, Thousands																																					
******************************************************************************************

import excel "wtp_age25to54.xlsx", sheet("data") firstrow clear

quietly rec_id_OECD
quietly rename_LFS_oecd wtp_25to54age

reshape long wtp_25to54age, i(id_n) j(year)
replace wtp_25to54age= "." if wtp_25to54age==".."
quietly destring wtp_25to54age,replace

quietly label variable wtp_25to54age "Part-time employment of women (aged 25-54),Thousands"

save wtp_25to54age.dta,replace

******************************************************************************************
***** Women																																					
***** 55 to 64																																					
***** Total employment																																					
***** Annual																																					
***** Part-time employment																																					
***** Persons, Thousands																																					
*****
*********************************************************************************************

import excel "wtp_age_55to64.xlsx", sheet("data") firstrow clear

quietly rec_id_OECD
quietly rename_LFS_oecd wtp_55to64age

quietly reshape long wtp_55to64age, i(id_n) j(year)
quietly replace wtp_55to64age= "." if wtp_55to64age==".."

quietly destring wtp_55to64age,replace
quietly label variable wtp_55to64age "Part-time employment of women (aged 55-64),Thousands"

save wtp_55to64age.dta,replace


**************************************************************************************
***** All persons																																					
***** 25 to 54																																					
***** Total employment																																					
***** Annual																																					
***** Full-time employment																																					
***** Persons, Thousands																																					
**************************************************************************************

import excel "atf_age25to54.xlsx", sheet("data") firstrow

quietly rec_id_OECD
quietly rename_LFS_oecd atf_25to54age

quietly reshape long atf_25to54age, i(id_n) j(year)
quietly replace atf_25to54age= "." if atf_25to54age==".."

quietly destring atf_25to54age,replace
quietly label variable atf_25to54age "Full-time employment, all persons (aged 25-54),Thousands"

save atf_25to54age.dta,replace

************************************************************************************
*** Sex	All persons																																					
*** Age	55 to 64																																					
*** Employment status	Total employment																																					
*** Frequency	Annual																																					
*** Series	Full-time employment																																					
*** Unit	Persons, Thousands																																					
************************************************************************************

import excel "atf_age55to64.xlsx", sheet("data") firstrow clear

quietly rec_id_OECD
quietly rename_LFS_oecd atf_55to64age

quietly reshape long atf_55to64age, i(id_n) j(year)
quietly replace atf_55to64age= "." if atf_55to64age==".."

quietly destring atf_55to64age,replace
quietly label variable atf_55to64age "Full-time employment, all persons (aged 55-64),Thousands"

save atf_55to64age.dta,replace

**************************************************************************************************************:
**** Sex	All persons																																					
**** Age	25 to 54																																					
**** Employment status	Total employment																																					
**** Frequency	Annual																																					
**** Series	Part-time employment																																					
**** Unit	Persons, Thousands																																					
***************************************************************************************************************

import excel "atp_age25to54.xlsx", sheet("data") firstrow clear

quietly rec_id_OECD
quietly rename_LFS_oecd atp_25to54age

quietly reshape long atp_25to54age, i(id_n) j(year)
quietly replace atp_25to54age= "." if atp_25to54age==".."

quietly destring atp_25to54age,replace
quietly label variable atp_25to54age "Part-time employment, all persons (aged 25-54),Thousands"
save atp_25to54age.dta,replace


*****************************************************************************************************************
**** Sex	All persons																																					
**** Age	55 to 64																																					
**** Employment status	Total employment																																					
**** Frequency	Annual																																					
**** Series	Part-time employment																																					
**** Unit	Persons, Thousands																																					
******************************************************************************************************************
import excel "atp_age55to64.xlsx", sheet("data") firstrow clear

quietly rec_id_OECD
quietly rename_LFS_oecd atp_55to64age

quietly reshape long atp_55to64age, i(id_n) j(year)
quietly replace atp_55to64age= "." if atp_55to64age==".."

quietly destring atp_55to64age,replace
quietly label variable atp_55to64age "Part-time employment, all persons (aged 55-64),Thousands"

save atp_55to64age.dta,replace

**************************************************
*** merge
*** master FISS_temp  using no.of death , pop(taken from WHO)
*************************************************

use FISS_temp.dta, clear

cd $death

local suicide = "sui_25to34fe sui_25to34male sui_35to54fe sui_35to54male sui_55to74fe sui_55to74male sui_75to_fe sui_75to_male sui_all25to34 sui_all25to34 sui_all35to54 sui_all55to74 sui_all74to"
local  pop_who = "who_pop_25to34all who_pop_25to34fe who_pop_35to54all who_pop_35to54fe who_pop_55to74all who_pop_55to74fe who_pop_75to_all who_pop_75to_fe"

foreach x in `suicide' `pop_who' {

merge 1:1 id_n year using `x'
drop _merge

}
**************************************************
*** merge
*** master FISS_temp  using LFS ,ALOS, Hospital stay
*************************************************

********* set cd**********
cd "C:\Users\rethink\Dropbox\2016_with ando and kaneko\LFS"

local wtfp ="wtf_25to54age wtf_55to64age wtp_25to54age wtp_55to64age atf_25to54age atf_55to64age atp_25to54age atp_55to64age ALOS_acute"

********merge ********************************
foreach x in `wtfp' {

merge 1:1 id_n year using `x'
drop _merge

}
**********************************
*** merge hospital_beds_world bank***
cd "C:\Users\rethink\Dropbox\2016_with ando and kaneko

merge 1:1 id_n year using hospital_beds
drop _merge

****label variable 
quietly label variable sui_25to34fe "No. of deaths - Intentional self-harm, female, 25-34 years"
quietly label variable sui_25to34male "No. of deaths - Intentional self-harm, male, 25-34 years"
quietly label variable sui_35to54fe "No. of deaths - Intentional self-harm, female, 35-54 years"
quietly label variable sui_35to54male "No. of deaths - Intentional self-harm, male, 35-54 years"
quietly label variable sui_55to74fe "No. of deaths - Intentional self-harm, female, 55-74 years"
quietly label variable sui_55to74male "No. of deaths - Intentional self-harm, male, 55-74 years"
quietly label variable sui_75to_fe "No. of deaths - Intentional self-harm, female, 75+ years"
quietly label variable sui_75to_male "No. of deaths - Intentional self-harm, male, 75+ years"
quietly label variable sui_25to34_a "No. of deaths - Intentional self-harm, both sexes, 25-34 years"
quietly label variable sui_35to54_a "No. of deaths - Intentional self-harm, both sexes, 35-54 years"
quietly label variable sui_74to_a "No. of deaths - Intentional self-harm, both sexes, 75+ years"
quietly label variable pop_25to34all "Population - numbers, 25-34 years taken from WHO"
quietly label variable pop_25to34fe "Population - numbers, female, 25-34 years"
quietly label variable pop_35to54all "Population - numbers, 35-54 years taken from WHO"
quietly label variable pop_35to54fe "Population - numbers, female, 35-54 years"
quietly label variable pop_55to74all "Population - numbers, 25-34 years taken from WHO"
quietly label variable pop_55to74fe "Population - numbers, female, 55-74 years"
quietly label variable sui_55to74_a "No. of deaths - Intentional self-harm, both sexes, 55-74 years"
quietly label variable pop_75to_all "Population - numbers, 75+ years"
quietly label variable pop_75to_fe "Population - numbers, female, 75+ years"

///

rename id_n idn

save FISS_add1.dta,replace

***** merge ***********************************************
*** master LTCI_FISS20160524 using FISS_add1
*** 
*************************************************************
//use LTCI_FISS20160524
//rename idn id_n
//merge 1:1 id_n year using FISS_add1
//drop _merge

//save "C:\Users\rethink\Dropbox\2016_with ando and kaneko\LTCI20160730.dta",replace





