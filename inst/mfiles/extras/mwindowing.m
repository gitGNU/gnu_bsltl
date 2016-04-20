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

function MATW = mwindowing(MAT,WLines,WColumns)
%
%  This function divides the MAT matrix in windows of WLines lines and WColumns 
%  columns, then in each one of these windows it is calculated the mean value of all 
%  elements. 
%
%  With theirs information is created a new matrix MATW with the same 
%  size and windows of MAT, and the mean values in the MAT matrix are replaced 
%  in all elements, for each window, in the MATW matrix.
%  
%  After starting the main routine just type the following command at the
%  prompt:
%  MATW = mwindowing(MAT,WLines,WColumns);
%  Mean values, of the elements in the window of 8x10 pixels, in the MAT matrix.
%  MATW = mwindowing(MAT,8,10);
%  
%  Input:
%  MAT      is a matrix with NLIN lines and NCOL columns.
%  WLines   is the number of lines in each analysis window.
%  WColumns is the number of columns in each analysis window.
%
%  Output:
%  MATW     is a matrix with the mean values, of the elements in 
%           the window of WLinesxWColumns pixels, in the MAT matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 09 of August of 2015.
%  Review: 25 of February of 2016.
%
    NSIZE = size(MAT);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);

	if(rem(NLIN,WLines)~=0)
		TEXT1=['WLines must be multiple of: ',mat2str(factor(NLIN)),'.'];
		TEXT2=['The last ',num2str(rem(NLIN,WLines)),' pixel lines (botom) were not processed'];
		warning([TEXT1,TEXT2]);
	end

	if(rem(NCOL,WColumns)~=0)
		TEXT1=['WColumns must be multiple of: ',mat2str(factor(NCOL)),'.'];
		TEXT2=['The last ',num2str(rem(NCOL,WColumns)),' pixel columns (right) were not processed'];
		warning([TEXT1,TEXT2]);
	end

    MATW = zeros(NLIN,NCOL);

    
	LINESSTEPS   = 1 : WLines   : NLIN-(WLines  -1);
	COLUMNSSTEPS = 1 : WColumns : NCOL-(WColumns-1);

    for lin = LINESSTEPS
	    for col = COLUMNSSTEPS

			LINES   = lin:lin+(WLines-1);
			COLUMNS = col:col+(WColumns-1);

			MEANVAL  = mean2(MAT(LINES,COLUMNS)); 

			MATW(LINES,COLUMNS)  = MEANVAL;
    	end	
    end

end 

