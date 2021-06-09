******************
** 目的(1)SOCXのbenefits in kind をexcelからdtaに変換,(2)高齢者データも変換。両者の割り算をトル。
**　手法：すべてstata上で操作
** 日時：2020/12/04
** 
**********************

/////////////////////////////////////////////
/// generate id_n
////////////////////////////////////////////

/*
Country		id		id_n
Australia	AUS		1
Austria		AUT		2
Belgium		BEL	3
Canada		CAN	4
Chile		CHL	5
Czech Republic	CZH	6
Denmark		DNK	7
Estonia		EST	8
Finland		FIN	9
France		FRA	10
Germany		DEU	11
Greece		GRC	12
Hungary		HUN	13
Iceland		ISL	14
Ireland		IRL	15
Israel		ISR	16
Italy		ITA	17
Japan		JPN	18
Korea		KOR	19
Luxembourg	LUX	20
Mexico		MEX	21
Netherlands	NLD	22
New Zealand	NZL	23
Norway		NOR	24
Poland		POL	25
Portugal	PRT	26
Slovak Republic	SVK	27
Slovenia	SVN	28
Spain		ESP	29
Sweden		SWE	30
Switzerland	CHE	31
Turkey		TUR	32
United Kingdom	UKM	33
United States	USA	34
*/


program id_n
		 gen id_n = 0
		 qui recode id_n 0=1  if Country=="Australia"
		 qui recode id_n 0=2  if Country=="Austria"
		 qui recode id_n 0=3  if Country=="Belgium"	
		 qui recode id_n 0=4  if Country=="Canada"	
		 qui recode id_n 0=5  if Country=="Chile"	
		 qui recode id_n 0=6  if Country=="Czech Republic"	
		 qui recode id_n 0=7  if Country=="Denmark"	
		 qui recode id_n 0=8  if Country=="Estonia"	
		 qui recode id_n 0=9  if Country=="Finland"	
		 qui recode id_n 0=10  if Country=="France"	
		 qui recode id_n 0=11 if Country=="Germany"	
		 qui recode id_n 0=12  if Country=="Greece"	
		 qui recode id_n 0=13  if Country=="Hungary"	
		 qui recode id_n 0=14  if Country=="Iceland"	
		 qui recode id_n 0=15  if Country=="Ireland"	
		 qui recode id_n 0=16  if Country=="Israel"	
		 qui recode id_n 0=17  if Country=="Italy"	
		 qui recode id_n 0=18  if Country=="Japan"	
		 qui recode id_n 0=19  if Country=="Korea"	
		 qui recode id_n 0=20  if Country=="Luxembourg"	
		 qui recode id_n 0=21  if Country=="Mexico"	
		 qui recode id_n 0=22  if Country=="Netherlands"	
		 qui recode id_n 0=23  if Country=="New Zealand"	
		 qui recode id_n 0=24  if Country=="Norway"	
		 qui recode id_n 0=25  if Country=="Poland"	
		 qui recode id_n 0=26  if Country=="Portugal"	
		 qui recode id_n 0=27  if Country=="Slovak Republic"	
		 qui recode id_n 0=28  if Country=="Slovenia"	
		 qui recode id_n 0=29  if Country=="Spain"	
		 qui recode id_n 0=30  if Country=="Sweden"	
		 qui recode id_n 0=31  if Country=="Switzerland"	
		 qui recode id_n 0=32  if Country=="Turkey"	
		 qui recode id_n 0=33  if Country=="United Kingdom"
		 qui recode id_n 0=34  if Country=="United States"
end


***set cd***

global cd_socx ""C:\Users\rethink\Dropbox\LTCI_FISS2016\Excel\socx\20201202\""
global cd_excel ""C:\Users\rethink\Dropbox\LTCI_FISS2016\Excel\""

cd $cd_socx


**import data pop


import excel "pop.xlsx", sheet("OECD.Stat export") clear

drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop1970
rename E pop1971
rename F pop1972
rename G pop1973
rename H pop1974
rename I pop1975
rename J pop1976
rename K pop1977
rename L pop1978
rename M pop1979
rename N pop1980
rename O pop1981
rename P pop1982
rename Q pop1983
rename R pop1984
rename S pop1985
rename T pop1986
rename U pop1987
rename V pop1988
rename W pop1989
rename X pop1990
rename Y pop1991
rename Z pop1992
rename AA pop1993
rename AB pop1994
rename AC pop1995
rename AD pop1996
rename AE pop1997
rename AF pop1998
rename AG pop1999
rename AH pop2000
rename AI pop2001
rename AJ pop2002
rename AK pop2003
rename AL pop2004
rename AM pop2005
rename AN pop2006
rename AO pop2007
rename AP pop2008
rename AQ pop2009
rename AR pop2010
rename AS pop2011
rename AT pop2012
rename AU pop2013
rename AV pop2014
rename AW pop2015
rename AX pop2016
rename AY pop2017
rename AZ pop2018


global popA "pop1970 pop1971 pop1972 pop1973 pop1974 pop1975 pop1976 pop1977 pop1978 pop1979 pop1980 pop1981 pop1982 pop1983 pop1984 pop1985 pop1986 pop1987 pop1988 pop1989 pop1990 pop1991 pop1992 pop1993 pop1994 pop1995 pop1996 pop1997 pop1998 pop1999 pop2000 pop2001 pop2002 pop2003 pop2004 pop2005 pop2006 pop2007 pop2008 pop2009 pop2010 pop2011 pop2012 pop2013 pop2014 pop2015 pop2016 pop2017 pop2018"


replace pop1980="." if pop1980==".."
replace pop1981="." if pop1981==".."
replace pop1982="." if pop1982==".."
replace pop1983="." if pop1983==".."
replace pop1984="." if pop1984==".."
replace pop2012="." if pop2012==".."
replace pop2013="." if pop2013==".."
replace pop2014="." if pop2014==".."
destring,replace

format %18.0g $popA

id_n 
drop if id_n==0
reshape long pop ,i(id_n) j(year)

save pop_all,replace
*

**import data**

import excel "pop_65to69.xlsx", sheet("OECD.Stat export") clear

drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop_65to691970
rename E pop_65to691971
rename F pop_65to691972
rename G pop_65to691973
rename H pop_65to691974
rename I pop_65to691975
rename J pop_65to691976
rename K pop_65to691977
rename L pop_65to691978
rename M pop_65to691979
rename N pop_65to691980
rename O pop_65to691981
rename P pop_65to691982
rename Q pop_65to691983
rename R pop_65to691984
rename S pop_65to691985
rename T pop_65to691986
rename U pop_65to691987
rename V pop_65to691988
rename W pop_65to691989
rename X pop_65to691990
rename Y pop_65to691991
rename Z pop_65to691992
rename AA pop_65to691993
rename AB pop_65to691994
rename AC pop_65to691995
rename AD pop_65to691996
rename AE pop_65to691997
rename AF pop_65to691998
rename AG pop_65to691999
rename AH pop_65to692000
rename AI pop_65to692001
rename AJ pop_65to692002
rename AK pop_65to692003
rename AL pop_65to692004
rename AM pop_65to692005
rename AN pop_65to692006
rename AO pop_65to692007
rename AP pop_65to692008
rename AQ pop_65to692009
rename AR pop_65to692010
rename AS pop_65to692011
rename AT pop_65to692012
rename AU pop_65to692013
rename AV pop_65to692014
rename AW pop_65to692015
rename AX pop_65to692016
rename AY pop_65to692017
rename AZ pop_65to692018


global pop_65to69A "pop_65to691970 pop_65to691971 pop_65to691972 pop_65to691973 pop_65to691974 pop_65to691975 pop_65to691976 pop_65to691977 pop_65to691978 pop_65to691979 pop_65to691980 pop_65to691981 pop_65to691982 pop_65to691983 pop_65to691984 pop_65to691985 pop_65to691986 pop_65to691987 pop_65to691988 pop_65to691989 pop_65to691990 pop_65to691991 pop_65to691992 pop_65to691993 pop_65to691994 pop_65to691995 pop_65to691996 pop_65to691997 pop_65to691998 pop_65to691999 pop_65to692000 pop_65to692001 pop_65to692002 pop_65to692003 pop_65to692004 pop_65to692005 pop_65to692006 pop_65to692007 pop_65to692008 pop_65to692009 pop_65to692010 pop_65to692011 pop_65to692012 pop_65to692013 pop_65to692014 pop_65to692015 pop_65to692016 pop_65to692017 pop_65to692018"


replace pop_65to691980="." if pop_65to691980==".."
replace pop_65to691981="." if pop_65to691981==".."
replace pop_65to691982="." if pop_65to691982==".."
replace pop_65to691983="." if pop_65to691983==".."
replace pop_65to691984="." if pop_65to691984==".."
replace pop_65to692012="." if pop_65to692012==".."
replace pop_65to692013="." if pop_65to692013==".."
replace pop_65to692014="." if pop_65to692014==".."
destring,replace

