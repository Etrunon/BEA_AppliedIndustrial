** You have to run this file before, as it defines all shared variables
// import 00Boilerplate.do
clear all

use "$data_original", replace

* It's pruning time
** Drop all other columns/variables
keep $all_var
** Drop observations with no SIC measurements and without LP
drop if year < 2007 | year > 2012
drop if ln_lp ==.

sum $VES
sum $SIC

// Output to be used when converting to latex
outreg2 using "table1.xls", excel sum(log) replace auto(2)

save "$data_first_cleaning", replace