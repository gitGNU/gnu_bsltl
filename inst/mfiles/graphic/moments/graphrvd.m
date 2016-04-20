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

function [GRVD] = graphrvd(DATA,varargin)
%
%  This function implements the Regular Value of the Differences method [1],
%  only on a pixel-by time, with the normalization of the co-occurrence matrix (COM) 
%  proposed by CARDOSO, R.R. et al. [2].
%
%  Use as input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $GRVD=\frac{1}{NTIMES-1}\sum\limits_{k=1}^{NTIMES-1} (I(k)-I(k+1))$
%
%
%  References:
%  [1]  Pujaico Rivera Fernando. Paper coming soon.
%  [2]  CARDOSO, R.R.; BRAGA R.A. Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis. Optics and Lasers in Engineering, 
%       63(Complete):19-24, 2014.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  GRVD = graphrvd(DATA);
%    
%  Input:
%  DATA is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represents NLIN and
%       N(1,2) represents NCOL and
%       N(1,3) represents NTIMES.
%  SHOW [Optional] If SHOW is equal to string 'off', then do not plot the result.
%
%  Output:
%  GRVD returns the GRVD matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>    
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date:   09 of August of 2015.
%  Review: 09 of March of 2016.
%  
    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);
    
    if (NTIMES<2)
        error('Number of frames used are not enough')
    end
    
    GRVD = zeros(NLIN,NCOL);
          
    for k = 1:NTIMES-1
 
        GRVD = (DATA(:,:,k+1) - DATA(:,:,k)) + GRVD;
    end

	GRVD=GRVD/(NTIMES-1);

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off'))  
		figure                 
    	imagesc(GRVD); colorbar
    	title('Graphic RVD Method');
		daspect ([1 1 1]);
	end
        
