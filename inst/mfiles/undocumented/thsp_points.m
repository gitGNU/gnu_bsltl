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

function Y = thsp_points(DATA, POINTS);
%
%  This function evaluates the THSP (Time History Speckle Patterns) of a set
%  points selected in DATA(:,:,1), and through DATA(:,:,k) 
%  for all k value. Similarly to [1][2] the THSP is calculated.
%
%  References:
%  [1]  OULOMARA, G.; TRIBILLON, J.; DUVERNOY, J. Biological activity measurements 
%       on botanical specimen surfaces using a temporal decorrelation effect of 
%       laser speckle. Journal of Moderns Optics, London, v. 36, n. 2, p. 136-179, 
%       Feb. 1989.
%
%  [2]  XU, Z.; JOENATHAN, C.; KHORANA, B. M. Temporal and spatial properties of 
%       the time-varying speckles of botanical specimens. Optical Engineering, Virginia, 
%       v. 34, n. 5, p. 1487-1502, May 1995.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Y = thsp_points(DATA, POINTS);
%  
%  Input:
%  DATA    is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%          intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represent NLIN and
%          N(1,2) represent NCOL and
%          N(1,3) represent NTIMES.
%  POINTS  is a matrix with two columns and M lines,
%          where each line represent one point in study as (line,column).
%          Or a column vector with M lines,
%          where each line represent one point in study as a linear index.
%          A matrix is linearly indexed moving from one column to next, 
%          filling up all rows in each column.
%
%  Output:
%  Y      is the time history speckle patterns. Where Y is a 2D matrix with
%         M lines and NTIMES columns.

%
%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%
%  Date:   08 of February of 2016.
%  Review: 25 of May of 2016.
%
    NSIZE = size(DATA); 
    NLIN  = NSIZE(1,1);
    NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	M = size(POINTS,1);
	L = size(POINTS,2);

	if ~( (L==2)||(L==1) )
		error('The second parameter should be of size [M 2] or [M 1].');
	end


	Y = zeros(M,NTIMES);

	for b = 1:M

			if (L==2)
	            lin=POINTS(b,1);
				col=POINTS(b,2);
			else
				[lin, col] = ind2sub ([NLIN, NCOL], POINTS(b,1));
			end

            for c = 1:NTIMES                
                Y(b,c) = DATA(lin,col,c);
            end
	end
    
end

