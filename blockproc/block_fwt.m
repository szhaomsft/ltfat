function c = block_fwt( f, h, J)
%BLOCK_FWT FWT func. wrapper for a block processing
%   Usage: 
%
%   Input parameters:
%         f     : Input data.
%         h     : Analysis Wavelet Filterbank. 
%         J     : Number of filterbank iterations.
%         Lb    : Length of the block.
%         Sb    : Starting index.
%
%   Output parameters:
%         c      : Coefficient vector.
%
% `c = block_fwt(f,h,J,Lb, Sb)` acceppts suitably extended block of data *f*
% and produces correct coefficients. *f* is expected to be a collumn vector
% or a matrix and the processing is done columnwise.
%
% From 
%
% Function should be independent of block_interface.
%
% See also: block, blockread, blockplay, plotblock
%
% References: 

if nargin<3
  error('%s: Too few input parameters.',upper(mfilename));
end;

% Initialize the wavelet filters structure
%h = fwtinit(h,'ana');

if any(h.a~=h.a(1))
   error('%s: Non-equal subsampling factors are not supported.',upper(mfilename));
end

% Extended block length 
Ls = size(f,1);
% Low-pass filter length
m = numel(h.h{1}.h);
% Low-pass subsampling factor
a = h.a(1);
% Extension length
rred = (a^J-1)/(a-1)*(m-a);
% Block boundaries
blocksize=h.a(1)^J;
% Input signal samples to be processed
L=rred+floor((Ls-rred)/blocksize)*blocksize;

levelLen = L;
filtNo = length(h.h);
subbNo = (filtNo-1)*J+1;
Lc = zeros(subbNo,1);
runPtr = 0; 
for jj=1:J
   for ff=filtNo:-1:2
      Lc(end-runPtr) = floor((levelLen-m-1)/h.a(ff));
      runPtr = runPtr + 1;
   end
   levelLen = floor((levelLen-m-1)/h.a(1));
end
Lc(1)=levelLen; 

% 
%[Lc, L] = fwtclength(Ls,h,J,'valid');

% Crop to the right length
if(Ls>L)
   f=postpad(f,L); 
end

m = numel(h.h{1}.h);
a = h.a(1);
rred = (a^J-1)/(a-1)*(m-a);
if Ls<rred+a^J
   error('%s: Insufficient input signal length for the %s flag. Minimum is %i.',upper(mfilename),'''valid''',rred+a^J);
end

c = comp_fwt(f,h.h,J,h.a,Lc,'valid');

% Do the cropping 
filtNo = length(h.h);
runPtr = 0; 
for jj=1:J-1
   for ff=filtNo:-1:2
      cstart = (a^(J-jj)-1)/(a-1)*(m-a);
      c{end-runPtr} = c{end-runPtr}(cstart+1:end,:);
      runPtr = runPtr + 1;
   end
end 

% To the pack format
c = cell2mat(c);