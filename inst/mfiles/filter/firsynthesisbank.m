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

function DATA=firsynthesisbank(DATA0,DATA1,H0)
%
%  This function makes a step to synthesis filter bank for each pixel
%  of datapacks DATA0 and DATA1. It uses up-samplers in your inputs and
%  after FIR filters (G0 and G1) of order (M-1) in non-causal form. If
%  H0    = [h0 h1 h2 ... h(M-1)]
%  then your Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
%
%  The function accepts the filter H0 as input parameter, so that the filters 
%  G0 and G1  are calculated as $G0[Z]=H0[Z]$ and $G1[Z]= -H0[-Z]$. 
%  H0 should be a low pass FIR filter with cut-off in pi/2 
%  (for a 2*pi normalized frequency range) and, DATA0 and DATA1 the outputs of
%  an step of a filter bank, as in the function firfilterbank() in MODE='MODE2'.
%  In order to get a perfect reconstruction it is necessary that 
%  $D[Z]=H0^2[Z]-H0^2[-Z]=A Z^B$ for any A and B.
%
%  
%  After starting the main routine just type the following command at the
%  prompt:
%  DATA=firsynthesisbank(DATA0,DATA1,H0);
%  
%  Input:
%  DATA0  is a speckle data pack. Where DATA0 is a 3D matrix created grouping NTIMES 
%         intensity matrices with NLIN lines and NCOL columns. When N=size(DATA0), then
%         N(1,1) represents NLIN and
%         N(1,2) represents NCOL and
%         N(1,3) represents NTIMES.
%         DATA0 is obtained after the down-sampler of output of H0 FIR filter in 
%         a step of a filter bank with low-pass filter H0.
%         DATA0 and DATA1 should have the same size.
%  DATA1  is a speckle data pack. Where DATA1 is a 3D matrix created grouping NTIMES 
%         intensity matrices with NLIN lines and NCOL columns. When N=size(DATA1), then
%         N(1,1) represents NLIN and
%         N(1,2) represents NCOL and
%         N(1,3) represents NTIMES.
%         DATA1 is obtained after the down-sampler of output of H1 FIR filter in 
%         a step of a filter bank with low-pass filter H0.
%         DATA1 and DATA0 should have the same size.
%  H0     is a vector with the parameters of a FIR filter. H0 should be a low 
%         pass filter with cut-off in pi/2 (for a 2*pi normalized frequency range).
%         In order to ger a perfect reconstruction it is necessary that 
%         $D[Z]=H0^2[Z]-H0^2[-Z]=A Z^B$ for any A and B.
%  
%  Output:
%  DATA   is a synthesis of speckle datapacks DATA0 and DATA1. The number of images
%         inside DATA is twice of the number of images of DATA0 and DATA1.
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
%  Review: 27 of February of 2016.
%
	if ~isequal(size(DATA0),size(DATA1))
		error('The datapacks should have the same sizes.');
	end

    NSIZE = size(DATA0);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

    if length(NSIZE)~=3
		error('The datapack should have 3 dimensions.');
	end

    if (NTIMES<2)
        error('Number of frames used are not enough.');
    end
	
	[G0 G1]=processing_filter(H0);

	%% upsampling datapack.
	DATA0_UP=datapack_upsampling(DATA0,2);

	%% upsampling datapack.
	DATA1_UP=datapack_upsampling(DATA1,2);

	%% Non-causal filtering using G0 coefficients
	DATA0_UP = datapack_conv(DATA0_UP,2*G0);

	%% Non-causal filtering using G1 coefficients
	DATA1_UP = datapack_conv(DATA1_UP,2*G1);

	DATA=DATA0_UP+DATA1_UP;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing the third parameter.                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [G0 G1]=processing_filter(H0)

	if  rem(length(H0),2)~=0
		error(['Creating, [G0 G1], the synthesis quadrature mirror filter: ', ...
			   'Number of elements of FIR filter must be even.']);
	end
	
	% Creating, G0= H0( Z),
	G0=H0;

	% Creating, G1=-H0(-Z),
	G1=-qmfmirror(H0);
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% D is up sampling version of DATA.                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D=datapack_upsampling(DATA,N)
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

	D=zeros(NLIN,NCOL,N*NTIMES);

	steps=[0:(NTIMES-1)]*N+2;

	D(:,:,steps)= DATA;
end

