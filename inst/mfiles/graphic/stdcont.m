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

function [C varargout] = stdcont(DATA,varargin)
%
%  This function implements the temporal speckle contrast matrix [1], the temporal 
%  speckle standard deviation matrix and the temporal speckle mean matrix. Use as
%  input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $MU= \frac{1}{NTIMES} \sum\limits_{k=1}^{NTIMES} I(k) \approx E[I(k)]$
%
%  $SIGMA = \sqrt{ \frac{1}{NTIMES} \sum\limits_{k=1}^{NTIMES} (I(k)-MU)^2  }$
%
%  With difference of proposed in [1], here is used the population standard
%  deviation. Finally
%
%  $C = SIGMA/MU$
%
%  The function additionally also returns the deviation and expected matrices.
%
%  Reference:
%  [1] R. Nothdurft and G. Yao, 'Imaging obscured subsurface inhomogeneity using 
%      laser speckle,' Opt. Express  13, 10034-10039 (2005). 
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  C       = stdcont(DATA);
%  [C D]   = stdcont(DATA);
%  [C D E] = stdcont(DATA);
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
%  C    returns the speckle contrast matrix of image Data Pack.
%  D    [Optional] Returns the standard deviation matrix (SIGMA) of image Data Pack.
%  E    [Optional] Returns the expected matrix (MU) of image Data Pack.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 16 of July of 2015.
%  Review: 09 of March of 2016.
%  
    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);
    
    if (NTIMES<2)
        error('Number of frames used are not enough.');
    end
    
    
    SIGMA = zeros(NLIN,NCOL);
    ED = zeros(NLIN,NCOL);
            
	for k = 1:NTIMES                
        ED = ED+ DATA(:,:,k) ;
    end
	ED=ED/NTIMES;

    for k = 1:NTIMES 
                     
        SIGMA =  SIGMA + (DATA(:,:,k)-ED).^2;
    end
    

    SIGMA = sqrt(SIGMA/(NTIMES)) ;

	C=SIGMA./(ED);


	if(nargout>=2)
		varargout{1}=SIGMA;
	end

	if(nargout>=3)
		varargout{2}=ED;
	end

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off')) 
		figure   
	    imagesc(ED); colorbar;
	    title('Images: Speckle Mean');
		daspect ([1 1 1]);   
    
		figure   
	    imagesc(SIGMA); colorbar;
	    title('Images: Speckle Standard Deviation');      
		daspect ([1 1 1]);

		figure   
	    imagesc(C); colorbar;
	    title('Images: Speckle Contrast');      
		daspect ([1 1 1]);
	end
