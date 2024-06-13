/******************************************************************************
* MERGING INDIVIDUAL FILES ACROSS WAVES INTO WIDE FORMAT                      *
* To match individual level files across two or more waves into a long format *
*******************************************************************************/

** Part A: Individual-level data.

** Step 1. Replace "filepath of your working directory" 
** with the filepath where you want to save all files
** That is your working directory. 
** Remember to include the double quotes
cd "C:\Users\sant6264\Downloads\UKHLS_analysis"

ssc install isvar

** Step 2. When you download and unzipped the data folder, 
** you will see that the data is provided in two folders "ukhls" and "bhps". 
** In this step, replace "filepath of downloaded data" with the filepath where 
** you have saved the two folders "ukhls" and "bhps"
** Remember to include the double quotes
global datain "C:\Users\sant6264\Downloads\UKHLS_analysis"

** Step 3. Decide which data files you want to combine, from which waves and which variables you want to keep.
** In this example we are combining indresp files from the first 12 UKHLS Waves and keeping variables jbstat & age_dv
** Note, pidp needs to be included always.

// loop through each wave
// Change: For fewer waves use only the wave prefix of the waves you need to merge
foreach w in a b c d e f g h i j k l m {
	
	// open the individual level file 
	// Change: for a different individual level file, e.g., indall: use "$datain/ukhls/`w'_indall", clear
	// Change: for BHPS data: use "$datain/bhps/b`w'_indresp", clear
	use "$datain/`w'_indresp_protect", clear
	
	// keep the variables you need
	// Change: for all variables delete these two lines
	isvar pidp ?_sexuor ?_qfhigh_dv ?_fihhmngrs_dv ?_fimngrs_dv ?_ethn_dv ?_marstat ?_jbstat ?_age_dv ?_sex_dv ?_jbhrs ?_birthsex ?_j2pay_dv ?_nunmpsp_dv ?_jbhrcpr ?_nxtendreas ?_nkids_dv ?_urban_dv ?_hidp ?_pidp ?_ppid ?_gor_dv ?_plbornc ?_prearn ?_ukborn ?_hhsize ?_indscus_lw ?_engspk ?_disdif1 ?_disdif2 ?_disdif3 ?_disdif4 ?_disdif5 ?_disdif6 ?_disdif7 ?_disdif8 ?_disdif9 ?_disdif10 ?_disdif11 ?_disdif12 ?_disdif96 ?_benbase1 ?_benbase2 ?_benbase3 ?_benbase4 ?_benbase96 ?_othben1 ?_othben2 ?_othben3 ?_othben4 ?_othben5 ?_othben6 ?_othben7 ?_othben8 ?_othben9 ?_othben96 ?_othben97 ?_hidp ?_psu ?_strata ?_fimnnet_dv ?_buno_dv ?_nchild_dv ?_indinub_lw ?_indinui_xw ?_hiqual_dv
	keep `r(varlist)'
	
	// drop the wave prefix from all variables
	rename `w'_* *
	
	// create a wave variable
	gen wave=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	
	// save one file for each wave
	save `w', replace
}
// Open one of the wave files
use a, clear
// append the files for all the other waves
foreach w in b c d e f g h i j k l m {
	append using `w'
}

// make sure this has worked and each row is uniquely identified by pidp wave combination
isid pidp wave

// save the long file
save indlongfile, replace

// erase temporary files
foreach w in a b c d e f g h i j k l m {
	erase `w'.dta
}


** Part B: Household-level data.

** Step 2. When you download and unzipped the data folder, 
** you will see that the data is provided in two folders "ukhls" and "bhps". 
** In this step, replace "filepath of downloaded data" with the filepath where 
** you have saved the two folders "ukhls" and "bhps"
** Remember to include the double quotes
global datain "C:\Users\sant6264\Downloads\UKHLS_analysis"

** Step 3. Decide which data files you want to combine, from which waves and which variables you want to keep.
** In this example we are combining indresp files from the first 12 UKHLS Waves and keeping variables jbstat & age_dv
** Note, pidp needs to be included always.

// loop through each wave
// Change: For fewer waves use only the wave prefix of the waves you need to merge
foreach w in a b c d e f g h i j k l m {
	
	// open the individual level file 
	// Change: for a different individual level file, e.g., indall: use "$datain/ukhls/`w'_indall", clear
	// Change: for BHPS data: use "$datain/bhps/b`w'_indresp", clear
	use "$datain/`w'_hhresp_protect", clear
	
	// keep the variables you need
	// Change: for all variables delete these two lines
	isvar ?_hidp ?_fihhmnnet1_dv ?_ieqmoecd_dv ?_fihhmngrs_dv ?_gor_dv ?_hhsize
	keep `r(varlist)'
	
	// drop the wave prefix from all variables
	rename `w'_* *
	
	// create a wave variable
	gen wave=strpos("abcdefghijklmnopqrstuvwxyz","`w'")
	
	// save one file for each wave
	save `w', replace
}

// Open one of the wave files
use a, clear
// append the files for all the other waves
foreach w in b c d e f g h i j k l m {
	append using `w'
}

// make sure this has worked and each row is uniquely identified by pidp wave combination
isid hidp wave

// save the long file
save hhlongfile, replace

// erase temporary files
foreach w in a b c d e f g h i j k l m {
	erase `w'.dta
}

