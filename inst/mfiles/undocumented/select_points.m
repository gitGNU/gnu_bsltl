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

function [P1 varargout] = select_points(DATA,Type,varargin)
%
%  This function select a set of M points, selected according to Type, 
%  in DATA(:,:,1), and through DATA(:,:,k) 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  P1 = select_points(DATA,Type,M);
%  [P1 P2]= select_points(DATA,'random',M,2);
%  [P1 P2 P3]= select_points(DATA,'region',3);
%  
%  Input:
%  DATA    is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%          intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represent NLIN and
%          N(1,2) represent NCOL and
%          N(1,3) represent NTIMES.
%  Type    is the type of selecting points method. These can be:
%          'gaussian' - Need selecting two points; center and deviation radius.
%                       This type select M points chosen randomly (Gaussian)
%                       around one central point. Also is needed add an additional 
%                       input parameter M, with the number of points.
%          'random'   - Need selecting two points; two opposite corners.
%                       This type select M points chosen uniformly random
%                       between two corner points. Also is needed add an additional 
%                       input parameter M, with the number of points
%          'region'   - Need selecting two points; two opposite corners.
%                       This type select all the pixels between two corner points.
%          'line'     - Need selecting two points; begin and end.
%                       This type select all the pixels in a line between two 
%                       corner points.
%  M        [Optional] is the number of points randomly selected.
%           if Type is 'gaussian' or 'random', then M is mandatory and M will be
%           the third input parameter; in other case M is not necessary and the 
%           third input parameter will be Groups.
%  Groups   [Optional] is the number of groups of points to be selected.
%           if Type is 'gaussian' or 'random', Groups is the fourth input parameter
%           in other case, Groups is the third parameter.
%           the groups of points are returned as additional output parameters.
%           by default Groups is 1.
%
%  Output:
%  P1      is a matrix with two columns and M lines. Thus, each line represent 
%          one point in study.(line,column).
%  Pi      is a matrix with two columns and M lines. Thus, each line represent 
%          one point in study.(line,column). the existence of this group of points
%          depend of input parameter Groups.
%

