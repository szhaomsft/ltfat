function definput=arg_firwin(definput)
  
  definput.flags.wintype={'hanning','hann','sqrthan','sqrthann','hamming', ...
                      'sqrtham','square','halfsquare','rect', ...
                      'sqrtsquare','sqrtrect', 'tria','triangular', ...
                      'sqrttria','blackman','blackman2','nuttall', 'ogg','itersine', ...
                      'sine'};

%OLDFORMAT
