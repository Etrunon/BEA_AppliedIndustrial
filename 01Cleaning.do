clear all
set more off

*** Define Local paths
local path  "/home/etrunon/Documents/UniBea/13Industrial/BEA_AppliedIndustrial"
local data "`path'/panel_2000_2012_tariff_finale.dta"
local result "`path'/result"

** Open up the dataset
cd "`path'"
use "`data'", replace

** Define variables
global var_VES "idTax year rev ln_tfp empl ln_lp main07Act4digit main07Act3digit main07Act2digit main07Act1digit"
global var_SIC "legal_institutions land_access land_expropriation time_bureaucracy_spending time_inspection_hours labor_general labor_soft_vocational" 
// All variables to be used in a single batch
global all_var $var_VES $var_SIC

* It's pruning time
** Drop all other columns/variables
keep $all_var
** Drop observations with no SIC measurements and without LP
drop if year < 2007 | year > 2012
drop if ln_lp ==.

sum $var_VES
sum $var_SIC

