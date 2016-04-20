%  Copyright (C) 2015, 2016   Roberto Alves Braga Junior
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

function [Y] = fujii(DATA,varargin)
%
%  This function implements the Fujii Technique [1]. Use as
%  input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $FUJII=\sum\limits_{k=1}^{NTIMES-1} \frac{|I(k)-I(k+1)|}{I(k)+I(k+1)+eps}$
%
%  The function is normalized to:
%
%  $Y=FUJII \frac{200}{NTIMES-1}$
%
%  Where (NTIMES-1) is the number of elements in the sum, 2 is a factor to
%  to do $(I(k)+I(k+1))/2$, a mean value, and 100 is a percentage factor.
%  Thus the Y matrix represents the expected percentage value of absolute difference 
%  $|I(k)-I(k+1)|$ relative to the mean value $(I(k)+I(k+1))/2$ for any two 
%  consecutive values.
%
%  $Y \approx 100*E[\frac{|I(k)-I(k+1)|}{(I(k)+I(k+1))/2}]$
%
%  References:
%  [1] FUJII, H. et al. Evaluation of blood flow by laser speckle image sensing. 
%      Applied Optics, New York, v. 26, n. 24, p. 5321-5325, 1987.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Y = fujii(DATA);
%  
%  Input:
%  DATA is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represents NLIN and
%       N(1,2) represents NCOL and
%       N(1,3) represents NTIMES.
%  SHOW [Optional] If SHOW is equal to the string 'off', then do not plot the result.
%
%  Output:
%  Y   returns the Fujii matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%  Code documented by: Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>          
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of May of 2013.
%  Review: 09 of March of 2016.
%
    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);
    
    if (NTIMES<2)
        error('Number of frames used are not enough.');
    end
    
    Y = zeros(NLIN,NCOL);
            
    for k = 1:NTIMES-1
        Y = abs(DATA(:,:,k) - DATA(:,:,k+1))./(DATA(:,:,k) + DATA(:,:,k+1) + eps) + Y;
    end
        
	Y=Y*200/(NTIMES-1);

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off')) 
		figure
    	imagesc(Y);colorbar
    	title('Fujii Method'); 
		daspect ([1 1 1]);
	end     

