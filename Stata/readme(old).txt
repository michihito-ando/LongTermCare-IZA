Readme file for
Ando, Furuichi, Kaneko (2021) IZA Journal of Labor Policy

Update infomation
Ver 1: 2019.1.17
Ver 2: 2020.2.12
Ver 3: 2020.11.24
Ver 4: 2021.7.1

Do files

?	intro.do > Check some descriptive data property
?	data_setup.do > Data setup
?	synth_y_setup/synth_$outcome.do > Setup for each outcome variable($outcome)
?	main_synth.do > Main synthetic control (SC) analysis
?	post_synth.do > Save post SC results
?	twoway_graph.do > Make SC graphs
?	basic_placebo.do >@Implement basic placebo tests
?	LOO_Placebo.do > Implement leave-one-out placebo tests
?	LOO_placebo_graph.do > Make and save leave-one-out placebo groups

Folders and their structures

?	do > do files
?	do/synth_y_setup, do/synth_y_setup_RR, do/synth_y_setup_RR2, do/synth_y_setup3 > Data setup do files for outcome variables (automatically implemented inside main_synth.do, main_synth_RR.do, main_synth_RR1.do, main_synth_RR2.do, and main_synth_RR3.do) 
?	graph > all the graphs are saved in sub-folders.
?	post_synth > all the post-estimation resutls are saved in sub-folders
?	raw > raw data used for analysis

 
Implementation

You need to set up your own directory and make folders in which results are saved. Folder names and ther structures have to be identical with the ones in GitHub. You also need to choose an outcome variable before implementation.

1.	Select an outcome variable

oldage_inkind > inkind benefit for the elderly (% of GDP)
oldage_inkind_pc >  inkind benefit for the elderly (per head)
soexp_health > social expenditure for health  (% of GDP)
soexp_heath_pc > social expenditure for health  (per capita)
lfp_40to44_fe > female labor force participation rate, ages 40-44
lfp_45to49_fe > female labor force participation rate, ages 45-49
lfp_50to54_fe > female labor force participation rate, ages 50-54
lfp_55to59_fe > female labor force participation rate, ages 55-59

demean > demeaned outcome


2.	Run main_synth.do
< The following do flies are implemented inside this do file„
data_setup.do
synth_y_setup/synth_$outcome.do
post_synth.do (save post synth results)
twoway_graph.do (graph cases 1-3)

3.	Run basic_placebo.do
<The following do flies are implemented inside this do file„
data_setup.do
synth_y_setup/synth_$outcome.do

ƒData is saved into designated folders„
post_synth/_$donor/_$outcome/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome.pdf

4.	Run LOO_placebo.do (LOO: leave one out)
<The following doflies are implemented inside this do file„
data_setup.do
synth_y_setup/synth_$outcome.do

< Data is saved into designated folders„
post_synth/_$donor/gap_$outcome


5.	Additional analysis

Implementation and data saving procedures are the same as the baseline analysis.
 
RR2 : In-time placebo, where year 1993 is used for placebo intervention year

RR3 : Drop Countries that LTC expenditure growth are above 0.1% point in 2000-2010, that is, Austria, Finland, France, Spain, UK. 

RR4: Drop countries that pre-2000 LTC expenditures are zero or fluctuated, that is,  Austalia, Belgium, Italy, Portugal, Sweden
