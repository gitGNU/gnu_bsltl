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

function [GIM] = graphim(DATA,varargin)
%
%  This function implements the Inertia Moment (IM) [1] method, only on a pixel-by time, 
%  with the normalization of the co-occurrence matrix (COM) proposed by 
%  CARDOSO, R.R. et al. [2]. The function returns the graphic IM method.
%  Use as input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $GIM=\frac{1}{NTIMES-1}\sum\limits_{k=1}^{NTIMES-1}(I(k)-I(k+1))^2 \approx E[(I(k)-I(k+1))^2]$
%
%  References:
%  [1]  ARIZAGA, R. et al. Speckle time evolution characterization by the 
%       co-occurrence matrix analysis. Optics and Laser Technology, Amsterdam, 
%       v. 31, n. 2, p. 163-169, 1999.
%  [2]  R.R. Cardoso, R.A. Braga, Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis, Optics and Lasers in Engineering, 
%       Volume 63, December 2014, Pages 19-24, ISSN 0143-8166, 
%       http://dx.doi.org/10.1016/j.optlaseng.2014.06.004.
% 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  GIM = graphim(DATA);
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
%  GIM  returns the Generalized Difference matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>     
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.bf>
%  
%  Date: 10 of July of 2015.
%  Review: 09 of March of 2016.
% 

    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);
    
    if (NTIMES<2)
        error('Number of frames used are not enough')
    end
    
    GIM = zeros(NLIN,NCOL);
          
    for k = 1:NTIMES-1
 
        GIM = (DATA(:,:,k) - DATA(:,:,k+1)).^2 + GIM;
    end

	GIM=GIM/(NTIMES-1);

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off')) 
		figure                 
    	imagesc(GIM); colorbar
    	title('Graphic IM Method');
		daspect ([1 1 1]);
	end
        
