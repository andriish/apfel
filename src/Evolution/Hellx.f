************************************************************************
*
*     Hellx.f:
*
*     This function returns the small-x resummed singlet splitting
*     functions.
*     The inputs are:
*     - k      = 4: qq, 5: qg, 6: gq, 7: gg (splittinf function),
*     - alphas = value of alphas,
*     - y      = Bjorken's variable.
*
************************************************************************
      function Hellx(k,alphas,y)
*
      implicit none
**
*     Input Variables
*
      integer k
      double precision alphas
      double precision y
**
*     Internal Variables
*
      double precision Hellx
**
*     Input Variables
*
      call xDeltaP(alphas,y)
      Hellx = 0d0
*
      return
      end
