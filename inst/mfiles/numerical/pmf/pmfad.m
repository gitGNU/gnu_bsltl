%  Copyright (C) 2015, 2016   Fernando Pujaico Rivera
%
%  This file is a part of the Bio Speckle Laser Tool Library (BSLTL) package.
%
%  This BSLTL computer package is free software; you can redistribute it
%  and/or modify it under the terms of the GNU General Public License as
%  published by the Free Software Foundation; either version 3 of the
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

function [Pr varargout ]=pmfad(COM)
%
%  The probability mass function of absolute difference (PMFAD) represents the 
%  probabilities of a random variable Z, being $Z=|i-j|$.
% 
%  $Pr(z+1)= P(|i-j|=z)$, $0 \leq z \leq 255$
%
%  Where i is one intensity id line in COM matrix and j is one intensity id column 
%  in COM. Thus $Pr(z+1)= P(|i-j|=z)$ is the probability of happen an absolute
%  intensity jump of value z. This function calculates the difference probability [1].
%  The COM matrix needs a matrix of 256x256 elements.
%
%  References:
%  [1]  R.M. Haralick, K. Shanmugam, and Its' Hak Dinstein. 'Textural Features 
%       for Image Classification'. In: Systems, Man and Cybernetics, IEEE 
%       Transactions on SMC-3.6 (Nov. 1973), pages 610-621. ISSN: 0018-9472. 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Pr = pmfad(COM);
%  
%  Input:
%  COM  is the Co-Occurrence matrix. A 2D matrix with 256 lines and 256 columns.
%
%  Output:
%  Pr   is the probability mass function, where  $Pr(z+1)= P(|i-j|=z)$ is the 
%       probability of happen an absolute intensity jump of value z. 0<=z<=255
%       Pr is a vector with 256 elements.
%  Z    [OPTIONAL] is a vector with the absolute intensities jumps $|i-j|=z$.
%       Z=[0:255];
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%	

%  Code developed by:  Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>                  
%  Code documented by: Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com> 
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 01 of July of 2015.
%  Review: 07 of July of 2015.
%  Review: 28 of March of 2016.
%
    Nsize = size(COM); 
	if( (Nsize(1,1)~=256)||(Nsize(1,2)~=256) )
		error('The co-occurrence matrix is not 256x256!!!.');
	end

	Pr=zeros(1,256);

	Ntot=sum(sum(COM));

    for a1 = 1:Nsize(1,1)
    for a2 = 1:Nsize(1,2) 
            Pr(1,round(abs(a1-a2)+1))=Pr(1,round(abs(a1-a2)+1))+COM(a1,a2)/Ntot;
    end
    end

	if(nargout>=2)
		varargout{1}=[0:255];
	end

end
