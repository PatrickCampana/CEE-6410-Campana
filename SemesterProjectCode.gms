$ontext

CEE 6410 - Water Resources Systems Analysis
Semester Project Code

$offtext

* 1. DEFINE MODEL DIMENSIONS
SETS Loc Locations in Model / Res "For storage or water surface elevation in F.G."
          Dam "For Flow out of F.G. Dam"/


     Years number of years modeled /Y1*Y5/

     Months variable for each month of the year M1 corresponds to January /M1*M12/
     HydrologicScenarios the three different hydrologic scenarios I envisioned for this model /W1*W3/;

* 2. DEFINE INPUT DATA
PARAMETERS

*Hydropower Constraints
   HydroPower(Months) Hydropower Monthly Flow Volumes
         /M1        110063
         M2        108932
         M3        50745
         M4        49732
         M5        51806
         M6        124661
         M7        89708
         M8        108694
         M9        98434
         M10        63808
         M11        77209
         M12        105989/;



*Flow Into Flaming Gorge Dam
*This currently assumes "Wet" hydrologic Scenario 5 years in a row
Table FlowIn(Months, Years) Flow In to F.G. Res (Ac-ft)
               Y1                Y2               Y3                 Y4                     Y5
M1        54709.8843        54709.8843         54709.8843           54709.8843            54709.8843
M2        102194.5785        102194.5785        102194.5785        102194.5785        102194.5785
M3        310868.6281        310868.6281        310868.6281        310868.6281        310868.6281
M4        412552.0661        412552.0661        412552.0661        412552.0661        412552.0661
M5        552063.4711        552063.4711        552063.4711        552063.4711        552063.4711
M6        658152.3967        658152.3967        658152.3967        658152.3967        658152.3967
M7        366615.6694        366615.6694        366615.6694        366615.6694        366615.6694
M8        170992.6612        170992.6612        170992.6612        170992.6612        170992.6612
M9        83957.95041        83957.95041        83957.95041        83957.95041        83957.95041
M10        65591.80165        65591.80165        65591.80165        65591.80165        65591.80165
M11        72242.18182        72242.18182        72242.18182        72242.18182        72242.18182
M12        64218.44628        64218.44628        64218.44628        64218.44628        64218.44628;



*LTRP enviromental flows for each year obtained by  subtracting Yampa river flows
*From Green River in Jensen Utah flows to approximate Flaming Gorge Release in June
*These flows also assume the entirety of the LTRP release occurs in the month of June

*W1 is a dry year, W2 is a average year, W3 is a wet year
Table EnviroFlows(Years,HydrologicScenarios) Enviromental Flow Release For Each Year and Hydrologic Scenario
          W1                    W2            W3
Y1        167147.11        287623.14        473652.89
Y2        167147.11        287623.14        473652.89
Y3        167147.11        287623.14        473652.89
Y4        167147.11        287623.14        473652.89
Y5        167147.11        287623.14        473652.89;


*Baseflow Constraints:
*Note This is set up so that It can be adjusted for different Hydrologic
*Or Colorado Pike Minnow Summer Base Flow constraints
*Currently it is set for my "Wet" hydrologic Scenario 5 years in a row and incorperates
*colorado pikeminnow b.f. constraints into baseflow constraints
Table    BaseFlows(Months, Years) Base Flow Constraints In Each Year Monthly Flow Volumes (Ac-ft)
                  Y1           Y2                   Y3                     Y4               Y5
M1        61487.60331        61487.60331        61487.60331        61487.60331       61487.60331
M2        55537.19008        55537.19008        55537.19008        55537.19008       55537.19008
M3        49190.08264        49190.08264        49190.08264        49190.08264       49190.08264
M4        47603.30579        47603.30579        47603.30579        47603.30579       47603.30579
M5        50578.5124         50578.5124         50578.5124         50578.5124        50578.5124
M6           0                     0                    0                0               0
M7        98380.16529        98380.16529        98380.16529        98380.16529       98380.16529
M8        98380.16529        98380.16529        98380.16529        98380.16529       98380.16529
M9        95206.61157        95206.61157        95206.61157        95206.61157       95206.61157
M10       52264.46281        52264.46281        52264.46281        52264.46281       52264.46281
M11       50578.5124         50578.5124         50578.5124         50578.5124        50578.5124
M12       61487.60331        61487.60331        61487.60331        61487.60331       61487.60331;



SCALARS
*Maximum outflow possible in one month. Does not consideer using the spillway
         MaxFlowOut  Maximum Flow Out In One Month (Ac-ft)   /511736/

*Maximum F.G. storage s.t.  1 to 10% exceedance can be routed at anytime
         MaxStore Maximum Water Storage in F.G. Reservoir (Ac-ft) /3086976/

*Minimum F.G. storage set midway between rated hydropower storage and minimum hydropower storage
         MinStore Minimum Water Storage in F.G. Reservoir (Ac-ft)/545757.5/

*Setting Intial Storage In Reservoir For Model, I arbitrarily chose this value
*It corresponds to a reservoir elevation of 6009.27 ft which may be a bit high
*in reality for january. Model results are likely fairly sensitive to this value


         IntStrg Intial Reservoir Storage of F.G. Reservoir (Ac-ft) /2617726.50/

*Set Upper and lower bounds for binary Variables
*         BinLow Lowerbound of Binary Variables /0/
*         BinHigh Upperbound of Binary Variables /1/;

