%  Copyright (C) 2015, 2016   Fernando Pujaico Rivera
%
%  This file is a part of the Bio Speckle Laser Tool Library (BSLTL) package.
%
%  This BSLTL computer package is free software; you can redistribute it
%  and/or modify it under the terms of the GNU General Public License as
%  published by the Free Software Foundation; either version 2 of the
%  License, or (at your option) any later version.
%
%  This BSLTL computer package is distributed hoping that it could be
%  useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, please download it from
%  <http://www.gnu.org/licenses>.

function [AH varargout]=freqmod(H,N)
% This function returns the modulus of frequency response of function H.
% Frequently H will be a FIR filter.
%
%  If  H    = [h0 h1 h2 ... h(M-1)] then your Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
%  and the function return $AH=|H[Z=e^{jW}]|$ for W from 0 to pi.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  AH=freqmod(H,N)
%  [AH FREQN]=freqmod(H,N);
%  
%  Input:
%  H     is a vector with the parameters of H function. 
%  N     is the number of analysis points in the frequency response.
%  Output:
%  AH     is the modulus of frequency response of function H. 
%         $AH=|H[Z=e^{jW}]|$ for W from 0 to pi.
%  FREQN  [OPTIONAL] is the normalized frequency of points in AH, thus for the 
%         point AH(id) we have W=FREQN(id)*pi.
%  
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 01 of December of 2015.
%  Review: 27 of February of 2016.
%
    M =length(H);
    
    TETA=[0:(N-1)]*pi/(N-1);
    
        
    AH=0;
    for II=1:M
        AH=AH+H(II)*exp(i*TETA*(II-1));
    end
    AH=abs(AH);

    if nargout>1
        %FREQN=[0:(N-1)]/(N-1);
        varargout{1}=[0:(N-1)]/(N-1);
    end
end
