** You have to run this file before, as it defines all shared variables
// import 00Boilerplate.do
clear all

use "$data_02ComputeAllocative", replace

// scatter covAllEfficiencyBySectorYear main07Act1digit year

outreg2 using "$result/03_tableVariables.xls", excel sum(log) replace auto(2)

//Boxplot firm size over years
graph box empl, over(year) title("Boxplot firm size over years")
graph export "$result/03_BoxplotFirmSizeOverYears.png", replace 

egen empl_mean = mean(empl), by(year) 
label variable empl_mean "Empl mean over years"
graph bar empl_mean, over(year) title("Boxplot Average firm size over years")
graph export "$result/03_BoxplotAverageFirmSizeOverYears.png", replace 

// Compute average Employee size over all the sectors (2digits)
use "$data_02ComputeAllocative", replace
drop if main07Act2digit==15
drop if main07Act2digit==26
bysort main07Act2digit year: egen averageEmplSectorYear=mean(empl) 
collapse averageEmplSectorYear, by(main07Act2digit year)
xtset main07Act2digit year
xtline averageEmplSectorYear if averageEmplSectorYear!=15, overlay

// Average productivity over years
use "$data_02ComputeAllocative", replace
egen ln_lp_mean = mean(ln_lp), by(year) 
label variable ln_lp_mean "ln_lp mean over years"
graph bar ln_lp_mean, over(year) title("Boxplot Average productivity over years")
graph export "$result/03_AverageProductivityOverYears.png", replace 

// Average productivity over all the provinces
use "$data_02ComputeAllocative", replace
bysort province year: egen averageProductivity=mean(empl) 
collapse averageProductivity, by(province year)
graph box averageProductivity, over(year) title("Average Province Productivity Over Years")
graph export "$result/03_AverageProvinceProductivityOverYears.png", replace 

//// Boxplot of labour productivity over the years
//// Pretty bad, unreadable
//egen ln_lp_mean = mean(ln_lp), by(year) 
//label variable ln_lp_mean "ln_lp mean over years"
//graph bar ln_lp_mean, over(year) title("Boxplot Average firm Labour Productivity over years")
//
//graph box rev, over(year) title("Boxplot of revenue over years")
//
//graph box rev if rev<10000000, over(year) title("Boxplot of revenue over years") subtitle("For revenues < 10^7")
//
//foreach var in $SIC {
//    graph box ln_lp, over(year)
//}