*3. Define Variables
VARIABLES
         Env(Years) value assumes 1 when enviromental flows are met
         Yenv dummy variable to hold sum of integers values
*         NoEnv(Years) value assumes 1 when envromental flows are not met
         X(Loc,Months,Years) volume of water flowing out of Dam or Stored in Reservoir;

*3a. Define Select Variables as Binary
BINARY VARIABLES
         Env;
*         NoEnv;

*3b. Define Positive Variables
POSITIVE VARIABLES
         X;

*4. COMBINE variables and data in equations
EQUATIONS
*Binary Constraints
*     BinarySumConst(Years) used to restrict flows in june to either enviromental or baseflow
     EnvBinaryHigh(Years)   Upper bound on binary variables
     EnvBinaryLow(Years)    Lower bound on binary variables
*    NoEnvBinaryHigh(Years)   Upper bound on binary variables
*     NoEnvBinaryLow(Years)    Lower bound on binary variables
     TotalEnv used to sum the number of times enviromental flows are met
*Enviromental Flow Constraint if Env = 1
     Enviro(Years) Sets outflow requirement for enviromental release flows in June for LTRP
*F.G. Flow and Storage Constraints

*This equaiton will be set later to determine maximum and minimum bounds of Water to be
*Released over a five year period. This is my maximumize flows to Lake Powell Constraint
     TotalOut(Months,Years) used to sum total outflows from F.G. over the model period

     MMinStore(Months,Years) used to check minimum storage is met for each month
     MMaxStore(Months,Years) used to check maximum storgage is not surpassed in each month
     MMaxFlowOut(Months,Years) used to check that maximum outflow is not surpassed in any year
     Hydro(Months,Years) used for hydropower constraints
     BF(Months,Years)    used baseflow constraints
*Conservation of Mass Constraints;
     IResMB used to require conservation of mass in the first timestep
     ResMB(Months, Years) used to require conservation of mass in the following time steps;


*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*Constraint Equations
*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

*1.) First define binary constraints because it is easy to do so:

*Forces either Enviromental Flows or No Enviromental Flows to occur for a given year in june
*     BinarySumConst(Years).. Env(Years)+NoEnv(Years) =L= 1;
     EnvBinaryHigh(Years).. Env(Years) =L=1;
     EnvBinaryLow(Years).. Env(Years) =G= 0;

*Function being maximized in this model
     TotalEnv.. Env('Y1')+Env('Y2')+Env('Y3')+Env('Y4')+Env('Y5')=E=Yenv;

*2.) Define Storage and Outflow Constraint Equations

*Flow is always less than bypass tunnel and spillway capacity
     MMaxFlowOut(Months,Years).. X('Dam',Months,Years) =L= MaxFlowOut;

*Flow is always greater than hydropower constraints
      Hydro(Months, Years).. X('Dam',Months,Years)=G=HydroPower(Months);

*Flow is always greater than baseflow constraints, ColoradoPikeMinnow Summer Base Flows are built into BaseFlows
     BF(Months,Years).. X('Dam',Months,Years)=G= BaseFlows(Months,Years);

*Minimum storage constraint. Corresponds to reservoir elevation midway between rated hydropower
*Elevation and minimum hydropower elevation needed for hydropower
         MMinStore(Months,Years).. X('Res',Months,Years) =G= MinStore;

*Maximum storage constraint. Corresponds to
         MMaxStore(Months,Years).. X('Res',Months,Years)=L= MaxStore;

*3.) Define Enviromental MIP LTRP Flow
*When this contraint is satisified Enviromental flows are met, I am fairly sure
*Multiplying the EnviroFlows parameter by the Env Variable will allow the model
*Flexibility in choosing to trying to meet enviromental flows or using hydropower
*constraint in June
         Enviro(Years).. X('Dam','M6',Years)=G= Env(Years)*EnviroFlows(Years,'W3');

*4.) Define Minimum allowable total flow to Lake Powell for 5 year period
*Note: I am going to start this constraint extremely low and then increment to see
*when it binds, and finally when it causes the model to become unfeasible
*This will be difficult for determininigs mixes of wet, dry, avg years
*I believe intial storage volume will heavily influence this constraint aswell

*3.) Define Massbalance Equations
*Intial Reservoir Mass Balance, defines one set of equations, 1 total
IResMB.. X('Res','M1','Y1')= FlowIn('M1', 'Y1')+IntStrg-X('Dam','M1','Y1')

* Reservoir Mass Balance, defines one set of equations, 5 total
ResMB..(Months,'Y1')$(ORD(Month)ge 2 ).. X('Res',Months,'Y1')= FlowIn(Months,'Y1')+X('Res',Months-1,'Y1')-X('Dam',Months,'Y1')    ;
ResMB..(Months,Years)$(ORD(Years)ge 2 ).. X('Res',Months,Years)= FlowIn(Months,Years)+X('Res',Months-1,Years)-X('Dam','M1','Y1')


*5. DEFINE the MODEL from the Equations
MODEL FlamingGorge /ALL/;
*IrrigationMaximization.OptFile = 1;
*        Display Slack Variables Rather Than LB and UB
         option solslack = 1;

*6. Solve the Model as an MIP
SOLVE FlamingGorge USING MIP MAXIMIZING Yenv;

*7. Dump File to Excel Workbook
Execute_Unload "HW5_MIP_V2.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW5_MIP_V2.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.







