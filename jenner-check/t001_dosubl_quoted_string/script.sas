/* Adapted from utl-twelve-interfaces-for-dosubl.sas (interface #6: Dosubl('...') )
   Author documents this as the "prefered - psuedo documented" interface: a macro
   variable is resolved into a quoted-string argument to the DOSUBL() call, which
   compiles and executes a second, independent DATA step at datastep execution time
   (as opposed to DOSUBL(%nrstr(...)), interface #1, which the same file documents
   as failing because %nrstr defers resolution past the point DOSUBL needs it).
   Only mechanical edit here: added a PROC PRINT of the OUT dataset so the result of
   the sub-step (captured via CALL SYMPUTX inside the DOSUBL'd code) is visible in
   the listing, not just in PUTLOG on the log. */

%let test=1;

data _null_;

   set sashelp.class(obs=1);
   call symputx('tst',1);

   rc=dosubl('
       data x;
          test="&test";
          putlog test;
          call symputx("dosubl_test", test);
       run;quit;
       ');

   putlog 'NOTE: DOSUBL return code rc=' rc;
   call symputx('dosubl_rc', rc);

run;quit;

data out;
   length dosubl_test $8 dosubl_rc 8;
   dosubl_test = symget('dosubl_test');
   dosubl_rc = input(symget('dosubl_rc'), best12.);
run;

proc print data=out noobs;
   title 'DOSUBL(''...'') interface: value round-tripped through the sub-step';
run;
