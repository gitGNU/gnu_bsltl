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

function [H]=qmfmaker(ORDER)
%
%  This function returns a vector with the parameters of a FIR filter with cut-off 
%  in pi/2 (for a 2*pi normalized frequency range). The function tries to fulfill 
%  $D[Z] = H^2[Z]-H^2[-Z] = A Z^B$ for any A and B.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  H=qmfmaker(ORDER);
%  
%  Input:
%  ORDER  is the order of H=[h0 h1 ... h(ORDER)] FIR filter that try fulfill 
%         $D[Z] = H^2[Z]-H^2[-Z] = A Z^B$ for any A and B.
%         The number of elements of FIR filter must be even 
%         and consequently the ORDER should be odd.
%  Output:
%  H     is a vector with the parameters of a FIR filter. H is a low pass 
%         filter with cut-off in pi/2 (for a 2*pi normalized frequency range).
%  
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>s
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 01 of December of 2015.
%  Review: 27 of February of 2016.
%
	if  rem(ORDER+1,2)~=0
		error(['The number of elements of FIR filter must be even and consequently the ORDER should be odd.']);
	end

	L=16;
	A=0.5;	B=0.6;

	[A B]=findminstd(A,B,L,ORDER);
	[A B]=findminstd(A,B,L,ORDER);
	[A B]=findminstd(A,B,L,ORDER);

	CUTOFF=(A+B)/2;
	H=get_fir_filter(ORDER,CUTOFF);
end

% Find the cut-off interval [CUTOFF_A0 CUTOFF_B0]
% smaller than the standard deviation value of D=|H^2(Z)-H^2(-Z)| with Z=exp(i w), 
% between the cut-off interval [CUTOFF_A CUTOFF_B].
function [CUTOFF_A0 CUTOFF_B0]=findminstd(CUTOFF_A,CUTOFF_B,L,ORDER)
	CUTOFF=linspace(CUTOFF_A,CUTOFF_B,L);
	sigma=zeros(1,L);

	for II=1:L	
		H=fir1(ORDER,CUTOFF(II));
		[H1 D]=qmfmirror(H,ORDER*2);
		sigma(II)=std(D);
	end
	[m, id] = min(sigma);

	if((id-1)>=1)
		CUTOFF_A0=CUTOFF(id-1);
	else
		CUTOFF_A0=CUTOFF(1);
	end

	if((id+1)<=L)
		CUTOFF_B0=CUTOFF(id+1);
	else
		CUTOFF_B0=CUTOFF(L);
	end
end
