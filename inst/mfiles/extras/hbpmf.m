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

function H=hbpmf(Pr)
%
%  The function returns the binary entropy of a probability mass function.
%
%  $H=-\sum\limits_i Pr(i)*log_2(Pr(i))$
%  $H=-\sum\limits_{ij} Pr(i,j)*log_2(Pr(i,j))$
%
%  After starting the main routine just type the following command at the
%  prompt:
%  H=hbpmf(Pr);
%
%  Input:
%  Pr   is a probability mass function. The sum of all values Pr(a) could be 1.0.
%       Pr can be a vector or matrix.
%
%  Output:
%  H    The binary entropy of a probability mass function.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date:   08 of July of 2015.
%  Review: 25 of February of 2016.
%
	if(length(size(Pr))~=2)
		error('Pr only can be a 1D vector or 2D marix.');
	end

    if(abs(sum(sum(Pr))-1.0)>128*eps)
		error('Sum Probability is not 1.0');
	end

	N=size(Pr);

	H=0;
	for II=1:N(1,1)
	for JJ=1:N(1,2)
		if(Pr(II,JJ)>0)
			H=H-Pr(II,JJ)*log2(Pr(II,JJ));
		end
	end
	end


end
