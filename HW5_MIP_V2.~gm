$ontext

CEE 6410 - Water Resources Systems Analysis
Problem 7.4.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

A farmer plans to develop water for irrigation. He is considering two possible sources of
water: a gravity diversion from a possible reservoir with two alternative capacities and/or a
pump from a lower river diversion. Between the reservoir and pump site the river base flow
increases by 2 acft/day due to groundwater drainage into the river. Ignore losses from the
reservoir. The river flow into the reservoir and the farmer's demand during each of two
six-month seasons of the year are given in the below table Revenue is estimated
at $300 per year per acre irrigated.

Assume that there are only two possible sizes of reservoir: a high dam that has capacity of
700 acft or a low dam with capacity of 300 acft. The capital costs are $10,000/year and
6,000 dollars/year for the high and low dams, respectively (no operating cost). The pump capacity
is fixed at 2.2 acft/day with a capital cost (if it is built) of $8,000/year and operating cost
of $20/acft.

                Seasonal Flow and Demand Table

Season   River Inflow(acft)  Irrigation Demand (acft/acre)
1               600              1.0
2               200              3.0


THE SOLUTION:
Model using INTEGER VARIABLES statement and SOLVE as MIP.

Patrick Campana
Patrickcampana555@gmail.com
10/2/2020

KEY ASSUMPTIONS
         1. 92 days per season
         2. -Pump is not operated outside of Seasons 1 and 2
$offtext

* 1. DEFINE MODEL DIMENSIONS
SETS Loc Locations in Model / Res "Reservoir", Divert "Irrigation Diversion from Res",
          ResOut "Reservoir Outlet to River", Pump "Pumping STA"/

     CLoc Constraint Locations /SD "Small Dam", LD "Large Dam", P "Pump"/

     Time two seasons that are modeled /T1, T2/;
*NOTE: ASSUMING THAT SEASONS T1 and T2 are each 92 days long

* 2. DEFINE INPUT DATA
PARAMETERS

    CapCost(CLoc) Capital costs ($)
         /SD     6000
          LD     10000
          P      8000/

    MaxCap(CLoc) Maximum capacity of Irrigation source per season (acft)
         /SD      300
          LD      700
          P       202.4/
* 2.2 acft/day * 92 day/season = 202.4 acrft per season

    IrrDEM(Time) Irrigation Demands in each month (acft per acre)
         /T1     1
          T2     3/

    Q(Time) Flow inputs each month (acft)
         /T1     600
          T2     200/

    IntUpBnd(CLoc) Upper bound on integer variables Besides No build For Reservoir
         /SD     1
          LD     1
          P      1/

    IntLowBnd(CLoc) Lower bound on integer variables Besides No build For Reservoir
         /SD     0
          LD     0
          P      0/;


SCALARS
         OCP  Operating cost pump ($ per acft pumped)    /20/
         IrrP Profit ($ per acre of crops irrigated) /300/
         G_H2O River Ground Water Recharge Per Season (Acft per season) /184/;
*RIVER GROUND WATER RECHARGE, ASSUMING 92 Days per season then 2.0 acft/day * 92 day = 184 acft per season

*3. Define Variables
VARIABLES
*Going to need to change I constraints to have 3 ISD, ILD and IPump
         I(CLoc) binary decision variables associated with Constraint Locations (0=no 1=yes )
         X(Loc,Time) volume of water going to each point
         NProfit Net profit($)
         AI Area Irrigated or Size of Farm;
*3a. Define Select Variables as Binary
BINARY VARIABLES
         I;

*3b. Define Positive Variables
POSITIVE VARIABLES
         X;

*4. COMBINE variables and data in equations
EQUATIONS
         MaxRes(Time) Maximum Capactiy of Dam in each time step (acft)
         MaxPump(Time) Maximum Capacity of Pump in each time step (acft)
         DAMSUM SUM of Dam related Integer Values (number)
         MBDT1 Mass Balance of Dam in season 1 No intial storage (acft)
         MBDT2 Mass Balance of Dam in season 2 Storage is X(Dam of Size L or D T1) (acft)
         MBR(Time) Mass Balance of River
         WaterDemand(Time) Calculated Area Irrigated For each time step (Acre)
         NoDiv(Time) No diversion if no Reservoir is built
         NetProfit Net Profit From Irrigated Area

*Integer Bounding Equations
         IntUpBound(CLoc) Upper bound on CPLoc set integer variables (number)
         IntLowBound(CLoc) Lower bound on CPLoc set integer variables (number);

*Maximum Reservoir Capactiy
MaxRes(Time)..   X('Res',Time) =L= I('SD')*MaxCap('SD')+I('LD')*MaxCap('LD');

*Maximum Pump Capacity
MaxPump(Time)..  X('Pump',Time) =L= MaxCap('P')*I('P');

*Sum of Integers Related to Dam building Possibilities
DAMSUM..         I('SD')+I('LD') =L= 1;

*Mass Balance of Reservoirs In Each Season
MBDT1..          X('Res','T1')=E= Q('T1')-X('ResOut','T1')-X('Divert','T1');
MBDT2..          X('Res','T2')=E= Q('T2')+X('Res','T1')-X('ResOut','T2')-X('Divert','T2');

*Mass Balance of River For all T steps
MBR(Time)..      X('Pump',Time) =L= X('ResOut',Time)+G_H2O;

*Water Demand of Irrigated Area
WaterDemand(Time)..X('Divert',Time)+X('Pump',Time) =G= AI*IrrDEM(Time);

*No Diversion If Reservoir Is not Built. Note 100000 is arbitrarily selected large number
NoDiv(Time)..     X('Divert',Time) =L= 100000*( I('SD')+I('LD') );

*Binary Forcing Functions
IntUpBound(CLoc)..      I(CLoc) =L= IntUpBnd(CLoc);
IntLowBound(CLoc)..     I(CLoc) =G= IntLowBnd(CLoc);

*Objective Function
NetProfit..  300*AI-SUM(CLoc, I(CLoc)*CapCost(CLoc))-OCP*SUM(Time,X('Pump',Time)) =E= NProfit;

*5. DEFINE the MODEL from the Equations
MODEL IrrigationMaximization /ALL/;

*        Display Slack Variables Rather Than LB and UB
         option solslack = 1;

*6. Solve the Model as an MIP
SOLVE IrrigationMaximization USING MIP MAXIMIZING NProfit;

*7. Dump File to Excel Workbook
Execute_Unload "HW5_MIP_V2.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW5_MIP_V2.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.







