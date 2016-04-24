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

function [DATA0 DATA1] = firfilterbank(DATA,FILTER,MODE)
%
%  This function implements a filter bank for each pixel of a datapack. 
%
%  This function uses two FIR filters (H0 and H1) of order (M-1) in non-causal 
%  form, so that if 
%  H    = [h0 h1 h2 ... h(M-1)]
%  then its Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
%
%  The function implements some modes
%  
%  MODE0: This mode uses two FIR filters (H0 and H1), thus it can accept {H0} or 
%         {H0 , H1} as input parameter. If only the H0 filter is delivered as  
%         input parameter, then the H1 filter is calculated as
%         the complement filter of H0. $H1[Z]= 1-H0[Z]$. 
%         
%  MODE2: This mode uses two FIR filters (H0 and H1), and it only can accept {H0} 
%         as input parameter; H1 filter is calculated as the quadrature mirror 
%         filter of H0. $H1[Z]= H0[-Z]$. At end the, there will be a 
%         down-sampler by 2.
%         This mode is commonly used with H0 as low pass FIR filter with cut-off 
%         in pi/2 (for a 2*pi normalized frequency range). In order to have a perfect reconstruction
%         it is necessary that $D[Z]=H0^2[Z]-H0^2[-Z]=A Z^B$ for any A and B.
%
%
%  After starting the main routine just type the following command at the
%  prompt:
%  [DATA0 DATA1] = firfilterbank(DATA,FILTER,MODE);
%  [DATA0 DATA1] = firfilterbank(DATA,H0,'MODE2');
%  [DATA0 DATA1] = firfilterbank(DATA,H0,'MODE0');
%  [DATA0 DATA1] = firfilterbank(DATA,[H0;H1],'MODE0');
%  
%  Input:
%  DATA   is a speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%         intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%         N(1,1) represents NLIN and
%         N(1,2) represents NCOL and
%         N(1,3) represents NTIMES.
%  FILTER is a matrix (with 2 lines) or a vector, where FILTER=H0 or FILTER=[H0;H1].
%         H0 and H1 represent two FIR filters.
%         FILTER=H0 is used in the mode 'MODE2', by other side FILTER=H0 or FILTER=[H0;H1] 
%         can be used in the mode 'MODE0'.
%  MODE   is the type of analysis selected of a filter bank. It can be 'MODE0' or 
%         'MODE2'.
%  
%  Output:
%  DATA0  is obtained from the output of H0 FIR filter, in non-causal form, 
%         with input each pixel of datapack. If the mode used have a 
%         down-sampler after filtering, then DATA0 is the output of down-sampler.
%  DATA1  is obtained after the output of H1 FIR filter, in non-causal form, 
%         with input each pixel of datapack. If the mode used have a 
%         down-sampler after filtering, then DATA1 is the output of down-sampler.
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

	MODE=upper(MODE);

	%% Processing the second parameter to get H0 and H1
	[H0 H1]=processing_filter(FILTER,MODE);

	%% Non-causal filtering using H0 coefficients
	DATA0=datapack_conv(DATA,H0);

	%% Non-causal filtering using H1 coefficients
	DATA1=datapack_conv(DATA,H1);
	

	if		( strcmp(MODE,'MODE2')==1 )
		DATA0=datapack_downsampling(DATA0,2);
		DATA1=datapack_downsampling(DATA1,2);
	elseif	( strcmp(MODE,'MODE0')==1 )
		%
	else
		warning('The used mode no exist. Switching to: MODE0');
	end
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% D is down sampling version of DATA.                                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D=datapack_downsampling(DATA,N)
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

	n=ceil(NTIMES/N);
	steps=[0:n-1]*N+1;

	D= DATA(:,:,steps);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing the second parameter.                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H0 H1]=processing_filter(FILTER,MODE)
	if isvector(FILTER)
		
		H0=FILTER;

		% Creating, H1, the quadrature mirror filter of H0.
		if  strcmp(MODE,'MODE2') 
			if  rem(length(FILTER),2)~=0
				error(['Creating, H1, the quadrature mirror filter: Number of elements ', ...
					   'of FIR filter must be even for creating quadrature filter.']);
			end
			%% H1 Quadrature filter of H0
			H1=qmfmirror(H0);

		%elseif ( strcmp(MODE,'MODE0' ) ) %%<--default
		else
			% H1[Z]= 1-H0[Z]. 
			M=length(H0);	M2=floor(M/2);
			H1=-H0;
			H1(M2+1)=1-H0(M2+1);
		end
	elseif ismatrix(FILTER)
		if size(FILTER,1)==2
			if strcmp(MODE,'MODE2') 
				error([ 'The MODE2 only accept a H0 filter vector (1xN_even).']);
			end
        	H0=FILTER(1,:);
			H1=FILTER(2,:);
			M=length(H0);
		else
			error('The second parameter should be a vector (1xN) or a matrix (2xN) with the parameters of FIR filters.');
		end
    end
end

