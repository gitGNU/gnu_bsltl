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

function DATAOUT=firsynthesispath(DATA,H0,SEQ)
%
%  This function makes a synthesis of a path in a filter bank, for each pixel
%  of datapack DATA. 
%
%  It uses in cascade of reconstruction blocks Bi with i=1 to i=L=length(SEQ). 
%  Each reconstruction block Bi is formed by:
%  1) up-sampler by 2
%  2) gain of 2
%  3) Gj FIR FILTER, so that j=SEQ(L+1-i)
%
%  The function accepts the filter H0 as input parameter, so that the filters 
%  G0 and G1  are calculated as $G0[Z]=H0[Z]$ and $G1[Z]= -H0[-Z]$.
%  If
%  H0    = [h0 h1 h2 ... h(M-1)]
%  then your Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
% 
%  H0 should be a low pass FIR filter with cut-off in pi/2 
%  (for a 2*pi normalized frequency range).
%  In order to get a perfect reconstruction it is necessary that 
%  $D[Z]=H0^2[Z]-H0^2[-Z]=A Z^C$ for any A and C.
%
%  
%  After starting the main routine just type the following command at the
%  prompt:
%  DATAOUT=firsynthesispath(DATA,H0,SEQ);
%  
%  Input:
%  DATA   is a speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%         intensity matrices with NLIN lines and NCOL columns. When N=size(DATA0), then
%         N(1,1) represents NLIN and
%         N(1,2) represents NCOL and
%         N(1,3) represents NTIMES.
%         DATA is obtained after the down-sampler of output of H0 FIR filter in 
%         a step of a filter bank with low-pass filter H0.
%  H0     is a vector with the parameters of a FIR filter. H0 should be a low 
%         pass filter with cut-off in pi/2 (for a 2*pi normalized frequency range).
%         In order to get a perfect reconstruction is necessary that 
%         $D[Z]=H0^2[Z]-H0^2[-Z]=A Z^B$ for any A and B.
%  SEQ    is a vector with binary values. These values indicates the path
%         in the decomposition scheme used to get the datapack DATA.
%  
%  Output:
%  DATAOUT is a synthesis of the speckle datapack DATA. The number of images
%          inside DATAOUT is 2^{L=length(SEQ)} times of the number of images of DATA.
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
	
	[G0 G1]=processing_filter(H0);

	L=length(SEQ);
	for II=L:-1:1
		if(SEQ(II)==0)
			DATA=reconstruction(DATA,G0);
		else
			DATA=reconstruction(DATA,G1);
		end
	end

	DATAOUT=DATA;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DATA -> UP2 -> 2-> G -> DATA_UP                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DATA_UP=reconstruction(DATA,G)
    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	M=length(G);
	M2=floor(M/2);

	%% Upsampling datapack.
	DATA_UP=datapack_upsampling(DATA,2);

	%% Non-causal filtering using G coefficients
	DATA_UP = datapack_conv(DATA_UP,2*G);

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