format %18.0g $pop_65to69A

id_n 
drop if id_n==0
reshape long pop_65to69 ,i(id_n) j(year)

save pop_65to69,replace

//////////////////////////
////// pop 70 to 74
//////////////////////////

import excel "pop_70to74.xlsx", sheet("OECD.Stat export") clear
drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop_70to741970
rename E pop_70to741971
rename F pop_70to741972
rename G pop_70to741973
rename H pop_70to741974
rename I pop_70to741975
rename J pop_70to741976
rename K pop_70to741977
rename L pop_70to741978
rename M pop_70to741979
rename N pop_70to741980
rename O pop_70to741981
rename P pop_70to741982
rename Q pop_70to741983
rename R pop_70to741984
rename S pop_70to741985
rename T pop_70to741986
rename U pop_70to741987
rename V pop_70to741988
rename W pop_70to741989
rename X pop_70to741990
rename Y pop_70to741991
rename Z pop_70to741992
rename AA pop_70to741993
rename AB pop_70to741994
rename AC pop_70to741995
rename AD pop_70to741996
rename AE pop_70to741997
rename AF pop_70to741998
rename AG pop_70to741999
rename AH pop_70to742000
rename AI pop_70to742001
rename AJ pop_70to742002
rename AK pop_70to742003
rename AL pop_70to742004
rename AM pop_70to742005
rename AN pop_70to742006
rename AO pop_70to742007
rename AP pop_70to742008
rename AQ pop_70to742009
rename AR pop_70to742010
rename AS pop_70to742011
rename AT pop_70to742012
rename AU pop_70to742013
rename AV pop_70to742014
rename AW pop_70to742015
rename AX pop_70to742016
rename AY pop_70to742017
rename AZ pop_70to742018


global pop_70to74A "pop_70to741970 pop_70to741971 pop_70to741972 pop_70to741973 pop_70to741974 pop_70to741975 pop_70to741976 pop_70to741977 pop_70to741978 pop_70to741979 pop_70to741980 pop_70to741981 pop_70to741982 pop_70to741983 pop_70to741984 pop_70to741985 pop_70to741986 pop_70to741987 pop_70to741988 pop_70to741989 pop_70to741990 pop_70to741991 pop_70to741992 pop_70to741993 pop_70to741994 pop_70to741995 pop_70to741996 pop_70to741997 pop_70to741998 pop_70to741999 pop_70to742000 pop_70to742001 pop_70to742002 pop_70to742003 pop_70to742004 pop_70to742005 pop_70to742006 pop_70to742007 pop_70to742008 pop_70to742009 pop_70to742010 pop_70to742011 pop_70to742012 pop_70to742013 pop_70to742014 pop_70to742015 pop_70to742016 pop_70to742017 pop_70to742018"


replace pop_70to741980="." if pop_70to741980==".."
replace pop_70to741981="." if pop_70to741981==".."
replace pop_70to741982="." if pop_70to741982==".."
replace pop_70to741983="." if pop_70to741983==".."
replace pop_70to741984="." if pop_70to741984==".."
replace pop_70to742012="." if pop_70to742012==".."
replace pop_70to742013="." if pop_70to742013==".."
replace pop_70to742014="." if pop_70to742014==".."
destring,replace

format %18.0g $pop_70to74A

id_n 
drop if id_n==0
reshape long pop_70to74 ,i(id_n) j(year)
save pop_70to74,replace


//////////////////////////
////// pop 75 to 79
//////////////////////////

import excel "pop_75to79.xlsx", sheet("OECD.Stat export") clear
drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop_75to791970
rename E pop_75to791971
rename F pop_75to791972
rename G pop_75to791973
rename H pop_75to791974
rename I pop_75to791975
rename J pop_75to791976
rename K pop_75to791977
rename L pop_75to791978
rename M pop_75to791979
rename N pop_75to791980
rename O pop_75to791981
rename P pop_75to791982
rename Q pop_75to791983
rename R pop_75to791984
rename S pop_75to791985
rename T pop_75to791986
rename U pop_75to791987
rename V pop_75to791988
rename W pop_75to791989
rename X pop_75to791990
rename Y pop_75to791991
rename Z pop_75to791992
rename AA pop_75to791993
rename AB pop_75to791994
rename AC pop_75to791995
rename AD pop_75to791996
rename AE pop_75to791997
rename AF pop_75to791998
rename AG pop_75to791999
rename AH pop_75to792000
rename AI pop_75to792001
rename AJ pop_75to792002
rename AK pop_75to792003
rename AL pop_75to792004
rename AM pop_75to792005
rename AN pop_75to792006
rename AO pop_75to792007
rename AP pop_75to792008
rename AQ pop_75to792009
rename AR pop_75to792010
rename AS pop_75to792011
rename AT pop_75to792012
rename AU pop_75to792013
rename AV pop_75to792014
rename AW pop_75to792015
rename AX pop_75to792016
rename AY pop_75to792017
rename AZ pop_75to792018


global pop_75to79A "pop_75to791970 pop_75to791971 pop_75to791972 pop_75to791973 pop_75to791974 pop_75to791975 pop_75to791976 pop_75to791977 pop_75to791978 pop_75to791979 pop_75to791980 pop_75to791981 pop_75to791982 pop_75to791983 pop_75to791984 pop_75to791985 pop_75to791986 pop_75to791987 pop_75to791988 pop_75to791989 pop_75to791990 pop_75to791991 pop_75to791992 pop_75to791993 pop_75to791994 pop_75to791995 pop_75to791996 pop_75to791997 pop_75to791998 pop_75to791999 pop_75to792000 pop_75to792001 pop_75to792002 pop_75to792003 pop_75to792004 pop_75to792005 pop_75to792006 pop_75to792007 pop_75to792008 pop_75to792009 pop_75to792010 pop_75to792011 pop_75to792012 pop_75to792013 pop_75to792014 pop_75to792015 pop_75to792016 pop_75to792017 pop_75to792018"


replace pop_75to791980="." if pop_75to791980==".."
replace pop_75to791981="." if pop_75to791981==".."
replace pop_75to791982="." if pop_75to791982==".."
replace pop_75to791983="." if pop_75to791983==".."
replace pop_75to791984="." if pop_75to791984==".."
replace pop_75to792012="." if pop_75to792012==".."
replace pop_75to792013="." if pop_75to792013==".."
replace pop_75to792014="." if pop_75to792014==".."
destring,replace

format %18.0g $pop_75to79A

id_n 
drop if id_n==0
reshape long pop_75to79 ,i(id_n) j(year)
save pop_75to79,replace


//////////////////////////
////// pop 80 to 84
//////////////////////////

import excel "pop_80to84.xlsx", sheet("OECD.Stat export") clear

drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop_80to841970
rename E pop_80to841971
rename F pop_80to841972
rename G pop_80to841973
rename H pop_80to841974
rename I pop_80to841975
rename J pop_80to841976
rename K pop_80to841977
rename L pop_80to841978
rename M pop_80to841979
rename N pop_80to841980
rename O pop_80to841981
rename P pop_80to841982
rename Q pop_80to841983
rename R pop_80to841984
rename S pop_80to841985
rename T pop_80to841986
rename U pop_80to841987
rename V pop_80to841988
rename W pop_80to841989
rename X pop_80to841990
rename Y pop_80to841991
rename Z pop_80to841992
rename AA pop_80to841993
rename AB pop_80to841994
rename AC pop_80to841995
rename AD pop_80to841996
rename AE pop_80to841997
rename AF pop_80to841998
rename AG pop_80to841999
rename AH pop_80to842000
rename AI pop_80to842001
rename AJ pop_80to842002
rename AK pop_80to842003
rename AL pop_80to842004
rename AM pop_80to842005
rename AN pop_80to842006
rename AO pop_80to842007
rename AP pop_80to842008
rename AQ pop_80to842009
rename AR pop_80to842010
rename AS pop_80to842011
rename AT pop_80to842012
rename AU pop_80to842013
rename AV pop_80to842014
rename AW pop_80to842015
rename AX pop_80to842016
rename AY pop_80to842017
rename AZ pop_80to842018


global pop_80to84A "pop_80to841970 pop_80to841971 pop_80to841972 pop_80to841973 pop_80to841974 pop_80to841975 pop_80to841976 pop_80to841977 pop_80to841978 pop_80to841979 pop_80to841980 pop_80to841981 pop_80to841982 pop_80to841983 pop_80to841984 pop_80to841985 pop_80to841986 pop_80to841987 pop_80to841988 pop_80to841989 pop_80to841990 pop_80to841991 pop_80to841992 pop_80to841993 pop_80to841994 pop_80to841995 pop_80to841996 pop_80to841997 pop_80to841998 pop_80to841999 pop_80to842000 pop_80to842001 pop_80to842002 pop_80to842003 pop_80to842004 pop_80to842005 pop_80to842006 pop_80to842007 pop_80to842008 pop_80to842009 pop_80to842010 pop_80to842011 pop_80to842012 pop_80to842013 pop_80to842014 pop_80to842015 pop_80to842016 pop_80to842017 pop_80to842018"


