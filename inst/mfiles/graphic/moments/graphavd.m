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

function [GAVD] = graphavd(DATA,varargin)
%
%  This function implements the Absolute Value of the Differences (AVD) method [1], 
%  only using a pixel-by time, with the normalization of the co-occurrence matrix (COM) 
%  proposed by CARDOSO, R.R. et al. [2]. 
%  Use as input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $GAVD=\frac{1}{NTIMES-1}\sum\limits_{k=1}^{NTIMES-1} |I(k)-I(k+1)| \approx E[|I(k)-I(k+1)|]$
%
%
%  References:
%  [1]  BRAGA, R.A. et al. Evaluation of activity through dynamic laser speckle 
%       using the absolute value of the differences, Optics Communications, v. 284, 
%       n. 2, p. 646-650, 2011.
%  [2]  R.R. Cardoso, R.A. Braga, Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis, Optics and Lasers in Engineering, 
%       Volume 63, December 2014, Pages 19-24, ISSN 0143-8166, 
%       http://dx.doi.org/10.1016/j.optlaseng.2014.06.004.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  GAVD = graphavd(DATA);
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
%  GAVD returns the GAVD matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>    
%  Code adapted by:    Roberto A Braga Jr <robertobraga@deg.ufla.br>
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
    
    GAVD = zeros(NLIN,NCOL);
          
    for k = 1:NTIMES-1
 
        GAVD = abs(DATA(:,:,k) - DATA(:,:,k+1)) + GAVD;
    end

   	GAVD=GAVD/(NTIMES-1);

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off')) 
		figure                 
    	imagesc(GAVD); colorbar
    	title('Graphic AVD Method');
		daspect ([1 1 1]);
	end    
