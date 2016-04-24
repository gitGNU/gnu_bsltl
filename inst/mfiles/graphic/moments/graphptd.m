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

function [GPTD] = graphptd(DATA,P,varargin)
%
%  This function implements the Parameterized form of Temporal Difference (PTD) 
%  [1] technique. Use as input data a 3D matrix created grouping NTIMES intensity 
%  matrices I(k), 1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $PTD=\sum\limits_{k=1}^{NTIMES-1} |I(k)-I(k+1)|^P$
%
%  The function is normalized  with the number of elements in the sum.
%  Thus, GPTD matrix represents the expected value of absolute difference 
%  $|I(k)-I(k+1)|$ for any k value.
%
%  $GPTD=\frac{PTD}{NTIMES-1} \approx E[|I(k)-I(k+1)|^P]$
%
%  References:
%  [1] Preeti D. Minz, A.K. Nirala, Intensity based algorithms for biospeckle 
%      analysis, Optik - International Journal for Light and Electron Optics, 
%      Volume 125, Issue 14, July 2014, Pages 3633-3636, ISSN 0030-4026, 
%      http://dx.doi.org/10.1016/j.ijleo.2014.01.083.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  GPTD = graphptd(DATA);
%    
%  Input:
%  DATA is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represents NLIN and
%       N(1,2) represents NCOL and
%       N(1,3) represents NTIMES.
%  P    is a parameter whose value may be positive integer as well as fraction.
%  SHOW [Optional] If SHOW is equal to string 'off', then do not plot the result.
%
%  Output:
%  GPTD returns the GPTD matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>    
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 09 of August of 2015.
%  Review: 09 of March of 2016.
%  
    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);
    
    if (NTIMES<2)
        error('Number of frames used are not enough')
    end
    
    GPTD = zeros(NLIN,NCOL);
          
    for k = 1:NTIMES-1
 
        GPTD = abs(DATA(:,:,k) - DATA(:,:,k+1)).^P + GPTD;
    end

	GPTD=GPTD/(NTIMES-1);

	SHOW='';
	if(nargin>=3)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off'))   
		figure                 
	    imagesc(GPTD); colorbar
	    title(['Graphic PTD Method with P=',num2str(P)]);
		daspect ([1 1 1]);
	end
        
