
********************************************************************************
*
* Readme file for
*
* INTERNATIONAL SPORTS EVENTS AND REPRESSION IN AUTOCRACIES:
* EVIDENCE FROM THE 1978 FIFA WORLD CUP
*
* By Adam Scharpf, Christian Glaessel, Pearce Edwards
*
* American Political Science Review
*
* July 2022
*
********************************************************************************



********************************************************************************
* NOTE
********************************************************************************

- Replicating results requires STATA 15.1/SE and R VERSION 4.1.1.
- Running the replication code takes approx. 45 minutes.
- Please contact authors should any problems occur.



********************************************************************************
* REPLICATION STEPS
********************************************************************************

- To replicate all results follow these steps:

	-> Set working directory in file "replication.do".
	-> If necessary, install required .ado-files as indicated in "replication.do".
	-> Run file "replication.do" to replicate all statistical results.

	-> Set working directory in file "replication_table_SI54_figure_8.R".
	-> If necassary, intall R-packages as indicated in "replication_table_SI54_figure_8.R".
	-> Run file "replication_table_SI54_figure_8.R" to replicate Figure 8 and Table SI.5.4.



********************************************************************************
* DATA FILES USED IN STATA 15.1 (VERSION SE 64-bit x86-64)
********************************************************************************

1. "main_data.dta": used to replicate all analyses reported in the manuscript and the supporting information.

2. "figure_1_data.dta": used to replicate Figure 1 in the manuscript.

3. "figure_3_data.dta": used to replicate Figure 3 in the manuscript.

4. "figure_7_data.dta": used to replicate Figure 7 in the manuscript.

5. "figure_9_data.dta": used to replicate Figure 9 in the manuscript.

6. "figure_11_SI71_data.dta": used to replicate Figure 11 in the manuscript and Figure SI.7.1 in the supporting information.

7. "figure_SI11_data.dta": used to replicate Figure SI.1.1 in the supporting information.

8. "figure_SI43_data.dta": used to replicate Figure SI.4.3 in the supporting information.

9. "figure_SI52_data.dta": used to replicate Figure SI.5.2 in the supporting information.



********************************************************************************
* STATA .DO FILE (STATA/SE 15.1 FOR WINDOWS 64-bit x86-64)
********************************************************************************

1. "replication.do": commands to be used with datasets 1 to 9 (see above) in order to replicate:

	-> Table 1 in the manuscript.
	-> Figures 1, 3, 4, 5, 6, 7, 9, 10, and 11 in the manuscript.
	-> Tables SI.3.1 to SI.6.1 in the supporting information.
	-> Figures SI.1.1 to SI.7.1 in the supporting information.



********************************************************************************
* R COMMAND SCRIPT (R VERSION 4.1.1 + R STUDIO VERSION 1.4.1717)
********************************************************************************

1. "replication_table_SI54_figure_8.R": commands to be used with dataset 1 (see above) in order to replicate:

	-> Figure 8 in the manuscript and results in Table SI.5.4 in the supporting information.

