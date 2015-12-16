************************************************************************
*
*     CheckAPFEL.f:
*
*     Code that tests APFEL against a pretabulated set of results for:
*     - alpha_s,
*     - evolution,
*     - structure functions.
*
************************************************************************
      function CheckAPFEL()
*
      implicit none
**
*     Internal Variables
*
      integer ilha,iQ,iref
      double precision Q20,Q2(4),Q0,Q
      double precision xlha(9)
      double precision eps
      double precision toll
      double precision AlphaQCD,AlphaQED
      double precision xPDFj
      double precision F2light,F2charm,F2bottom,F2total
      double precision FLlight,FLcharm,FLbottom,FLtotal
      double precision F3light,F3charm,F3bottom,F3total
      double precision Ref(616),Act(616)
      character*6 apfelversion
      logical succ
      parameter(eps=1d-10)
      parameter(toll=1d-6)
**
*     Output Variables
*
      logical CheckAPFEL
*
      data Q20  / 2d0 /
      data Q2   / 10d0, 100d0, 1000d0, 10000d0 /
      data xlha / 1d-5, 1d-4, 1d-3, 1d-2, 1d-1, 3d-1, 5d-1, 7d-1, 9d-1 /
      data Ref /
     1     2.442349E-01,
     1     1.193883E-03,  7.485612E-04,  6.868048E+00,  1.831932E+00,
     1     2.655775E+01,
     1     2.059015E+00,  6.994916E-01,  2.093744E-02,  2.779444E+00,
     1     3.875328E-01,  1.006460E-01,  6.703522E-04,  4.888492E-01,
     1     1.256929E-06,  3.480626E-08,  0.000000E+00,  1.291735E-06,
     1     6.082243E-03,  3.673864E-03,  4.311003E+00,  9.826655E-01,
     1     1.708808E+01,
     1     1.261224E+00,  3.495144E-01,  8.853400E-03,  1.619592E+00,
     1     2.664201E-01,  5.551253E-02,  3.046247E-04,  3.222373E-01,
     1     5.598271E-06,  6.595660E-08,  0.000000E+00,  5.664228E-06,
     1     3.154171E-02,  1.862800E-02,  2.635558E+00,  4.839233E-01,
     1     9.870201E+00,
     1     7.693925E-01,  1.513201E-01,  2.724851E-03,  9.234375E-01,
     1     1.677755E-01,  2.700265E-02,  1.043831E-04,  1.948825E-01,
     1     2.491683E-05,  5.059317E-08,  0.000000E+00,  2.496743E-05,
     1     1.600625E-01,  9.286047E-02,  1.506545E+00,  2.030065E-01,
     1     4.752342E+00,
     1     5.042087E-01,  5.023447E-02,  3.238253E-04,  5.547670E-01,
     1     9.453095E-02,  1.008410E-02,  1.414191E-05,  1.046292E-01,
     1     1.074142E-04, -8.526164E-08,  0.000000E+00,  1.073290E-04,
     1     5.924218E-01,  3.096044E-01,  4.698048E-01,  3.807994E-02,
     1     1.253625E+00,
     1     4.001098E-01,  4.724732E-03,  8.339361E-11,  4.048345E-01,
     1     3.948809E-02,  9.000592E-04,  8.355552E-13,  4.038815E-02,
     1     3.524928E-04, -8.802170E-08,  0.000000E+00,  3.524048E-04,
     1     5.532676E-01,  2.227867E-01,  6.641915E-02,  4.042677E-03,
     1     2.148627E-01,
     1     2.810528E-01,  3.739516E-04,  0.000000E+00,  2.814268E-01,
     1     1.391836E-02,  2.616136E-05,  0.000000E+00,  1.394452E-02,
     1     3.456621E-04, -1.528147E-08,  0.000000E+00,  3.456469E-04,
     1     2.609897E-01,  7.458697E-02,  6.246904E-03,  3.558559E-04,
     1     2.982973E-02,
     1     1.422989E-01,  5.475138E-05,  0.000000E+00,  1.423536E-01,
     1     3.877733E-03,  1.452066E-06,  0.000000E+00,  3.879185E-03,
     1     1.850496E-04, -2.078495E-09,  0.000000E+00,  1.850475E-04,
     1     6.207467E-02,  1.058961E-02,  2.033834E-04,  1.262901E-05,
     1     1.897997E-03,
     1     4.198413E-02,  3.426506E-06,  0.000000E+00,  4.198755E-02,
     1     5.307111E-04,  3.336312E-08,  0.000000E+00,  5.307445E-04,
     1     5.476990E-05, -1.416551E-10,  0.000000E+00,  5.476976E-05,
     1     2.065521E-03,  1.169276E-04,  1.786145E-07,  1.856107E-08,
     1     9.042790E-06,
     1     2.383365E-03,  1.084957E-08,  0.000000E+00,  2.383376E-03,
     1     6.606358E-06,  2.196185E-11,  0.000000E+00,  6.606380E-06,
     1     3.038179E-06, -6.766132E-13,  0.000000E+00,  3.038179E-06,
     1     1.762926E-01,
     1     1.954139E-03,  1.216905E-03,  1.480260E+01,  5.849861E+00,
     1     7.855152E+01,
     1     4.585890E+00,  2.393062E+00,  2.258020E-01,  7.204754E+00,
     1     8.643771E-01,  4.778972E-01,  3.458827E-02,  1.376863E+00,
     1     1.746064E-05,  8.735200E-07,  5.625975E-08,  1.839042E-05,
     1     9.179124E-03,  5.493595E-03,  7.968872E+00,  2.851825E+00,
     1     4.029939E+01,
     1     2.437195E+00,  1.143592E+00,  9.857765E-02,  3.679364E+00,
     1     4.565096E-01,  2.385014E-01,  1.594475E-02,  7.109558E-01,
     1     7.497309E-05,  1.534705E-06,  9.885521E-08,  7.660665E-05,
     1     4.313805E-02,  2.516065E-02,  4.048167E+00,  1.223524E+00,
     1     1.807542E+01,
     1     1.238481E+00,  4.742340E-01,  3.592884E-02,  1.748644E+00,
     1     2.133898E-01,  1.027996E-01,  6.186306E-03,  3.223757E-01,
     1     3.193489E-04,  9.258278E-07,  5.979743E-08,  3.203345E-04,
     1     1.923348E-01,  1.096634E-01,  1.856183E+00,  4.124144E-01,
     1     6.410208E+00,
     1     6.423019E-01,  1.523453E-01,  8.868077E-03,  8.035152E-01,
     1     8.335602E-02,  3.327609E-02,  1.652999E-03,  1.182851E-01,
     1     1.289130E-03, -2.187819E-06, -1.410736E-07,  1.286801E-03,
     1     5.809821E-01,  2.953398E-01,  4.385038E-01,  5.498299E-02,
     1     1.104517E+00,
     1     3.995660E-01,  1.793594E-02,  4.402064E-04,  4.179421E-01,
     1     2.301439E-02,  3.467720E-03,  7.904955E-05,  2.656116E-02,
     1     3.636159E-03, -1.691483E-06, -1.094544E-07,  3.634358E-03,
     1     4.561709E-01,  1.770074E-01,  5.062895E-02,  4.449623E-03,
     1     1.403836E-01,
     1     2.355041E-01,  1.282831E-03,  1.599353E-05,  2.368029E-01,
     1     6.772695E-03,  1.576637E-04,  1.105935E-06,  6.931465E-03,
     1     2.929902E-03, -2.397068E-07, -1.558799E-08,  2.929647E-03,
     1     1.872729E-01,  5.127266E-02,  4.097817E-03,  3.195284E-04,
     1     1.631257E-02,
     1     9.969116E-02,  9.026569E-05,  1.696972E-06,  9.978312E-02,
     1     1.632771E-03,  5.393065E-06,  4.420695E-08,  1.638209E-03,
     1     1.293538E-03, -2.727454E-08, -1.774377E-09,  1.293509E-03,
     1     3.796512E-02,  6.170690E-03,  1.134532E-04,  9.210497E-06,
     1     9.196954E-04,
     1     2.327558E-02,  2.893255E-06,  9.159328E-08,  2.327856E-02,
     1     1.868562E-04,  4.886224E-08,  8.943544E-10,  1.869060E-04,
     1     3.004911E-04, -1.465297E-09, -9.587770E-11,  3.004896E-04,
     1     9.481397E-04,  5.100329E-05,  7.582728E-08,  9.419155E-09,
     1     3.918809E-06,
     1     8.613113E-04,  3.945335E-09,  3.732842E-10,  8.613156E-04,
     1     1.694203E-06,  6.795136E-12,  7.518326E-13,  1.694210E-06,
     1     1.086259E-05, -4.911201E-12, -3.031354E-13,  1.086259E-05,
     1     1.394600E-01,
     1     2.604739E-03,  1.607003E-03,  2.424120E+01,  1.060433E+01,
     1     1.449920E+02,
     1     7.744478E+00,  4.549379E+00,  7.811103E-01,  1.307497E+01,
     1     1.274763E+00,  8.093049E-01,  1.624830E-01,  2.246551E+00,
     1     1.980196E-04,  1.008022E-05,  1.450990E-06,  2.095509E-04,
     1     1.175628E-02,  6.980267E-03,  1.178330E+01,  4.787030E+00,
     1     6.467167E+01,
     1     3.731566E+00,  2.038148E+00,  3.319472E-01,  6.101662E+00,
     1     5.771952E-01,  3.587688E-01,  7.026264E-02,  1.006227E+00,
     1     8.327957E-04,  1.669188E-05,  2.403362E-06,  8.518909E-04,
     1     5.229824E-02,  3.025743E-02,  5.302761E+00,  1.874272E+00,
     1     2.480014E+01,
     1     1.681514E+00,  7.798604E-01,  1.190087E-01,  2.580383E+00,
     1     2.265879E-01,  1.350060E-01,  2.561491E-02,  3.872088E-01,
     1     3.441583E-03,  8.060796E-06,  1.164364E-06,  3.450809E-03,
     1     2.150196E-01,  1.212462E-01,  2.100117E+00,  5.591412E-01,
     1     7.286330E+00,
     1     7.499186E-01,  2.276850E-01,  3.060107E-02,  1.008205E+00,
     1     7.167508E-02,  3.696269E-02,  6.674020E-03,  1.153118E-01,
     1     1.317404E-02, -2.511245E-05, -3.619875E-06,  1.314531E-02,
     1     5.656673E-01,  2.821585E-01,  4.102597E-01,  6.179678E-02,
     1     9.649982E-01,
     1     3.947922E-01,  2.414030E-02,  2.416120E-03,  4.213486E-01,
     1     1.576772E-02,  3.184479E-03,  5.016090E-04,  1.945381E-02,
     1     3.297591E-02, -1.609415E-05, -2.327454E-06,  3.295749E-02,
     1     3.925134E-01,  1.484221E-01,  4.111154E-02,  4.291871E-03,
     1     1.018903E-01,
     1     2.052165E-01,  1.644175E-03,  1.167752E-04,  2.069775E-01,
     1     4.132343E-03,  1.473595E-04,  1.795946E-05,  4.297662E-03,
     1     2.318010E-02, -1.996491E-06, -2.899166E-07,  2.317781E-02,
     1     1.457293E-01,  3.872085E-02,  2.993576E-03,  2.752314E-04,
     1     1.064042E-02,
     1     7.699046E-02,  1.071494E-04,  5.710875E-06,  7.710332E-02,
     1     8.945749E-04,  6.215826E-06,  5.224535E-07,  9.013132E-04,
     1     9.022103E-03, -2.021303E-07, -2.932857E-08,  9.021872E-03,
     1     2.630763E-02,  4.132449E-03,  7.381624E-05,  6.985780E-06,
     1     5.526844E-04,
     1     1.543311E-02,  2.820586E-06,  1.260567E-07,  1.543605E-02,
     1     8.961946E-05,  9.125569E-08,  3.736707E-09,  8.971446E-05,
     1     1.795009E-03, -9.462094E-09, -1.366381E-09,  1.794998E-03,
     1     5.332114E-04,  2.768258E-05,  4.067541E-08,  5.732506E-09,
     1     2.019313E-06,
     1     4.260707E-04,  2.189017E-09,  2.108989E-10,  4.260731E-04,
     1     6.444128E-07,  7.225642E-12,  3.943471E-13,  6.444204E-07,
     1     4.857509E-05, -2.313313E-11, -3.267244E-12,  4.857506E-05,
     1     1.156048E-01,
     1     3.190717E-03,  1.953179E-03,  3.472769E+01,  1.587473E+01,
     1     2.200884E+02,
     1     1.388592E+01,  7.509596E+00,  2.126980E+00,  2.352249E+01,
     1     1.966895E+00,  1.133360E+00,  3.759462E-01,  3.476201E+00,
     1     1.216946E-03,  5.842191E-05,  1.032664E-05,  1.285695E-03,
     1     1.402318E-02,  8.274831E-03,  1.561595E+01,  6.725001E+00,
     1     8.879532E+01,
     1     6.195502E+00,  3.163824E+00,  8.588064E-01,  1.021813E+01,
     1     7.989797E-01,  4.549234E-01,  1.491942E-01,  1.403097E+00,
     1     5.036738E-03,  9.210445E-05,  1.628662E-05,  5.145129E-03,
     1     6.001837E-02,  3.451867E-02,  6.417005E+00,  2.449712E+00,
     1     3.040235E+01,
     1     2.543605E+00,  1.144959E+00,  2.901276E-01,  3.978692E+00,
     1     2.770040E-01,  1.528701E-01,  4.935959E-02,  4.792337E-01,
     1     2.030603E-02,  3.556989E-05,  6.313690E-06,  2.034791E-02,
     1     2.324342E-01,  1.299955E-01,  2.277838E+00,  6.674927E-01,
     1     7.791220E+00,
     1     1.003761E+00,  3.087651E-01,  7.034661E-02,  1.382873E+00,
     1     7.519260E-02,  3.640884E-02,  1.147375E-02,  1.230752E-01,
     1     7.436229E-02, -1.437369E-04, -2.544627E-05,  7.419310E-02,
     1     5.499427E-01,  2.703594E-01,  3.852852E-01,  6.443370E-02,
     1     8.527497E-01,
     1     4.497427E-01,  2.931170E-02,  5.430075E-03,  4.844844E-01,
     1     1.370163E-02,  2.582467E-03,  7.807655E-04,  1.706486E-02,
     1     1.688369E-01, -8.001287E-05, -1.421069E-05,  1.687427E-01,
     1     3.462369E-01,  1.283344E-01,  3.460428E-02,  4.008907E-03,
     1     7.890782E-02,
     1     2.073712E-01,  1.844811E-03,  2.819953E-04,  2.094980E-01,
     1     3.186956E-03,  1.072456E-04,  3.084863E-05,  3.325050E-03,
     1     1.065740E-01, -8.960585E-06, -1.598000E-06,  1.065634E-01,
     1     1.186885E-01,  3.081331E-02,  2.320240E-03,  2.371218E-04,
     1     7.640742E-03,
     1     7.012716E-02,  1.126822E-04,  1.498492E-05,  7.025483E-02,
     1     6.242092E-04,  4.416003E-06,  1.191382E-06,  6.298166E-04,
     1     3.763910E-02, -8.293081E-07, -1.477928E-07,  3.763813E-02,
     1     1.953161E-02,  2.988309E-03,  5.235428E-05,  5.543178E-06,
     1     3.710112E-04,
     1     1.239960E-02,  2.766198E-06,  3.231595E-07,  1.240269E-02,
     1     5.565763E-05,  6.965714E-08,  1.625364E-08,  5.574354E-05,
     1     6.653826E-03, -3.405727E-08, -6.152651E-09,  6.653786E-03,
     1     3.352660E-04,  1.693529E-05,  2.487982E-08,  3.897961E-09,
     1     1.171783E-06,
     1     2.718150E-04,  2.009842E-09,  2.678658E-10,  2.718173E-04,
     1     3.289674E-07,  2.508406E-11,  1.261800E-12,  3.289938E-07,
     1     1.441552E-04, -7.117880E-11, -1.186194E-11,  1.441551E-04/
