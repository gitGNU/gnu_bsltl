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

function [Pr varargout ]=pmfrd(COM)
%
%  The probability mass function of regular difference (PMFRD) represents the 
%  probabilities of a random variable W, being $W=(i-j)$. 
% 
%  $Pr(w+256)=P((i-j)=w)$, $-255 \leq w \leq 255$
%
%  Where i is one intensity id line in COM matrix and j is one intensity id 
%  column in COM. Thus  $Pr(w+256)=P((i-j)=w)$ is the probability of happen an 
%  intensity jump of value i to value $j=i+w$, with -255<=w<=255. This function 
%  calculates a similar difference probability proposed in [1]. The COM matrix 
%  need have 256x256 elements.
%
%  References:
%  [1]  R.M. Haralick, K. Shanmugam, and Its' Hak Dinstein. 'Textural Features 
%       for Image Classification'. In: Systems, Man and Cybernetics, IEEE 
%       Transactions on SMC-3.6 (Nov. 1973), pages 610-621. ISSN: 0018-9472. 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Pr = pmfrd(COM);
%  
%  Input:
%  COM  is the Co-Occurrence matrix. A 2D matrix with 256 lines and 256 columns.
%
%  Output:
%  Pr   is the probability mass function, where  $Pr(w+256)=P((i-j)=w)$ is the 
%       probability of happen an intensity jump of value i to value j=i+w, with 
%       -255<=w<=255. Pr is a vector with 511 elements.
%  W    [OPTIONAL] is a vector with the intensities jumps $(i-j)=w$.
%       W=[-255:255];
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%
	
%  Code developed by:  Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>                     
%  Code documented by: Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com> 
%  Code adapted by:    Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 01 of July of 2015.
%  Review: 07 of July of 2015.
%  Review: 28 of March of 2016.
%
    Nsize = size(COM); 
	if( (Nsize(1,1)~=256)||(Nsize(1,2)~=256) )
		error('The co-occurrence matrix is not 256x256!!!.');
	end

	N=511;
	L=(N+1)/2;

	Pr=zeros(1,N);

	Ntot=sum(sum(COM));


    for a1 = 1:Nsize(1,1)
    for a2 = 1:Nsize(1,2) 
            Pr(1,round(a2-a1)+L)=Pr(1,round(a2-a1)+L)+COM(a1,a2)/Ntot;
    end
    end

	if(nargout>=2)
		varargout{1}=[-255:255];
	end

end
