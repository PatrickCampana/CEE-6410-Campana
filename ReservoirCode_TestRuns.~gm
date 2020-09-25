$ontext
CEE 6410 - Water Resources Systems Analysis
Example Reservoir Opertation

THE PROBLEM:

A reservoir is designed to provide hydropower and water for irrigation.
The turbine releases may also be used for irrigation.At least one unit of water must be kept in the river each month
The hydropower turbines have a capacity of 4 units of water per month
(flows are constant during any single month), and any other releases must bypass the turbines.
The size of farmed area is very large relative to the amount of irrigation water available,
so there is no upper limit on usable irrigation water.  The reservoir has a capacity of 9 units,
and initial storage is 5 units of water.  The ending storage must be equal to or greater than the
beginning storage. The benefits per unit of waters, and the estimated average inflows to the reservoir are given in Table 1.

Figure of System
                         ------->[Spillway] -------v
->[Inflow]->[Reservoir]-^-->[Hydropower]->[SpillwayHydroJunction]--->---v--------------->[River Flow]
                                                                 [Irrigation Diversion]


Table        Hydropower and Irrigation Problem Data

Month    Inflow Units    Hydropower Benefits ($/units)   Irrigation Benefits ($/units)
1        2               1.6                             1
2        2               1.7                             1.2
3        3               1.8                             1.9
4        4               1.9                             2.0
5        3               2.0                             2.2
6        2               2.0                             2.2

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Patrick Campana
patrickcampana555@gmail.com
September 18, 2020
$offtext

* 1. DEFINE the SETS
SETS Loc different locations in the model space  /Reservoir, Spillway, Turbines, Irrigation, RiverA /
     CLoc(Loc)  Locations with Volume constraints /Reservoir, Turbines/
     PLoc(Loc)  Locations which generate Profit /Turbines, Irrigation/
     GLoc(Loc)  Locations which generate Profit /RiverA/
     ILoc (Loc) Locations which Receive external Flows /Reservoir/
     Time Months in period of interest (months) /M1, M2,M3, M4, M5, M6/
     TimeP1(Time)   Months after M1 /M2,M3, M4, M5, M6/;


* 2. DEFINE input data, Flow Constraints Coeffiecents, Monthly Inflow, Profit Coefficients
PARAMETERS

  ble(CLoc) RHS constraint coeffients the must be met or less than (volume)
                        /Reservoir  9
                         Turbines   4/

  bge(GLoc) RHS constraint coeffcients the must be met or greater than (volume)
                         /RiverA  2/
  test(Time);

         test(time) = ORD(Time);
         display test;
  test(Time) = test(time+1);
         display test;


  TABLE FlowIn(Loc, Time) Monthly Inflows of water to the reservoir (volume)
                          M1      M2      M3      M4      M5      M6
         Reservoir        2       2       3        4       3       2;



  TABLE c(Loc,Time) Objective function coefficients ($ per month)
                         M1      M2      M3      M4      M5      M6
         Turbines        1.6     1.7     1.8     1.9     2.0     2.0
         Irrigation      1.0     1.2     1.9     2.0     2.2     2.2;

  Scalar
         IStore Intial Storage In Reservoir /5/;


* 3. DEFINE the variables: Flow to each location, Benefit
VARIABLES
          X(Loc, Time) Flow Per Location Per Time (Volume)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   LFlow_CONSTRAINTS(CLoc,Time) Flow Constraints that must be met or less than (volume)
   GFlow_CONSTRAINTS(GLoc,time) Flow Constraints that must be met or greater than (volume)
   IResMB Intial Reservoir Mass Balance (volume)
   ResMB(Time)  Reservoir Mass Balance For Time Steps Greater than M1 (Volume)
   RiverMB(Loc,Time) River Mass Balance For all Time Steps (Volume)
   Sustainability Makes it so that Final Reservoir storage is not less that intial;

*Maximize Profit
PROFIT..     VPROFIT =E= SUM( (PLoc,Time), c(Ploc,Time)*X(Ploc,Time) );

*Equations that Limit Reservoir and Turbine Volumes For each time step, defines two sets of equations, 12 total
LFlow_CONSTRAINTS(CLoc,Time)..  X(CLoc,Time) =L= ble(Cloc);

*Equations that set RiverA volumes for each time step, defines one set of equations, 6 total
GFlow_CONSTRAINTS (GLoc, time)..     X(GLoc,Time) =G= bge(GLoc);

*Intial Reservoir Mass Balance, defines one set of equations, 1 total
IResMB..   FlowIn('Reservoir','M1') + IStore - X('spillway','M1')- X('Turbines','M1')=E= X('Reservoir', 'M1');

* Reservoir Mass Balance, defines one set of equations, 5 total
ResMB(Time)$(ORD(Time)ge 2 )..   X('Reservoir', Time - 1) + FlowIn('Reservoir',Time)- X('spillway',Time)- X('Turbines',Time)  =E= X('Reservoir',Time);

*River Mass Balance, defines one set of equations, 6 total
RiverMB(Loc,Time)..   X('Spillway',Time)+ X('Turbines',Time) =E= X('Irrigation', Time)+X('RiverA',Time);

*Sustainability Constraint, defines one set of equations, 1 total
Sustainability.. X('Reservoir','M6') =G= IStore;


* 5. DEFINE the MODEL from the EQUATIONS
MODEL ReservoirOptimization /ALL/;
*Altnerative way to write (include all previously defined equations)
*MODEL /ALL/;

* 6. SOLVE the MODEL
* Solve the ReservoirOptimization model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
option solslack = 1;

SOLVE ReservoirOptimization USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
