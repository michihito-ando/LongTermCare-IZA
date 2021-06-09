/***************************************
作成日：2016/09/18
2016/09/25
目的：OECD,LFS,employment/population rateをdtaファイルに変換

******************************************/


//global pc1 "C:\Users\rethink\Dropbox\2016_with ando and kaneko"  /// Furuichi's PC

global pc "C:\Users\rethink\Dropbox\LTCI_FISS2016"  /// 共有フォルダ。古市の環境

* cd 
global data ""$pc\Excel\OECD_LFS"" 

global data_dta ""$pc\STATA\raw""

//// cd "C:\Users\rethink\Dropbox\2016_with ando and kaneko\OECD_LFS"

cd $data

***************************************************************************************************************
****** LFS by age group taken from OECD                                                               *********
***************************************************************************************************************

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

	quietly rename B `1'1960
	quietly rename C `1'1961
	quietly rename D `1'1962
	quietly rename E `1'1963
	quietly rename F `1'1964
	quietly rename G `1'1965
	quietly rename H `1'1966
	quietly rename I `1'1967
	quietly rename J `1'1968
	quietly rename K `1'1969
	quietly rename L `1'1970
	quietly rename M `1'1971
	quietly rename N `1'1972 
	quietly rename O `1'1973 
	quietly rename P `1'1974 
	quietly rename Q `1'1975 
	quietly rename R `1'1976 
	quietly rename S `1'1977
	quietly rename T `1'1978 
	quietly rename U `1'1979 
	quietly rename V `1'1980 
	quietly rename W `1'1981 
	quietly rename X `1'1982 
	quietly rename Y `1'1983 
	quietly rename Z `1'1984 
	quietly rename AA `1'1985 
	quietly rename AB `1'1986 
	quietly rename AC `1'1987 
	quietly rename AD `1'1988 
	quietly rename AE `1'1989 
	quietly rename AF `1'1990 
	quietly rename AG `1'1991 
	quietly rename AH `1'1992
	quietly rename AI `1'1993 
	quietly rename AJ `1'1994 
	quietly rename AK `1'1995 
	quietly rename AL `1'1996 
	quietly rename AM `1'1997 
	quietly rename AN `1'1998 
	quietly rename AO `1'1999 
	quietly rename AP `1'2000 
	quietly rename AQ `1'2001 
	quietly rename AR `1'2002 
	quietly rename AS `1'2003 
	quietly rename AT `1'2004 
	quietly rename AU `1'2005 
	quietly rename AV `1'2006 
	quietly rename AW `1'2007 
	quietly rename AX `1'2008 
	quietly rename AY `1'2009 
	quietly rename AZ `1'2010 
	quietly rename BA `1'2011 
	quietly rename BB `1'2012 
	quietly rename BC `1'2013
end

\\\\


****************************************************
* LFS by age.  
*****************************************************

program OECD_LFP_to_dta
	import excel `1'.xlsx, sheet("Sheet2") firstrow clear

	quietly rec_id_OECD
	quietly rename_oecd `1' 

	forvalues i =1960/1999 {

	quietly replace `1'`i'="." if `1'`i'==".."
	quietly destring `1'`i',replace
	}
	*
	reshape long `1',i(id_n) j(year)
	save `1'.dta,replace
end

OECD_LFP_to_dta LFP_15to64_all
OECD_LFP_to_dta LFP_15to64_men
OECD_LFP_to_dta LFP_15to64_fe

OECD_LFP_to_dta LFP_25to54_all
OECD_LFP_to_dta LFP_25to54_men
OECD_LFP_to_dta LFP_25to54_fe

OECD_LFP_to_dta LFP_55to64_all
OECD_LFP_to_dta LFP_55to64_men
OECD_LFP_to_dta LFP_55to64_fe

*****LFS by age *******

OECD_LFP_to_dta lfp_30to34_all
OECD_LFP_to_dta lfp_30to34_fe
OECD_LFP_to_dta lfp_30to34_men