replace pop_80to841980="." if pop_80to841980==".."
replace pop_80to841981="." if pop_80to841981==".."
replace pop_80to841982="." if pop_80to841982==".."
replace pop_80to841983="." if pop_80to841983==".."
replace pop_80to841984="." if pop_80to841984==".."
replace pop_80to842012="." if pop_80to842012==".."
replace pop_80to842013="." if pop_80to842013==".."
replace pop_80to842014="." if pop_80to842014==".."
destring,replace

format %18.0g $pop_80to84A

id_n 
drop if id_n==0
reshape long pop_80to84 ,i(id_n) j(year)
save pop_80to84,replace

//////////////////////////
////// pop 85 over
//////////////////////////

import excel "pop_85over.xlsx", sheet("OECD.Stat export") clear

drop in 1/4
drop in 2
drop B C
drop in 39/58
rename A Country

rename D pop_85over1970
rename E pop_85over1971
rename F pop_85over1972
rename G pop_85over1973
rename H pop_85over1974
rename I pop_85over1975
rename J pop_85over1976
rename K pop_85over1977
rename L pop_85over1978
rename M pop_85over1979
rename N pop_85over1980
rename O pop_85over1981
rename P pop_85over1982
rename Q pop_85over1983
rename R pop_85over1984
rename S pop_85over1985
rename T pop_85over1986
rename U pop_85over1987
rename V pop_85over1988
rename W pop_85over1989
rename X pop_85over1990
rename Y pop_85over1991
rename Z pop_85over1992
rename AA pop_85over1993
rename AB pop_85over1994
rename AC pop_85over1995
rename AD pop_85over1996
rename AE pop_85over1997
rename AF pop_85over1998
rename AG pop_85over1999
rename AH pop_85over2000
rename AI pop_85over2001
rename AJ pop_85over2002
rename AK pop_85over2003
rename AL pop_85over2004
rename AM pop_85over2005
rename AN pop_85over2006
rename AO pop_85over2007
rename AP pop_85over2008
rename AQ pop_85over2009
rename AR pop_85over2010
rename AS pop_85over2011
rename AT pop_85over2012
rename AU pop_85over2013
rename AV pop_85over2014
rename AW pop_85over2015
rename AX pop_85over2016
rename AY pop_85over2017
rename AZ pop_85over2018


global pop_85overA "pop_85over1970 pop_85over1971 pop_85over1972 pop_85over1973 pop_85over1974 pop_85over1975 pop_85over1976 pop_85over1977 pop_85over1978 pop_85over1979 pop_85over1980 pop_85over1981 pop_85over1982 pop_85over1983 pop_85over1984 pop_85over1985 pop_85over1986 pop_85over1987 pop_85over1988 pop_85over1989 pop_85over1990 pop_85over1991 pop_85over1992 pop_85over1993 pop_85over1994 pop_85over1995 pop_85over1996 pop_85over1997 pop_85over1998 pop_85over1999 pop_85over2000 pop_85over2001 pop_85over2002 pop_85over2003 pop_85over2004 pop_85over2005 pop_85over2006 pop_85over2007 pop_85over2008 pop_85over2009 pop_85over2010 pop_85over2011 pop_85over2012 pop_85over2013 pop_85over2014 pop_85over2015 pop_85over2016 pop_85over2017 pop_85over2018"


replace pop_85over1980="." if pop_85over1980==".."
replace pop_85over1981="." if pop_85over1981==".."
replace pop_85over1982="." if pop_85over1982==".."
replace pop_85over1983="." if pop_85over1983==".."
replace pop_85over1984="." if pop_85over1984==".."
replace pop_85over2012="." if pop_85over2012==".."
replace pop_85over2013="." if pop_85over2013==".."
replace pop_85over2014="." if pop_85over2014==".."
destring,replace

format %18.0g $pop_85overA

id_n 
drop if id_n==0
reshape long pop_85over ,i(id_n) j(year)

save pop_85over,replace

////////////
// merge ///
///////////


merge 1:1 id_ year using pop_65to69
drop _merge

merge 1:1 id_ year using pop_70to74
drop _merge

merge 1:1 id_ year using pop_75to79
drop _merge

merge 1:1 id_ year using pop_80to84
drop _merge

merge 1:1 id_ year using pop_all
drop _merge

save pop65over,replace

///////////////////////////////
///// public expenditure
///////////////////////////////

/// % of GDP

import excel "pub_oldage_in_kind", sheet("OECD.Stat export") clear


drop B C
drop in 1/7
drop in 2
drop in 39/44

drop in 1
rename A Country
rename D pub_oldage_in_kind1980
rename E pub_oldage_in_kind1981
rename F pub_oldage_in_kind1982
rename G pub_oldage_in_kind1983
rename H pub_oldage_in_kind1984
rename I pub_oldage_in_kind1985
rename J pub_oldage_in_kind1986
rename K pub_oldage_in_kind1987
rename L pub_oldage_in_kind1988
rename M pub_oldage_in_kind1989
rename N pub_oldage_in_kind1990
rename O pub_oldage_in_kind1991
rename P pub_oldage_in_kind1992
rename Q pub_oldage_in_kind1993
rename R pub_oldage_in_kind1994
rename S pub_oldage_in_kind1995
rename T pub_oldage_in_kind1996
rename U pub_oldage_in_kind1997
rename V pub_oldage_in_kind1998
rename W pub_oldage_in_kind1999
rename X pub_oldage_in_kind2000
rename Y pub_oldage_in_kind2001
rename Z pub_oldage_in_kind2002
rename AA pub_oldage_in_kind2003
rename AB pub_oldage_in_kind2004
rename AC pub_oldage_in_kind2005
rename AD pub_oldage_in_kind2006
rename AE pub_oldage_in_kind2007
rename AF pub_oldage_in_kind2008
rename AG pub_oldage_in_kind2009
rename AH pub_oldage_in_kind2010
rename AI pub_oldage_in_kind2011
rename AJ pub_oldage_in_kind2012
rename AK pub_oldage_in_kind2013
rename AL pub_oldage_in_kind2014
rename AM pub_oldage_in_kind2015
rename AN pub_oldage_in_kind2016
rename AO pub_oldage_in_kind2017
rename AP pub_oldage_in_kind2018
rename AQ pub_oldage_in_kind2019


global pub_oldage_kind "pub_oldage_in_kind1980 pub_oldage_in_kind1981 pub_oldage_in_kind1982 pub_oldage_in_kind1983 pub_oldage_in_kind1984 pub_oldage_in_kind1985 pub_oldage_in_kind1986 pub_oldage_in_kind1987 pub_oldage_in_kind1988 pub_oldage_in_kind1989 pub_oldage_in_kind1990 pub_oldage_in_kind1991 pub_oldage_in_kind1992 pub_oldage_in_kind1993 pub_oldage_in_kind1994 pub_oldage_in_kind1995 pub_oldage_in_kind1996 pub_oldage_in_kind1997 pub_oldage_in_kind1998 pub_oldage_in_kind1999 pub_oldage_in_kind2000 pub_oldage_in_kind2001 pub_oldage_in_kind2002 pub_oldage_in_kind2003 pub_oldage_in_kind2004 pub_oldage_in_kind2005 pub_oldage_in_kind2006 pub_oldage_in_kind2007 pub_oldage_in_kind2008 pub_oldage_in_kind2009 pub_oldage_in_kind2010 pub_oldage_in_kind2011 pub_oldage_in_kind2012 pub_oldage_in_kind2013 pub_oldage_in_kind2014 pub_oldage_in_kind2015 pub_oldage_in_kind2016 pub_oldage_in_kind2017 pub_oldage_in_kind2018 pub_oldage_in_kind2019"

