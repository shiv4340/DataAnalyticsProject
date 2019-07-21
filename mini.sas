

libname clinical'C:\Documents and Settings\Administrator\Desktop\project';
/* create a library and import the data */
data demo;
set clinical.adsl(keep=USUBJID AGE SEX TRT01A );
RUN;
proc print data= demo;
run;
/*firstly  make a copy of dataset using set function,
In this dataset keep the requried elements suchas usunjid,age,sex 
and soon..*/
data demo1;
set demo;
output;
TRT01a="overall";
output;
run;
proc print data = demo1;
run;
/*create a overall column as per the requrinment of the client.
In this we will get multiple dup values ,so we have to sort.
so sort using the nodupkey by usubjid*/
proc sort data = demo1 out = demo2 nodupkey;
by USUBJID;
run;
proc print data = demo2;
run;

/* by using proc means find the n,mean
std,min,max,median*/
proc means data = demo2 n mean std min max median;
var age;
run;
proc print data =demo2;
run;

/*create a class for TRT01A drug and calculate for age use output by this the
output will print in horizontal manner but client needs in the vertical manner or order*/

proc means data= demo2;
class TRT01A;
var age;
output out =sts (drop =_TYPE__FREQ_)
n=_n
mean=_mean
std=_std
min=_min
max=_max
median=_median;
run;
proc print data = demo2;
run;
/*in this assign the length for mean meadin  min max 
according to the client provieded format*/
data demo2;
length n meanstd minmax median $50;
set sts;
n=put(_n,5.);
meanstd=put(_mean,7.1)||"("||put(_std,8.2)||")";
minmax=put(_min,5.)||","||put(_max,5.);
median=put(_median,7.1);
if TRT01a ne'';
drop _n _mean _std _min _max _median;
run;

proc sort data =demo2 out =demo3;
by TRT01A;
run;
proc print data =demo3;
run;
proc transpose data =demo3 out =demo4;
id TRT01A;
var n meanstd median minmax;
run;
proc print data = demo4;
run;
/*change the headings according to thee client needs*/
data demo5;
set demo4;
if _NAME_="n" then _Name_="N";
if _NAME_="medianstd" then _Name_="Mean(SD)";
if _NAME_="minmax" then _Name_="Min,Max";
if _NAME_="median" then _Name_="Median";
run;
proc print data =demo5;
run;

data label;
length _name_ $50;
_name_="Age(years)";
run;
proc print data =label;
run;
/*create a dataset called label for ages(years)*/
data demo6;
set label demo5;
if _n_ > 1 then _Name_="  "||_name_;
run;
proc print data = demo6;
run;
