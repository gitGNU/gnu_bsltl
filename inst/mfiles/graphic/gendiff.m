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

function [Y] = gendiff(DATA,varargin)
%
%  This function implements the Generalized Difference Technique [1]. Use as
%  input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  I(k)=DATA(:,:,k)
%
%  $GD=\sum\limits_{k=1}^{NTIMES-1} \sum\limits_{l=1}^{NTIMES-k} |I(k)-I(k+l)|$
%
%  The function is normalized  with the number of elements in the sum.
%
%  $Y=\frac{GD}{\binom{NTIMES}{2}}$
%
%  Where $\binom{NTIMES}{2}$ is the binomial coefficient of NTIMES and 
%  2. It is the number of combinations of NTIMES items taken 2 at a time.
%  Thus Y matrix represents the expected value of absolute difference 
%  $|I(k1)-I(k2)|$ for any two different k1 and k2 values.
%
%  $Y\approx E[|I(k1)-I(k2)|]$
%
%  Reference:
%  [1] ARIZAGA, R. et al. Display of the local activity using dynamical speckle 
%      patterns. Optical Engineering, Redondo Beach, v. 41, n. 2, p. 287-294, 
%      June 2002.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Y = gendiff(DATA);
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
%  Y    returns the Generalized Difference matrix.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
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
        error('Number of frames used are not enough')
    end
    
    disp('Start G.D. method ...'); 
    
    Y = zeros(NLIN,NCOL);
          
    for k1 = 1:NTIMES-1
        for k2 = 1:NTIMES-k1 
            Y = abs(DATA(:,:,k1) - DATA(:,:,k1+k2)) + Y;
        end

		if(mod(k1,round(NTIMES/10))==0)
			disp([num2str(k1*100/(NTIMES-1)),' %']); 
		end
    end

    disp('[OK]');
	
	Y=Y/nchoosek(NTIMES,2);

	SHOW='';
	if(nargin>=2)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

    if ( ~strcmp(SHOW,'off')) 
		figure                 
    	imagesc(Y); colorbar
    	title('Generalized Difference Method');
		daspect ([1 1 1]);
	end
        
