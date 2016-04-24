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

function [C varargout] = stscorr(DATA,Tau,K0)
%
%  This function implements the spatial-temporal speckle correlation [1] 
%  technique. The correlation is applied between K0 image and
%  all other images. 
%  Use as input data a 3D matrix created grouping NTIMES intensity matrices I(k)
%  1<=k<=NTIMES
%
%  L    = [1:NTIMES]-K0
%  LTau = L * Tau
%
%  $corr(A,B)= \frac{E[(A-\mu_A)(B-\mu_B)]}{\sqrt{E[(A-\mu_A)^2]E[(B-\mu_B)^2]}}$
%
%  $C(k)= corr(I(K0),I(k))$,  $\forall~1 \leq k \leq NTIMES$
%
%  [1] ZDUNEK, A. et al. New nondestructive method based on spatial-temporal
%      speckle correlation technique for evaluation of apples quality during
%      shelf-life. International Agrophysics, v. 21, n. 3, p. 305-310, 2007. 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  C          = stscorr(DATA,Tau,K0)
%  [C LTau]   = stscorr(DATA,Tau,K0)
%  [C LTau L] = stscorr(DATA,Tau,K0)
%  
%  Input:
%  DATA is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represents NLIN and
%       N(1,2) represents NCOL and
%       N(1,3) represents NTIMES.
%  Tau  is the sampling rate in seconds.
%  K0   is the number of the reference frame used in correlation analysis.
%
%  Output: 
%  C    is the correlation vector. This corresponds with the C(l*tau) values used 
%       in [1] at equation (7), with the difference that negative values of 
%       l*tau also are calculated.
%  LTau [Optional] is the vector with the values of time l*tau in the vector C. This
%       can have negative values.
%  L    [Optional] is the vector with the values of index l in the vector C. This
%       can have negative values.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira  <juniomoreira@iftm.edu.br>
%                      Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 25 of August of 2013.
%  Review: 28 of March of 2016.
%

    NSIZE = size(DATA);
    NTIMES=NSIZE(1,3);
  
	C = zeros(1,NTIMES);

	LL   = [1:NTIMES]-K0;
	LTau = LL*Tau;

    
    for KK = 1:NTIMES
        C(KK) = corr2( DATA(:,:,K0) , DATA(:,:,KK) );
    end

	if (nargout>=2)
		varargout{1}=LTau;
	end

	if (nargout>=3)
		varargout{2}=LL;
	end

	figure(1)
    plot(LTau,C,'-s');grid on;
	xlim([min(LTau) max(LTau)]);
	xlabel('k tau');
	ylabel('Correlation coefficients');
    title(['Spatial-Temporal Speckle Correlation Technique: k0=',num2str(K0)]);       
        

