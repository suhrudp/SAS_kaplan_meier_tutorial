/*IMPORT DATA*/
proc import datafile="/home/u62868661/Datasets/KM/Chemo.csv"
dbms=csv
out=df
replace;
run;

/*DESCRIPTIVE TABLES*/
proc means data=df chartype mean std min max median n range vardef=df clm 
		alpha=0.05 q1 q3 qmethod=os;
	var Age Duration;
	class Group Outcome;
run;
proc freq data=WORK.DF;
	tables  (Group Smoking) *(Outcome) / chisq relrisk fisher nocol nocum 
		plots(only)=(freqplot mosaicplot);
run;

/*HISTOGRAMS*/
proc univariate data=df vardef=df noprint;
	var Age Duration;
	class Group Outcome;
	histogram Age Duration / normal(noprint) kernel;
	inset mean std min max median n range q1 q3 / position=nw;
run;

/*BOXPLOTS*/
proc boxplot data=df;
	plot (Age Duration)*Group / boxstyle=schematic;
	insetgroup mean stddev min max n q1 q2 q3 range / position=top;
run;

proc sort data=df out=df1;
by Outcome;
run;

proc boxplot data=df1;
	plot (Age Duration)*Outcome / boxstyle=schematic;
	insetgroup mean stddev min max n q1 q2 q3 range / position=top;
run;

/*SURVIVAL ANALYSIS*/
proc lifetest data=df plots=(s(atrisk(outside) cb));
	time Duration*Outcome(0);
	strata Group / adjust=tukey;
run;
proc lifetest data=df plots=(s(atrisk(outside) cb));
	time Duration*Outcome(0);
	strata Smoking / adjust=tukey;
run;