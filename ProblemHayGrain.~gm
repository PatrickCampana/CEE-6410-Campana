$ontext

CEE 6410 - Water Resources Systems Analysis
Problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

An aqueduct constructed to supply water to industrial users has an excess
capacityin the months of June, July, and August of 14,000 acft, 18,000 acft,
and 6,000 acft,respectively. It is proposed to develop not more than 10,000
acres of new land by utilizing the excessaqueduct capacity for irrigation water
 deliveries. Two crops, hay and grain, are to begrown. Their monthly water
requirements and expected net returns are given in the following table:

                 Monthly Water Requirment (acft/acre)
         june    july    august          Return, $/acre
Hay         2       1       1               100
Grain       1       2       0               120

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Patrick Campana
Patrickcampana555@gmail.com
September 23, 2020

$offtext

* 1. DEFINE the SETS
SETS crop crops growing /Hay, Grain/
     time months: june = M1 etc /M1*M3/;

* 2. DEFINE input data
PARAMETERS
   c(crop) Objective function coefficients ($ per acre)
         /Hay 100
          Grain 120/

   bb(time) Water RHS Constraints Per Month (acre-ft)
         /M1 14000
          M2 18000
          M3 6000/


TABLE A(crop,time) Water Left hand side constraint coefficients (acre-ft per acre)
                 M1      M2        M3
         Hay     2       1         1
         Grain   1       2         0   ;

Scalar Land the max amount of land available for crops  RHS coefficient (acres)
         /10000/;

* 3. DEFINE the variables
VARIABLES X(crop) acres of crop planted (acre)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   WATER_CONSTRAIN(time) water resource Constraints
   LAND_CONSTRAIN land resource constraint      ;

PROFIT..                 VPROFIT =E= SUM(crop,c(crop)*X(crop));
WATER_CONSTRAIN(time)..    SUM(crop,A(crop,time)*X(crop)) =L= bb(time);
LAND_CONSTRAIN..         SUM(crop, X(crop)) =L= Land;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL MaxProfit /All/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the MaxProfit model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE MaxProfit USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
