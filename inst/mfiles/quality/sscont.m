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

function [C,mC] = sscont(DATAFRAME,WLines,WColumns)
%
%  Spatial speckle contrast window [1] method. This consist in test the contrast 
%  of speckles in a window region of an image. The image DATAFRAME is
%  divided into windows of WLines pixel lines and WColumns pixel columns.
%  The contrast in a window Cw is calculated as the quotient between spatial
%  standard deviation (populational) and spatial mean in the window.
%  All the pixels in the analysed window are filled with the contrast value.
%
%  Cw=(Spatial Deviation)/(Spatial Mean)
%  
%  [1]  Cardoso, R.R. ; Braga, R.A. ; Rabal, H.J. Alternative protocols on 
%       dynamic speckle laser analysis. SPIE 8413, V International Conference 
%       on Speckle Metrology. 2012
%
%  After starting the main routine just type the following command at the
%  prompt:
%  [C,mC] = sscont(DATAFRAME,WLines,WColumns);
%  % Analysis window of 6x5 pixels.
%  [C,mC] = sscont(DATAFRAME,6,5);  
%  
%  Input:
%  DATAFRAME is the image under analysis.
%  WLines    is the number of lines in the analysed window.
%  WColumns  is the number of columns in the analysed window.
%
%  Output:
%  C         is the spatial speckle contrast window image.
%  mC        is the mean value of the contrast in all windows.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://www.nongnu.org/bsltl
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>               
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of August of 2015.
%  Review: 15 of March of 2016.
%
    NSIZE = size(DATAFRAME);    
	NLIN=NSIZE(1,1);
	NCOL=NSIZE(1,2);

	if(rem(NLIN,WLines)~=0)
		TEXT1=['WLines must be multiple of: ',mat2str(factor(NLIN)),'.'];
		TEXT2=['The last ',num2str(rem(NLIN,WLines)),' pixel lines (botom) were not processed'];
		warning([TEXT1,TEXT2]);
		%msgbox(TEXT1,TEXT2);
	end

	if(rem(NCOL,WColumns)~=0)
		TEXT1=['WColumns must be multiple of: ',mat2str(factor(NCOL)),'.'];
		TEXT2=['The last ',num2str(rem(NCOL,WColumns)),' pixel columns (right) were not processed'];
		warning([TEXT1,TEXT2]);
		
	end

	TOTAL=WLines*WColumns;

    C = zeros(NLIN,NCOL);    

    for lin = 1:WLines  :NLIN-(WLines-1)
    for col = 1:WColumns:NCOL-(WColumns-1)

			LINES   = lin : lin+(WLines-1);
			COLUMNS = col : col+(WColumns-1);

            Z = DATAFRAME(LINES,COLUMNS);

            C(LINES,COLUMNS) = std(reshape(Z,1,TOTAL),1)/(mean(mean(Z))+eps);
    end        
    end
    
    mC = mean(mean(C));

    figure(1);    
    imagesc(C);   colorbar
    title(sprintf('Spatial speckle contrast method - %f.',mC));
	daspect ([1 1 1]);
     
end