foreach i in $pub_oldage_kind {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long pub_oldage_in_kind ,i(id_n) j(year)
label vari pub_oldage_in_kind "Old age Benefits in Kind.Per head % of GDP"

save pub_oldage_in_kind,replace


** **


/// % of GDP

import excel "pub_health_total", sheet("OECD.Stat export") clear


drop B C
drop in 1/7
drop in 2
drop in 39/44

drop in 1
rename A Country
rename D pub_health_total1980
rename E pub_health_total1981
rename F pub_health_total1982
rename G pub_health_total1983
rename H pub_health_total1984
rename I pub_health_total1985
rename J pub_health_total1986
rename K pub_health_total1987
rename L pub_health_total1988
rename M pub_health_total1989
rename N pub_health_total1990
rename O pub_health_total1991
rename P pub_health_total1992
rename Q pub_health_total1993
rename R pub_health_total1994
rename S pub_health_total1995
rename T pub_health_total1996
rename U pub_health_total1997
rename V pub_health_total1998
rename W pub_health_total1999
rename X pub_health_total2000
rename Y pub_health_total2001
rename Z pub_health_total2002
rename AA pub_health_total2003
rename AB pub_health_total2004
rename AC pub_health_total2005
rename AD pub_health_total2006
rename AE pub_health_total2007
rename AF pub_health_total2008
rename AG pub_health_total2009
rename AH pub_health_total2010
rename AI pub_health_total2011
rename AJ pub_health_total2012
rename AK pub_health_total2013
rename AL pub_health_total2014
rename AM pub_health_total2015
rename AN pub_health_total2016
rename AO pub_health_total2017
rename AP pub_health_total2018
rename AQ pub_health_total2019


global pub_oldage_kind "pub_health_total1980 pub_health_total1981 pub_health_total1982 pub_health_total1983 pub_health_total1984 pub_health_total1985 pub_health_total1986 pub_health_total1987 pub_health_total1988 pub_health_total1989 pub_health_total1990 pub_health_total1991 pub_health_total1992 pub_health_total1993 pub_health_total1994 pub_health_total1995 pub_health_total1996 pub_health_total1997 pub_health_total1998 pub_health_total1999 pub_health_total2000 pub_health_total2001 pub_health_total2002 pub_health_total2003 pub_health_total2004 pub_health_total2005 pub_health_total2006 pub_health_total2007 pub_health_total2008 pub_health_total2009 pub_health_total2010 pub_health_total2011 pub_health_total2012 pub_health_total2013 pub_health_total2014 pub_health_total2015 pub_health_total2016 pub_health_total2017 pub_health_total2018 pub_health_total2019"

foreach i in $pub_oldage_kind {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long pub_health_total ,i(id_n) j(year)
label vari pub_health_total "social expenditure Health % of GDP"

save pub_health_total,replace





////////////////
//// merge 

use Tpub_old_benefit_per_h_cPPP,clear

//////pub_old_benefit_per_h_constantPPP////

import excel "pub_oldage_in_kind_per_head_constantPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与

drop B C
drop in 1/7
drop in 2
drop in 39/44

rename A Country

rename D pub_oldage_inkind_pc_conPPP1980
rename E pub_oldage_inkind_pc_conPPP1981
rename F pub_oldage_inkind_pc_conPPP1982
rename G pub_oldage_inkind_pc_conPPP1983
rename H pub_oldage_inkind_pc_conPPP1984
rename I pub_oldage_inkind_pc_conPPP1985
rename J pub_oldage_inkind_pc_conPPP1986
rename K pub_oldage_inkind_pc_conPPP1987
rename L pub_oldage_inkind_pc_conPPP1988
rename M pub_oldage_inkind_pc_conPPP1989
rename N pub_oldage_inkind_pc_conPPP1990
rename O pub_oldage_inkind_pc_conPPP1991
rename P pub_oldage_inkind_pc_conPPP1992
rename Q pub_oldage_inkind_pc_conPPP1993
rename R pub_oldage_inkind_pc_conPPP1994
rename S pub_oldage_inkind_pc_conPPP1995
rename T pub_oldage_inkind_pc_conPPP1996
rename U pub_oldage_inkind_pc_conPPP1997
rename V pub_oldage_inkind_pc_conPPP1998
rename W pub_oldage_inkind_pc_conPPP1999
rename X pub_oldage_inkind_pc_conPPP2000
rename Y pub_oldage_inkind_pc_conPPP2001
rename Z pub_oldage_inkind_pc_conPPP2002
rename AA pub_oldage_inkind_pc_conPPP2003
rename AB pub_oldage_inkind_pc_conPPP2004
rename AC pub_oldage_inkind_pc_conPPP2005
rename AD pub_oldage_inkind_pc_conPPP2006
rename AE pub_oldage_inkind_pc_conPPP2007
rename AF pub_oldage_inkind_pc_conPPP2008
rename AG pub_oldage_inkind_pc_conPPP2009
rename AH pub_oldage_inkind_pc_conPPP2010
rename AI pub_oldage_inkind_pc_conPPP2011
rename AJ pub_oldage_inkind_pc_conPPP2012
rename AK pub_oldage_inkind_pc_conPPP2013
rename AL pub_oldage_inkind_pc_conPPP2014
rename AM pub_oldage_inkind_pc_conPPP2015
rename AN pub_oldage_inkind_pc_conPPP2016
rename AO pub_oldage_inkind_pc_conPPP2017
rename AP pub_oldage_inkind_pc_conPPP2018
rename AQ pub_oldage_inkind_pc_conPPP2019

drop in 1

global Tpub_old_pc "pub_oldage_inkind_pc_conPPP1980 pub_oldage_inkind_pc_conPPP1981 pub_oldage_inkind_pc_conPPP1982 pub_oldage_inkind_pc_conPPP1983 pub_oldage_inkind_pc_conPPP1984 pub_oldage_inkind_pc_conPPP1985 pub_oldage_inkind_pc_conPPP1986 pub_oldage_inkind_pc_conPPP1987 pub_oldage_inkind_pc_conPPP1988 pub_oldage_inkind_pc_conPPP1989 pub_oldage_inkind_pc_conPPP1990 pub_oldage_inkind_pc_conPPP1991 pub_oldage_inkind_pc_conPPP1992 pub_oldage_inkind_pc_conPPP1993 pub_oldage_inkind_pc_conPPP1994 pub_oldage_inkind_pc_conPPP1995 pub_oldage_inkind_pc_conPPP1996 pub_oldage_inkind_pc_conPPP1997 pub_oldage_inkind_pc_conPPP1998 pub_oldage_inkind_pc_conPPP1999 pub_oldage_inkind_pc_conPPP2000 pub_oldage_inkind_pc_conPPP2001 pub_oldage_inkind_pc_conPPP2002 pub_oldage_inkind_pc_conPPP2003 pub_oldage_inkind_pc_conPPP2004 pub_oldage_inkind_pc_conPPP2005 pub_oldage_inkind_pc_conPPP2006 pub_oldage_inkind_pc_conPPP2007 pub_oldage_inkind_pc_conPPP2008 pub_oldage_inkind_pc_conPPP2009 pub_oldage_inkind_pc_conPPP2010 pub_oldage_inkind_pc_conPPP2011 pub_oldage_inkind_pc_conPPP2012 pub_oldage_inkind_pc_conPPP2013 pub_oldage_inkind_pc_conPPP2014 pub_oldage_inkind_pc_conPPP2015 pub_oldage_inkind_pc_conPPP2016 pub_oldage_inkind_pc_conPPP2017 pub_oldage_inkind_pc_conPPP2018 pub_oldage_inkind_pc_conPPP2019"

foreach i in $Tpub_old_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long pub_oldage_inkind_pc_conPPP ,i(id_n) j(year)
rename pub_oldage_inkind_pc_conPPP Tpub_old_benefit_pc_conPPP
label vari Tpub_old_benefit_pc_conPPP "Benefits in Kind(Old).Per head,at constant prices (2015) and constant PPPs (2015), in US dollars"
save Tpub_old_kind_pc_constantPPP,replace

/////// socx_t_health_per_head_constanttPPP 

import excel "socx_t_health_per_head_constanttPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与

drop B C
drop in 1/7
drop in 2
drop in 39/44

rename A Country

rename D socx_t_health_pc_conPPP1980
rename E socx_t_health_pc_conPPP1981
rename F socx_t_health_pc_conPPP1982
rename G socx_t_health_pc_conPPP1983
rename H socx_t_health_pc_conPPP1984
rename I socx_t_health_pc_conPPP1985
rename J socx_t_health_pc_conPPP1986
rename K socx_t_health_pc_conPPP1987
rename L socx_t_health_pc_conPPP1988
rename M socx_t_health_pc_conPPP1989
rename N socx_t_health_pc_conPPP1990
rename O socx_t_health_pc_conPPP1991
rename P socx_t_health_pc_conPPP1992
rename Q socx_t_health_pc_conPPP1993
rename R socx_t_health_pc_conPPP1994
rename S socx_t_health_pc_conPPP1995
rename T socx_t_health_pc_conPPP1996
rename U socx_t_health_pc_conPPP1997
rename V socx_t_health_pc_conPPP1998
rename W socx_t_health_pc_conPPP1999
rename X socx_t_health_pc_conPPP2000
rename Y socx_t_health_pc_conPPP2001
rename Z socx_t_health_pc_conPPP2002
rename AA socx_t_health_pc_conPPP2003
rename AB socx_t_health_pc_conPPP2004
rename AC socx_t_health_pc_conPPP2005
rename AD socx_t_health_pc_conPPP2006
rename AE socx_t_health_pc_conPPP2007
rename AF socx_t_health_pc_conPPP2008
rename AG socx_t_health_pc_conPPP2009
rename AH socx_t_health_pc_conPPP2010
rename AI socx_t_health_pc_conPPP2011
rename AJ socx_t_health_pc_conPPP2012
rename AK socx_t_health_pc_conPPP2013
rename AL socx_t_health_pc_conPPP2014
rename AM socx_t_health_pc_conPPP2015
rename AN socx_t_health_pc_conPPP2016
rename AO socx_t_health_pc_conPPP2017
rename AP socx_t_health_pc_conPPP2018
rename AQ socx_t_health_pc_conPPP2019

drop in 1

global Tpub_old_pc "socx_t_health_pc_conPPP1980 socx_t_health_pc_conPPP1981 socx_t_health_pc_conPPP1982 socx_t_health_pc_conPPP1983 socx_t_health_pc_conPPP1984 socx_t_health_pc_conPPP1985 socx_t_health_pc_conPPP1986 socx_t_health_pc_conPPP1987 socx_t_health_pc_conPPP1988 socx_t_health_pc_conPPP1989 socx_t_health_pc_conPPP1990 socx_t_health_pc_conPPP1991 socx_t_health_pc_conPPP1992 socx_t_health_pc_conPPP1993 socx_t_health_pc_conPPP1994 socx_t_health_pc_conPPP1995 socx_t_health_pc_conPPP1996 socx_t_health_pc_conPPP1997 socx_t_health_pc_conPPP1998 socx_t_health_pc_conPPP1999 socx_t_health_pc_conPPP2000 socx_t_health_pc_conPPP2001 socx_t_health_pc_conPPP2002 socx_t_health_pc_conPPP2003 socx_t_health_pc_conPPP2004 socx_t_health_pc_conPPP2005 socx_t_health_pc_conPPP2006 socx_t_health_pc_conPPP2007 socx_t_health_pc_conPPP2008 socx_t_health_pc_conPPP2009 socx_t_health_pc_conPPP2010 socx_t_health_pc_conPPP2011 socx_t_health_pc_conPPP2012 socx_t_health_pc_conPPP2013 socx_t_health_pc_conPPP2014 socx_t_health_pc_conPPP2015 socx_t_health_pc_conPPP2016 socx_t_health_pc_conPPP2017 socx_t_health_pc_conPPP2018 socx_t_health_pc_conPPP2019"

foreach i in $Tpub_old_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long socx_t_health_pc_conPPP ,i(id_n) j(year)
label vari socx_t_health_pc_conPPP "pub socx_health.Per head,at constant prices (2015) and constant PPPs (2015), in US dollars"
save socx_t_health_pc_conPPP,replace

//////////////医療費//////////
///とりあえず、Government/compulsory schemes																																																
///Current expenditure on health (all functions)																																																
///All providers																																																
///Per capita, constant prices, constant PPPs, OECD base year		
/// GDP比

import excel "govhealth_all_constantPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与

drop B C D
drop in 1/6
drop in 2
drop in 39/47


rename A Country
rename E gov_all_pc_constantPPP1970
rename F gov_all_pc_constantPPP1971
rename G gov_all_pc_constantPPP1972
rename H gov_all_pc_constantPPP1973
rename I gov_all_pc_constantPPP1974
rename J gov_all_pc_constantPPP1975
rename K gov_all_pc_constantPPP1976
rename L gov_all_pc_constantPPP1977
rename M gov_all_pc_constantPPP1978
rename N gov_all_pc_constantPPP1979
rename O gov_all_pc_constantPPP1980
rename P gov_all_pc_constantPPP1981
rename Q gov_all_pc_constantPPP1982
rename R gov_all_pc_constantPPP1983
rename S gov_all_pc_constantPPP1984
rename T gov_all_pc_constantPPP1985
rename U gov_all_pc_constantPPP1986
rename V gov_all_pc_constantPPP1987
rename W gov_all_pc_constantPPP1988
rename X gov_all_pc_constantPPP1989
rename Y gov_all_pc_constantPPP1990
rename Z gov_all_pc_constantPPP1991

rename AA gov_all_pc_constantPPP1992
rename AB gov_all_pc_constantPPP1993
rename AC gov_all_pc_constantPPP1994
rename AD gov_all_pc_constantPPP1995
rename AE gov_all_pc_constantPPP1996
rename AF gov_all_pc_constantPPP1997
rename AG gov_all_pc_constantPPP1998
rename AH gov_all_pc_constantPPP1999
rename AI gov_all_pc_constantPPP2000

rename AJ gov_all_pc_constantPPP2001
rename AK gov_all_pc_constantPPP2002
rename AL gov_all_pc_constantPPP2003
rename AM gov_all_pc_constantPPP2004
rename AN gov_all_pc_constantPPP2005
rename AO gov_all_pc_constantPPP2006
rename AP gov_all_pc_constantPPP2007
rename AQ gov_all_pc_constantPPP2008
rename AR gov_all_pc_constantPPP2009
rename AS gov_all_pc_constantPPP2010
rename AT gov_all_pc_constantPPP2011
rename AU gov_all_pc_constantPPP2012
rename AV gov_all_pc_constantPPP2013
rename AW gov_all_pc_constantPPP2014
rename AX gov_all_pc_constantPPP2015
rename AY gov_all_pc_constantPPP2016
rename AZ gov_all_pc_constantPPP2017
rename BA gov_all_pc_constantPPP2018
rename BB gov_all_pc_constantPPP2019



global gov_all_pc "gov_all_pc_constantPPP1970 gov_all_pc_constantPPP1971 gov_all_pc_constantPPP1972 gov_all_pc_constantPPP1973 gov_all_pc_constantPPP1974 gov_all_pc_constantPPP1975 gov_all_pc_constantPPP1976 gov_all_pc_constantPPP1977 gov_all_pc_constantPPP1978 gov_all_pc_constantPPP1979 gov_all_pc_constantPPP1980 gov_all_pc_constantPPP1981 gov_all_pc_constantPPP1982 gov_all_pc_constantPPP1983 gov_all_pc_constantPPP1984 gov_all_pc_constantPPP1985 gov_all_pc_constantPPP1986 gov_all_pc_constantPPP1987 gov_all_pc_constantPPP1988 gov_all_pc_constantPPP1989 gov_all_pc_constantPPP1990 gov_all_pc_constantPPP1991 gov_all_pc_constantPPP1992 gov_all_pc_constantPPP1993 gov_all_pc_constantPPP1994 gov_all_pc_constantPPP1995 gov_all_pc_constantPPP1996 gov_all_pc_constantPPP1997 gov_all_pc_constantPPP1998 gov_all_pc_constantPPP1999 gov_all_pc_constantPPP2000 gov_all_pc_constantPPP2001 gov_all_pc_constantPPP2002 gov_all_pc_constantPPP2003 gov_all_pc_constantPPP2004 gov_all_pc_constantPPP2005 gov_all_pc_constantPPP2006 gov_all_pc_constantPPP2007 gov_all_pc_constantPPP2008 gov_all_pc_constantPPP2009 gov_all_pc_constantPPP2010 gov_all_pc_constantPPP2011 gov_all_pc_constantPPP2012 gov_all_pc_constantPPP2013 gov_all_pc_constantPPP2014 gov_all_pc_constantPPP2015 gov_all_pc_constantPPP2016 gov_all_pc_constantPPP2017 gov_all_pc_constantPPP2018 gov_all_pc_constantPPP2019"

foreach i in $gov_all_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace

id_n 
drop if id_n==0
reshape long gov_all_pc_constantPPP ,i(id_n) j(year)
label vari gov_all_pc_constantPPP "Government_current expenditure on health(all functions).per capita,constant prices,constantPPP"
save govhealth_all_pc_constantPPP,replace

///allhealth_pc_constantPPP	
///All financing schemes																																																
///Current expenditure on health (all functions)																																																
///All providers																																																
///Per capita, constant prices, constant PPPs, OECD base year																																																

///allhealth_pc_constantPPP	
																																				
import excel "allhealth_pc_constantPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与


drop B C D
drop in 1/6
drop in 2
drop in 39/47


rename A Country
rename E allhealth_pc_constantPPP1970
rename F allhealth_pc_constantPPP1971
rename G allhealth_pc_constantPPP1972
rename H allhealth_pc_constantPPP1973
rename I allhealth_pc_constantPPP1974
rename J allhealth_pc_constantPPP1975
rename K allhealth_pc_constantPPP1976
rename L allhealth_pc_constantPPP1977
rename M allhealth_pc_constantPPP1978
rename N allhealth_pc_constantPPP1979
rename O allhealth_pc_constantPPP1980
rename P allhealth_pc_constantPPP1981
rename Q allhealth_pc_constantPPP1982
rename R allhealth_pc_constantPPP1983
rename S allhealth_pc_constantPPP1984
rename T allhealth_pc_constantPPP1985
rename U allhealth_pc_constantPPP1986
rename V allhealth_pc_constantPPP1987
rename W allhealth_pc_constantPPP1988
rename X allhealth_pc_constantPPP1989
rename Y allhealth_pc_constantPPP1990
rename Z allhealth_pc_constantPPP1991

rename AA allhealth_pc_constantPPP1992
rename AB allhealth_pc_constantPPP1993
rename AC allhealth_pc_constantPPP1994
rename AD allhealth_pc_constantPPP1995
rename AE allhealth_pc_constantPPP1996
rename AF allhealth_pc_constantPPP1997
rename AG allhealth_pc_constantPPP1998
rename AH allhealth_pc_constantPPP1999
rename AI allhealth_pc_constantPPP2000

rename AJ allhealth_pc_constantPPP2001
rename AK allhealth_pc_constantPPP2002
rename AL allhealth_pc_constantPPP2003
rename AM allhealth_pc_constantPPP2004
rename AN allhealth_pc_constantPPP2005
rename AO allhealth_pc_constantPPP2006
rename AP allhealth_pc_constantPPP2007
rename AQ allhealth_pc_constantPPP2008
rename AR allhealth_pc_constantPPP2009
rename AS allhealth_pc_constantPPP2010
rename AT allhealth_pc_constantPPP2011
rename AU allhealth_pc_constantPPP2012
rename AV allhealth_pc_constantPPP2013
rename AW allhealth_pc_constantPPP2014
rename AX allhealth_pc_constantPPP2015
rename AY allhealth_pc_constantPPP2016
rename AZ allhealth_pc_constantPPP2017
rename BA allhealth_pc_constantPPP2018
rename BB allhealth_pc_constantPPP2019



global gov_all_pc "allhealth_pc_constantPPP1970 allhealth_pc_constantPPP1971 allhealth_pc_constantPPP1972 allhealth_pc_constantPPP1973 allhealth_pc_constantPPP1974 allhealth_pc_constantPPP1975 allhealth_pc_constantPPP1976 allhealth_pc_constantPPP1977 allhealth_pc_constantPPP1978 allhealth_pc_constantPPP1979 allhealth_pc_constantPPP1980 allhealth_pc_constantPPP1981 allhealth_pc_constantPPP1982 allhealth_pc_constantPPP1983 allhealth_pc_constantPPP1984 allhealth_pc_constantPPP1985 allhealth_pc_constantPPP1986 allhealth_pc_constantPPP1987 allhealth_pc_constantPPP1988 allhealth_pc_constantPPP1989 allhealth_pc_constantPPP1990 allhealth_pc_constantPPP1991 allhealth_pc_constantPPP1992 allhealth_pc_constantPPP1993 allhealth_pc_constantPPP1994 allhealth_pc_constantPPP1995 allhealth_pc_constantPPP1996 allhealth_pc_constantPPP1997 allhealth_pc_constantPPP1998 allhealth_pc_constantPPP1999 allhealth_pc_constantPPP2000 allhealth_pc_constantPPP2001 allhealth_pc_constantPPP2002 allhealth_pc_constantPPP2003 allhealth_pc_constantPPP2004 allhealth_pc_constantPPP2005 allhealth_pc_constantPPP2006 allhealth_pc_constantPPP2007 allhealth_pc_constantPPP2008 allhealth_pc_constantPPP2009 allhealth_pc_constantPPP2010 allhealth_pc_constantPPP2011 allhealth_pc_constantPPP2012 allhealth_pc_constantPPP2013 allhealth_pc_constantPPP2014 allhealth_pc_constantPPP2015 allhealth_pc_constantPPP2016 allhealth_pc_constantPPP2017 allhealth_pc_constantPPP2018 allhealth_pc_constantPPP2019"

foreach i in $gov_all_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long allhealth_pc_constantPPP ,i(id_n) j(year)
label vari allhealth_pc_constantPPP "All financing schemes_current expenditure on health(all functions).per capita,constant prices,constantPPP"
save allhealth_all_pc_constantPPP,replace

//////////////////////////////////////////////////////////
/// 以下、実額ベース　constant prices constant PPP NOT per head
/////////////////////////////////////////////////////////////
///とりあえず、Government/compulsory schemes																																																
///Current expenditure on health (all functions)																																																
///All providers																																																
///constant prices, constant PPPs, OECD base year		

import excel "govhealth_all_constantPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与
drop B C D
drop in 1/6
drop in 2
drop in 39/47


rename A Country
rename E gov_all_constantPPP1970
rename F gov_all_constantPPP1971
rename G gov_all_constantPPP1972
rename H gov_all_constantPPP1973
rename I gov_all_constantPPP1974
rename J gov_all_constantPPP1975
rename K gov_all_constantPPP1976
rename L gov_all_constantPPP1977
rename M gov_all_constantPPP1978
rename N gov_all_constantPPP1979
rename O gov_all_constantPPP1980
rename P gov_all_constantPPP1981
rename Q gov_all_constantPPP1982
rename R gov_all_constantPPP1983
rename S gov_all_constantPPP1984
rename T gov_all_constantPPP1985
rename U gov_all_constantPPP1986
rename V gov_all_constantPPP1987
rename W gov_all_constantPPP1988
rename X gov_all_constantPPP1989
rename Y gov_all_constantPPP1990
rename Z gov_all_constantPPP1991

rename AA gov_all_constantPPP1992
rename AB gov_all_constantPPP1993
rename AC gov_all_constantPPP1994
rename AD gov_all_constantPPP1995
rename AE gov_all_constantPPP1996
rename AF gov_all_constantPPP1997
rename AG gov_all_constantPPP1998
rename AH gov_all_constantPPP1999
rename AI gov_all_constantPPP2000

rename AJ gov_all_constantPPP2001
rename AK gov_all_constantPPP2002
rename AL gov_all_constantPPP2003
rename AM gov_all_constantPPP2004
rename AN gov_all_constantPPP2005
rename AO gov_all_constantPPP2006
rename AP gov_all_constantPPP2007
rename AQ gov_all_constantPPP2008
rename AR gov_all_constantPPP2009
rename AS gov_all_constantPPP2010
rename AT gov_all_constantPPP2011
rename AU gov_all_constantPPP2012
rename AV gov_all_constantPPP2013
rename AW gov_all_constantPPP2014
rename AX gov_all_constantPPP2015
rename AY gov_all_constantPPP2016
rename AZ gov_all_constantPPP2017
rename BA gov_all_constantPPP2018
rename BB gov_all_constantPPP2019

drop in 1

global gov_all_c "gov_all_constantPPP1970 gov_all_constantPPP1971 gov_all_constantPPP1972 gov_all_constantPPP1973 gov_all_constantPPP1974 gov_all_constantPPP1975 gov_all_constantPPP1976 gov_all_constantPPP1977 gov_all_constantPPP1978 gov_all_constantPPP1979 gov_all_constantPPP1980 gov_all_constantPPP1981 gov_all_constantPPP1982 gov_all_constantPPP1983 gov_all_constantPPP1984 gov_all_constantPPP1985 gov_all_constantPPP1986 gov_all_constantPPP1987 gov_all_constantPPP1988 gov_all_constantPPP1989 gov_all_constantPPP1990 gov_all_constantPPP1991 gov_all_constantPPP1992 gov_all_constantPPP1993 gov_all_constantPPP1994 gov_all_constantPPP1995 gov_all_constantPPP1996 gov_all_constantPPP1997 gov_all_constantPPP1998 gov_all_constantPPP1999 gov_all_constantPPP2000 gov_all_constantPPP2001 gov_all_constantPPP2002 gov_all_constantPPP2003 gov_all_constantPPP2004 gov_all_constantPPP2005 gov_all_constantPPP2006 gov_all_constantPPP2007 gov_all_constantPPP2008 gov_all_constantPPP2009 gov_all_constantPPP2010 gov_all_constantPPP2011 gov_all_constantPPP2012 gov_all_constantPPP2013 gov_all_constantPPP2014 gov_all_constantPPP2015 gov_all_constantPPP2016 gov_all_constantPPP2017 gov_all_constantPPP2018 gov_all_constantPPP2019"

foreach i in $gov_all_c {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long gov_all_constantPPP ,i(id_n) j(year)

label vari gov_all_constantPPP "Government_current expenditure on health(all functions),constant prices,constantPPP"
save g_health_constantPPP_not_pc,replace

///allhealth_pc_constantPPP	
///All financing schemes																																																
///Current expenditure on health (all functions)																																																
///All providers																																																
/// constant prices, constant PPPs, OECD base year																																																

///allhealth_constantPPP	
																																				
import excel "allhealth_constantPPP",clear

/// データ整形**
//// 不要な行を削除して、変数名付与
drop B C D
drop in 1/6
drop in 2
drop in 39/47


rename A Country
rename E allhealth_pc_constantPPP1970
rename F allhealth_pc_constantPPP1971
rename G allhealth_pc_constantPPP1972
rename H allhealth_pc_constantPPP1973
rename I allhealth_pc_constantPPP1974
rename J allhealth_pc_constantPPP1975
rename K allhealth_pc_constantPPP1976
rename L allhealth_pc_constantPPP1977
rename M allhealth_pc_constantPPP1978
rename N allhealth_pc_constantPPP1979
rename O allhealth_pc_constantPPP1980
rename P allhealth_pc_constantPPP1981
rename Q allhealth_pc_constantPPP1982
rename R allhealth_pc_constantPPP1983
rename S allhealth_pc_constantPPP1984
rename T allhealth_pc_constantPPP1985
rename U allhealth_pc_constantPPP1986
rename V allhealth_pc_constantPPP1987
rename W allhealth_pc_constantPPP1988
rename X allhealth_pc_constantPPP1989
rename Y allhealth_pc_constantPPP1990
rename Z allhealth_pc_constantPPP1991

rename AA allhealth_pc_constantPPP1992
rename AB allhealth_pc_constantPPP1993
rename AC allhealth_pc_constantPPP1994
rename AD allhealth_pc_constantPPP1995
rename AE allhealth_pc_constantPPP1996
rename AF allhealth_pc_constantPPP1997
rename AG allhealth_pc_constantPPP1998
rename AH allhealth_pc_constantPPP1999
rename AI allhealth_pc_constantPPP2000

rename AJ allhealth_pc_constantPPP2001
rename AK allhealth_pc_constantPPP2002
rename AL allhealth_pc_constantPPP2003
rename AM allhealth_pc_constantPPP2004
rename AN allhealth_pc_constantPPP2005
rename AO allhealth_pc_constantPPP2006
rename AP allhealth_pc_constantPPP2007
rename AQ allhealth_pc_constantPPP2008
rename AR allhealth_pc_constantPPP2009
rename AS allhealth_pc_constantPPP2010
rename AT allhealth_pc_constantPPP2011
rename AU allhealth_pc_constantPPP2012
rename AV allhealth_pc_constantPPP2013
rename AW allhealth_pc_constantPPP2014
rename AX allhealth_pc_constantPPP2015
rename AY allhealth_pc_constantPPP2016
rename AZ allhealth_pc_constantPPP2017
rename BA allhealth_pc_constantPPP2018
rename BB allhealth_pc_constantPPP2019

drop in 1
global all_all_npc "allhealth_pc_constantPPP1970 allhealth_pc_constantPPP1971 allhealth_pc_constantPPP1972 allhealth_pc_constantPPP1973 allhealth_pc_constantPPP1974 allhealth_pc_constantPPP1975 allhealth_pc_constantPPP1976 allhealth_pc_constantPPP1977 allhealth_pc_constantPPP1978 allhealth_pc_constantPPP1979 allhealth_pc_constantPPP1980 allhealth_pc_constantPPP1981 allhealth_pc_constantPPP1982 allhealth_pc_constantPPP1983 allhealth_pc_constantPPP1984 allhealth_pc_constantPPP1985 allhealth_pc_constantPPP1986 allhealth_pc_constantPPP1987 allhealth_pc_constantPPP1988 allhealth_pc_constantPPP1989 allhealth_pc_constantPPP1990 allhealth_pc_constantPPP1991 allhealth_pc_constantPPP1992 allhealth_pc_constantPPP1993 allhealth_pc_constantPPP1994 allhealth_pc_constantPPP1995 allhealth_pc_constantPPP1996 allhealth_pc_constantPPP1997 allhealth_pc_constantPPP1998 allhealth_pc_constantPPP1999 allhealth_pc_constantPPP2000 allhealth_pc_constantPPP2001 allhealth_pc_constantPPP2002 allhealth_pc_constantPPP2003 allhealth_pc_constantPPP2004 allhealth_pc_constantPPP2005 allhealth_pc_constantPPP2006 allhealth_pc_constantPPP2007 allhealth_pc_constantPPP2008 allhealth_pc_constantPPP2009 allhealth_pc_constantPPP2010 allhealth_pc_constantPPP2011 allhealth_pc_constantPPP2012 allhealth_pc_constantPPP2013 allhealth_pc_constantPPP2014 allhealth_pc_constantPPP2015 allhealth_pc_constantPPP2016 allhealth_pc_constantPPP2017 allhealth_pc_constantPPP2018 allhealth_pc_constantPPP2019"

foreach i in $all_all_npc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace


id_n 
drop if id_n==0
reshape long allhealth_pc_constantPPP ,i(id_n) j(year)
label vari allhealth_pc_constantPPP "All financing schemes_current expenditure on health(all functions).constant prices,constantPPP"
save allhealth_all_constantPPP_npc,replace

//// GDP 比 ////


import excel "allhealth_all_gdp",clear

/// データ整形**
//// 不要な行を削除して、変数名付与

drop B C D
drop in 1/6
drop in 2
drop in 39/51


rename A Country
rename E allhealth_all_gdp1970
rename F allhealth_all_gdp1971
rename G allhealth_all_gdp1972
rename H allhealth_all_gdp1973
rename I allhealth_all_gdp1974
rename J allhealth_all_gdp1975
rename K allhealth_all_gdp1976
rename L allhealth_all_gdp1977
rename M allhealth_all_gdp1978
rename N allhealth_all_gdp1979
rename O allhealth_all_gdp1980
rename P allhealth_all_gdp1981
rename Q allhealth_all_gdp1982
rename R allhealth_all_gdp1983
rename S allhealth_all_gdp1984
rename T allhealth_all_gdp1985
rename U allhealth_all_gdp1986
rename V allhealth_all_gdp1987
rename W allhealth_all_gdp1988
rename X allhealth_all_gdp1989
rename Y allhealth_all_gdp1990
rename Z allhealth_all_gdp1991

rename AA allhealth_all_gdp1992
rename AB allhealth_all_gdp1993
rename AC allhealth_all_gdp1994
rename AD allhealth_all_gdp1995
rename AE allhealth_all_gdp1996
rename AF allhealth_all_gdp1997
rename AG allhealth_all_gdp1998
rename AH allhealth_all_gdp1999
rename AI allhealth_all_gdp2000

rename AJ allhealth_all_gdp2001
rename AK allhealth_all_gdp2002
rename AL allhealth_all_gdp2003
rename AM allhealth_all_gdp2004
rename AN allhealth_all_gdp2005
rename AO allhealth_all_gdp2006
rename AP allhealth_all_gdp2007
rename AQ allhealth_all_gdp2008
rename AR allhealth_all_gdp2009
rename AS allhealth_all_gdp2010
rename AT allhealth_all_gdp2011
rename AU allhealth_all_gdp2012
rename AV allhealth_all_gdp2013
rename AW allhealth_all_gdp2014
rename AX allhealth_all_gdp2015
rename AY allhealth_all_gdp2016
rename AZ allhealth_all_gdp2017
rename BA allhealth_all_gdp2018
rename BB allhealth_all_gdp2019



global gov_all_pc "allhealth_all_gdp1970 allhealth_all_gdp1971 allhealth_all_gdp1972 allhealth_all_gdp1973 allhealth_all_gdp1974 allhealth_all_gdp1975 allhealth_all_gdp1976 allhealth_all_gdp1977 allhealth_all_gdp1978 allhealth_all_gdp1979 allhealth_all_gdp1980 allhealth_all_gdp1981 allhealth_all_gdp1982 allhealth_all_gdp1983 allhealth_all_gdp1984 allhealth_all_gdp1985 allhealth_all_gdp1986 allhealth_all_gdp1987 allhealth_all_gdp1988 allhealth_all_gdp1989 allhealth_all_gdp1990 allhealth_all_gdp1991 allhealth_all_gdp1992 allhealth_all_gdp1993 allhealth_all_gdp1994 allhealth_all_gdp1995 allhealth_all_gdp1996 allhealth_all_gdp1997 allhealth_all_gdp1998 allhealth_all_gdp1999 allhealth_all_gdp2000 allhealth_all_gdp2001 allhealth_all_gdp2002 allhealth_all_gdp2003 allhealth_all_gdp2004 allhealth_all_gdp2005 allhealth_all_gdp2006 allhealth_all_gdp2007 allhealth_all_gdp2008 allhealth_all_gdp2009 allhealth_all_gdp2010 allhealth_all_gdp2011 allhealth_all_gdp2012 allhealth_all_gdp2013 allhealth_all_gdp2014 allhealth_all_gdp2015 allhealth_all_gdp2016 allhealth_all_gdp2017 allhealth_all_gdp2018 allhealth_all_gdp2019"

foreach i in $gov_all_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace

id_n 
drop if id_n==0
reshape long allhealth_all_gdp ,i(id_n) j(year)
label vari allhealth_all_gdp "All financing schemes_current expenditure on health(all functions).% of GDP"
save allhealth_all_gdp,replace

/*
Government/compulsory schemes																																																	
Current expenditure on health (all functions)																																																	
All providers																																																	
Share of gross domestic product																																																	

*/


import excel "govhealth_all_gdp",clear

/// データ整形**
//// 不要な行を削除して、変数名付与

drop B C D
drop in 1/6
drop in 2
drop in 39/51


rename A Country
rename E govhealth_all_gdp1970
rename F govhealth_all_gdp1971
rename G govhealth_all_gdp1972
rename H govhealth_all_gdp1973
rename I govhealth_all_gdp1974
rename J govhealth_all_gdp1975
rename K govhealth_all_gdp1976
rename L govhealth_all_gdp1977
rename M govhealth_all_gdp1978
rename N govhealth_all_gdp1979
rename O govhealth_all_gdp1980
rename P govhealth_all_gdp1981
rename Q govhealth_all_gdp1982
rename R govhealth_all_gdp1983
rename S govhealth_all_gdp1984
rename T govhealth_all_gdp1985
rename U govhealth_all_gdp1986
rename V govhealth_all_gdp1987
rename W govhealth_all_gdp1988
rename X govhealth_all_gdp1989
rename Y govhealth_all_gdp1990
rename Z govhealth_all_gdp1991

rename AA govhealth_all_gdp1992
rename AB govhealth_all_gdp1993
rename AC govhealth_all_gdp1994
rename AD govhealth_all_gdp1995
rename AE govhealth_all_gdp1996
rename AF govhealth_all_gdp1997
rename AG govhealth_all_gdp1998
rename AH govhealth_all_gdp1999
rename AI govhealth_all_gdp2000

rename AJ govhealth_all_gdp2001
rename AK govhealth_all_gdp2002
rename AL govhealth_all_gdp2003
rename AM govhealth_all_gdp2004
rename AN govhealth_all_gdp2005
rename AO govhealth_all_gdp2006
rename AP govhealth_all_gdp2007
rename AQ govhealth_all_gdp2008
rename AR govhealth_all_gdp2009
rename AS govhealth_all_gdp2010
rename AT govhealth_all_gdp2011
rename AU govhealth_all_gdp2012
rename AV govhealth_all_gdp2013
rename AW govhealth_all_gdp2014
rename AX govhealth_all_gdp2015
rename AY govhealth_all_gdp2016
rename AZ govhealth_all_gdp2017
rename BA govhealth_all_gdp2018
rename BB govhealth_all_gdp2019



global gov_all_pc "govhealth_all_gdp1970 govhealth_all_gdp1971 govhealth_all_gdp1972 govhealth_all_gdp1973 govhealth_all_gdp1974 govhealth_all_gdp1975 govhealth_all_gdp1976 govhealth_all_gdp1977 govhealth_all_gdp1978 govhealth_all_gdp1979 govhealth_all_gdp1980 govhealth_all_gdp1981 govhealth_all_gdp1982 govhealth_all_gdp1983 govhealth_all_gdp1984 govhealth_all_gdp1985 govhealth_all_gdp1986 govhealth_all_gdp1987 govhealth_all_gdp1988 govhealth_all_gdp1989 govhealth_all_gdp1990 govhealth_all_gdp1991 govhealth_all_gdp1992 govhealth_all_gdp1993 govhealth_all_gdp1994 govhealth_all_gdp1995 govhealth_all_gdp1996 govhealth_all_gdp1997 govhealth_all_gdp1998 govhealth_all_gdp1999 govhealth_all_gdp2000 govhealth_all_gdp2001 govhealth_all_gdp2002 govhealth_all_gdp2003 govhealth_all_gdp2004 govhealth_all_gdp2005 govhealth_all_gdp2006 govhealth_all_gdp2007 govhealth_all_gdp2008 govhealth_all_gdp2009 govhealth_all_gdp2010 govhealth_all_gdp2011 govhealth_all_gdp2012 govhealth_all_gdp2013 govhealth_all_gdp2014 govhealth_all_gdp2015 govhealth_all_gdp2016 govhealth_all_gdp2017 govhealth_all_gdp2018 govhealth_all_gdp2019"

foreach i in $gov_all_pc {

	qui replace `i' ="." if  `i'== ".." 
}
*

qui destring,replace

id_n 
drop if id_n==0
reshape long govhealth_all_gdp ,i(id_n) j(year)
label vari govhealth_all_gdp " Government current expenditure on health(all functions).% of GDP"
save govhealth_all_gdp,replace


///////////////////////////////
///// SOCX public expenditure. Health
///////////////////////////////
/*import excel "socx_t_health_per_head_constantPPP", sheet("OECD.Stat export") clear

reshape long socx_t_health_pc_constantPPP ,i(id_n) j(year)
label vari socx_t_health_pc_constantPPP "social expendtiure.public.Health. Per head, at constant prices (2010) and constant PPPs (2010), in US dollars																																					"
save socx_t_health_pc_constantPPP,replace
*/


////////////
// merge 
/////////////


use g_health_constantPPP_not_pc,clear

merge 1:1 id_n year using allhealth_all_pc_constantPPP
drop _merge

merge 1:1 id_n year using govhealth_all_pc_constantPPP
drop _merge

merge 1:1 id_n year using pub_oldage_in_kind
drop _merge

merge 1:1 id_n year using pub_health_total
drop _merge

merge 1:1 id_n year using Tpub_old_kind_pc_constantPPP
drop _merge

merge 1:1 id_n year using socx_t_health_pc_conPPP

drop _merge

xtset id_n year

merge 1:1 id_n year using pop65over

drop _merge

/// merge data % of GDP


merge 1:1 id_n year using govhealth_all_gdp

drop _merge

xtset id_n year

merge 1:1 id_n year using allhealth_all_gdp

drop _merge

xtset id_n year

/// gen variable
// benefits in kind(old) per old = (per head ppp*pop) / pop_old_over) 
//

gen double pop65over = pop_65to69+pop_70to74+pop_75to79+ pop_80to84+ pop_85over
gen pub_benefit_inkind_oldage_perold =(Tpub_old_benefit_pc_conPPP*pop)/pop65over 

label vari pop65over "pop65to69+pop70to74+pop75to79+ pop80to84+ pop85over"
label vari pub_benefit_inkind_oldage_perold "Benefits in Kind(Old).per pop(aged 65over),"


rename gov_all_pc_constantPPP gov_health_pc_constantPPP
rename allhealth_pc_constantPPP allhealth_pc_constantPPP

gen gov_health_constantPPP_perold =(gov_health_pc_constantPPP*pop)/pop65over 
gen allhealth_constantPPP_perold =(allhealth_pc_constantPPP*pop)/pop65over 
gen p_bene_inkind_old_per_old_c = (Tpub_old_benefit_pc_conPPP*pop)/pop65over 
gen socx_pub_health_per_old_c =(socx_t_health_pc_conPPP*pop)/pop65over 

label vari socx_pub_health_per_old_c "SOCX Public Health,Per head, at constant prices (2015) and constant PPPs (2015), in US dollars" 

label vari pop65over "pop65to69+pop70to74+pop75to79+ pop80to84+ pop85over"
label vari gov_health_constantPPP_perold "government_current expenditure on health per pop(aged 65over),constant prices,constantPPP"
label vari allhealth_constantPPP_perold "All financing schemes_current expenditure on health per pop(aged 65over),constant prices,constantPPP"
label vari p_bene_inkind_old_per_old_c "Benefits in Kind(Old).per aged 65over, at constant prices and constant PPPs, in US dollars"

xtset id_n year

rename pub_oldage_in_kind oldage_inkind
label vari oldage_inkind "Public expenditure on old-age benefits in kind as percentages of GDP."
label vari pub_health_total "Total public expenditure on health care, as a percentage of GDP.202012"

label vari pub_health_total "SOCX public social expenditure on Health % of GDP. 202012"
rename socx_t_health_pc_conPPP socx_t_health_pc_constantPPP /// 2020 1210
rename pub_health_total soexp_health

order id_n year Country allhealth_pc_constantPPP allhealth_constantPPP_perold allhealth_all_gdp gov_all_constantPPP gov_health_pc_constantPPP gov_health_constantPPP_perold govhealth_all_gdp oldage_inkind Tpub_old_benefit_pc_conPPP pub_benefit_inkind_oldage_perold p_bene_inkind_old_per_old_c soexp_health socx_t_health_pc_constantPPP socx_pub_health_per_old_c

save old_benefits_health_exp,replace
