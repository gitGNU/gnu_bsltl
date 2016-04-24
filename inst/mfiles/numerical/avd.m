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

function [Y, varargout] = avd(COM,varargin)
%
%  Absolute Value of the Differences (AVD) method. This function implements
%  the modification proposed by BRAGA, R.A. et al. [1] that is a modification
%  of the Inertia Moment (IM) index.
%  The AVD index can be implemented using:
%
%  $Y\approx E[|i-j|]$
%  $Y2\approx E[|i-j|^2]$
%  $Y3\approx E[|i-j|^2] - E[|i-j|]^2$
%
%  TYPE 1: The normalized co-occurrence matrix (COM) proposed by 
%          CARDOSO, R.R. et al. [2]. The AVD first moment: $Y$.
%  TYPE 2: The CARDOSO, R.R. et al. [2] COM normalization with quadratic AVD  
%          The AVD second moment: $Y2$.
%  TYPE 3: The AVD center second moment: $Y3$.
%  TYPE 4: The normalized co-occurrence matrix (COM) proposed by 
%          ARIZAGA, R. et al. [3] (Other pseudo first moment): $Y4$.
%
%  References:
%  [1]  BRAGA, R.A. et al. Evaluation of activity through dynamic laser speckle 
%       using the absolute value of the differences, Optics Communications, v. 284, 
%       n. 2, p. 646-650, 2011.
%  [2]  BRAGA R.A. CARDOSO, R.R. Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis. Optics and Lasers in Engineering, 
%       63(Complete):19-24, 2014.
%  [3]  ARIZAGA, R. et al. Speckle time evolution characterization by the 
%       co-occurrence matrix analysis. Optics and Laser Technology, Amsterdam, 
%       v. 31, n. 2, p. 163-169, 1999.
%
%  After starting the main routine just type the following command at the
%  prompt:
%           [Y] = avd(COM);
%        [Y Y2] = avd(COM,2);
%  [Y Y2 Y3 Y4] = avd(COM,2,3,4);
%  [Y Y4 Y3 Y2] = avd(COM,4,3,2);
%
%  Input:
%  COM  is a 2D matrix, with 256 lines and 256 columns, that represents the 
%       Co-Occurrence Matrix of a THSP matrix. The element COM(a,b) in the 
%       co-occurrence matrix represents the quantity of times that in two 
%       successive columns, of THSP matrix, the intensity values jump from 
%       a-1 to b-1.
%  TYPE [Optional] can be used many options. When it is used
%       the function returns an additional result in the same position.
%       If TYPE is equal to 2, the function also returns the AVD second moment, using 
%       CARDOSO[2] COM normalization with ARIZAGA[3] value difference.
%       If TYPE is equal to 3, the function also returns the AVD center second moment. 
%       If TYPE is equal to 4, the function also returns the AVD with ARIZAGA[3] 
%       COM normalization.
%
%  Output:
%  Y     is the value of AVD first moment [1].
%
%  Ytype If TYPE is equal to 2, the function also returns the AVD second moment, using 
%        CARDOSO[2] COM normalization with ARIZAGA[3] value difference.
%        If TYPE is equal to 3, the function also returns the AVD center second moment. 
%        If TYPE is equal to 4, the function also returns the AVD with ARIZAGA[3] COM normalization.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%                      Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
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

	%% Second moment, ARIZAGA[3] value difference with CARDOSO[2] COM normalization.
	ENABLEavd2m=0;
	ENABLECALCavd2m=0;
	AVD2M=0;

	%% Center second moment, variance of AVD.
	ENABLEavd2c=0;
	AVD2C=0;

	%% Pseudo First moment with ARIZAGA[3] COM normalization.
	ENABLEavdariz=0;
	AVDARIZ=0;

	for II=2:nargin
		if(varargin{II-1}==2)
			ENABLEavd2m=1;
			IDOUTavd2m=II-1;
		elseif(varargin{II-1}==3)
			ENABLEavd2c=1;
			ENABLECALCavd2m=1;
			IDOUTavd2c=II-1;
		elseif(varargin{II-1}==4)
			ENABLEavdariz=1;
			IDOUTavdariz=II-1;
		else
			error(['Inexistent Parameter: ',num2str(varargin{II-1}),'!!!']); 
		end
	end

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for b1 = 1:Nsize(1,1)
        for b2 = 1:Nsize(1,2) 
            
            Y = Y+ (COM(b1,b2)*abs(b1-b2)) /Ntot;    

			%% Second moment, ARIZAGA[3] value difference with CARDOSO[2] COM normalization.
			if((ENABLEavd2m==1)||(ENABLECALCavd2m==1))
            	AVD2M = AVD2M + (COM(b1,b2)*( (b1-b2)*(b1-b2) ))/Ntot;
			end

			%% Pseudo first moment with ARIZAGA[3] COM normalization.
			if(ENABLEavdariz==1)
				norma = sum(COM(b1,:));
				if norma == 0;
					norma= 1;
				end
            	AVDARIZ = AVDARIZ + (COM(b1,b2)*abs(b1-b2) )/norma ;

			end

        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(ENABLEavd2m==1)
	varargout{IDOUTavd2m}=AVD2M;
end

if(ENABLEavd2c==1)
	varargout{IDOUTavd2c}=AVD2M-Y^2;
end

if(ENABLEavdariz==1)
	varargout{IDOUTavdariz}=AVDARIZ;
end

