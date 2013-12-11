#include "config.h"
#include "ltfat.h"
#include "ltfat_types.h"




LTFAT_EXTERN void
LTFAT_NAME(idgt_long)(const LTFAT_COMPLEX *cin, const LTFAT_COMPLEX *g,
			  const int L, const int W,
			  const int a, const int M,
			  LTFAT_COMPLEX *f)
{
LTFAT_COMPLEX *gf = (LTFAT_COMPLEX*) ltfat_malloc(L*sizeof(LTFAT_COMPLEX));
LTFAT_NAME_COMPLEX(wfac)(g, L, 1, a, M, gf);

LTFAT_NAME(idgt_fac)(cin, (const LTFAT_COMPLEX*) gf, L, W,a, M, f);

ltfat_free(gf);
}



LTFAT_EXTERN void
LTFAT_NAME(idgtreal_long)(const LTFAT_COMPLEX *cin, const LTFAT_REAL *g,
			      const int L, const int W,
			      const int a, const int M,
			      LTFAT_REAL *f)
{
// TO DO: Is it possible to use wfacreal? wfacreal_size(L,a,M)

LTFAT_COMPLEX *gf = (LTFAT_COMPLEX*) ltfat_malloc(L*sizeof(LTFAT_COMPLEX));
LTFAT_NAME(wfac)(g, L, 1, a, M, gf);

LTFAT_NAME(idgtreal_fac)(cin, (const LTFAT_COMPLEX*) gf, L, W,a, M, f);

ltfat_free(gf);
}