%
%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com> 
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%
%  Date:   08 of February of 2016.
%  Review: 25 of May of 2016.
%
 
    NLIN   = size(DATA,1);
    NCOL   = size(DATA,2);
	NTIMES = size(DATA,3);

	Groups=1;

	if(~ischar(Type))
		error('The second parameter should be a string char.');
	end


	if( strcmp(Type,'gaussian')||strcmp(Type,'random') )
		if (nargin<3)
			cadena=['The function need 3 parameters in the gaussian', ...
					' and random case, See: help select_points'];
			error(cadena);
		end

		if ( (~isnumeric(varargin{1}))||(~isscalar(varargin{1})) )
			cadena=['The third parameter should be a scalar number, ', ...
					'See: help select_points'];
			error(cadena);
		end

		M=varargin{1};

		if (nargin>=4)
			if ( (~isnumeric(varargin{2}))||(~isscalar(varargin{2})) )
				cadena=['The fourth parameter should be a scalar number, ', ...
						'See: help select_points'];
				error(cadena);
			end

			Groups=varargin{2};
		end

	elseif( strcmp(Type,'region')||strcmp(Type,'line') )
		if (nargin>=3)
			if ( (~isnumeric(varargin{1}))||(~isscalar(varargin{1})) )
				cadena=['The tirth parameter should be a scalar number, ', ...
						'See: help select_points'];
				error(cadena);
			end

			Groups=varargin{1};
		end
	else
		error('The second input parameter is unknown. See: help select_points');
	end

	for k=1:Groups

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if(strcmp(Type,'gaussian'))

			imagesc(DATA(:,:,1));
			if(k==1)
				msg='Select 2 points: center a radius.';
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				Pr=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));

				[ Pr(2) Pr(1)]=ginput(1);
				Pr(2)=round(Pr(2));Pr(1)=round(Pr(1));

				Sigma=sqrt((Pr(2)-P0(2))^2+(Pr(1)-P0(1))^2);
			else
				msg=['Select 1 point: center. Deviation:',num2str(Sigma)];
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));
			end

			POINTS(:,1) = round(Sigma*randn([M 1])+P0(1));	
			POINTS(:,2) = round(Sigma*randn([M 1])+P0(2));
	
			%% verificando que los puntos esten dentro de la imagen
			for m = 1:M	

				while ( (POINTS(m,1)<1) || (POINTS(m,1)>NLIN) || (POINTS(m,2)<1) || (POINTS(m,2)>NCOL) )
					POINTS(m,1) = round(Sigma*randn(1)+P0(1));	
					POINTS(m,2) = round(Sigma*randn(1)+P0(2));
				end
			end
		
			if k==1
				P1=POINTS;
			else
				if(nargout>=k)
				varargout{k-1}=POINTS;
				end
			end
		
			hold on;
			scatter(POINTS(:,2),POINTS(:,1),'r');

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		elseif(strcmp(Type,'random'))

			imagesc(DATA(:,:,1));
			if(k==1)
				msg='Select 2 opposite corners points.';
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				Pr=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));

				[ Pr(2) Pr(1)]=ginput(1);
				Pr(2)=round(Pr(2));Pr(1)=round(Pr(1));

				DLIN =  Pr(1)-P0(1)+1;
	            DCOL =  Pr(2)-P0(2)+1;

			else
				msg=['Select 1 point: center. Size:',num2str(DLIN),'x',num2str(DCOL)];
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));
			end


			POINTS(:,1) = round(DLIN*rand([M 1])+P0(1));	
			POINTS(:,2) = round(DCOL*rand([M 1])+P0(2));
	
			%% verificando que los puntos esten dentro de la imagen
			for m = 1:M	
				while ( (POINTS(m,1)<1) || (POINTS(m,1)>NLIN) || (POINTS(m,2)<1) || (POINTS(m,2)>NCOL) )
					POINTS(m,1) = round(DLIN*rand([1 1])+P0(1));	
					POINTS(m,2) = round(DCOL*rand([1 1])+P0(2));
				end
			end
		
			if k==1
				P1=POINTS;
			else
				if(nargout>=k)
				varargout{k-1}=POINTS;
				end
			end
		
			hold on;
			scatter(POINTS(:,2),POINTS(:,1),'r');

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		elseif(strcmp(Type,'region'))

			imagesc(DATA(:,:,1));
			if(k==1)
				msg='Select 2 opposite corners points.';
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				Pr=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));

				while 0==check_point1(P0(1),P0(2),NLIN,NCOL)
					msgbox ('Wrong, point out of bounds. Select another point');
					[ P0(2) P0(1)]=ginput(1);
					P0(2)=round(P0(2));P0(1)=round(P0(1));
				end

				[ Pr(2) Pr(1)]=ginput(1);
				Pr(2)=round(Pr(2));Pr(1)=round(Pr(1));

				while 0==check_point1(Pr(1),Pr(2),NLIN,NCOL)
					msgbox ('Wrong, point out of bounds. Select another point');
					[ Pr(2) Pr(1)]=ginput(1);
					Pr(2)=round(Pr(2));Pr(1)=round(Pr(1));
				end

				DLIN =  Pr(1)-P0(1)+1;
	            DCOL =  Pr(2)-P0(2)+1;

			else
				msg=['Select 1 point: corner point. Size:',num2str(DLIN),'x',num2str(DCOL)];
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));

				while( (0==check_point1(P0(1),P0(2),NLIN,NCOL))||(0==check_point1(P0(1)+DLIN-1,P0(2)+DCOL-1,NLIN,NCOL))  )
					msgbox ('Wrong, point out of bounds. Select another point');
					[ P0(2) P0(1)]=ginput(1);
					P0(2)=round(P0(2));P0(1)=round(P0(1));
				end
			end
		
			if DLIN>DCOL
				POINTS=zeros(DLIN,2);
			
				L=1;
				for II=1:abs(DLIN)
					POINTS(L,1) = P0(1)+sign(DLIN)*(II-1);	
					POINTS(L,2) = P0(2)+sign(DCOL)*(JJ-1);
					L=L+1;
				end

			else
				POINTS=zeros(DCOL,2);
			
				L=1;
				for JJ=1:abs(DCOL)

				end
			end
		
			if k==1
				P1=POINTS;
			else
				if(nargout>=k)
				varargout{k-1}=POINTS;
				end
			end
		
			hold on;
			scatter(POINTS(:,2),POINTS(:,1),'r');

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		elseif(strcmp(Type,'line'))

			imagesc(DATA(:,:,1));
			if(k==1)
				msg='Select 2 opposite corners points.';
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);
				Pr=zeros(1,2);
				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));	P0(1)=round(P0(1));

				while 0==check_point1(P0(1),P0(2),NLIN,NCOL)
					msgbox ('Wrong, point out of bounds. Select another point');
					[ P0(2) P0(1)]=ginput(1);
					P0(2)=round(P0(2));	P0(1)=round(P0(1));
				end

				[ Pr(2) Pr(1)]=ginput(1);
				Pr(2)=round(Pr(2));	Pr(1)=round(Pr(1));

				while 0==check_point1(Pr(1),Pr(2),NLIN,NCOL)
					msgbox ('Wrong, point out of bounds. Select another point');
					[ Pr(2) Pr(1)]=ginput(1);
					Pr(2)=round(Pr(2));	Pr(1)=round(Pr(1));
				end

				DLIN =  Pr(1)-P0(1)+1;
	            DCOL =  Pr(2)-P0(2)+1;

			else
				msg=['Select 1 point: corner point. Size:',num2str(DLIN*DCOL)];
				msgbox (msg);
				title(msg);
				P0=zeros(1,2);

				[ P0(2) P0(1)]=ginput(1);
				P0(2)=round(P0(2));P0(1)=round(P0(1));

				while( (0==check_point1(P0(1),P0(2),NLIN,NCOL))||(0==check_point1(P0(1)+DLIN-1,P0(2)+DCOL-1,NLIN,NCOL))  )
					msgbox ('Wrong, point out of bounds. Select another point');
					[ P0(2) P0(1)]=ginput(1);
					P0(2)=round(P0(2));P0(1)=round(P0(1));
				end
			end
		
			NPOINTS=max(abs(DLIN),abs(DCOL));
			POINTS=zeros(NPOINTS,2);
	
			D=sqrt((DCOL-1)^2+(DLIN-1)^2);
			ul=(DLIN-1)/D;
			uc=(DCOL-1)/D;

			for JJ=0:(NPOINTS-1)
				POINTS(JJ+1,1) = round(P0(1)+ul*D*(JJ)/(NPOINTS-1));	
				POINTS(JJ+1,2) = round(P0(2)+uc*D*(JJ)/(NPOINTS-1));
			end
		
			if k==1
				P1=POINTS;
			else
				if(nargout>=k)
				varargout{k-1}=POINTS;
				end
			end
		
			hold on;
			scatter(POINTS(:,2),POINTS(:,1),'r');
		else

			error('Type option unknown.');

		end	
	end

	refresh 
	hold off;    
end


function h=check_point1(x,y,nlin,ncol)
% Check if (x,y) is in (1,1) -> (nlin,ncol)
% return true=1 or false=0

	if ((x>=1)&&(x<=nlin)&&(y>=1)&&(y<=ncol))
		h=1;
	else
		h=0;
	end
end
