Project Description

Topic:
The effect of drug decriminilization on overdose deaths and well-being.

Why it matters:
The study of drug decriminalization and overdose rates in Oregon has potential for significant policy and societal relevance. There are many debates on the benefits and drawbacks of drugs use and decriminalization has potential for policy implications involving economics, public health, criminal justice, and community well-being.

Research Question and Motivation:
What is the effect of drug decriminalization on overdose deaths and well-being? A policy change like Oregon's can have significant consequences on populations who are most at risk of overdose deaths and the economic impacts on health care costs and overall well-being. We used the synthetic control method to understand how the policy change impacted Oregon by comparing what would have happened in the absence of the policy being implemented. 

Description of Data:

Overdose Mortality by county in the US:
The Overdose Mortality by County in the US is from the CDC Center for Health Statistics for the years 2020-2023. These provisional county-Level drug Overdose death counts are based on death records and is received  by the NCHS receives the death records from the state vital registration offices through the Vital Statistics Cooperative Program (VSCP). The provisional counts are reported by the county were the decedent resided, not necessarily where they died. 

County Well-Being Rankings:
The County Well-Being Rankings are for the years 2014-2023 and is collected by County Health Rankings & Roadmaps CHR&R, a program of the University of Wisconsin Population Health Institute. The health rankings include deaths which include overdose deaths, years of potential life lost, mental health statistics, income, and other health public heatlh rankings. 

Overdose by Drug:
The Overdose by drug dataset contains information on non-fatal overdose data by state for 2018-2023. Provided by the CDC, DOSE (Drug Overdose Surveillance and Epidemiology) collects health department reports in each state. 

Other variables of interest include opioid and stimulant overdoses and the significance of the change from previous months in those overdoses.

Violent Crime Data
From the FBI crime data reporter database, the number of violent crimes in Oregon. 

How are they related? 
The Well-Being Ranks, Overdose Mortality by County contain county fips codes, county names and year in relation. The Overdose by Drug has a relationship of total non-fatal drug overdoses in each state.

Data Processing:
For the county health rankings data, we originally had years 2014-2023, but after further inspection the way overdose deaths were collected for 2014-2015 was significantly different that for the years 2016-2023. We opted to drop those years since those data sets also did not include as many well-being measures. 

The data collected was generally in clean condition. SOme column name changes were done, and general data manipulation was completed. For example, health rankings came from yearly files- these had to be merged together. 
There was generally little missing data. Violent crime and overdose by drugs contained zero missing values. However, a key data set used, health rankings, contained 13 percent N/A values. These appeared generally randomly scatter, and we will assume these are missing at random and will be ignored. 


Findings:
Initial findings include general decrease in well being, likely due to covid19 (mental health days, pct fair or poor health days, etc). Additionally, drug overdose deaths have been increasing, especially since 2020. However, it appears that Oregon's increase may be slower relative to Washington and Oregon after decriminilzaing drugs. 

Limitations:
It is a challenge to find a single cause for an impact on drug decriminalization and its relationship to drug overdose deaths. Since multiple factors can contribute to drug-related outcomes. There has been some evidence linked to the Covid-19 pandemic contributing to drug use, well-being, and mental health. 
There is limited generalizability to this study as findings from synthetic control analysis are specific to the context of Oregon’s drug policies and may not be generalized to other regions or policies. 
There is also limited data post treatment period (2 years). Additionally, the synthetic Oregon may not be a good fit. This wil be further analyzed throughout the semester. As well as continuing to fully understand the statistical basis for synthetic control better. 

Results:
Decriminilizing drugs in Oregon has slowed the increase in drug overdose deaths. 