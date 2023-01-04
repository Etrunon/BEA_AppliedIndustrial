use "$data_01Cleaning", clear

drop if province == 105

xtset idTax year

**COrevRIANCE AT SECTOR-PROVINCE LEVEL
*AGGREGATE PRODUCTIVITY

// Legend of abbreviations
// ispt: firm setor province time
// spt: sector province time
//

* Shares
egen empl_spt = sum(empl), by(main07Act2digit province year)
gen share_empl_ispt = empl / empl_spt

egen rev_spt = sum(rev), by(main07Act2digit province year)
gen share_rev_ispt = rev / rev_spt

*Aggregate Productivity

**FIRST TERM: Unweighted (log)TFP
egen ln_lp_mean_spt = mean(ln_lp), by(main07Act2digit province year)
egen ln_tfp_mean_spt = mean(ln_tfp), by(main07Act2digit province year)

**SECOND TERM: Covariance Terms
       
*Average Sectoral Province Shares
egen share_empl_mean_p = mean(share_empl_ispt), by(main07Act2digit province year)
egen share_rev_mean_p = mean(share_rev_ispt), by(main07Act2digit province year)
 
*Deviations from mean values
gen Deviation_share_empl_p = share_empl_ispt - share_empl_mean_p
gen Deviation_share_rev_p = share_rev_ispt - share_rev_mean_p

gen Deviation_ln_lp_p = ln_lp - ln_lp_mean_spt
gen Deviation_ln_tfp_p = ln_tfp - ln_tfp_mean_spt

*Covariance term
gen temp= Deviation_share_empl_p * Deviation_ln_lp_p
egen cov_ln_lp_spt = sum(temp), by(main07Act2digit province year)
drop temp
gen temp= Deviation_share_rev_p * Deviation_ln_tfp_p
egen cov_ln_tfp_spt = sum(temp), by(main07Act2digit province year)
drop temp

egen py=group(province year)

*egen nfirm=count(idTax), by (main07Act2digit province year)
*egen nexp=count(idTax), by (export main07Act2digit province year)

hhi rev, by (main07Act2digit year)

collapse cov_ln_lp_spt cov_ln_tfp_spt hhi land_access land_expropriation labor_general labor_soft_vocational time_bureaucracy_spending  export empl, by (main07Act2digit province year)

rename cov_ln_lp_spt              allocEff_ln_lp_spt
rename cov_ln_tfp_spt             allocEff_ln_tfp_spt
rename main07Act2digit            sector_2digit
rename hhi                        hhi_marketConcentration
rename export                     share_exportingFirm_spt
rename land_access                pci_land_access
rename land_expropriation         pci_land_expropriation
rename labor_general              pci_labor_general
rename labor_soft_vocational      pci_labor_soft_vocational
rename time_bureaucracy_spending  pci_time_bureaucracy_spending
rename empl                       employee

label variable allocEff_ln_lp_spt               "AllocativeEfficiencyLP_{spt}"
label variable allocEff_ln_tfp_spt              "AllocativeEfficiencyTFP_{spt}"
label variable sector_2digit                    "Sector"
label variable hhi_marketConcentration          "HHI\_index"
label variable share_exportingFirm_spt          "Share\_ExportingFirms_{spt}"
label variable pci_land_access                  "PCI\_LandAccess"
label variable pci_land_expropriation           "PCI\_LandExpropriation"
label variable pci_labor_general                "PCI\_EducationGeneral"
label variable pci_labor_soft_vocational        "PCI\_EducationVocational"
label variable pci_time_bureaucracy_spending    "PCI\_TimeSpentBurocracy"
label variable employee                         "NumberOfEmployee"

label define sector_2digit 10 "Food" 11 "Beverages" 12 "Tobacco" 13 "Textiles" 14 "Wearing apparel" 15 "Leather" 16 "Wood" ///
    17 "Paper" 18 "Printing and Publishing" 19 "Coke and Refined petroleum" 20 "Chemicals" 21 "Pharmaceuticals and Medicines" ///
    22 "Rubber and Plastics" 23 "Non-metallic minerals" 24 "Basic metals" 25 "Fabricated metals" 26 "Electronic products" ///
    27 "Electrical equipment" 28 "Machinery and equipment" 29 "Motor vehicles and Trailers" 30 "Other transport equipment" ///
    31 "Furniture" 32 "Other manufacturing" 33 "Repair and Installation"
label values sector_2digit sector_2digit

label define province 301 "Lai Chau" 203 "Cao Bang" 601 "Kon Tum" 707 "Binh Phuoc" 103 "Hai Phong" 201 "Ha Giang" ///
 111 "Ha Nam" 101 "Ha Noi" 225 "Quang Ninh" 217 "Phu Tho" 823 "Ca Mau" 211 "Tuyen Quang" 209 "Lang Son"  ///
 117 "Ninh Binh" 503 "Quang Nam" 207 "Bac Kan" 401 "Thanh Hoa" 113 "Nam Dinh" 305 "Hoa Binh" 107 "Hai Duong"  ///
 813 "Kien Giang" 109 "Hung Yen" 511 "Khanh Hoa" 715 "Binh Thuan" 509 "Phu Yen" 821 "Bac Lieu" 405 "Ha Tinh"  ///
 403 "Nghe An" 215 "Thai Nguyen" 603 "Gia Lai" 106 "Bac Ninh" 407 "Quang Binh" 115 "Thai Binh" 607 "Lam Dong"  ///
 709 "Tay Ninh" 811 "Ben Tre" 701 "HCMC" 213 "Yen Bai" 815 "Can Tho" 303 "Son La" 717 "BRVT" 817 "Tra Vinh"  ///
 805 "An Giang" 409 "Quang Tri" 705 "Ninh Thuan" 505 "Quang Ngai" 801 "Long An" 104 "Hau Giang" 605 "Dak Lak"  ///
 205 "Lao Cai" 807 "Tien Giang" 221 "Bac Giang" 713 "Dong Nai" 501 "Da Nang" 803 "Dong Thap" 711 "Binh Duong"  ///
 507 "Soc Trang" 819 "Binh Dinh" 411 "TT-Hue" 809 "Vinh Long"
label values province province

save "$data_03ComputeAllocative", replace