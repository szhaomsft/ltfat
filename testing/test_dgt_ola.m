function test_failed=test_dgt_ola
%TEST_DGT_OLA  Test DGT Overlap-add implementation
%
%  This script runs a throrough test of the DGT using the OLA algorithm,
%  testing it on a range of input parameters.
%
      
Lr  = [48,420, 4, 8];
ar  = [ 2,  3, 2, 2];
Mr  = [ 4,  4, 4, 4];
glr = [ 8, 24, 4, 4];
blr = [16, 60, 4, 4];

test_failed=0;

disp(' ===============  TEST_DGT_OLA ================');

disp('--- Used subroutines ---');

which comp_dgt_ola
which comp_dgtreal_ola

for ii=1:length(Lr);

  L=Lr(ii);
  
  M=Mr(ii);
  a=ar(ii);
  gl=glr(ii);
  bl=blr(ii);

  b=L/M;
  N=L/a;
  
  for W=1:3

    for rtype=1:2
      
      if rtype==1
        rname='REAL ';	
        f=randn(L,W);
        g=randn(gl,1);        

        c1 = comp_dgtreal_ola(f,g,a,M,bl);
        c2 = dgtreal(f,g,a,M);

      else
        rname='CMPLX';	
        f=crand(L,W);
        g=crand(gl,1);

        c1 = comp_dgt_ola(f,g,a,M,bl);
        c2 = dgt(f,g,a,M);

      end;
        
      res = c1-c2;
      res = norm(res(:));
      
      [test_failed,fail]=ltfatdiditfail(res,test_failed);
      s=sprintf('REF %s L:%3i W:%3i a:%3i M:%3i gl:%3i bl:%3i %0.5g %s',...
                rname,L,W,a,M,gl,bl,res,fail);
      disp(s)
      
    end;
  
  end;
  
end;
      

%OLDFORMAT
