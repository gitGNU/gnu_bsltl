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

function [DATACUT varargout]=datacut(DATA)
%
%  DATACUT is a function in graphic mode that selects and cuts a portion of
%  data pack (DATA).
%
%  After starting the main routine just type the following command at the
%  prompt:
%  DATACUT=datacut(DATA);
%  [DATACUT LINES COLUMNS]=datacut(DATA);
%
%  Input:
%  DATA is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represent NLIN and
%       N(1,2) represent NCOL and
%       N(1,3) represent NTIMES.
%
%  Output:
%  DATACUT Is the cut part of speckle data pack. Where DATACUT is a 3D matrix 
%          created grouping NTIMES cut parts of DATA.
%  LINES   [Optional] Is a vector with two elements, these are the first line
%          and the last line in the cut of DATA.
%  COLUMNS [Optional] Is a vector with two elements, these are the first column
%          and the last column in the cut of DATA.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A. Braga Jr <robertobraga@deg.ufla.br>
%  Date:   08 of July of 2015.
%  Review: 25 of February of 2016.
%

    NSIZE = size(DATA);

    if (length(NSIZE)~=3) 
       error('This function need a 3D matrix.');
    end

    NLIN  = NSIZE(1,1);
    NCOL  = NSIZE(1,2);
    NTIMES= NSIZE(1,3);

    
	SIGMA = zeros(NLIN,NCOL);
    ED = zeros(NLIN,NCOL);

    for k = 1:NTIMES
        ED = ED+ DATA(:,:,k);
    end

    ED=ED/NTIMES;

    for k = 1:NTIMES 
       SIGMA =  SIGMA + (DATA(:,:,k)-ED).^2;
    end

    SIGMA = sqrt(SIGMA/(NTIMES-1));

    ALERTA='<< CHOOSE A REGION CLICKING WITH MOUSE IN TWO POINTS >>';

    warndlg(ALERTA);

    figure;
    imagesc(SIGMA);
    title(ALERTA);

    [COL,LIN]=ginput(2);
    COL=round(sort(COL));
    LIN=round(sort(LIN));

    rectangle('Position',[COL(1), LIN(1), COL(2)-COL(1), LIN(2)-LIN(1)], 'LineWidth',3, 'EdgeColor','b');
    DATACUT=DATA(LIN(1):LIN(2),COL(1):COL(2),:);

    if(nargout>=2)
		varargout{1}=COL;
    end

    if(nargout>=3)
        varargout{2}=LIN;
    end

end
