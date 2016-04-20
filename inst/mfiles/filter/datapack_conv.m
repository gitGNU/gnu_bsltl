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

function [DATAOUT] = datapack_conv(DATA,H)
%
%  This function implements a convolution for each pixel of datapack. 
%
%  It convolves each pixel of signal with the function H of M elements, 
%  so that if 
%  H    = [h0 h1 h2 ... h(M-1)]
%  then its Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
%
%  Thus H represents an impulse response with sample zero in h(M2).
%
%  After starting the main routine just type the following command at the
%  prompt:
%  DATAOUT = datapack_conv(DATA,H)
%  
%  Input:
%  DATA   is a speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%         intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%         N(1,1) represents NLIN and
%         N(1,2) represents NCOL and
%         N(1,3) represents NTIMES.
%  H      is a vector, where H represents a non-causal FIR filters centered in h(M2).
%
%  
%  Output:
%  DATAOUT  is obtained from the output of H FIR filter, in non-causal form, 
%           where its input is each pixel of datapack. 
%  
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date: 01 of December of 2015.
%  Review: 25 of February of 2016.
%

    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

    if length(NSIZE)~=3
		error('The datapack should have 3 dimensions.');
	end

    if (NTIMES<2)
        error('Number of frames used are not enough.');
    end

	M=length(H);
	M2=floor(M/2);


	%% Adding M/2 frames with zeros to datapack.
	%% This new datapack is called of D.
	D=zeros(NLIN,NCOL,M2+NTIMES+M2);
	D(:,:,(1+M2):(NTIMES+M2))=DATA(:,:,1:NTIMES);

	

	%% Non-causal filtering using H coefficients
	DATAOUT=filter(H,[1],D,[],3);
	DATAOUT=DATAOUT(:,:,M2+1+M2:M2+NTIMES+M2);
end