OECD_LFP_to_dta lfp_35to39_all
OECD_LFP_to_dta lfp_35to39_fe
OECD_LFP_to_dta lfp_35to39_men

OECD_LFP_to_dta lfp_35to44_all
OECD_LFP_to_dta lfp_35to44_fe
OECD_LFP_to_dta lfp_35to44_men

OECD_LFP_to_dta lfp_40to44_all
OECD_LFP_to_dta lfp_40to44_fe
OECD_LFP_to_dta lfp_40to44_men

OECD_LFP_to_dta lfp_45to49_all
OECD_LFP_to_dta lfp_45to49_fe
OECD_LFP_to_dta lfp_45to49_men

OECD_LFP_to_dta lfp_45to54_men
OECD_LFP_to_dta lfp_45to54_fe
OECD_LFP_to_dta lfp_45to54_all

OECD_LFP_to_dta lfp_50to54_all
OECD_LFP_to_dta lfp_50to54_fe
OECD_LFP_to_dta lfp_50to54_men

OECD_LFP_to_dta lfp_55to59_men
OECD_LFP_to_dta lfp_55to59_fe
OECD_LFP_to_dta lfp_55to59_all

***************


*****employment/population rate ,by sex , by age group**********

OECD_LFP_to_dta emp_pop_15to64_all
OECD_LFP_to_dta emp_pop_15to64_men
OECD_LFP_to_dta emp_pop_15to64_fe

OECD_LFP_to_dta emp_pop_25to54_all
OECD_LFP_to_dta emp_pop_25to54_men
OECD_LFP_to_dta emp_pop_25to54_fe

OECD_LFP_to_dta emp_pop_55to64_all
OECD_LFP_to_dta emp_pop_55to64_men
OECD_LFP_to_dta emp_pop_55to64_fe

*********merge master LTCI_temp *******

use FISS_temp.dta, clear

global oecd_lfp = " LFP_15to64_all LFP_15to64_men LFP_15to64_fe LFP_25to54_all LFP_25to54_men LFP_25to54_fe LFP_55to64_all LFP_55to64_men LFP_55to64_fe"
global oecd_emp =" emp_pop_15to64_all   emp_pop_15to64_men   emp_pop_15to64_fe   emp_pop_25to54_all   emp_pop_25to54_men    emp_pop_25to54_fe emp_pop_55to64_all emp_pop_55to64_men   emp_pop_55to64_fe"
global  oecd_lfp2="lfp_30to34_all lfp_30to34_fe lfp_30to34_men lfp_35to39_all   lfp_35to39_fe   lfp_35to39_men  lfp_35to44_all  lfp_35to44_fe  lfp_35to44_men  lfp_40to44_all lfp_40to44_fe lfp_40to44_men"
global  oecd_lfp3="lfp_45to49_all lfp_45to49_fe   lfp_45to49_men lfp_45to54_men lfp_45to54_fe lfp_45to54_all lfp_50to54_all lfp_50to54_fe lfp_50to54_men  lfp_55to59_men lfp_55to59_fe lfp_55to59_all"

foreach x in $oecd_lfp' $oecd_emp'{

quietly merge 1:1 id_n year using `x'
quietly drop _merge
}
*
*2016 0925 *
foreach x in $oecd_lfp2 $oecd_lfp3{

quietly merge 1:1 id_n year using `x'
quietly drop _merge
}
*


****label  

quietly label variable LFP_15to64_all "Labour force participation rate(%),all persons,(aged 15-64)"
quietly label variable LFP_15to64_men "Labour force participation rate(%),men,(aged 15-64)"
quietly label variable LFP_15to64_fe "Labour force participation rate(%), women,(aged 15-64)"
quietly label variable LFP_25to54_all "Labour force participation rate(%),all persons,(aged 25-54)"
quietly label variable LFP_25to54_men "Labour force participation rate(%),men,(aged 25-54)"
quietly label variable LFP_25to54_fe "Labour force participation rate(%),women,(aged 25-54)"
quietly label variable LFP_55to64_all "Labour force participation rate(%),all persons,(aged 55-64)"
quietly label variable LFP_55to64_men "Labour force participation rate(%),men,(aged 55-64)" 
quietly label variable LFP_55to64_fe "Labour force participation rate(%),women,(aged 55-64)"

