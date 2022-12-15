use "$data_01Cleaning", clear

xtset idTax year

**COrevRIANCE AT SECTOR-PROVINCE LEVEL
*AGGREGATE PRODUCTIVITY

// Legend of abbreviations
// ispt: firm setor province time
// spt: sector province time
//

* Shares
egen empl_spt = sum(empl), by(main07Act2digit province year)
gen share_empl_ispt = empl    / empl_spt

egen rev_spt = sum(rev), by(main07Act2digit province year)
gen share_rev_ispt = rev    / rev_spt

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

collapse cov_ln_lp_spt cov_ln_tfp_spt hhi land_expropriation labor_general export empl, by (main07Act2digit province year)