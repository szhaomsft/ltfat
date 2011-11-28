function [s,fs]=traindoppler()
%TRAINDOPPLER  Load the 'traindoppler' test signal.
%   Usage:  s=traindoppler;
%
%   TRAINDOPPLER loads the 'traindoppler' signal. It is a recording
%   of a train passing close by with a clearly audible doppler shift of
%   the train whistle sound.
%
%   [sig,fs]=TRAINDOPPLER additionally returns the sampling frequency fs.
%
%   The signal is 157058 samples long and sampled at 8 kHz.
%
%   The signal was obtained from
%      http://www.fourmilab.ch/cship/doppler.html

%   AUTHOR : Peter Soendergaard
%   TESTING: TEST_SIGNALS
%   REFERENCE: OK
  
if nargin>0
  error('This function does not take input arguments.')
end;

f=mfilename('fullpath');

s=wavread([f,'.wav']);
fs=8000;