quietly label variable emp_pop_15to64_all "Employment/population ratio (%),All persons (aged 15to64)"
quietly label variable emp_pop_15to64_men "Employment/population ratio (%),men (aged 15to64)"
quietly label variable emp_pop_15to64_fe "Employment/population ratio (%),women (aged 15to64)"
quietly label variable emp_pop_25to54_all "Employment/population ratio (%),All persons (aged 25to54)" 
quietly label variable emp_pop_25to54_men  "Employment/population ratio (%),men (aged 25to54)" 
quietly label variable emp_pop_25to54_fe "Employment/population ratio (%),women (aged 25to54)" 
quietly label variable emp_pop_55to64_all "Employment/population ratio (%),All persons (aged 55to54)" 
quietly label variable emp_pop_55to64_men "Employment/population ratio (%),men (aged 55to54)"
quietly label variable emp_pop_55to64_fe "Employment/population ratio (%),women (aged 55to54)"

quietly label variable lfp_30to34_all "Labour force participation rate(%),all persons,(aged 30-34)"
quietly label variable lfp_30to34_fe "Labour force participation rate(%),female,(aged 30-34)"
quietly label variable lfp_30to34_men "Labour force participation rate(%),men,(aged 30-34)"
quietly label variable lfp_35to39_all "Labour force participation rate(%),all persons,(aged 35-39)"
quietly label variable lfp_35to39_fe  "Labour force participation rate(%),female,(aged 35-39)"
quietly label variable lfp_35to39_men  "Labour force participation rate(%),men,(aged 35-39)"
quietly label variable lfp_35to44_all  "Labour force participation rate(%),all persons,(aged 35-44)"
quietly label variable lfp_35to44_fe  "Labour force participation rate(%),female,(aged 35-44)"
quietly label variable lfp_35to44_men  "Labour force participation rate(%),men,(aged 35-44)"
quietly label variable lfp_40to44_all "Labour force participation rate(%),all persons,(aged 40-44)"
quietly label variable lfp_40to44_fe  "Labour force participation rate(%),female,(aged 40-44)"
quietly label variable lfp_40to44_men  "Labour force participation rate(%),men,(aged 40-44)"
quietly label variable lfp_45to49_all  "Labour force participation rate(%),all persons,(aged 45-49)"
quietly label variable lfp_45to49_fe  "Labour force participation rate(%),female,(aged 45-49)"
quietly label variable lfp_45to49_men   "Labour force participation rate(%),men,(aged 45-49)"
quietly label variable lfp_45to54_men   "Labour force participation rate(%),men,(aged 45-54)"
quietly label variable lfp_45to54_fe   "Labour force participation rate(%),female,(aged 45-54)"
quietly label variable lfp_45to54_all "Labour force participation rate(%),all persons,(aged 45-54)"
quietly label variable lfp_50to54_all "Labour force participation rate(%),all persons,(aged 50-54)" 
quietly label variable lfp_50to54_fe "Labour force participation rate(%),female,(aged 50-54)" 
quietly label variable lfp_50to54_men "Labour force participation rate(%),men,(aged 50-54)" 
quietly label variable lfp_55to59_men "Labour force participation rate(%),men,(aged 55-59)" 
quietly label variable lfp_55to59_fe "Labour force participation rate(%),female,(aged 55-59)" 
quietly label variable lfp_55to59_all "Labour force participation rate(%),all persons,(aged 55-59)" 

//save

cd $data_dta

save oecd_lfp_empr,replace
