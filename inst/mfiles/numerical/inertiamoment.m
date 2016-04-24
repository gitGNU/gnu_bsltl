%  Copyright (C) 2015, 2016   Roberto Alves Braga Junior
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

function [Y, varargout] = inertiamoment(COM,varargin)
%
%  This function implements the Inertia Moment (IM) method  [1]. 
%  This method can be used with different normalizations over the co-occurrence 
%  matrix. Thus, they can be:
%
%  $Y\approx E[(i-j)^2]$ 
%
%  TYPE 1: The function uses the normalized co-occurrence matrix (COM) proposed by 
%          CARDOSO, R.R. et al. [2]: $Y$.
%  TYPE 2: The function uses the normalized co-occurrence matrix (COM) proposed by 
%          ARIZAGA, R. et al. [1]: $Y2$.
%
%  References:
%  [1]  ARIZAGA, R. et al. Speckle time evolution characterization by the 
%       co-occurrence matrix analysis. Optics and Laser Technology, Amsterdam, 
%       v. 31, n. 2, p. 163-169, 1999.
%  [2]  BRAGA R.A. CARDOSO, R.R. Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis. Optics and Lasers in Engineering, 
%       63(Complete):19-24, 2014.
%
%  After starting the main routine just type the following command at the
%  prompt:
%           [Y] = inertiamoment(COM);
%        [Y Y2] = inertiamoment(COM,2);
%
%  Input:
%  COM  is a 2D matrix, with 256 lines and 256 columns, that represents the 
%       Co-Occurrence Matrix of THSP matrix. The element COM(a,b) in the 
%       co-occurrence matrix represents the quantity of times that, in two 
%       successive columns of a THSP matrix, the intensity values jump of 
%       a-1 to b-1.
%  TYPE [Optional] the function returns an additional 
%       result in the same position in the output.
%       If TYPE is equal to 2, the function also returns the inertia moment
%       with ARIZAGA [2] co-occurrence normalization.
%
%  Output:
%  Y     is the value of inertia moment [1] with CARDOSO normalization [2].
%
%  Ytype if TYPE is equal to 2, the function also returns the inertia moment. 
%        ARIZAGA [2] co-occurrence normalization.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%                      Junio Moreira <juniomoreira@iftm.edu.br>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 01 of July of 2015.
%  Review: 28 of March of 2016.
%
    Nsize = size(COM); 
	if( (Nsize(1,1)~=256)||(Nsize(1,2)~=256) )
		error('The co-occurrence matrix is not 256x256!!!.');
	end

	if( nargin~=nargout )
		error('Error with the number of arguments Input/Out!!!.');
	end

	Ntot=sum(sum(COM));

	%% First moment
	Y=0;

	%% Pseudo First moment with ARIZAGA[2] COM normalization.
	ENABLE_im_ariz=0;
	IM_ARIZ=0;

	for II=2:nargin
		if(varargin{II-1}==2)
			ENABLE_im_ariz=1;
			IDOUT_im_ariz=II-1;
		else
			error(['Inexistent Parameter: ',num2str(varargin{II-1}),'!!!']); 
		end
	end

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for b1 = 1:Nsize(1,1)

		if(ENABLE_im_ariz==1)
			norma = sum(COM(b1,:));
			if norma == 0;
				norma= eps;
			end
		end

        for b2 = 1:Nsize(1,2) 
            
            Y = Y+ (COM(b1,b2)*(b1-b2)^2) /Ntot;    

			%% Pseudo first moment with ARIZAGA[2] COM normalization.
			if(ENABLE_im_ariz==1)
			   	IM_ARIZ = IM_ARIZ + (COM(b1,b2)*(b1-b2)^2 )/norma ;
			end

        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



	if(ENABLE_im_ariz==1)
		varargout{IDOUT_im_ariz}=IM_ARIZ;
	end

