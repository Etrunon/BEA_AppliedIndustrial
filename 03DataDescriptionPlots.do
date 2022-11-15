** You have to run this file before, as it defines all shared variables
// import 00Boilerplate.do
clear all

use "$data_02ComputeAllocative", replace

// scatter covAllEfficiencyBySectorYear main07Act1digit year

outreg2 using "$result/03_tableVariables.xls", excel sum(log) replace auto(2)


// Boxplot of labour productivity over the years
// Pretty bad, unreadable
graph box ln_lp, over(year)

graph box rev, over(year) title("Boxplot of revenue over years")

graph box rev if rev<10000000, over(year) title("Boxplot of revenue over years") subtitle("For revenues < 10^7")

foreach var in $SIC {
    graph box ln_lp, over(year)
}