** You have to run this file before, as it defines all shared variables
// import 00Boilerplate.do
clear all

use "$data_original", replace

* It's pruning time
** Drop all other columns/variables
keep $all_var
** Drop observations with no PCI measurements, without LP and TFP
drop if year < 2007 | year > 2012
drop if ln_lp == .

drop if ln_tfp == .
count if province == .
drop if province == .
count if main07Act2digit == .


sum $VES
sum $SIC

// Output to be used when converting to latex
outreg2 using "$result/01_tableVariables.xls", excel sum(log) replace auto(2)

// Apply all the labels
label variable idTax "Firm Id"
label variable year "Year"
label variable main07Act1digit "Sector code 1-digit"
label variable main07Act2digit "Sector code 2-digit"
label variable main07Act3digit "Sector code 3-digit"
label variable main07Act4digit "Sector code 4-digit"
label variable rev "Revenue"
label variable ln_tfp "Log of Total Factor Productivity"
label variable empl "Employee"
label variable ln_lp "Log of Labour Productivity"
label variable land_access "Land Access index"
label variable legal_institutions "Legal institution index"
label variable land_expropriation "Land Expropriation index"
label variable time_bureaucracy_spending "Time spent due to bureocracy"
label variable time_inspection_hours "Hours spent due to inspections"
label variable labor_general "Index of quality perception of general education"
label variable labor_soft_vocational "Index of quality perception of vocational education"
label variable export "Whether the firm exports or not"

save "$data_01Cleaning", replace