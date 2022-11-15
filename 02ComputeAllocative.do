** You have to run this file before, as it defines all shared variables
// import 00Boilerplate.do
clear all

use "$data_01Cleaning", replace

// This file is used to compute and add the allocative efficiency by each sector and year.
// As sector the most specific code is used from the main07Act classification

// Compute the average of productivity and size for each sector and year
bysort main07Act4digit year: egen averageLnProdBySectorYear=mean(ln_lp)
bysort main07Act4digit year: egen averageFirmSizeBySectorYear=mean(empl)

// Compute and save the difference of the averages and each firm value
gen emplDiffWithAverageSector = empl - averageFirmSizeBySectorYear
gen prodDiffWithAverageSector = ln_lp - averageLnProdBySectorYear

// Compute each sector covariance
gen covarForFirm = emplDiffWithAverageSector * prodDiffWithAverageSector
bysort main07Act4digit year: egen covAllEfficiencyBySectorYear=sum(covarForFirm) 

sort main07Act4digit
browse idTax ///
        main07Act4digit  ///
        year  ///
        empl  ///
        ln_lp  ///
        covAllEfficiencyBySectorYear ///
        averageFirmSizeBySectorYear  ///
        averageLnProdBySectorYear  ///
        emplDiffWithAverageSector ///
        prodDiffWithAverageSector 

// Scatter test
// scatter covAllEfficiencyBySectorYear year if main07Act2digit == 10

drop averageFirmSizeBySectorYear ///
        averageLnProdBySectorYear ///
        emplDiffWithAverageSector ///
        prodDiffWithAverageSector

label variable covarForFirm "Covariance at firm level (over sector and year)"
label variable covAllEfficiencyBySectorYear "Allocative efficiency by sector and year"

save "$data_02ComputeAllocative", replace