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

function [X1 varargout]=threshold2d(X,U)
%
%  It is a function that returns a matrix X with elements smaller than U.
%  For this purpose all elements superior to U are truncated to U.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  X1=threshold2d(X,U);
%  [X1 X2]=threshold2d(X,U);
%
%  Input:
%  X   is a 2D matrix that needs be truncated.
%  U   is the threshold of matrix X. He makes all values higher than U are set to U.
%      U can be the matrix X or a scalar value.
%
%  Output:
%  X1  is the truncated matrix to threshold U.
%  X2  [Optional] is the complement of the truncated matrix to threshold U. 
%      X2 + X1 = X
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date:   08 of July of 2015.
%  Review: 25 of February of 2016.
%
    
    if (length(size(X))~=2)
        error('threshold2d() only work with 2D matrices.');
    end

	if (max(size(U))~=1)
		if (size(U)~=size(X))
        	error('The second parameter only can be a scalar value or a matrix with the same size as the first parameter.');
		end
    end

	X_MENOR =(X<=U);
	X_MAYOR =1-X_MENOR;

	%values smaller than U
	X1=X.*X_MENOR + X_MAYOR.*U;

	if(nargout>=2)
		%complement with values higher than U.
		varargout{1}=X-X1;
	end

end
