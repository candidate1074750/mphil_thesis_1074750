
// Set and check working directory.
cd "C:\Users\candidate\Downloads\UKHLS_analysis"
pwd

// Load data. 
use "stata_ukhls.dta", clear

// Install package for dynamic panel data modelling using maximum likelihood.
ssc install xtdpdml
install esttab

// Informing package of the data structure.
xtset pidp wave

// Full(er) models.

// Employment.

xtdpdml num_spells_unemployed sexor_binary_2 age_dv, inv(female) // Doesn't converge.

// Income.

xtdpdml disp_inc sexor_binary_2 age_dv, inv(female) // Doesn't converge.

// Poverty.

xtdpdml in_poverty sexor_binary_2 age_dv, inv(female) // Doesn't converge.

// Simplified models.

// Employment.

xtdpdml num_spells_unemployed sexor_binary_2 // Doesn't converge. 

// Income.

xtdpdml disp_inc sexor_binary_2 // Doesn't converge. 

eststo disp_inc_simple

* Create the table using estout
esttab disp_inc_simple, cells(b(fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) ///
    stats(N chi2 p, fmt(%9.0fc %9.2fc %9.3fc) labels("Observations" "Chi-squared" "P-value")) ///
    mlabels("Model 1") collabels(none) ///
    title("Sexuality on disposable income, simple") ///
    varwidth(20) modelwidth(12) ///
    nonumbers label nobaselevels

// Poverty.

xtdpdml in_poverty sexor_binary_2 // Doesn't converge. 