*
      call getapfelversion(apfelversion)
      write(6,*) achar(27)//"[34m"
      write(6,*) "Checking APFEL v",apfelversion," ...",achar(27)//"[0m"
*
*     Settings
*
c      call EnableWelcomeMessage(.false.)
      call SetMassScheme("FONLL-C")
      call SetProcessDIS("NC")
*
*     Compute predictions
*
      call InitializeAPFEL_DIS
*
*     Compare the output with the reference
*
      Q0   = dsqrt(Q20) - eps
      iref = 0
      do iQ=1,4
         Q = dsqrt(Q2(iQ))
         call ComputeStructureFunctionsAPFEL(Q0,Q)
*     alpha_s
         iref = iref + 1
         Act(iref) = AlphaQCD(Q)
*     PDF evolution
         do ilha=1,9
            iref = iref + 1
            Act(iref) = xPDFj(2,xlha(ilha))-xPDFj(-2,xlha(ilha))
            iref = iref + 1
            Act(iref) = xPDFj(1,xlha(ilha))-xPDFj(-1,xlha(ilha))
            iref = iref + 1
            Act(iref) = 2d0*(xPDFj(-1,xlha(ilha))+xPDFj(-2,xlha(ilha)))
            iref = iref + 1
            Act(iref) = xPDFj(4,xlha(ilha))+xPDFj(-4,xlha(ilha)) 
            iref = iref + 1
            Act(iref) = xPDFj(0,xlha(ilha))
