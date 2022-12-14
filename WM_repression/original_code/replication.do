

********************************************************************************
*
* Title:	INTERNATIONAL SPORTS EVENTS AND REPRESSION IN AUTOCRACIES:
* 			EVIDENCE FROM THE 1978 FIFA WORLD CUP
*
* Authors: 	Adam Scharpf, Christian Glaessel, Pearce Edwards
*
* Journal:	American Political Science Review
*
* Date:		July 2022
*
********************************************************************************
*
* Content:	Replication of results in the manuscript and supporting information	
*
*			Steps:
*			1) Set working directory
*			2) Load dataset
*			3) Replicate results and figures of manuscript and supporting information
*
********************************************************************************
*
* Packages: Before running this code, please make sure you have the following
*			.ado-files installed
*
*			- CEM Package, Version 10.1: 
*					ssc install cem
*
*			- Parmest Package, Version 2
*					net install st0043_2.pkg
*
*			- Rangestat Package, Version 1.1.1
*					ssc install rangestat
*
*
********************************************************************************


	version 15.1
	set more off

	clear all
  
 
 
********************************************************************************
*
* Setting working directory in macro
*
********************************************************************************

	*Insert path to folder containing datasets before running
	*global path="..." //Example: "C:\Users\me\Desktop\ScharpfGlaesselEdwards_APSR_WorldCup"
	global path="C:\Users\scharpf\Dropbox\ArgentinaWorldCup\replication\replicationfiles"
 
 
********************************************************************************
*
* Producing log-file of results
*
********************************************************************************

	*Start recording log file
	log using "$path\ScharpfGlaesselEdwards_APSR", replace 

	
	
********************************************************************************
*
* Loading main replication dataset
*
********************************************************************************

	*Loading replication dataset
	use "$path\main_data.dta"


********************************************************************************
*
* Summary statistics 
*
********************************************************************************	
	
	****************************************************************************
	*Table SI.3.1.: Summary statistics (Main analyses)
	****************************************************************************	

	#delimit ;
	sum 
		repression 
		lnrepression 
		dumrepression	
		hostcity 
		prox_hotelonly
		prox_hotelpress	
		time 
		time2 
		time3 
		lnpop_1970 
		literacy_avg 
		vote_frejuli 
		lnrebact1974 
		lnrepression70_77 
		latitude
		lnstrikes
		lnlag_strikes
		lnlag2_strikes	
		zone1-zone5
	if time!=.
	;
	#delimit cr
	
	
	****************************************************************************
	*Table SI.3.2.: Summary statistics (Post-World Cup period)
	****************************************************************************		
	
	#delimit ;
	sum 
		repression 
		lnrepression 
		hostcity 
		postwc_time3mdum
		time_postwc 
		time2_postwc 
		time3_postwc	
		lnpop_1970 
		vote_frejuli 
		literacy_avg 
		lnrebact1974 
		lnrepression70_77 
		zone1-zone5
	if
	postwc_time3mdum!=.
	;
	#delimit cr		
	
	
	
