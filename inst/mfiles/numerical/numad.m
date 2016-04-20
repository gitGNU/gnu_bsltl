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

function [Y, varargout] = numad(COM,varargin)
%
%  Numerical analysis of the modified AVD method [1]. This function implements
%  the the numerical method [1] that is a modification
%  over absolute difference (Fujii method)  [2]
%
%  $Y \approx E[\frac{|i-j|}{i+j}]$
%  $Y2\approx E[\frac{(i-j)^2}{(i+j)^2}]$  
%
%  References:
%  [1] Renan O Reis; Roberto Braga; Hector J Rabal.
%      Light intensity independence during dynamic laser speckle analysis
%  [2] FUJII, H. et al. Evaluation of blood flow by laser speckle image sensing. 
%      Applied Optics, New York, v. 26, n. 24, p. 5321-5325, 1987.
%
%  After starting the main routine just type the following command at the
%  prompt:
%           [Y] = numad(COM);
%        [Y Y2] = numad(COM,2);
%
%  Input:
%  COM  is a 2D matrix, with 256 lines and 256 columns, that represents the 
%       Co-Occurrence Matrix of THSP matrix. The element COM(a,b), in the 
%       co-occurrence matrix, represents the quantity of times that, in two 
%       successive columns of a THSP matrix, the intensity values jump of 
%       a-1 to b-1.
%  TYPE [Optional] the function returns an additional result.
%       If TYPE is equal to 2, the function also returns the AD second moment. 
%
%  Output:
%  Y    is the value of the modified AVD first moment [1].
%
%  Y2   if TYPE is equal to 2, the function also returns the AVD second moment. 
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 01 of July of 2015.
%  Review: 28 of March of 2016.
%
    Nsize = size(COM); 
	if( (Nsize(1,1)~=256)||(Nsize(1,2)~=256) )
		error('The co-occurrence matrix is not 256x256!!!.');
	end

	if nargin > 2
		error('This function only accepts two parameters!!!.');
	end

	if( nargin~=nargout )
		error('Error with the number of arguments Input/Out!!!.');
	end

	ENABLEad2m=0;

	if nargin > 1
		if(varargin{1}==2)
			ENABLEad2m=1;
		else
			error(['Inexistent type: ',num2str(varargin{1}),'!!!']);
		end
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Ntot=sum(sum(COM));

	%% First moment
	Y=0;
	%% Second moment
	AD2M =0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for b1 = 1:Nsize(1,1)
        for b2 = 1:Nsize(1,2) 
            
            Y = Y+ (COM(b1,b2)/Ntot)*(abs(b1-b2)/(b1+b2+eps)) ;    

			%% Second moment with CARDOSO[2] COM normalization.
			if(ENABLEad2m==1)
            	AD2M = AD2M + (COM(b1,b2)/Ntot)*( (b1-b2)^2/(b1+b2+eps)^2 );
			end

        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(ENABLEad2m==1)
	varargout{1}=AD2M;
end