*     F_2
            iref = iref + 1
            Act(iref) = F2light(xlha(ilha))
            iref = iref + 1
            Act(iref) = F2charm(xlha(ilha))
            iref = iref + 1
            Act(iref) = F2bottom(xlha(ilha))
            iref = iref + 1
            Act(iref) = F2total(xlha(ilha))
*     F_L
            iref = iref + 1
            Act(iref) = FLlight(xlha(ilha))
            iref = iref + 1
            Act(iref) = FLcharm(xlha(ilha))
            iref = iref + 1
            Act(iref) = FLbottom(xlha(ilha))
            iref = iref + 1
            Act(iref) = FLtotal(xlha(ilha))
*     F_3
            iref = iref + 1
            Act(iref) = F3light(xlha(ilha))
            iref = iref + 1
            Act(iref) = F3charm(xlha(ilha))
            iref = iref + 1
            Act(iref) = F3bottom(xlha(ilha))
            iref = iref + 1
            Act(iref) = F3total(xlha(ilha))
         enddo
      enddo
*
*     Compare present predictions with the reference
*
      succ = .true.
      do iref=1,616
         if((Ref(iref)-Act(iref))/Ref(iref).gt.toll) succ = .false.
      enddo
*
      if(succ)then
         write(6,*) "Check ... ",
     1        achar(27)//"[1;32m","succeded",achar(27)//"[0m"
      else
         write(6,*) "Check ... ",
     1        achar(27)//"[1;31m","failed",achar(27)//"[0m"
      endif
      write(6,*)
      CheckAPFEL = succ
