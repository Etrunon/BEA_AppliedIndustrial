use "$data_03ComputeAllocative", clear

// Descriptive table with mean median and sd
tabstat allocEff_ln_lp_spt allocEff_ln_tfp_spt hhi_marketConcentration share_exportingFirm_spt employee pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending, ///
    statistics(mean median sd) ///
    format(%4.3f) ///
    columns(s)

// Boxplot of the pci indexes over year
local iteration "province sector_2digit"
foreach i in `iteration'{
    use "$data_03ComputeAllocative", clear
    local pci "pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending"
    collapse `pci' hhi_marketConcentration, by(`i' year)


    foreach index in `pci'{
        graph box `index', over(year)
        graph export "$result/04/Boxplot_CollapsedOn`i'_`index'_overYear.png", replace
    }

    // Boxplot of hhi over year
    graph box hhi_marketConcentration, over(year)
    graph export "$result/04/Boxplot_CollapsedOn`i'_HHI_index_overYear.png", replace
}

// Alllocative Efficiency graphs
local iteration "province sector_2digit"
local allocatives "allocEff_ln_lp_spt allocEff_ln_tfp_spt"
foreach allocative in `allocatives' {
    foreach i in `iteration'{
        use "$data_03ComputeAllocative", clear

        collapse `allocative', by(`i' year)
        graph box `allocative' , over(year)

        graph export "$result/04/Boxplot_`allocative'_CollapsedOn`i'_overYear.png", replace

    }
}