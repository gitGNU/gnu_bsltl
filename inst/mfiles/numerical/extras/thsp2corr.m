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

function [C varargout] = thsp2corr(THSP, varargin)
%
%  This function implements the space-time speckle correlation [1] 
%  technique. 
%  Use as input data a matrix THSP  of M lines and NTIMES columns, that
%  represents the intensity time evolution of M pixels in NTIMES samples.
%
%  CORR(i,l) = corr( THSP(:,i) , THSP(:,i+l) ) 
%
%  Correlation type 1:
%  $corr(A,B)=\frac{E[AB]}{\sqrt{E[A^2]E[B^2]}}$
%
%  Correlation type 2 (Pearson correlation):
%  $corr(A,B)= \frac{E[(A-\mu_A)(B-\mu_B)]}{\sqrt{E[(A-\mu_A)^2]E[(B-\mu_B)^2]}}$
%
%  $C(l) = \frac{1}{NTIMES/2}\sum\limits_{i=1}^{NTIMES/2} CORR(i,l)$, 
%
%  [1] ZiJie Xu, Charles Joenathan, and Brij M. Khorana. 'Temporal and spatial 
%      properties of the time-varying speckles of botanical specimens'. 
%      In: Optical Engineering 34.5 (1995), pages 1487-1502. 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  C       = thsp2corr(THSP);
%  C       = thsp2corr(THSP,2);
%  [C L]   = thsp2corr(THSP);
%  [C L]   = thsp2corr(THSP,2);
%  
%  Input:
%  THSP is a integer 2D matrix that represents the time history speckle pattern (THSP). 
%       This matrix can be obtained using the function THSP. It is necessary that the
%       THSP matrix only has values between 0 and 255, the function does not
%       verify. The function truncates values outside this  interval.
%  TYPE [optional] indicates the type of correlation used. If TYPE=1 then it is used
%       the correlation type 1, in other case, it is used the Pearson correlation.
%       By default it is used the correlation type 1.
%
%  Output: 
%  C    is the correlation vector, with elements C(j) for all  0<=j<=NTIMES/2.
%  L    is a vector with the times j of C(j). L=[0:NTIMES/2].
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>  
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 25 of August of 2015.
%  Review: 28 of March of 2016.
%
	TYPE=1;

    NSIZE = size(THSP);
    M= NSIZE(1,1);
    N= NSIZE(1,2);

	N2=round(N/2);
    
	CMAT = zeros(N2,N2);

	if (nargin>1)
	if isnumeric(varargin{1})
		TYPE=varargin{1};
	end
	end


	if TYPE==1
		for II=1:N2
		for LL=1:N2
			CMAT(II,LL)=pseudo_corr(THSP(:,II), THSP(:,II+LL) );
		end
		end
	else
		for II=1:N2
		for LL=1:N2
			CMAT(II,LL)=corr(THSP(:,II), THSP(:,II+LL) );
		end
		end
	end

    C    = zeros(1,N2+1);

	C(1) =1.0;
	for LL=1:N2
		C(LL+1)=mean(CMAT(:,LL));
	end

	if (nargout>1)
		varargout{1} = [0:N2];
	end
           
  
end

function C=pseudo_corr(A,B)

	C=sum(A.*B)/sqrt(sum(A.^2)*sum(B.^2));

end