********************************************************************************
*
* Statistical analysis 
*
********************************************************************************


	****************************************************************************
	*Table 1: Repression in departments with and without host cities
	****************************************************************************

	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2, robust
	
	*Model 2
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
		
	*Model 3
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			

	*Model 4
	nbreg repression hostcitytime hostcitytime2 hostcity time time2, cluster(id)
	
	*Model 5
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)	
	
	*Model 6
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)
	
	
	
	****************************************************************************
	*Table SI.4.1: Linear regressions (OLS) for repression in departments with and without host cities
	****************************************************************************	
	
 	*Model 1
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2, robust
	
	*Model 2
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
	
	*Model 3
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	 
	
	
	
	****************************************************************************
	*Table SI.4.2: Regression results with standard errors clustered on departments (and partidos)
	****************************************************************************		
	
	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2, cluster(id)
	
	*Model 2
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)		
	
	*Model 3
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)
 
	*Model 4
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2, cluster(id)
	
	*Model 5
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)	
		
	*Model 6
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)			
		
	
	
	****************************************************************************
	*Table SI.4.3: Regression results with standard errors clustered on provinces
	****************************************************************************		
	
	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2, cluster(id_prov)
	
	*Model 2
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id_prov)		
		
	*Model 3
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id_prov)
 
	*Model 4
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2, cluster(id_prov)
	
	*Model 5
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id_prov)	
		
	*Model 6
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id_prov)			
 
	
	
	****************************************************************************
	*Table SI.4.4: Regression results for cubic polynomials of time
	****************************************************************************		
	
	*Model 1 
	nbreg repression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3, robust
	
	*Model 2 
	nbreg repression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
	
	*Model 3 
	nbreg repression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
	
	*Model 4 
	reg lnrepression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3, robust
	
	*Model 5 
	reg lnrepression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
	
	*Model 6 
	reg lnrepression hostcitytime hostcitytime2 hostcitytime3 hostcity time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
	
	
	
	****************************************************************************
	*Table SI.4.5: Regression results for binary variable of repression
	****************************************************************************		

	*Model 1
	logit dumrepression hostcitytime hostcitytime2 hostcity time time2, robust
	
	*Model 2
	logit dumrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
	
	*Model 3
	logit dumrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust		 
	
	*Model 4
	reg dumrepression hostcitytime hostcitytime2 hostcity time time2, robust

	*Model 5
	reg dumrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
	
	*Model 6
	reg dumrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	 
	
	
	
	****************************************************************************
	*Table SI.4.6: Negative binomial regressions for matched samples
	****************************************************************************		
	
	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 if matched_simple==1, robust
	
	*Model 2
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_simple==1, robust
		
	*Model 3
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_simple==1, robust			
	
	*Model 4
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 if matched_allhosts==1, robust
	
	*Model 5
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_allhosts==1, robust
		
	*Model 6
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_allhosts==1, robust			

	*Model 7
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 if matched_nocapfed==1, robust
	
	*Model 8
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_nocapfed==1, robust
		
	*Model 9
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_nocapfed==1, robust			

	
	
	****************************************************************************
	*Table SI.4.7: Linear regressions (OLS) for matched samples
	****************************************************************************		
	
	*Model 1
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 if matched_simple==1, robust
	
	*Model 2
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_simple==1, robust	
	
	*Model 3
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_simple==1, robust	 
	
	*Model 4
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 if matched_allhosts==1, robust
	
	*Model 5
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_allhosts==1, robust	
	
	*Model 6
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_allhosts==1, robust	 
	
	*Model 7
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 if matched_nocapfed==1, robust
	
	*Model 8
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 if matched_nocapfed==1, robust	
	
	*Model 9
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if matched_nocapfed==1, robust	 
	
	
	
	****************************************************************************
	*Table SI.4.8: Outlier test with dropping one host city at a time
	****************************************************************************		
 
	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=1, robust			
 	
	*Model 2	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=2, robust			
 	
	*Model 3	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=3, robust			
 	
	*Model 4	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=4, robust			
 	
	*Model 5	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=5, robust			
 	
	*Model 6
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=1, robust			
 	
	*Model 7	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=2, robust			
 	
	*Model 8	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=3, robust			
 	
	*Model 9	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=4, robust			
 	
	*Model 10	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5 if hostcitynum!=5, robust			
 
 	

	****************************************************************************
	*Table SI.4.9: Regression results for extended analysis window (January 1, 1978 - June 25, 1978)
	****************************************************************************		
	
	*Model 1
	nbreg repression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long, cluster(id)
	
	*Model 2 
	nbreg repression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)
		
	*Model 3
	nbreg repression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)			

	*Model 4
	reg lnrepression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long, cluster(id)
	
	*Model 5
	reg lnrepression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)
		
	*Model 6
	reg lnrepression hostcitytime_long hostcitytime2_long hostcitytime3_long hostcity time_long time2_long time3_long lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)			

	
	
	****************************************************************************
	*Table SI.4.10: Linear regressions (OLS) with different fixed effects specifications
	****************************************************************************		
	
	*Model 1 
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 prov2-prov24, robust
	
	*Model 2 
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 prov2-prov24, robust
			
	*Model 3 
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 subzone2-subzone18, robust
	
	*Model 4 
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 subzone2-subzone18, robust
		
	
	
	****************************************************************************
	*Table SI.4.11: Regressions with Heckman sample selection for departments with host cities
	****************************************************************************		
	
	*Model 1	
	heckman lnrepression time time2, select(hostcity = lnpop_1970 literacy_avg vote_frejuli) robust
		
	*Model 2	
	heckman lnrepression time time2, select(hostcity = lnpop_1970 literacy_avg vote_frejuli lnrebact1974 lnrepression70_77) robust 

	*Model 3
	heckman lnrepression time time2 , select(hostcity = latitude lnpop_1970 vote_frejuli literacy_avg) robust	
	
	*Model 4
	heckprobit dumrepression time time2, select(hostcity = lnpop_1970 literacy_avg vote_frejuli) robust
		
	*Model 5	
	heckprobit dumrepression time time2, select(hostcity = lnpop_1970 literacy_avg vote_frejuli lnrebact1974 lnrepression70_77) robust
	
	*Model 6	
	heckprobit dumrepression time time2, select(hostcity = latitude lnpop_1970 vote_frejuli literacy_avg) robust 
	
	
	
	****************************************************************************
	*Table SI.4.12: Negative binomial regression results with week-level data
	****************************************************************************		
			
	*Preserving data
	preserve
		
	*Generating week variable
	gen week=wofd(date)
	format week %tw

	*Keeping obs of window
	keep if time!=.
	
	*Collapsing data by department-week
	#delimit ;
	collapse (sum) repression_w=repression 
			 (first) hostcity lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone*
			 , 
			 by(id week)
			 ;
	#delimit cr
				 
	*Generating running number for week variable
	bys id (week): gen time=_n
	replace time=time/10
	gen time2=time^2

	*Preparing repression variable
	gen lnrepression_w = ln(repression_w + 1)		
		
	*Generating interactions
	gen hostcitytime=hostcity*time
	gen hostcitytime2=hostcity*time2		
			
		
	*Model 1
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2, robust
		
	*Model 2
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust		
		
	*Model 3
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
		
	*Model 4
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2, cluster(id)

	*Model 5
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)		
		
	*Model 6
	nbreg repression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)		
		
	
	
	****************************************************************************
	*Table SI.4.13: Linear regression results with week-level data
	****************************************************************************		
	
	*Model 1
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2, robust	
		
	*Model 2
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
		
	*Model 3
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
		
	*Model 4
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2, cluster(id)		
		
	*Model 5
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, cluster(id)		
		
	*Model 6
	reg lnrepression_w hostcitytime hostcitytime2 hostcity time time2 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, cluster(id)				
	
	
	*Restoring data		
	restore	
	
	
	
	****************************************************************************
	*Table SI.4.14: Regression results with controls for protest
	****************************************************************************		
	
	*Model 1
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnstrikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust		
	
	*Model 2	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnlag_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
	
	*Model 3
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnlag2_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
	
	*Model 4
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnstrikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust		
	
	*Model 5
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnlag_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust
	
	*Model 6	
	nbreg repression hostcitytime hostcitytime2 hostcity time time2 lnlag2_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust		
		
	*Model 7
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnstrikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust		
	
	*Model 8	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnlag_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust	
	
	*Model 9	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnlag2_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
	
	*Model 10
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnstrikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	
		
	*Model 11	
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnlag_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	 
	
	*Model 12
	reg lnrepression hostcitytime hostcitytime2 hostcity time time2 lnlag2_strikes lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	 	
	
	
	
	****************************************************************************
	*Table SI.5.1: Regression results for types of repression (time indicators)
	****************************************************************************		
	
	*Preserving data
	preserve
	
	*Loading data
	use "$path\figure_7_data.dta"
	
	*Model 1	
	nbreg disappear timedum2 timedum3 timedum4, robust		
		
	*Model 2
	reg ln_disappear timedum2 timedum3 timedum4, robust		
		
	*Model 3
	nbreg kill timedum2 timedum3 timedum4, robust		
		
	*Model 4
	reg ln_kill timedum2 timedum3 timedum4, robust			
	
	*Restoring data
	restore	
	
	
	
	****************************************************************************
	*Table SI.5.2: Regression results for proximity to nearest journalist hotel
	****************************************************************************			
	
	*Model 1
	nbreg repression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3, robust
	
	*Model 2
	nbreg repression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
		
	*Model 3
	nbreg repression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			

	*Model 4
	reg lnrepression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3, robust
	
	*Model 5
	reg lnrepression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
		
	*Model 6
	reg lnrepression prox_hotelonly_time prox_hotelonly_time2 prox_hotelonly_time3 prox_hotelonly time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
	
	
	
	****************************************************************************
	*Table SI.5.3: Regression results for proximity to nearest journalist venue (journalist hotel, team hotel, or press venue)
	****************************************************************************			
	
	*Model 1
	nbreg repression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3, robust
	
	*Model 2
	nbreg repression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
		
	*Model 3
	nbreg repression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			
	
	*Model 4
	reg lnrepression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3, robust
	
	*Model 5
	reg lnrepression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust
		
	*Model 6
	reg lnrepression prox_hotelpress_time prox_hotelpress_time2 prox_hotelpress_time3 prox_hotelpress time time2 time3 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust			

	
	
	****************************************************************************
	*Table SI.6.1: Linear regressions (OLS) with biweekly time interactions in full analysis window (March - September 1978)
	****************************************************************************			

 	*Model 1
	reg lnrepression hcXbiweek2-hcXbiweek15 hostcity biweek2-biweek15, robust
	
	*Model 2
	reg lnrepression hcXbiweek2-hcXbiweek15 hostcity biweek2-biweek15 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77, robust		
	
	*Model 3
	reg lnrepression hcXbiweek2-hcXbiweek15 hostcity biweek2-biweek15 lnpop_1970 vote_frejuli literacy_avg lnrebact1974 lnrepression70_77 zone2-zone5, robust	
		
	
	
