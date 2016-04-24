%  Copyright (C) 2015, 2016   Roberto Alves Braga Junior
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

function [C] = coom(THSP)
%
%  This function creates the Co-occurrence matrix (COM)[1]. Also known as GLCM 
%  (gray-level co-occurrence matrices), GLCH (gray-level co-occurrence histograms) 
%  or spatial dependence matrix. 
%
%  References:
%  [1]  ARIZAGA, R. et. al. Speckle time evolution characterization by the 
%       co-occurence matrix analysis. Optics and Laser Technology, Amsterdam, 
%       v. 31, n. 2, p. 163-169, 1999.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  C = coom(THSP);
%  
%  Input:
%  THSP is an integer 2D matrix that represents the time history speckle pattern (THSP). 
%	This matrix can be obtained using the function THSP. It is necessary that the
%	THSP matrix only have values between 0 and 255, the function does not 
%	verify. The function limits the values outside this interval.
%
%  Output:
%  C    is a 2D matrix, with 256 lines and 256 columns, that represents the 
%       Co-Occurrence Matrix of a THSP matrix. The element C(a,b) in the C 
%       co-occurrence matrix represents the quantity of times that, in two 
%       successive columns of a THSP matrix, the intensity values changed from 
%       a-1 to b-1.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%                      Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com> 
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of may of 2013.
%  Review: 15 of august of 2013.
%  Review: 22 of august of 2013.
%  Review: 28 of March of 2016.
%
	a = size(THSP);
	C = zeros(256,256);   

	for linea = 1:a(1,1)
	for col   = 1:a(1,2)-1    

		d1 = THSP(linea,col)+1;
		d2 = THSP(linea,col+1)+1;

		d1=round(d1);
		d2=round(d2);            

		%Limits the value in the range
		if (d1 >= 256)
			d1 = 256;
		end
		if (d1<=1)
			d1=1;
		end
		if (d2 >= 256)
			d2 = 256;
		end
		if (d2<=1)
			d2=1;
		end

		C(d1,d2) = C(d1,d2)+1;
	end
	end
        
    return;    

