use "$data_01Cleaning", clear
xtset idTax year

**COVARIANCE AT SECTOR-PROVINCE LEVEL

*AGGREGATE PRODUCTIVITY

* Shares
egen empl_spt = sum(empl), by(main07Act2digit province year)
gen share_empl_ispt = empl / empl_spt

egen rev_spt = sum(rev), by(main07Act2digit province year)
gen share_rev_ispt = rev / rev_spt

**FIRST TERM: Unweighted (log)TFP
egen ln_lp_mean_spt = mean(ln_lp), by(main07Act2digit province year)
egen ln_tfp_mean_spt = mean(ln_tfp), by(main07Act2digit province year)

**SECOND TERM: Covariance Terms
 
*Average main07Act2digital provinceince Shares
egen share_empl_mean_p = mean(share_empl_ispt), by(main07Act2digit province year)
egen share_rev_mean_p = mean(share_rev_ispt), by(main07Act2digit province year)
 
*Deviations from mean values
gen Deviation_share_empl_p = share_empl_ispt - share_empl_mean_p
gen Deviation_share_rev_p = share_rev_ispt - share_rev_mean_p

gen Deviation_ln_lp_p = ln_lp - ln_lp_mean_spt
gen Deviation_ln_tfp_p = ln_tfp - ln_tfp_mean_spt

*Covariance term
gen temp = Deviation_share_empl_p * Deviation_ln_lp_p
egen covariance_ln_lp_spt = sum(temp), by(main07Act2digit province year)
drop temp
gen temp= Deviation_share_rev_p * Deviation_ln_tfp_p
egen covariance_ln_tfp_spt = sum(temp), by(main07Act2digit province year)
drop temp

egen py=group(province year)

*egen nfirm=count(idTax), by (main07Act2digit province year)
*egen nexp=count(idTax), by (export main07Act2digit province year)

hhi rev, by (main07Act2digit year)

collapse covariance_ln_lp_spt covariance_ln_tfp_spt hhi land_expropriation labor_general export empl, ///
    by (main07Act2digit province year)

sort covariance_ln_lp_spt covariance_ln_tfp_spt
twoway (scatter covariance_ln_lp_spt covariance_ln_tfp_spt) (lfit covariance_ln_lp_spt covariance_ln_tfp_spt) if year == 2008