use "$data_03ComputeAllocative", clear

local pci "pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending"
local ves "employee hhi_marketConcentration share_exportingFirm_spt"
local allocative "allocEff_ln_lp_spt allocEff_ln_tfp_spt "

collapse `pci' `ves' `allocative', by(province year)

pwcorr `pci' `ves' `allocative', star(.05)
outreg2 using "$result/05/CorrelationMatrix.tex", replace ctitle(Correlation Matrix)

// Set the dataset as panel on province and year
xtset province year

// Regress model with LP
reg allocEff_ln_lp_spt pci_land_access
outreg2 using "$result/05/ModelLP.tex", replace ctitle(Land)
reg allocEff_ln_lp_spt pci_labor_general  
outreg2 using "$result/05/ModelLP.tex", append ctitle(Education)
reg allocEff_ln_lp_spt pci_time_bureaucracy_spending  
outreg2 using "$result/05/ModelLP.tex", append ctitle(Bureaucracy)

reg allocEff_ln_lp_spt pci_land_access pci_labor_general pci_time_bureaucracy_spending  
outreg2 using "$result/05/ModelLP.tex", append ctitle(Simple model)

reg allocEff_ln_lp_spt pci_land_access pci_land_expropriation pci_labor_general pci_time_bureaucracy_spending hhi_marketConcentration employee 
outreg2 using "$result/05/ModelLP.tex", append ctitle(Employee)

reg allocEff_ln_lp_spt pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending hhi_marketConcentration employee share_exportingFirm_spt 
outreg2 using "$result/05/ModelLP.tex", append ctitle(Export)

estat vif




// Regress model with TFP
reg allocEff_ln_tfp_spt pci_land_access
outreg2 using "$result/05/ModelTFP.tex", replace ctitle(Land)
reg allocEff_ln_tfp_spt pci_labor_general  
outreg2 using "$result/05/ModelTFP.tex", append ctitle(Education)
reg allocEff_ln_tfp_spt pci_time_bureaucracy_spending  
outreg2 using "$result/05/ModelTFP.tex", append ctitle(Bureaucracy)

reg allocEff_ln_tfp_spt pci_land_access pci_labor_general pci_time_bureaucracy_spending  
outreg2 using "$result/05/ModelTFP.tex", append ctitle(Simple model)

reg allocEff_ln_tfp_spt pci_land_access pci_land_expropriation pci_labor_general pci_time_bureaucracy_spending hhi_marketConcentration employee 
outreg2 using "$result/05/ModelTFP.tex", append ctitle(Complete)

reg allocEff_ln_tfp_spt pci_land_access pci_land_expropriation pci_labor_general pci_labor_soft_vocational pci_time_bureaucracy_spending hhi_marketConcentration employee share_exportingFirm_spt
outreg2 using "$result/05/ModelTFP.tex", append ctitle(Complete)

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

// ----------------------------------------------------------------------------------------------------------------------------
// Il blocco qui sotto va a disegnare dei grafici che cercano la correlazione tra dimensione dell'azienda e percezione
// di facilità di accesso ai terreni. 
// L'intuizione era che più un azienda è grande e meno difficoltà avrà a ottenere terreni, perchè avrà persone dedicate esclusivamente 
// a quell'attività.
// L'intuizione non è completamente corretta, vale solo in alcuni anni. Probabilmente bisognerebbe scorporare l'influenza della 
// crisi del 2009 e altri fattori.
forvalues anno = 2007 (1) 2012{
    use "$data_03ComputeAllocative", clear
    
    keep if year == `anno'

    collapse employee pci_land_access, by (province)

    graph twoway (scatter employee pci_land_access, mlabel(province) ) (lfit employee pci_land_access), ///
    ytitle(employee) xtitle(pci_land_access) title(mean pci_land_access and employee by province)  legend(off) scheme(s2mono)  graphregion(color(white))

    graph export "$result/05/Scatter_correlationLandAccessEmployee_`anno'.png", replace
}

// ----------------------------------------------------------------------------------------------------------------------------
// Il blocco qui sotto va a disegnare dei grafici che cercano la correlazione tra dimensione dell'azienda e percezione
// di problemi con la burocrazia. 
// L'intuizione era che più un azienda è grande e meno difficoltà avrà a gestire la burocrazia, perchè avrà persone dedicate esclusivamente 
// a quell'attività.
use "$data_03ComputeAllocative", clear
collapse employee pci_time_bureaucracy_spending, by (province)

graph twoway (scatter employee pci_time_bureaucracy_spending, mlabel(province) ) (lfit employee pci_time_bureaucracy_spending), ///
ytitle(employee) xtitle(pci_time_bureaucracy_spending) title(mean pci_time_bureaucracy_spending and employee by province)  legend(off) scheme(s2mono)  graphregion(color(white))

graph export "$result/05/Scatter_correlationBureauocracyEmployee_AllPeriod.png", replace

forvalues anno = 2007 (1) 2012{
    use "$data_03ComputeAllocative", clear
    
    keep if year == `anno'

    collapse employee pci_time_bureaucracy_spending, by (province)

    graph twoway (scatter employee pci_time_bureaucracy_spending, mlabel(province) ) (lfit employee pci_time_bureaucracy_spending), ///
    ytitle(employee) xtitle(pci_time_bureaucracy_spending) title(mean pci_time_bureaucracy_spending and employee by province)  legend(off) scheme(s2mono)  graphregion(color(white))

    graph export "$result/05/Scatter_correlationBureauocracyEmployee_`anno'.png", replace
}



// Paper images below

use "$data_03ComputeAllocative", clear

collapse pci_labor_soft_vocational allocEff_ln_lp_spt allocEff_ln_tfp_spt pci_land_access, by (province)

twoway (scatter allocEff_ln_lp_spt pci_labor_soft_vocational, mlabel(province) ) (lfit allocEff_ln_lp_spt pci_labor_soft_vocational), ///
    ytitle(All. Eff. LP) xtitle(Quality of Vocational Education) ///
    title(LP All.Eff. based and Vocational Education)  legend(off) scheme(s2mono)  graphregion(color(white))

graph export "$result/05/05_Paper_Scatter_LP_Vocational_byProvince.png", replace

twoway (scatter allocEff_ln_tfp_spt pci_labor_soft_vocational, mlabel(province) ) (lfit allocEff_ln_tfp_spt pci_labor_soft_vocational), ///
    ytitle(All. Eff. TFP) xtitle(Quality of Vocational Education) ///
    title(TFP All.Eff. and Vocational Education)  legend(off) scheme(s2mono)  graphregion(color(white))

graph export "$result/05/05_Paper_Scatter_TFP_Vocational_byProvince.png", replace

twoway (scatter allocEff_ln_lp_spt pci_land_access, mlabel(province) ) (lfit allocEff_ln_lp_spt pci_land_access), ///
    ytitle(All. Eff. LP) xtitle(Quality of Land Access) ///
    title(LP All.Eff. based and Land Access)  legend(off) scheme(s2mono)  graphregion(color(white))

graph export "$result/05/05_Paper_Scatter_LP_LandAccess_byProvince.png", replace