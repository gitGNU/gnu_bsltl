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

function [Y varargout] = thsp_gaussian(DATA, M,Sigma,varargin)
%
%  This function creates the THSP (Time History Speckle Pattern)[1][2] 
%  of a set of M points (pixels) randomly (Gaussian) selected in EXAMPLE_MATRIX, 
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
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma);
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,'on');
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,P0);
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,P0,'on');
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,HG);
%  [Y POINTS]= thsp_gaussian(DATA,M,Sigma,HG,'on');
%  
%  Input:
%  DATA    is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%          intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represents NLIN and
%          N(1,2) represents NCOL and
%          N(1,3) represents NTIMES.
%  M       is the number of points, Gaussian randomly selected, in analysis.
%  Sigma   is the standard deviation in pixels. 
%  P0      [Optional] is the initial point [line column], around this point, M 
%          values are selected to create the time history speckle pattern. If this parameter
%          is not used, then a graphic window is enabled to the selection of a point P0.
%  HG      [Optional] is the used graphic handler; Additionally, it is enable the graphic 
%          selection of a point P0 in the figure pointed by the graphic handler.
%  MAT     [Optional] is a matrix thats enable the graphic 
%          selection of a point P0 in the figure created of imagesc the MAT.
%  Show    [Optional] can be used in the last position of input, and its function 
%          is used to enable a graphic output of the selected points that formed the
%          THSP. Show='on', Show='on-red', Show='on-green' or Show='on-blue' to enable. 
%          It is disabled in other cases, by default Show='off'.
%          Show='on' plot the points in the color red, in other cases are used the
%          specified colors.
%
%  Output:
%  Y      is the time history speckle pattern. Where, Y is a 2D matrix with
%         M lines and NTIMES columns.
%  POINTS [Optional] is a matrix with two columns and 
%         M lines. Thus, each line represents one point in study, (line,column).
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>   
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%                      Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  
%  Date: 09 of July of 2015.
%  Review: 01 of July of 2016.
%
    NSIZE = size(DATA); 
    NLIN  = NSIZE(1,1);
    NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	Y      = zeros(M,NTIMES);        
	POINTS = zeros(M,2);

    EXAMPLE_MATRIX=DATA(:,:,1);



    [P0 HG SHOW]=bsltl_get_point0(varargin{:},EXAMPLE_MATRIX);

    if( (P0(1)<1) || (P0(1)>NLIN) )
        error(sprintf('The line of selected central point is out of datapack line limits. LINE:%d',P0(1)));
    end
    if( (P0(2)<1) || (P0(2)>NCOL) )
        error(sprintf('The column of selected central point is out of datapack column limits. COLUMN:%d',P0(2)));
    end

	POINTS(:,1) = Sigma*randn([M 1])+P0(1);	%%lines
	POINTS(:,2) = Sigma*randn([M 1])+P0(2);	%%columns

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

    bsltl_plot_points(POINTS,HG,EXAMPLE_MATRIX,SHOW);

	if(nargout >=2)
		varargout{1}=POINTS;
	end
    
end

%%
%% Getting a point P0 and HG.
%%
function  [P0 HG SHOW]=bsltl_get_point0(varargin)
    HG=0;
    P0=[0 0];
	SHOW='off';

    %% P0 and HG loaded 
	for II=1:nargin
		if( isvector(varargin{II})  && (length(varargin{II})==2) && ~ischar(varargin{II}) )
		    P0=varargin{II};

		elseif( ishghandle(varargin{II}) )
			HG=figure(varargin{II});
            refresh(HG);

		elseif( ischar(varargin{II}))
			SHOW=varargin{II};

		elseif( (length(size(varargin{II}))==2)&&(min(size(varargin{II}))>=3)&&(HG==0) )
            imagesc(varargin{II});
            HG=gcf;
            refresh(HG);
        end
    end

    if ((P0(1)==0)||(P0(2)==0))
		msgbox('Please select one point');
		[ P0(2) P0(1)]=ginput(1);
    end
end

%%
%% Getting a point P0 and HG.
%%
function  bsltl_plot_points(POINTS,HG,EXAMPLE_MATRIX,SHOW)

	if(strcmp(SHOW,'on') || strcmp(SHOW,'on-red') || strcmp(SHOW,'on-green') || strcmp(SHOW,'on-blue'))

        if(HG==0)
		    imagesc(EXAMPLE_MATRIX);
        end
   
		hold on;

        if(strcmp(SHOW,'on') || strcmp(SHOW,'on-red') )
		    scatter(POINTS(:,2),POINTS(:,1),'r','filled');
        elseif(strcmp(SHOW,'on-green') )
		    scatter(POINTS(:,2),POINTS(:,1),'g','filled');
        elseif(strcmp(SHOW,'on-blue') )
		    scatter(POINTS(:,2),POINTS(:,1),'b','filled');
        end
		refresh 
		hold off;
	end
end

