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

function [H1 varargout]=qmfmirror(H0,varargin)
%  This function returns the vector H1, the quadrature mirror filter 
%  of H0. If  H0 = [h0 h1 h2 ... h(M-1)] then your Z transform is:
%  M2=floor(M/2);
%  $H[Z] = h0 Z^{+M2} + h1 Z^{+M2-1} + ...  h(M-1) Z^{+M2-(M-1)}$ 
%  and
%  $H1[Z]=H0[-Z]$
%
%  Additionally, the function returns $|D[Z=e^{i*W}]|$, where $D[Z] = H0^2[Z]-H0^2[-Z]$
%  for W from 0 to pi.
% 
%
%  After starting the main routine just type the following command at the
%  prompt:
%  H1=qmfmirror(H0);
%  [H1 AD]=qmfmirror(H0);
%  [H1 AD]=qmfmirror(H0,N);
%  [H1 AD FREQN]=qmfmirror(H0);
%  [H1 AD FREQN]=qmfmirror(H0,N);
%  
%  Input:
%  H0     is a vector with the parameters of a FIR filter.
%  N      [Optional] is the number of analyzed points in AD.
%  Output:
%  H1     is the quadrature mirror filter of H0. H0[Z]=H1[-Z]
%  AD     [Optional] is a modulus of $D[Z=e^{i*W}]$, where $D[Z] = H0^2[Z]-H0^2[-Z]$.
%         The number of analyzed points in AD is equal to N.
%  FREQN  [Optional] is the normalized frequency of points in AD, thus for the 
%         point AD(id) we have W=FREQN(id)*pi.
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
    M =length(H0);
	H1=zeros(1,M);

    M2=floor(M/2);

    for II=1:M
        H1(II)=((-1)^(+M2+1-II) )*H0(II);
    end

    if nargout>1
        D=(conv(H0,H0)-conv(H1,H1));

        if nargin>1
            N=varargin{1};
        else
            N=65;
        end

        [varargout{1} FREQN]=freqmod(D,N);
        if nargout>2
            varargout{2}=FREQN;
        end
    end
end

