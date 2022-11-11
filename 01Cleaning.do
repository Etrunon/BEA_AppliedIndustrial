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
global VES_sectors "main07Act4digit main07Act3digit main07Act2digit main07Act1digit"
global VES_styl "idTax year rev ln_tfp empl ln_lp"

global VES $VES_sectors $VES_styl

global SIC_land "land_access land_expropriation"
global SIC_legal "legal_institutions"
global SIC_burocracy "time_bureaucracy_spending time_inspection_hours" 
global SIC_education "labor_general labor_soft_vocational" 

global SIC $SIC_land $SIC_legal $SIC_burocracy $SIC_education

// All variables to be used in a single batch
global all_var $VES $SIC

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