*
*     Code to write the reference table
*
c$$$      Q0 = dsqrt(Q20) - eps
c$$$      write(6,'(a)') "      data Ref /"
c$$$      do iQ=1,4
c$$$         Q = dsqrt(Q2(iQ))
c$$$         call ComputeStructureFunctionsAPFEL(Q0,Q)
c$$$*     alpha_s
c$$$         write(6,'(a,es14.6,a)') "     1   ",AlphaQCD(Q),","
c$$$*     PDF evolution
c$$$         do ilha=1,9
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           xPDFj(2,xlha(ilha)) - xPDFj(-2,xlha(ilha)),",",
c$$$     2           xPDFj(1,xlha(ilha)) - xPDFj(-1,xlha(ilha)),",",
c$$$     3           2d0*(xPDFj(-1,xlha(ilha)) + xPDFj(-2,xlha(ilha))),",",
c$$$     4           xPDFj(4,xlha(ilha)) + xPDFj(-4,xlha(ilha)),","
c$$$            write(6,'(a,es14.6,a)') "     1   ",
c$$$     1           xPDFj(0,xlha(ilha)),","
c$$$*     F_2
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           F2light(xlha(ilha)),",",
c$$$     2           F2charm(xlha(ilha)),",",
c$$$     3           F2bottom(xlha(ilha)),",",
c$$$     4           F2total(xlha(ilha)),","
c$$$*     F_L
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           FLlight(xlha(ilha)),",",
c$$$     2           FLcharm(xlha(ilha)),",",
c$$$     3           FLbottom(xlha(ilha)),",",
c$$$     4           FLtotal(xlha(ilha)),","
c$$$*     F_3
c$$$            write(6,'(a,4(es14.6,a))') "     1   ",
c$$$     1           F3light(xlha(ilha)),",",
c$$$     2           F3charm(xlha(ilha)),",",
c$$$     3           F3bottom(xlha(ilha)),",",
c$$$     4           F3total(xlha(ilha)),","
c$$$         enddo
c$$$      enddo
c$$$      write(6,'(a)') "      /"
*
      return
      end

