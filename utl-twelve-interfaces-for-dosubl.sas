Twelve interfaces for dosubl                                                                                                    
                                                                                                                                
github                                                                                                                          
https://github.com/rogerjdeangelis/utl-twelve-interfaces-for-dosubl                                                             
                                                                                                                                
Thanks Q                                                                                                                        
Quentin McMullen                                                                                                                
qmcmullen.sas@gmail.com                                                                                                         
                                                                                                                                
Great question about %nrstr, we need documentation.                                                                             
                                                                                                                                
%nrstr works well in open code. (see where it works and wher it fails below)                                                    
                                                                                                                                
I notice that "dosubl('" allowed macro resolution and string concatination                                                      
within a datastep. I just felt this was the correct syntax? Indirect documentation?                                             
                                                                                                                                
Here are possible interfaces                                                                                                    
                                                                                                                                
     1. DOSUBL(%nrstr( (good in open code)                                                                                      
     2. macro variables (with and without symgetn or syget)                                                                     
     3. Shared storage with '%common' macro                                                                                     
     4. Call Execute like string concatination  dosubl('data x;'!!age!!'=2;'!!'run;)                                            
     5. Dosubl(%tslit( (heps with quote doubling)  (better cal execute)                                                         
     6. Dosubl('    (prefered - psuedo documented)                                                                              
     7. Dosubl("                                                                                                                
     8. Dosubl(''   (quote doubling when ypu have single quotes in your code)                                                   
     9. Dosubl(""   (quote doubling when ypu have single quotes in your code)                                                   
    10. Dosubl( hiding quotes using "27"x, and "22"x for single and double quotes)                                              
    11. Passing a macro  rc=dosubl('%isperfectsquare(&num);');                                                                  
    12. Share within a datastep(sort of) processes in involving inputs and outputs;      
    13. Using dosubl within a macro smf share enviroment variable with mainline(parent)                                          
        https://tinyurl.com/37wfav9p                                                                                              
        https://github.com/rogerjdeangelis/utl-embedding-dosubl-in-a-macro-and-returning-an-updated-environment-variable-contents 

                                                                                                                                
        Rrocess Timing                                                                                                          
                                                                                                                                
         1. macro time                                                                                                          
         2. datastep compile time                                                                                               
         3. dataset execution time                                                                                              
                                                                                                                                
          +---------                                                                                                            
          |         data want;                                                                                                  
          |                                                                                                                     
          |   +------- If _n_=0 then do;                                                                                        
          |   |   +---                                                                                                          
          |   |   |        %let rc=%sysfunc(dosubl('                                                                            
          | 3 | 2 | 1          proc sql; select put(age,2.) into: ages separated by " " from sashelp.class;quit;                
          |   |   |            %let numages=&sqlobs;                                                                            
          |   |   |            %put &=numages;                                                                                  
          |   |   |        '));                                                                                                 
          |   |   +---                                                                                                          
          |   |          array ages[&numages] n1-n&numages (&ages);                                                             
          |   +------                                                                                                           
          |            end;                                                                                                     
          |                                                                                                                     
          |            sumAge=sum(of ages[*]);                                                                                  
          |            putlog sumAge=;                                                                                          
          |                                                                                                                     
          |          run;quit;                                                                                                  
          +-----------                                                                                                          
                                                                                                                                
                                                                                                                                
        %put &=ages;                                                                                                            
                                                                                                                                
        SUMAGE=253                                                                                                              
                                                                                                                                
I wish more programmers would experiment with DOSUBL, I can't figure                                                            
out all the applications alone. Many of my posts are academic with obivious                                                     
simple solutions.                                                                                                               
                                                                                                                                
github                                                                                                                          
https://github.com/rogerjdeangelis/utl_dosubl_subroutine_interfaces                                                             
https://tinyurl.com/y3xaxhvs                                                                                                    
https://github.com/rogerjdeangelis/utl-a-better-call-execute-using-dosubl                                                       
                                                                                                                                
run;quit;                                                                                                                       
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=dosubl++in%3Aname&type=&language=                          
                                                                                                                                
                                                                                                                                
*               _           __       _ _                                                                                        
 _ __  _ __ ___| |_ _ __   / _| __ _(_) |___                                                                                    
| '_ \| '__/ __| __| '__| | |_ / _` | | / __|                                                                                   
| | | | |  \__ \ |_| |    |  _| (_| | | \__ \                                                                                   
|_| |_|_|  |___/\__|_|    |_|  \__,_|_|_|___/                                                                                   
                                                                                                                                
;                                                                                                                               
                                                                                                                                
%let test=1;                                                                                                                    
data _null_;                                                                                                                    
                                                                                                                                
   set sashelp.class(obs=1);                                                                                                    
   call symputx('tst',1);                                                                                                       
                                                                                                                                
   rc=dosubl(%nrstr(                                                                                                            
       data x;                                                                                                                  
          test="&test";                                                                                                         
          putlog test;                                                                                                          
       run;quit;                                                                                                                
       ));                                                                                                                      
                                                                                                                                
run;quit;                                                                                                                       
                                                                                                                                
data x;           test="&test";           putlog test;        run;                                                              
     -                                                                                                                          
     388                                                                                                                        
     -                                                                                                                          
     76                                                                                                                         
159 ! quit;                                                                                                                     
                                                                                                                                
ERROR 388-185: Expecting an arithmetic operator.                                                                                
ERROR 76-322: Syntax error, statement will be ignored.                                                                          
159          ));                                                                                                                
              -                                                                                                                 
              180                                                                                                               
ERROR 180-322: Statement is not valid or it is used out of proper order.                                                        
                                                                                                                                
                                                                                                                                
*_   _     _                          _                                                                                         
| |_| |__ (_)___  __      _____  _ __| | _____                                                                                  
| __| '_ \| / __| \ \ /\ / / _ \| '__| |/ / __|                                                                                 
| |_| | | | \__ \  \ V  V / (_) | |  |   <\__ \                                                                                 
 \__|_| |_|_|___/   \_/\_/ \___/|_|  |_|\_\___/                                                                                 
                                                                                                                                
;                                                                                                                               
%let test=1;                                                                                                                    
data _null_;                                                                                                                    
                                                                                                                                
   set sashelp.class(obs=1);                                                                                                    
   call symputx('tst',1);                                                                                                       
                                                                                                                                
   rc=dosubl('                                                                                                                  
       data x;                                                                                                                  
          test="&test";                                                                                                         
          putlog test;                                                                                                          
       run;quit;                                                                                                                
       ');                                                                                                                      
                                                                                                                                
run;quit;                                                                                                                       
                                                                                                                                
SYMBOLGEN:  Macro variable TEST resolves to 1                                                                                   
1                                                                                                                               
                                                                                                                                
