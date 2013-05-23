function c = blockana(F, f)
%BLOCKANA Blockwise analysis interface
%   Usage: blockana(F, f)
%
%   Input parameters:
%      F  : Frame object.
%      f  : Analyzed block.
%   Output parameters:
%      c  : Block coefficients.
%
%   `c=blockana(F, f)` calculates coefficients `c` of block `f` using 
%   frame defined by `F`.

if nargin<2
  error('%s: Too few input parameters.',upper(mfilename));
end;

if ~isstruct(F)
  error('%s: First agument must be a frame definition structure.',upper(mfilename));
end;

% Block length
Lb = size(f,1);
% Next block index start (from a global point of view, starting with zero)
nextSb = block_interface('getPos');
% Block index start (from a global point of view, starting with zero)
Sb = nextSb-Lb;

switch(F.type)
   case 'fwt'
      J = F.J;
      w = F.g;
      m = numel(w.h{1}.h);
      a = w.a(1);
      rred = (a^J-1)/(a-1)*(m-a);
      Sbolen = rred + mod(Sb,a^J);
      nextSbolen = rred + mod(nextSb,a^J);
      fext = [loadOverlap(Sbolen);f];
      c = block_fwt(fext,w,J);
      storeOverlap(fext,nextSbolen);
   otherwise
      % General processing
      % Equal block length assumtion
      % Slicing window
      g = fftshift(firwin('hann',2*Lb));
      % Append the previous block
      fext = [loadOverlap(Lb);f];
      % Save the current block
      storeOverlap(fext,Lb);
      % Multyply by the slicing window (all channels)
      fwin = bsxfun(@times,g,fext);
      % Apply transform
      c = frana(F,fwin);
end

function overlap = loadOverlap(L)
   % Load stored overlap
   overlap = block_interface('getAnaOverlap');
   % Supply zeros if it is empty
   if isempty(overlap)
     overlap = zeros(L,size(f,2),block_interface('getClassId'));
   end
   Lo = size(overlap,1);
   if nargin<1
      L = Lo;
   end
   % If required more than stored, do zero padding
   if L>Lo
      oTmp = zeros(L,size(overlap,2));
      oTmp(end-Lo+1:end) = oTmp(end-Lo+1:end)+overlap;
      overlap = oTmp;
   else
      overlap = overlap(end-L+1:end,:);
   end

end

function storeOverlap(fext,L)
   if L>size(fext,1)
       error('%s: Storing more samples than passed.',upper(mfilename));
   end
   block_interface('setAnaOverlap',fext(end-L+1:end,:)); 
end





end