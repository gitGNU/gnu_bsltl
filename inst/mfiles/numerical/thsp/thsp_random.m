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

function [Y varargout] = thsp_random(DATA, M,varargin)
%
%  This function creates the THSP (Time History Speckle Pattern)[1][2] of a set
%  of  M points (pixels) randomly (Uniform) selected in DATA(:,:,1), and through 
%  DATA(:,:,k) for all k value.
%
%  References:
%  [1]  OULOMARA, G.; TRIBILLON, J.; DUVERNOY, J. Biological activity measurements 
%       on botanical specimen surfaces using a temporal decorrelation effect of 
%       laser speckle. Journal of Moderns Optics, London, v. 36, n. 2, p. 136-179, 
%       Feb. 1989.
%
%  [2]  XU, Z.; JOENATHAN, C.; KHORANA, B. M. Temporal and spatial properties of 
%       the time-varying speckles of botanical specimens. Optical Engineering, Virginia, 
%       v. 34, n. 5, p. 1487-1502, May 1995.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Y         = thsp_random(DATA, M);
%  [Y POINTS]= thsp_random(DATA, M);
%  [Y POINTS]= thsp_random(DATA, M, 'on');
%  
%  Input:
%  DATA    is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%          intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represents NLIN and
%          N(1,2) represents NCOL and
%          N(1,3) represents NTIMES.
%  M       is the number of points, randomly selected, in analysis.
%  Show    [Optional] can be used in the last position of input, and its
%          function is to enable a graphic outcome of selected points in the
%          THSP. Show='on' to enable. And disable in other cases, by default Show='off'.
%
%  Output:
%  Y      is the time history speckle pattern. Where Y is a 2D matrix with
%         M lines and NTIMES columns.
%  POINTS [Optional] is a matrix with two columns and 
%         M lines. Thus, each line represents one point under study. (line,column).
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%                      Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of May of 2013.
%  Review: 28 of March of 2016.
%
    a     = size(DATA); 
    NLIN  =a(1,1);
    NCOL  =a(1,2);
	NTIMES=a(1,3);

	Y      = zeros(M,NTIMES);        
	POINTS = zeros(M,2);

	for b = 1:M

            lin = randi(NLIN);	col = randi(NCOL);
            POINTS(b,1) = lin;	POINTS(b,2) = col;

            for c = 1:NTIMES                
                Y(b,c) = DATA(lin,col,c);
            end
	end

	SHOW='off';

	if(nargin>2)
		for II=3:nargin
			if(ischar(varargin{II-2}))
				SHOW=varargin{II-2};
			end
		end
	end

	if(strcmp(SHOW,'on'))
		imagesc(DATA(:,:,1));
		hold on;
		scatter(POINTS(:,2),POINTS(:,1),'r');
		refresh 
		hold off;
	end


	if(nargout >=2)
		varargout{1}=POINTS;
	end
    
end

