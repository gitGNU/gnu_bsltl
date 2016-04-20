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

function [Y varargout] = thsp_gaussian(DATA, M,Sigma,varargin)
%
%  This function creates the THSP (Time History Speckle Pattern)[1][2] 
%  of a set of M points (pixels) randomly (Gaussian) selected in DATA(:,:,1), 
%  and through DATA(:,:,k) for all k value.   
%  Around a point P0, M points are selected randomly, these points are concentrated
%  mostly in a radius Sigma around the point P0.
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
%  Y         = thsp_gaussian(DATA,M,Sigma);
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,'on');
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,P0,'on');
%  
%  Input:
%  DATA    is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%          intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represents NLIN and
%          N(1,2) represents NCOL and
%          N(1,3) represents NTIMES.
%  M       is the number of points, Gaussian randomly selected, in analysis.
%  Sigma   is the standard deviation in pixels. 
%  P0      [Optional] is the initial point, around this point, M values are selected 
%          to create the time history speckle pattern. If this parameter
%          is not used, then a graphic window is enabled to the selection of a point P0.
%  Show    [Optional] can be used in the last position of input, and its
%          function is to enable a graphic output of the selected points that formed the
%          THSP. Show='on' to enable. It is disabled in other cases, by default Show='off'.
%
%  Output:
%  Y      is the time history speckle patterns. Where Y is a 2D matrix with
%         M lines and NTIMES columns.
%  POINTS [Optional] is a matrix with two columns and 
%         M lines. Thus, each line represents one point in study.(line,column).
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>   
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 09 of July of 2015.
%  Review: 28 of March of 2016.
%
    NSIZE = size(DATA); 
    NLIN  = NSIZE(1,1);
    NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	Y      = zeros(M,NTIMES);        
	POINTS = zeros(M,2);



	if(nargin<4)
		imagesc(DATA(:,:,1));
		P0=zeros(1,2);	
		msgbox('Please select one point');	
		[ P0(2) P0(1)]=ginput(1);
		disp('Point loaded. Please wait ...');
	else
		if(isvector(varargin{1}) && ~ischar(varargin{1}))
			P0=varargin{1};
		else
			if(~ischar(varargin{1}))
				error('The 4th input parameter should be a vector [a b].');
			else
				imagesc(DATA(:,:,1));
				P0=zeros(1,2);		
				msgbox('Please select one point');
				[ P0(2) P0(1)]=ginput(1);
				disp('Point loaded. Please wait ...');
			end
		end
	end

	POINTS(:,1) = Sigma*randn([M 1])+P0(1);	
	POINTS(:,2) = Sigma*randn([M 1])+P0(2);

	for m = 1:M	
		POINTS(m,1)=round(POINTS(m,1));
		POINTS(m,2)=round(POINTS(m,2));
		while ( (POINTS(m,1)<1) || (POINTS(m,1)>NLIN) || (POINTS(m,2)<1) || (POINTS(m,2)>NCOL) )
			POINTS(m,1) = round(Sigma*randn(1)+P0(1));	
			POINTS(m,2) = round(Sigma*randn(1)+P0(2));
		end
	end

	for m = 1:M	
		for k = 1:NTIMES                
			Y(m,k) = DATA( POINTS(m,1) , POINTS(m,2) , k);
		end
	end

	SHOW='off';

	if(nargin>3)
		for II=4:nargin
			if(ischar(varargin{II-3}))
				SHOW=varargin{II-3};
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