********************************************************************************
*
* Substantive effects graphs
*
********************************************************************************	
	
	
	****************************************************************************
	*Figure 5: Substantive effects
	****************************************************************************			
	
	*1) Calculating substantive effects
	
	*Estimating Model 3, Table 1
	#delimit ;
	nbreg repression 
		  i.hostcity#c.time 
		  i.hostcity#c.time#c.time 
		  i.hostcity 
		  c.time 
		  c.time#c.time 
		  c.lnpop_1970 
		  c.vote_frejuli 
		  c.literacy_avg 
		  c.lnrebact1974 
		  c.lnrepression70_77 
		  i.zone2 i.zone3 i.zone4 i.zone5
		  , 
		  robust 		
	;
	#delimit cr
	
	*Calculating effects and exporting effects data
	#delimit ;	
	margins, at((asobserved) _all time = (0.01(0.01)1.17)) over(hostcity) 			 
			 level(95) 
			 post;
	parmest, saving("$path\table1_model3_effects.dta", replace) format(estimate min95 max95);
	#delimit cr
	
	
	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading effects data
	use "$path\table1_model3_effects.dta", clear	
		
	*Identifying host and non-host cities
	gen hostcity=1 if regexm(parm, "1.hostcity$")
	replace hostcity=0 if regexm(parm, "0.hostcity$") & hostcity==.	
	
	*Generating day variable
	egen days= seq(), from(1) to() block(2)	
	
	*Generating STATA date variable
	gen date=td(28feb1978)+days
	format date %td
		
	*Generating World Cup event window
	gen eventx=days if date>=td(01jun1978)
	gen eventylow=0 if eventx!=. & hostcity==1
	gen eventyhigh=.51 if eventx!=.	& hostcity==1	
	
	gen eventylow_nohc=0 if eventx!=. & hostcity==0
	gen eventyhigh_nohc=.051 if eventx!=. & hostcity==0		
			
	
	*3) Plotting Figure 5
	
	*(a) Host cities
	#delimit ;		
	twoway (rarea eventylow eventyhigh eventx, 
					lwidth(0) fcolor(gs15)
			)
			(rarea min95 max95 days if hostcity==1,
					lwidth(0) fcolor(gs11)
			)
		    (line estimate days if hostcity==1,	
					 lcolor(black) lwidth(*2)
			)
					,					
					ysize(1)
					xsize(1.1) 
					yscale(range(0 .5) noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(, 
							nogrid labsize(*1) angle(0)
					)
					xlabel(0.5 "March 1" 31.5 "April 1" 61.5 "May 1" 92.5 "June 1" 117.5 "June 25",
							labsize(*1)
					)
					ytitle("Predicted number of daily repression events", size(*1))
					xtitle(" ")
					legend(off)
					text(.5 105.4 "World Cup", place(s) size(*1))
					yline(0, lpattern(dot) lcolor(black) noextend)
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr		
	graph export "$path\figure_5a.pdf", as(pdf) replace		
		
		
	*(b) Other cities	
	#delimit ;		
	twoway (rarea eventylow_nohc eventyhigh_nohc eventx, 
					lwidth(0) fcolor(gs15)
			)
			(rarea min95 max95 days if hostcity==0,
					lwidth(0) fcolor(gs11)
			)
		    (line estimate days if hostcity==0,	
					 lpattern(shortdash) lcolor(black) lwidth(*2)
			)
					,		
					ysize(1)
					xsize(1.1) 
					yscale(range() noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(0(.01).05, 
							nogrid labsize(*1) angle(0)
					)
					xlabel(0.5 "March 1" 31.5 "April 1" 61.5 "May 1" 92.5 "June 1" 117.5 "June 25",
							labsize(*1)
					)
					ytitle("Predicted number of daily repression events", color(black) size(*1))
					xtitle(" ")
					text(.05 105.4 "World Cup", place(s) size(*1))						
					legend(off)
					yline(0, lpattern(dot) lcolor(black) noextend)					
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr		
	graph export "$path\figure_5b.pdf", as(pdf) replace		
	
	*Restoring data
	restore	
			
		
	
	****************************************************************************
	*Figure 6: Substantive effects for matched sample
	****************************************************************************

	*1) Calculating substantive effects	
	
	*Estimating Model 6, Table SI.4.6
	#delimit ;
	nbreg repression 
		  i.hostcity#c.time 
		  i.hostcity#c.time#c.time 
		  i.hostcity 
		  c.time 
		  c.time#c.time 
		  c.lnpop_1970 
		  c.vote_frejuli 
		  c.literacy_avg 
		  c.lnrebact1974 
		  c.lnrepression70_77 
		  i.zone2 i.zone3 i.zone4 i.zone5
		  if matched_allhosts==1
		  , 
		  robust 		
	;
	#delimit cr
	
	*Calculating effects and exporting effects data	
	#delimit ;	
	margins, at((asobserved) _all time = (0.01(0.01)1.17)) over(hostcity) 			 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI46_model6_effects.dta", replace) format(estimate min95 max95);			 
	#delimit cr
		

	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading effects data
	use "$path\tableSI46_model6_effects.dta", clear		
	
	*Identifying host and non-host cities
	gen hostcity="hc_" if regexm(parm, "1.hostcity$")
	replace hostcity="nohc_" if regexm(parm, "0.hostcity$") & hostcity==""
	
	*Identifying time values
	gen time=regexs(0) if regexm(parm,"^[0-9]+")
	destring time, replace
	
	*Dropping unused variables
	drop parm z p
	
	*Reshaping data
	reshape wide @estimate @stderr @min95 @max95, i(time) j(hostcity) string 
	
	*Generating day variable
	gen days=_n-1
	
	*Generating STATA date variables
	gen date=td(1mar1978) in 1
	replace date=date[_n-1]+1 if date==.
	format date %td
	
	*Generating event window
	gen eventx=days if date>=td(01jun1978)
	gen eventylow=0 if eventx!=.
	gen eventyhigh=0.51 if eventx!=.	
	
	
	*3) Plotting Figure 6
	
	#delimit ;		
	twoway (rarea eventylow eventyhigh eventx, 
					lwidth(0) fcolor(gs15)
			)
		    (rarea nohc_min95 nohc_max95 days,
					lwidth(0) fcolor(gs11%60)
			)
		    (rarea hc_min95 hc_max95 days,
					lwidth(0) fcolor(gs11%60)
			)
		    (line nohc_estimate days,
					lwidth(*1.3)
					lcolor(black)
					lpattern(shortdash)
			 )
		    (line hc_estimate days,	
					 lcolor(black) lwidth(*2)
			)
					,
					ysize(1)
					xsize(1.1) 
					yscale(range(0 .26) noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(, 
							nogrid labsize(small) angle(0)
					)
					xlabel(-0.5 "March 1" 30.5 "April 1" 60.5 "May 1" 91.5 "June 1" 116.5 "June 25",
							labsize(small)
					)
					ytitle("Predicted number of daily repression events")
					xtitle("Date")
					legend(
						order(5 "Host cities" 4 "Matched non-host cities") 
						size(*1) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
						 bmargin(0 0 0 2)
					)
					text(.5 104.25 "World Cup", place(s) size(*1))
					yline(0, lpattern(dot) lcolor(black) noextend)					
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr		
	graph export "$path\figure_6.pdf", as(pdf) replace	
		
	*Restoring data
	restore	
	
	
	
	****************************************************************************
	*Figure 7: Types of repression before and during the 1978 World Cup
	****************************************************************************	
	
	*1) Calculating substantive effects	
	
	*Preserving data
	preserve
	
	*Loading data
	use "$path\figure_7_data.dta"	
	
	*Estimating Model 1, Table SI.5.1	
	#delimit ;
	nbreg disappear 
		  i.timedum2 
		  i.timedum3 
		  i.timedum4
		  , 
		  robust			
	;
	#delimit cr		
	
	*Calculating effects and exporting effects data	
	#delimit ;				
	margins, 
			 at(timedum2=0 timedum3=0 timedum4=0) 
			 at(timedum2=1 timedum3=0 timedum4=0) 
			 at(timedum2=0 timedum3=1 timedum4=0) 
			 at(timedum2=0 timedum3=0 timedum4=1) 			 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI51_model1_effects.dta", replace) 
			 format(estimate min95 max95)
			 rename(estimate disappear_estimate min95 disappear_min95 max95 disappear_max95) 
			 ;	
	#delimit cr		

	*Estimating Model 3, Table SI.5.1		
	#delimit ;
	nbreg kill 
		  i.timedum2 
		  i.timedum3 
		  i.timedum4
		  , 
		  robust			
	;
	#delimit cr	
	
	*Calculating effects and exporting effects data	
	#delimit ;				
	margins, 
			 at(timedum2=0 timedum3=0 timedum4=0) 
			 at(timedum2=1 timedum3=0 timedum4=0) 
			 at(timedum2=0 timedum3=1 timedum4=0) 
			 at(timedum2=0 timedum3=0 timedum4=1) 			 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI51_model3_effects.dta", replace) 
			 format(estimate min95 max95)
			 rename(estimate kill_estimate min95 kill_min95 max95 kill_max95) 
			 ;	
	#delimit cr	
	
	*Restoring data
	restore
	
	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading effects data for disappearances
	use "$path\tableSI51_model1_effects.dta", clear	
	
	*Dropping unused variables
	drop stderr z p
	
	*Merging data with data for killings
	merge 1:1 parm using "$path\tableSI51_model3_effects.dta"		

	*Dropping unused variables
	drop stderr z p	
	
	*Identifying time values
	gen xaxis=regexs(0) if regexm(parm,"^[0-9]+")
	destring xaxis, replace	
	
	
	*3) Plotting Figure 7
	
	#delimit ;		
	twoway (rspike disappear_min95 disappear_max95 xaxis,
			lcolor(black) 
			)
			(rspike kill_min95 kill_max95 xaxis,
			lcolor(gs11)
			)
			(connected disappear_estimate xaxis,
			mcolor(black) lcolor(black) lpattern(shortdash)
			)	
			(connected kill_estimate xaxis,
			mcolor(gs11) lcolor(gs11) lpattern(shortdash)
			)			
					,
					ysize(1)
					xsize(1.1) 
					yscale(range(0 5) noextend titlegap(*+5))
					xscale(range(.75 4.25) noextend titlegap(*+10)) 
					ylabel(, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(1 "March" 2 "April" 3 "May" 4 `" "June" "(World Cup)" "',
							labsize(*.9)
					)
					ytitle("Predicted number of daily repression events")
					xtitle("")
					legend(
						cols(1)
						order(3 "Disappearances" 4 "Killings") 
						size(*1) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
					 bmargin(0 0 0 0)
					)							
					graphregion(color(white) lcolor(white) lalign(outside) margin(5 7 1 2))				
					; 
	#delimit cr
	graph export "$path\figure_7.pdf", as(pdf) replace	
	
	*Restoring data
	restore			
		
	
	
	****************************************************************************
	*Figure 10: Changes in repression before, during, and after the World Cup
	****************************************************************************	
	
	*1) Calculating substantive effects	
	
	*Estimating Model 3, Table SI.6.1
	#delimit ;
	reg lnrepression 
		  i.biweek2#i.hostcity 
		  i.biweek3#i.hostcity 
		  i.biweek4#i.hostcity 
		  i.biweek5#i.hostcity 
		  i.biweek6#i.hostcity 
		  i.biweek7#i.hostcity 
		  i.biweek8#i.hostcity 
		  i.biweek9#i.hostcity 
		  i.biweek10#i.hostcity 
		  i.biweek11#i.hostcity 
		  i.biweek12#i.hostcity 
		  i.biweek13#i.hostcity 
		  i.biweek14#i.hostcity	
		  i.biweek15#i.hostcity	
		  i.hostcity
		  i.biweek2 
		  i.biweek3 
		  i.biweek4 
		  i.biweek5 
		  i.biweek6 
		  i.biweek7 
		  i.biweek8 
		  i.biweek9 
		  i.biweek10 
		  i.biweek11 
		  i.biweek12 
		  i.biweek13 
		  i.biweek14
		  i.biweek15		  
		  c.lnpop_1970 
		  c.vote_frejuli 
		  c.literacy_avg 
		  c.lnrebact1974 
		  c.lnrepression70_77 
		  i.zone2 i.zone3 i.zone4 i.zone5
		  , 
		  robust		
	;
	#delimit cr				
			
	*Calculating effects and exporting effects data	
	#delimit ;				
	margins, 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 
			 at((asobserved) _all biweek2=1 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0)  		 
			 at((asobserved) _all biweek2=0 biweek3=1 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0)
 			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=1 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=1 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=1 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=1 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=1 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=1 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=1 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=1 biweek12=0 biweek13=0 biweek14=0 biweek15=0) 			 
			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=1 biweek13=0 biweek14=0 biweek15=0)
 			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=1 biweek14=0 biweek15=0)
 			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=1 biweek15=0) 			 
 			 at((asobserved) _all biweek2=0 biweek3=0 biweek4=0 biweek5=0 biweek6=0 biweek7=0 biweek8=0 biweek9=0 biweek10=0 biweek11=0 biweek12=0 biweek13=0 biweek14=0 biweek15=1) 
			 over(hostcity)		 
 			 expression((exp(predict(xb)))-1)	
			 level(95) 
			 post;
	parmest, saving("$path\tableSI61_model3_effects.dta", replace) 
			 format(estimate min95 max95)
			 ;	
	#delimit cr		
	
	
	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading effects data
	use "$path\tableSI61_model3_effects.dta", clear		
			
	*Extracting biweekly information		
	gen week=regexs(0) if regexm(parm, "^[0-9]+")		
	destring week, replace		
	
	*Identifying host cities
	gen hostcity=regexs(3) if regexm(parm, "(^[0-9]+)(._at#)([0-9])")
	replace hostcity="_"+hostcity
	
	*Keeping relevant variables
	keep estimate min* max* week hostcity
	
	*Reshaping data for plotting
	reshape wide estimate min95 max95, i(week) j(hostcity) string	
	
	
	*3) Plotting Figure 10
	
	#delimit ;		
	twoway (rspike min95_0 max95_0 week,
			lcolor(gs11)
			)	
			(connected estimate_0 week,
			mcolor(gs11) lcolor(gs11) lpattern(shortdash)
			)
			(rspike min95_1 max95_1 week,
			lcolor(black) 
			)			
			(connected estimate_1 week,
			mcolor(black) lcolor(black) lpattern(shortdash)
			)			
					,
					ysize(1)
					xsize(1.4) 
					yscale(range( ) noextend titlegap(*+5))
					xscale(range(.5 15.5) noextend titlegap(*+6)) 
					ylabel(, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(1 "-14" 2 "-12" 3 "-10" 4 "-8" 5 "-6" 6 "-4" 7 "-2" 8 "0" 9 "+2" 10 "+4" 11 "+6" 12 "+8" 13 "+10" 14 "+12" 15 "+14",
							labsize(*.9)
					)
					ytitle("Predicted number of daily repression events")
					xtitle("Week")
					legend(
						cols(1)
						order(4 "Host cities" 2 "Other cities") 
						size(*1) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
					position(2) ring(0) bmargin(0 3 0 0)
					region(lcolor(white))
					)							
					graphregion(color(white) lcolor(white) lalign(outside))				
					; 
	#delimit cr		
	graph export "$path\figure_10.pdf", as(pdf) replace		
	
	*Restoring data
	restore	
	
	
	
	****************************************************************************
	*Figure SI.4.1: Substantive effects using clustered standard errors
	****************************************************************************		
	
	*1) Calculating substantive effects
	
	*Estimating Model 3, Table SI.4.2.
	#delimit ;
	nbreg repression 
		  i.hostcity#c.time 
		  i.hostcity#c.time#c.time 
		  i.hostcity 
		  c.time 
		  c.time#c.time 
		  c.lnpop_1970 
		  c.vote_frejuli 
		  c.literacy_avg 
		  c.lnrebact1974 
		  c.lnrepression70_77 
		  i.zone2 i.zone3 i.zone4 i.zone5
		  , 
		  cluster(id) 		
	;
	#delimit cr 
 
	*Calculating effects and exporting effects data
	#delimit ;	
	margins, at((asobserved) _all time = (0.01(0.01)1.17)) over(hostcity) 			 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI42_model3_effects.dta", replace) format(estimate min95 max95);
	#delimit cr	
	
	
	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading data
	use "$path\table1_model3_effects.dta", clear	
				
	*Identifying host and non-host cities
	gen hostcity=1 if regexm(parm, "1.hostcity$")
	replace hostcity=0 if regexm(parm, "0.hostcity$") & hostcity==.	
	
	*Generating day variable
	egen days= seq(), from(1) to() block(2)	
	
	*Generating STATA date variable
	gen date=td(28feb1978)+days
	format date %td
		
	*Generating event window
	gen eventx=days if date>=td(01jun1978)
	gen eventylow=0 if eventx!=. & hostcity==1
	gen eventyhigh=.51 if eventx!=.	& hostcity==1	
	
	gen eventylow_nohc=0 if eventx!=. & hostcity==0
	gen eventyhigh_nohc=.051 if eventx!=. & hostcity==0		
	
	*Keeping relevant variables from Model 3
	keep parm event* estimate *95 days hostcity
		
	*Renaming variables from Model 3
	foreach var of varlist estimate min95 max95 {
		rename `var' mod3_`var'
	}	
			
	*Adding results from Model 3, Table SI.4.2
	merge 1:1 parm using "$path\tableSI42_model3_effects.dta"
	
	*Renaming variables
	foreach var of varlist estimate min95 max95 {
		rename `var' mod4_`var'
	}
	
	*Dropping unused variables
	keep hostcity days event* mod3_* mod4_*
	
	*Sorting data
	sort hostcity days
	
	
	*3) Plotting Figure SI.4.1
	
	*(a) Host cities
	#delimit ;		
	twoway (rarea eventylow eventyhigh eventx, 
					lwidth(0) fcolor(gs15)
			)
			(rspike mod4_min95 mod4_max95 days if hostcity==1, //Model 4
					lwidth(*.6) lcolor(black) 
			)				
			(rarea mod3_min95 mod3_max95 days if hostcity==1, //Model 3
					lwidth(0) fcolor(gs8%70)
			)	    
			(line mod3_estimate days if hostcity==1,	
					 lcolor(black) lwidth(*2)
			)			
					,				
					ysize(1)
					xsize(1.1) 
					yscale(range(0 .5) noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(0(.1).5, 
							nogrid labsize(*1) angle(0)
					)
					xlabel(0.5 "March 1" 31.5 "April 1" 61.5 "May 1" 92.5 "June 1" 117.5 "June 25",
							labsize(*1)
					)
					ytitle("Predicted number of daily repression events", size(*1))
					xtitle(" ")
					legend(off)
					text(.5 105.4 "World Cup", place(s) size(*1))
					yline(0, lpattern(dot) lcolor(black) noextend)
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr			
	graph export "$path\figure_SI41a.pdf", as(pdf) replace		
		
		
	*(b) Other cities
	#delimit ;		
	twoway (rarea eventylow_nohc eventyhigh_nohc eventx, 
					lwidth(0) fcolor(gs15)
			)
			(rspike mod4_min95 mod4_max95 days if hostcity==0,
					lwidth(*.6) lcolor(black) 
			)
			(rarea mod3_min95 mod3_max95 days if hostcity==0,
					lwidth(0) fcolor(gs8%70)
			)
		    (line mod3_estimate days if hostcity==0,	
					 lpattern(shortdash) lcolor(black) lwidth(*2)
			)
					,				
					ysize(1)
					xsize(1.1) 
					yscale(range(0 .05) noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(0(.01).05, 
							nogrid labsize(*1) angle(0)
					)
					xlabel(0.5 "March 1" 31.5 "April 1" 61.5 "May 1" 92.5 "June 1" 117.5 "June 25",
							labsize(*1)
					)
					ytitle("Predicted number of daily repression events", color(black) size(*1))
					xtitle(" ")
					text(.05 105.4 "World Cup", place(s) size(*1))						
					legend(off)
					yline(0, lpattern(dot) lcolor(black) noextend)					
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr		
	graph export "$path\figure_SI41b.pdf", as(pdf) replace		
		
	*Restoring data
	restore
	
	
	
	****************************************************************************
	*Figure SI.4.2: Substantive effects using cubic polynomials in negative binomial regression
	****************************************************************************			

	*1) Calculating substantive effects	
	
	*Estimating Model 3, Table SI.4.4
	#delimit ;
	nbreg repression 
		  i.hostcity#c.time 
		  i.hostcity#c.time#c.time 
		  i.hostcity#c.time#c.time#c.time 
		  i.hostcity 
		  c.time 
		  c.time#c.time 
		  c.time#c.time#c.time   
		  c.lnpop_1970 
		  c.vote_frejuli 
		  c.literacy_avg 
		  c.lnrebact1974 
		  c.lnrepression70_77 
		  i.zone2 i.zone3 i.zone4 i.zone5
		  , 
		  robust 		
	;
	#delimit cr		
	
	*Calculating effects and exporting effects data
	#delimit ;	
	margins, at((asobserved) _all time = (0.01(0.01)1.17)) over(hostcity) 			 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI44_model3_effects.dta", replace) format(estimate min95 max95);
	#delimit cr	
	

	*2) Preparing data for plotting	
	
	*Preserving data
	preserve
	
	*Loading effects data
	use "$path\tableSI44_model3_effects.dta", clear	
	
	*Identifying host and non-host cities
	gen hostcity="hc_" if regexm(parm, "1.hostcity$")
	replace hostcity="nohc_" if regexm(parm, "0.hostcity$") & hostcity==""
	
	*Identifying time values
	gen time=regexs(0) if regexm(parm,"^[0-9]+")
	destring time, replace
	
	*Dropping unused variables
	drop parm z p
	
	*Reshaping data
	reshape wide @estimate @stderr @min95 @max95, i(time) j(hostcity) string 
	
	*Generating day variable
	gen days=_n-1
	
	*Generating STATA date variables
	gen date=td(1mar1978) in 1
	replace date=date[_n-1]+1 if date==.
	format date %td
	
	*Generating event window
	gen eventx=days if date>=td(01jun1978)
	gen eventylow=0 if eventx!=.
	gen eventyhigh=.6 if eventx!=.	
		
	
	*3) Plotting Figure SI.4.2
	
	#delimit ;		
	twoway (rarea eventylow eventyhigh eventx, 
					lwidth(0) fcolor(gs15)
			)
		    (rarea hc_min95 hc_max95 days,
					lwidth(0) fcolor(gs11)
			)
		    (line hc_estimate days,	
					 lcolor(black) lwidth(*2)
			)
		    (rarea nohc_min95 nohc_max95 days,
					lwidth(0) fcolor(gs11)
			)
		    (line nohc_estimate days,
					lwidth(*1.3)
					lcolor(black)
					lpattern(shortdash)
			 )
					,
					ysize(1)
					xsize(1.1) 
					yscale(range(0 .6) noextend titlegap(*+5))
					xscale(range(0 120) noextend titlegap(*+10)) 
					ylabel(0(.1).6, 
							nogrid labsize(small) angle(0)
					)
					xlabel(-0.5 "March 1" 30.5 "April 1" 60.5 "May 1" 91.5 "June 1" 116.5 "June 25",
							labsize(small)
					)
					ytitle("Predicted number of daily repression events")
					xtitle("Date")
					legend(
						order(3 "Host cities" 5 "Non-host cities") 
						size(*1) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
						 bmargin(0 0 0 2)
					)
					text(.595 104 "World Cup", place(s) size(*.85))
					yline(0, lpattern(dot) lcolor(black) noextend)						
					graphregion(color(white) lcolor(white) lalign(outside))
					; 
	#delimit cr		
	graph export "$path\figure_SI42.pdf", as(pdf) replace

	*Restoring data
	restore	
	
	
	
	****************************************************************************
	*Figure SI.5.1: Repression as a function of proximity to journalist hotels and time to World Cup (negative binomial regression)
	****************************************************************************				

	*1) Calculating substantive effects		
	
	*Estimating Model 1, Table SI.5.2
	#delimit ;
	nbreg repression 
		  c.prox_hotelonly#c.time
		  c.prox_hotelonly#c.time#c.time
		  c.prox_hotelonly#c.time#c.time#c.time		  
		  c.prox_hotelonly 
		  c.time
		  c.time#c.time
		  c.time#c.time#c.time		  
		  , 
		  robust		
	;
	#delimit cr		
	
	*Increasing matsize
	set matsize 10000
	
	*Calculating effects and exporting effects data
	#delimit ;	
	margins, at((asobserved) _all prox_hotelonly = (0(.376)9.4) time = (0.01(0.04)1.17))					 
			 level(95) 
			 post;
	parmest, saving("$path\tableSI52_model1_effects.dta", replace) format(estimate min95 max95);
	#delimit cr
	
	
	*2) Preparing data for plotting		
	
	*Preserving data
	preserve	
	
	*Loading data
	use "$path\tableSI52_model1_effects.dta", clear		
	
	*Identifying individual observations
	gen obs=regexs(0) if regexm(parm,"^[0-9]+")	
	destring obs, replace
	
	*Generating time value (determines length of each proxy panel)
	egen prox=seq(), block(30)
	bys prox (obs): gen timevalue=0.01 if _n==1
	bys prox (obs): replace timevalue=timevalue[_n-1]+0.04 if timevalue==.	
	
	*Generating proximity values
	gen proxvalue=(prox-1)*0.376
	
	*Keeping relevant variables
	keep estimate timevalue proxvalue
	
	*Labeling vars
	label var estimate "Predicted count"
	label var timevalue "Time (01 = March 1,..., 1.17 = June 25)"
	label var proxvalue "Proximity to hotel (0 = Far away,..., 9.4 = Close)"
	
	
	*3) Plotting Figure SI.5.1
	
	#delimit ;		
	twoway (contour estimate proxvalue timevalue, levels(20) minmax)		
					,
					ysize(1)
					xsize(1.5) 
					yscale(range(0 9.4) noextend titlegap(*+5))
					xscale(range(0.01 1.17) noextend titlegap(*+10)) 
					zlabel(#5, labsize(*.9)  format(%9.3f))
					ylabel(0 "Min" 9.4 "Max", 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(0.01 "March 1" 0.32 "April 1" 0.62 "May 1" 0.93 "June 1" 1.17 "June 25",
							labsize(*.9)
					)
					ytitle("Proximity to journalist hotel")
					xtitle("Time")						
					graphregion(color(white) lcolor(white) lalign(outside) margin(5 7 1 2))				
					scheme(s2mono)
					; 
	#delimit cr
	graph export "$path\figure_SI51.pdf", as(pdf) replace		
	
	*Restoring data
	restore	
		
	
	
	
********************************************************************************
*
* Descriptive analysis
*
********************************************************************************	
	

	****************************************************************************
	*Figure 1: Autocratic hosts of international sports events, 1990-2024
	****************************************************************************
	
	*Preserving data
	preserve	
	
	*Loading data
	use "$path\figure_1_data.dta", clear
		
	*Plotting Figure 1
	#delimit ;
	twoway (connected autochostperc postcwy,
			lcolor(black)
			mlcolor(black)
			mfcolor(black)
			),
		ysize(1)
		xsize(1.2)
		yscale(range(0 7) noextend titlegap(+2))
		ylabel(0(10)50, angle(horizontal) nogrid) 
		xscale(range(.5 7.5) noextend titlegap(+3))		
		xlabel(1 `" "1990-" "1994 " "' 2 `" "1995-" "1999 " "' 3 `" "2000-" "2004 " "' 4 `" "2005-" "2009 " "'
			   5 `" "2010-" "2014 " "' 6 `" "2015-" "2019 " "' 7 `" "2020-" "2024 " "', noticks labgap(+3))		
		xticks(1(1)7,tlength(*1))		
		ytitle("Autocratic host regimes (in %)", size(*1.2))
		xtitle("Years", size(*1.2))
		legend(off)
		plotregion(lcolor(white)) 
		graphregion(color(white) lcolor(white) lalign(outside))			
	;
	#delimit cr
	graph export "$path\figure_1.pdf", as(pdf) replace	

	*Restoring data
	restore
	
	
	****************************************************************************
	*Figure 3: Accredited international journalists by country
	****************************************************************************	
	
	*Preserving data
	preserve	
	
	*Loading data
	use "$path\figure_3_data.dta", clear
			
	*Plotting Figure 3	
	#delimit ;
	twoway (dropline journalists rank if democracy==1 | democracy==.,
			horizontal
			mcolor(black)
			lcolor(black)
			)
			(dropline journalists rank if democracy==0,
						horizontal
						mcolor(black)
						mfcolor(white)
						lcolor(black)
			)			
		,
		ysize(1.5)
		xsize(1.25)		
		yscale(range(.5 24) noextend titlegap(+2) reverse)			
		xscale(range() noextend titlegap(+3))				
		ylabel(1(1)24, valuelabel angle(horizontal) nogrid)			
		xtick(0(100)500, tlength(*.5))
		ytitle("")
		xtitle("Number of journalists", size(*1))
		legend(order( 
								2 "Autocracy"
								1 "Democracy"
								)					
							col(1)
							size(*.85) 			
							keygap(*1) 
							symxsize(*0.35) 
							symysize(*0.5) 
							region(lcolor(white))
							position(4) ring(0) bmargin(2 0 10 10)
							)
		plotregion(lcolor(white)) 
		graphregion(color(white) lcolor(white) lalign(outside))	
	;
	#delimit cr	
	graph export "$path\figure_3.pdf", as(pdf) replace
		
	*Preserving data
	restore		
		
		
	****************************************************************************
	*Figure 4: Repression before and during the 1978 FIFA World Cup
	****************************************************************************			
	
	*Preserving data
	preserve
	
	*Collapsing data by host city in analysis window
	collapse (sum) sum_rep=repression (mean) mean_rep=repression (first) date, by(hostcity prewc_time3m)
	
	*Dropping obs outside of window
	drop if prewc_time3m==.	
	sort hostcity date
	
	*Generating 5-day moving average variable
	rangestat (mean) sum_rep, by(hostcity) interval(prewc_time3m -2 2)
	
	*Generating shading for World Cup phase
	sum sum_rep mean_rep
	gen wc_sumrep_low=0 if date>=td(01jun1978)
	gen wc_sumrep_high=7.2 if date>=td(01jun1978) 
	
	gen wc_sumrep_low_smooth=0 if date>=td(01jun1978)
	gen wc_sumrep_high_smooth=3.2 if date>=td(01jun1978) 	
	
	
	*Plotting Figure 4	
	#delimit ;	
	twoway (rarea wc_sumrep_low wc_sumrep_high prewc_time3m if prewc_time3m<=117 & hostcity==1, lwidth(none) fcolor(gs15))	
		   (spike sum_rep prewc_time3m if prewc_time3m<=117 & hostcity==1, lpattern(solid) lcolor(gs12) lwidth(*1))
		   (line sum_rep_mean prewc_time3m if prewc_time3m<=117 & hostcity==1, lpattern(solid) lcolor(black) lwidth(*1.3))		   
		   ,
			ysize(1)
			xsize(1.1)			
			yscale(range() noextend titlegap(*+5))
			xscale(range(0 117.5) noextend titlegap(*+7))
			ylabel(0(1)7, angle(horizontal) nogrid)
			xlabel(15.5 "March" 46.5 "April" 76.5 "May" 105.5 "June" 117.5 " ", noticks labgap(+1.5))
			xtick(0.5 31.5 61.5 92.5)
			ytitle("Number of repression events")
			xtitle("")
			yline(0, lcolor(black) lpattern(dot))
			graphregion(color(white) lcolor(white) lalign(outside)) 
		    text(7 105.4 "World Cup", placement(c))				
			legend(off)
		   ;
	#delimit cr		
	graph export "$path\figure_4.pdf", as(pdf) replace	

	*Restoring data
	restore	
		
		
	
	****************************************************************************
	*Figure 9: Daytime patterns of repression before, during, and after the World Cup
	****************************************************************************	
	
	*Preserving data
	preserve	
	
	*Loading data
	use "$path\figure_9_data.dta", clear	
	
	*Generating variable indicating whether repression occurred before, during, after World Cup
	gen period=1 if days<0 & days>=-90
	replace period=2 if days==0
	replace period=3 if days>0 & days<=90
		
	*Aggregating victims by part of day (1=[23:00-11:59], 2=[12:00-22:59])
	bysort period (date): egen n_reptimeobs_c=count(daytime) 		
	
	*Calculating share of victims targeted in each part of day
	foreach l of numlist 1 2 {
	gen reptd_`l'_c=1 if daytime==`l'  
	bysort period (date): egen n_reptd_`l'_c=total(reptd_`l'_c) 	
	bysort period (date): generate s_reptd_`l'_c=(n_reptd_`l'_c/n_reptimeobs_c)*100		
	}	
	
	*Collapsing data for plotting
	collapse (firstnm) s_reptd_*, by(period)
	drop if period==.		

	*Plotting Figure 9	
	#delimit ;
	twoway (connected s_reptd_1_c period, lpattern(shortdash) lcolor(black) mlcolor(black) mfcolor(white) msize(*1.1))
		   (connected s_reptd_2_c period, lpattern(solid) lcolor(black) mcolor(black) msize(*1.1))
					, 
					 ysize(1)
					 xsize(1.1)
					 yscale(range() noextend titlegap(*+5))
					 xscale(range() noextend titlegap(*+7))					 
					 ylabel(30(10)70, angle(horizontal) nogrid)
					 xlabel(1 "Before" 2 "During" 3 "After")
					 ytitle("Share of repression events (in %)")
					 xtitle("World Cup")
					 legend(
						cols(1) 
						order( 2 "Core broadcasting hours (12:00 - 22:59)" 1 "Rest of the day (23:00 - 11:59)") // 1=[23:00-11:59], 2=[12:00-22:59]	
						size(*1) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
						 bmargin(0 0 0 2)						
					 )
					graphregion(color(white) lcolor(white) lalign(outside)) 					 
					 ;
	#delimit cr		 
	graph export "$path\figure_9.pdf", as(pdf) replace			
		
	*Restoring data
	restore	
			
	
	
	****************************************************************************
	*Figure 11: Changes in repression around international sports events, 1945-2020
	****************************************************************************	
	
	*Preserving data
	preserve		
	
	*Loading data
	use "$path\figure_11_SI71_data.dta", clear
	
	*Gernerating manually demeaned repression scores
	bys winid_event_all (year): egen winmean_event_all = mean(hr_mean) if winid_event_all!=. 
	bys winid_event_all (year): gen repdemean_event_all = hr_mean - winmean_event_all if winid_event_all!=.	
	bys fullwin_event_all (year): egen mean_repdemean_event_all = mean(repdemean_event_all) if fullwin_event_all!=.		
	
	*Plotting Figure 9	
	#delimit ;		
	twoway 	(connected mean_repdemean_event_all fullwin_event_all if fullwin_event_all!=.
					,
					msize(*1.2)
					mcolor(black) lcolor(black) mlwidth(0)
			)			
					,
					ysize(1)
					xsize(1.1) 
					yscale(range(-.02 .06) noextend titlegap(*+5))
					xscale(range(-4.25 4.25) noextend titlegap(*+10)) 
					ylabel(-.02(.02).06, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(-4(1)0 1 "+1" 2 "+2" 3 "+3" 4 "+4",
							labsize(*.9)
					)
					xticks(,tlength(*1))
					xline(0, lcolor(gs15) lwidth(*20))
					ytitle("Mean repression" "(window standardized)", size(*1.2))
					xtitle("Year", size(*1.2))
					legend(off)							
					graphregion(color(white) lcolor(white) lalign(outside))				
					; 
	#delimit cr			
	graph export "$path\figure_11.pdf", as(pdf) replace

	*Restoring data
	restore		
	
	

	****************************************************************************
	*Figure SI.4.3: Protest occurrence, March 1976 - March 1981
	****************************************************************************				
	
	*Preserving data
	preserve		
	
	*Loading data
	use "$path\figure_SI43_data.dta", clear
	
	*Calculating difference in strikes between host and other cities
	gen strike_diff=strike_hc-strike_nonhc	
	
	*Inverting strike counts in non-host cities for plotting
	gen strike_nonhc_inv=strike_nonhc*(-1)	
	
	
	*Plotting Figure SI.4.3.	
	
	*a) Occurrence of protest events
	#delimit ;	
	twoway (bar strike_hc month, color(gray) lwidth(0) barwidth(0.9))
		   (bar strike_nonhc_inv month, color(black) lwidth(0) barwidth(0.9))		   
		   ,
			ysize(1)
			xsize(1.25)			
			yscale(range(-15  15) noextend titlegap(*+5))
			xscale(range(-.5 61) noextend titlegap(*+7))
			ylabel(-15 "15" -10 "10" -5 "5" 0(5)15, angle(horizontal) nogrid)
			xlabel(5 "1976" 16 "1977" 28 "1978" 40 "1979" 52 "1980" 61.5 " ", labgap(+1.5) noticks)
			xticks(-.5 10.5 22.5 34.5 46.5 58.5)
			ytitle("Number of strikes")
			xtitle("Time")
			xline(28, lcolor(gray) lpattern(shortdash) lwidth(*1))
			yline(0, lcolor(black) lwidth(0.2))
			graphregion(color(white) lcolor(white) lalign(outside)) 
			legend(order(1 "Host cities" 2 "Other cities")	
						cols(1)
						size(*1) keygap(*0.75) symxsize(*0.1) symysize(*1)
						bmargin(1 0 0 5)
						position(3))
		   ;
	#delimit cr			
	graph export "$path\figure_SI43a.pdf", replace as(pdf)	
	

	*b) Difference in protest events
	#delimit ;	
	twoway (dropline strike_diff month, msize(*.8) color(gs12) lwidth(*.7) ) //lwidth(0) barwidth(0.9)
		   (lpoly strike_diff month, kernel(gaussian) bwidth(2) lpattern(solid) lcolor(black) lwidth(*1.2) )
		   ,
			ysize(1)
			xsize(1.25)			
			yscale(range(-10  10) noextend titlegap(*+5))
			xscale(range(-.5 61) noextend titlegap(*+7))
			ylabel(-10(5)10, angle(horizontal) nogrid)
			xlabel(5 "1976" 16 "1977" 28 "1978" 40 "1979" 52 "1980" 61.5 " ", labgap(+1.5) noticks)
			xticks(-.5 10.5 22.5 34.5 46.5 58.5)
			ytitle("Strikes{subscript:Host cities} {bf:-} Strikes{subscript:Other cities}")
			xtitle("Time")
			xline(28, lcolor(gray) lpattern(shortdash) lwidth(*1))
			yline(0, lcolor(gs12) lwidth(0.2))
			graphregion(color(white) lcolor(white) lalign(outside)) 
			legend(order(1 "Raw" "difference" 2 "Smoothed" "difference")
						cols(1)
						size(*1) keygap(*0.75) symxsize(*0.5) symysize(*0.5)
						bmargin(1 0 0 5)
						position(3))
		   ;
	#delimit cr	
	graph export "$path\figure_SI43b.pdf", replace as(pdf)	
	
	*Restoring data
	restore		
	
	
	
	****************************************************************************
	*Figure SI.1.1: Host regimes of international sports event, 1945-2024
	****************************************************************************		
	
	*Preserving data
	preserve	
	
	*Loading data
	use "$path\figure_SI11_data.dta", clear
	
	*Plotting Figure SI.1.1
	#delimit ;
	twoway (rspike democ baseline year,
			lwidth(*2.5)
			lcolor(gs10)
			)
		   (rspike autoc baseline year,
			lwidth(*2.5)
			lcolor(black)
			)
		,
		ysize(1)
		xsize(1.4)
		yscale(range(2.5 27.5) noextend)
		xscale(range(1946 2022) noextend titlegap(+3))						
		ylabel( 
				2.5 "Rugby World Cup"
				5 "Winter Olympic Games"
				7.5 "Summer Olympic Games"
				10 "World Athletics Championships"
				12.5 "Ice Hockey World Championships"
				15 "FIFA World Cup"
				17.5 "Cricket World Cup"
				20 "World Handball Championship"
				22.5 "World Table Tennis Championships"
				25 "Basketball World Cup"
				27.5 "Volleyball World Championship"
				, angle(horizontal) valuelabel glcolor(gs10) glwidth(*.1) labsize(*.9)) 
		xlabel(1950(10)2020, labsize(*.9))	
		xtitle("")
		legend(off)
		plotregion(lcolor(white)) 
		graphregion(color(white) lcolor(white) lalign(outside))			
	;
	#delimit cr	
	graph export "$path\figure_SI11.pdf", as(pdf) replace	
	
	*Restoring data
	restore		
	
	

	****************************************************************************
	*Figure SI.5.2: Match schedule and journalist working hours during the 1978 FIFA World Cup
	****************************************************************************				

	*Preserving data
	preserve	
	
	*Loading data
	use "$path\figure_SI52_data", clear
	
	*Generating y-axis
	gen yaxis=day
	replace yaxis=0.5 if day==1
	replace yaxis=25.5 if day==25	
	
	*Generating shaded area	
	gen broadcaststart=12
	gen broadcastend=22.95		
	
	*Plotting Figure SI.5.2
	#delimit ;
	twoway  (rarea broadcastend broadcaststart yaxis, horizontal lwidth(none) fcolor(gs14)) 
			(pci -4 12 29.5 12, lpattern(shortdash) lcolor(black))
			(pci -4 23 29.5 23, lpattern(shortdash) lcolor(black))		    
			(rbar time_start_plot time_end_plot day, horizontal barwidth(.75) fcolor(black) lwidth(none))
			, 
					 ysize(1)
					 xsize(1.65)
					 yscale(range(-4 29.5) extend titlegap(*-15))
					 xscale(range(6 28) noextend titlegap(*+7) )			 
					 ylabel(0.5 `" "Opening match" "(June 01)" "' 25.5 `" "Final match" "(June 25)" "'
							,labsize(*.8) labgap(+3) notick angle(horizontal) glcolor(black) glpattern(dot) 
					 )
					 ytick(0.5 25.5, tlength(*1.2))
					 xlabel(6 "6:00" 8 "8:00"  10 "10:00" 12 "12:00" 14 "14:00" 16 "16:00" 
							18 "18:00" 20 "20:00" 22 "22:00" 24 "24:00"
							26 "2:00" 28 "4:00" 30 "6:00"
							, labsize(*.8)
					 )
					 xtick(6(1)30, tlength(*.5))
					 ytitle("World Cup")
					 xtitle("Day time")		
					 legend( 
					 	rows(2) 
						order(1 "Core broadcasting hours" 4 "Matches")
						size(*.8) keygap(*0.5) symxsize(*0.5) symysize(*0.5)
						bmargin(5 -5 0 0)	
						position(3) ring(0)
					 )
					 graphregion(color(white) margin(r=5) lcolor(white) lalign(outside)) 	 
					 ;
	#delimit cr		
	graph export "$path\figure_SI52.pdf", as(pdf) replace

	*Restoring data
	restore	
	
	
	
	****************************************************************************
	*Figure SI.7.2: Changes in repression before and during the Africa Cup
	****************************************************************************				
	
	*Preserving data
	preserve		
	
	*Loading data
	use "$path\figure_11_SI71_data.dta", clear
	
	*Generating mean repression score: Full time period
	bys fullwin_event_africacup (year): egen repmean_event_africacup = mean(hr_mean) if fullwin_event_africacup!=.
	
	*Generating mean repression score: Cold War and Post-Cold War period
	bys fullwin_event_africacup (year): egen repmean_event_africacup_cw = mean(hr_mean) if event_africacup_cw==1
	bys fullwin_event_africacup (year): egen repmean_event_africacup_postcw = mean(hr_mean) if event_africacup_postcw==1	
			
	*Sorting data
	sort fullwin_event_africacup year	
		
	*Panel 1: 1945-2020	
	#delimit ;		
	twoway (connected repmean_event_africacup fullwin_event_africacup if fullwin_event_africacup<=0
			,
			msize(*1.2)
			mcolor(black) lcolor(black) mlwidth(0))		
					,
					ysize(1.2)
					xsize(1) 
					yscale(range(.4 .9) noextend titlegap(*+5))
					xscale(range(-4.25 0.25) noextend titlegap(*+10)) 
					ylabel(.4(.1).9, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(-4(1)0,
							labsize(*.9)
					)
					xticks(,tlength(*1))
					xline(0, lcolor(gs15) lwidth(*20))
					ytitle("Mean repression", size(*1.2))
					xtitle("Year", size(*1.2) color(white))
					subtitle("1945-2020", size(*.8) box bexpand margin(t=1.25) fcolor(gs14) lcolor(black) lalign(center))					
					legend(off)							
					graphregion(color(white) lcolor(white) lalign(outside))	
					name(africacup_fullp, replace)					
					; 
	#delimit cr	
	
	
	*Panel 2: 1945-1990	
	#delimit ;		
	twoway (connected repmean_event_africacup_cw fullwin_event_africacup if fullwin_event_africacup<=0 & event_africacup_cw==1
			,
			msize(*1.2)
			mcolor(black) lcolor(black) mlwidth(0))		
					,
					ysize(1)
					xsize(1.1) 
					yscale(range(.4 .9) noextend titlegap(*+5))
					xscale(range(-4.25 0.25) noextend titlegap(*+10)) 
					ylabel(.4(.1).9, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(-4(1)0,
							labsize(*.9)
					)
					xticks(,tlength(*1))
					xline(0, lcolor(gs15) lwidth(*20))
					ytitle("Mean repression", size(*1.2) color(white))
					xtitle("Year", size(*1.2))
					legend(off)	
					subtitle("1945-1990", size(*.8) box bexpand margin(t=1.25) fcolor(gs14) lcolor(black) lalign(center))					
					graphregion(color(white) lcolor(white) lalign(outside))				
					name(africacup_cw, replace)							
					; 
	#delimit cr		
	

	sort fullwin_event_all year	
	
	*Panel 3: 1991-2020
	#delimit ;		
	twoway (connected repmean_event_africacup_postcw fullwin_event_africacup if fullwin_event_africacup<=0 & event_africacup_postcw==1
			,
			msize(*1.2)
			mcolor(black) lcolor(black) mlwidth(0))						
					,
					ysize(1.2)
					xsize(1) 
					yscale(range(.4 .9) noextend titlegap(*+5))
					xscale(range(-4.25 0.25) noextend titlegap(*+10)) 
					ylabel(.4(.1).9, 
							nogrid labsize(*.9) angle(0)
					)
					xlabel(-4(1)0,
							labsize(*.9)
					)
					xticks(,tlength(*1))
					xline(0, lcolor(gs15) lwidth(*20))
					ytitle("Mean repression", size(*1.2) color(white))
					xtitle("Year", size(*1.2) color(white))
					legend(off)	
					subtitle("1991-2020", size(*.8) box bexpand margin(t=1.25) fcolor(gs14) lcolor(black) lalign(center))						
					graphregion(color(white) lcolor(white) lalign(outside))				
					name(africacup_postcw, replace)							
					; 
	#delimit cr	
	
	*Plotting Figure SI.7.1.
	#delimit ;	
	graph combine africacup_fullp africacup_cw africacup_postcw
		  ,
		  row(1)
		  iscale(*1.4)
		  ysize(1)
		  xsize(1.75)
		  graphregion(color(white) lcolor(white) lalign(outside))	
		  ; 
	#delimit cr		
	graph export "$path\figure_SI71.pdf", as(pdf) replace	


	*Restoring data
	restore		
		
		
	
********************************************************************************	
*	
********************************************************************************		
	
	*Closing graph windows
	graph close _all 
	
	*Clearing data
	clear all
	
	*End recording log file
	log close	

 
 
	

	
	
