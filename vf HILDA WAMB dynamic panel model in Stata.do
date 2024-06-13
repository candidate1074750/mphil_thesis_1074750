
// Set and check working directory.
cd "/Users/candidate/Documents/Ox Dissertation/analysis/HILDA/combined_files"
pwd

// Load data. 
use "hilda_2.dta", clear

// Install package for dynamic panel data modelling using maximum likelihood.
ssc install xtdpdml

// Informing package of the data structure.
xtset xwaveid wave_2 // Note: I use wave_2 rather than original variable, wave. wave_2 is compatible with the package requirement that time period numbering starts from 1.

describe disp_inc

sum num_spells_unemployed
sum sexor_binary_2
sum hgage
sum female

gen age_cat = 1 if hgage >= 26 & hgage <= 41
replace age_cat = 2 if hgage >= 42 & hgage <= 57
replace age_cat = 3 if hgage >= 58 & hgage <= 73
replace age_cat = 4 if hgage >= 74 & hgage <= 89
replace age_cat = 5 if hgage > 89
label define age_cat_label 1 "26-41" 2 "42-57" 3 "58-73" 4 "74-89" 5 "89+"
label values age_cat age_cat_label

sum age_cat
sum ed_degree
sum disp_inc
sum q_man
sum q_woman

// Full(er) models.

// Employment.

xtdpdml num_spells_unemployed sexor_binary_2 hgage, inv(female) // Doesn't converge.

// Income.

xtdpdml disp_inc q_man age_cat
sum hgage
sum female
sum disp_inc
sum q_man

sum hgage
sum female
sum disp_inc
sum q_man

// Poverty.

xtdpdml in_poverty sexor_binary_2 hgage, inv(female) // Doesn't converge.

// Simplified models.

// Employment.

xtdpdml num_spells_unemployed sexor_binary_2 // Doesn't converge. 

// Income.

xtdpdml disp_inc sexor_binary_2 // Doesn't converge. 

// Poverty.

xtdpdml in_poverty sexor_binary_2 // Doesn't converge. 






