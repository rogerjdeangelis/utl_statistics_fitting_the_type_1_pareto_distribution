Statistics fitting the type I pareto distribution

see SAS Forum
https://tinyurl.com/yap8jgpc
https://communities.sas.com/t5/SAS-Procedures/Is-Pareto-distribution-for-this-data-work/m-p/477768




1 |       Type I  PARETO pdf = 2 * (1/x) lamda=2 sigma=1
2 +*
  |*                                     lamda-1
  |**     pdf = (lamda/sigma) * (sigma/x)
  | *
  | *     mean - lamda*sigma / (lamda -1 )
  |  *
  |  **   if lamda=2 and sigma=1
1 +   *
  |   **       pdf= 2 * (1/x)
  |    **
  |     **     mean(u) = E(x) =
  |       ***        lamda*sigma/( lamda -1 ) = 2/1 = 2
  |         ****
  |            ************
0 +                       *********** ....
  -+--------+--------+--------+--------+-
 1.00     1.81     2.62     3.43     4.24 ...
                    X

EXAMPLE OUTPUT
---------------

 WORK.WANTWPS total obs=1

            EMPIRICAL                THEORETICAL VALUES
    --------------------------     -----------------------
    MEAN      LAMBDA     SIGMA     MEAN   LAMBDA     SIGMA

  1.95733    2.04227    1.00005      2       2         1


PROCESS (R working code)
========================

  x <- rpareto(1000, 1, 2);
  pareto.fit(x, estim.method = "MLE");

  I don't think SAS can generate random numbers from
  a 'pareto' with rand('pareto',2,1). So we will do
  all gereration and fitting in R

  * you could draw random samples by inverting the cum rand('uniform')=F(x).
    Where F(x) is the closed form cum of the pareto


OUTPUT
======

 WORK.WANTWPS total obs=1

    MEAN      LAMBDA     SIGMA

  2.04452    1.98497    1.00011

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

 all data in the R script

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;
%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(EnvStats);
library(ParetoPosStable);
x <- rpareto(10000, 1, 2);
want<-pareto.fit(x, estim.method = "MLE");
stats<-mean(x);
want<-c(mean=stats,want[[1]]);
str(want);
endsubmit;
import r=want data=wrk.wantwps;
run;quit;
');


