use "$data_03ComputeAllocative", clear

local pci "pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending"
local ves "employee hhi_marketConcentration share_exportingFirm_spt"
local allocative "allocEff_ln_lp_spt allocEff_ln_tfp_spt "

collapse `pci' `ves' `allocative', by(province year)

pwcorr `pci' `ves' `allocative', star(.05)

// Set the dataset as panel on province and year
xtset province year

// Regress model with LP
reg allocEff_ln_lp_spt pci_land_access pci_land_expropriation pci_labor_general pci_time_bureaucracy_spending hhi_marketConcentration employee 
estat vif


// Regress model with TFP
reg allocEff_ln_tfp_spt pci_land_access pci_labor_general pci_time_bureaucracy_spending hhi_marketConcentration employee
estat vif


// ----------------------------------------------------------------------------------------------------------------------------

// Questo codice genera vari grafici. Per una migliore lettura faccio bulk renaming dei file
// secondo le regole qui sotto nel commento.
// "allocEff_ln_" -> ""
// "_spt" -> ""
// "pci_" -> ""
local pci "pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending"
local allocative "allocEff_ln_lp_spt allocEff_ln_tfp_spt "

foreach alloc in `allocative'{
    foreach index in `pci'{
        use "$data_03ComputeAllocative", clear

        collapse `index' `alloc', by (province)

        twoway (scatter `alloc' `index', mlabel(province) ) (lfit `alloc' `index'), ///
            ytitle(`alloc') xtitle(`index') title(mean `index' and `alloc' by province)  legend(off) scheme(s2mono)  graphregion(color(white))

        graph export "$result/05/Scatter_`alloc'_`index'_byProvince.png", replace
    }

// Il blocco qui commentato calcola gli stessi grafici ma differenziando per settore e non per provincia. Alcune cose hanno senso
// per esempio si vede che i settori high tech apprezzano maggiormente l'educazione.  Ma per il resto non mi sembrano sconvolgenti
//    foreach index in `pci'{
//        use "$data_03ComputeAllocative", clear
//
//        collapse `index' `alloc', by (sector)
//
//        twoway (scatter `alloc' `index', mlabel(sector) ) (lfit `alloc' `index'), ///
//            ytitle(`alloc') xtitle(`index') title(mean `index' and `alloc' by sector)  legend(off) scheme(s2mono)  graphregion(color(white))
//
//        graph export "$result/05/Scatter_`alloc'_`index'_bySector.png", replace
//    }
}

// ----------------------------------------------------------------------------------------------------------------------------

// Il blocco qui sotto contiene vari grafici usati per cercare di intuire come procedere con l'analisi. Sono molto grezzi e non
// eccessivamente indicativi
// Graph to show correlation between allocative and pci indexes
//use "$data_03ComputeAllocative", clear
//
//graph twoway scatter allocEff_ln_lp_spt employee, by(sector)
//graph twoway scatter allocEff_ln_lp_spt pci_land_access, by(sector)
//graph twoway scatter allocEff_ln_lp_spt pci_land_expropriation, by(sector)
//graph twoway scatter allocEff_ln_lp_spt pci_labor_general, by(sector)
//graph twoway scatter allocEff_ln_lp_spt pci_labor_soft_vocational, by(sector)
//graph twoway scatter allocEff_ln_lp_spt pci_time_bureaucracy_spending, by(sector)
//
//graph twoway scatter allocEff_ln_tfp_spt employee, by(sector)
//graph twoway scatter allocEff_ln_tfp_spt pci_land_access, by(sector)
//graph twoway scatter allocEff_ln_tfp_spt pci_land_expropriation, by(sector)
//graph twoway scatter allocEff_ln_tfp_spt pci_labor_general, by(sector)
//graph twoway scatter allocEff_ln_tfp_spt pci_labor_soft_vocational, by(sector)
//graph twoway scatter allocEff_ln_tfp_spt pci_time_bureaucracy_spending, by(sector)
//
//
//graph twoway scatter allocEff_ln_tfp_spt employee if sector==11