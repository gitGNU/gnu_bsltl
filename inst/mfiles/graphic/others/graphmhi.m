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

function MHI=graphmhi(DATA,U,varargin)
%
%  This function implements  the Motion History Image (MHI) technique [1-2], 
%  and considers a pixel as in activity, where it should have an 
%  absolute intensity jump superior to U.  
%
%  References:
%  [1]  Davis, J.W., 'Hierarchical motion history images for recognizing human 
%       motion,' Detection and Recognition of Events in Video, 2001. Proceedings. 
%       IEEE Workshop on , vol., no., pp.39,46, 2001. doi: 10.1109/EVENT.2001.938864
%  [2]  R.P. Godinho, M.M. Silva, J.R. Nozela, R.A. Braga, 'Online biospeckle assessment
%       without loss of definition and resolution by motion history image', 
%       Optics and Lasers in Engineering, Volume 50, Issue 3, March 2012, Pages 366-372,
%       ISSN 0143-8166, http://dx.doi.org/10.1016/j.optlaseng.2011.10.023.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  graphmhi(DATA,U);
%  graphmhi(DATA,U,'off');
%  
%  Input:
%  DATA     is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%           intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%           N(1,1) represents NLIN and
%           N(1,2) represents NCOL and
%           N(1,3) represents NTIMES.
%  U        is the activity threshold. Only considered as activity, it changes the 
%           intensity values larger than U.
%  SHOW     [Optional] If SHOW is equal to string 'off' then not plot the result.
%           By default 'on'.
%
%  Output:
%  MHI      is the motion history image matrix of data pack. The elements, in 
%           the matrix, with higher values pertain to most recent activities
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>                    
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 09 of July of 2015.
%  Review: 23 of March of 2016.
%
    NSIZE = size(DATA); 
    NLIN  = NSIZE(1,1);
    NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	% subtration of two images in sequence
    S = cell(1,NTIMES-1);
    for JJ = 1 : NTIMES-1
        S{JJ} = abs( DATA(:,:,JJ) - DATA(:,:,JJ+1) );
    end
     
	% threshold U
    T = cell(1,NTIMES-1);
    for JJ = 1 : NTIMES-1
        T{JJ} = ( S{JJ} > U );
    end
    clear S;

	% composition of the final image with weighting 
    MHI = zeros(NLIN,NCOL);

    k = 255 / sum(1:NTIMES-1);
    for JJ = 1 : NTIMES-1
        MHI = MHI + T{JJ} * (k * JJ);
    end
    clear T;

	SHOW='';
	if(nargin>=3)
		if(ischar(varargin{1}))
			SHOW=varargin{1};
		end
	end

	if ( ~strcmp(SHOW,'off')) 
	    imagesc(MHI); 
	    title('Motion History Image');
		daspect ([1 1 1]);
	end
end
