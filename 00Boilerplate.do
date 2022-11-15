// In this file there are all the definitions and settings that should be shared among all other files

clear all
set more off

// Define Local paths
global path  "/home/etrunon/Documents/UniBea/13Industrial/BEA_AppliedIndustrial"
global result "$path/results"

global data_original "$path/panel_2000_2012_tariff_finale.dta"

global data_01Cleaning "$result/01Cleaning.dta"
global data_02ComputeAllocative "$result/02ComputeAllocative.dta"

// Define variables
global VES_sectors "main07Act4digit main07Act3digit main07Act2digit main07Act1digit"
global VES_styl "idTax year rev ln_tfp empl ln_lp province"

global VES $VES_sectors $VES_styl

global SIC_land "land_access land_expropriation"
global SIC_legal "legal_institutions"
global SIC_burocracy "time_bureaucracy_spending time_inspection_hours" 
global SIC_education "labor_general labor_soft_vocational" 

global SIC $SIC_land $SIC_legal $SIC_burocracy $SIC_education

// All variables to be used in a single batch
global all_var $VES $SIC

// Open the correct workspace
cd "$path"
