function gf=ref_wfac(g,a,M)
%REF_WFAC  Compute window factorization
%  Usage: gf=ref_wfac(g,a,M);

% The commented _nos code in this file can be used to test
% the _nos versions of the C-library.

L=size(g,1);
R=size(g,2);

N=L/a;
b=L/M;

c=gcd(a,M);
p=a/c;
q=M/c;
d=N/q;

gf=zeros(p,q*R,c,d);
gf_nos=zeros(d,p,q*R,c);

for w=0:R-1
  for s=0:d-1
    for l=0:q-1
      for k=0:p-1	    
	gf(k+1,l+1+q*w,:,s+1)=g((1:c)+c*mod(k*q-l*p+s*p*q,d*p*q),w+1);
	%gf_nos(s+1,k+1,l+1+q*w,:)=g((1:c)+c*mod(k*q-l*p+s*p*q,d*p*q),w+1);
      end;
    end;
  end;
end;

% dft them
if d>1
  gf=fft(gf,[],4);
  %gf_nos=fft(gf_nos);
end;

% Scale by the sqrt(M) comming from Walnuts representation
gf=gf*sqrt(M);
%gf_nos=gf_nos*sqrt(M);

%gf_nos=permute(gf_nos,[2, 3, 4, 1]);

%norm(gf_nos(:)-gf(:))

gf=reshape(gf,p*q*R,c*d);
%OLDFORMAT
