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

function [F S D] = satdark(DATAFRAME,WLines,WColumns,MaxDark,MinSat,P)
%
%  Saturation and sub-exposition of light[1]. Here it is tested if  
%  an analysed windows of the image is saturated with light or is dark.
%
%  [1]  Cardoso, R.R. ; Braga, R.A. ; Rabal, H.J. Alternative protocols on 
%       dynamic speckle laser analysis. SPIE 8413, V International Conference 
%       on Speckle Metrology. 2012
%
%  After starting the main routine just type the following command at the
%  prompt:
%  [F S D] = satdark(DATAFRAME, WLines, WColumns, MaxDark, MinSat, P);
%  % Analysis window of 6x5 pixels and 
%  % 50 percent of pixels in the window to declare it dark or saturated.
%  [F S D] = satdark(DATAFRAME,      6,        5, MaxDark, MinSat, 50);  
%
%  Input:
%  DATAFRAME is the image under analysis.
%  WLines    is the number of lines in the analysed window.
%  WColumns  is the number of columns in the analysed window.
%  MaxDark   is the maximum gray-scale level that is considered as dark.
%  MinSat    is the minimum gray-scale level that is considered as saturated.
%  P         is the percentage of pixels in a window to declare it dark or saturated.
%
%  Output:
%  F         is an image with dark or saturated areas in analysed windows. 
%            The dark windows are filled with 0, the saturated windows are 
%            filled with 255. To consider a window as dark or saturated, 
%            it should overcome a P percentage of pixels in analysis window.
%  S         is a matrix with the same size of F, this matrix has ones in
%            regions with saturated windows and zeros in other regions.
%  D         is a matrix with the same size of F, this matrix has ones in
%            regions with dark windows and zeros in other regions.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://www.nongnu.org/bsltl
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of August of 2015.
%  Review: 28 of March of 2016.
%
    NSIZE = size(DATAFRAME);  
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);

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

    F = zeros(NLIN,NCOL);
    S = zeros(NLIN,NCOL);        
    D = zeros(NLIN,NCOL);    
     

    for lin = 1: WLines   : ( NLIN-(WLines-1) )
    for col = 1: WColumns : ( NCOL-(WColumns-1) )

		LINES   = lin : lin+(WLines-1);
		COLUMNS = col : col+(WColumns-1);

		[f s d] = part_sat_dark( DATAFRAME( LINES , COLUMNS ) ,MaxDark,MinSat,P);            
          
		F( LINES , COLUMNS ) = f;
		S( LINES , COLUMNS ) = s;
		D( LINES , COLUMNS ) = d;
    end
    end
    
    figure(1);  
    imagesc(F);  
	colorbar;    
    title('Preview');
	daspect ([1 1 1]);

    figure(2);  
    imagesc(S);  
	colorbar;
    title('Saturation Zone Image');
	daspect ([1 1 1]);

    figure(3);  
    imagesc(D);  daspect ([1 1 1])
	colorbar;
    title('Dark Zone Image');
	daspect ([1 1 1]);
end  


function [F S D] = part_sat_dark(WINDOW,MaxDark,MinSat,P)
%
%  This function analises the window tagged as WINDOW, where
%  a dark window is filled with 0, and a saturated window is
%  filled with 255. To consider a window as dark or saturated, it
%  should overcome a P percentage of pixels in the window.
%
%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>  
%  Code adapted by:    Junio Moreira                   
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Date:   09 of August of 2015.
%  Review: 15 of March of 2016.
%
%  This method only implements the values when the function
%  is called satdark()
%  
%  Input:
%  WINDOW    is the window under analysis.
%  MaxDark   is the maximum gray-scale level that is considered as dark.
%  MinSat    is the minimum gray-scale level that is considered as saturated.
%  P         is the percentage of pixels in a window to declare dark or saturate.
%
%  Output:
%  F         is the dark or saturated window. 
%            The dark windows are filled with 0, and the saturated windows are 
%            filled with 255. To consider a window as dark or saturated, it
%            should overcome a P percentage of pixels in the window.
%  S         is a matrix with the same size of F, this matrix has ones if F 
%            is saturated and zero in other case.
%  D         is an matrix with the same size of F, this matrix has ones if F 
%            is dark and zero in other case.
%

    WLines   = size(WINDOW,1);
    WColumns = size(WINDOW,2);

    F = zeros(WLines,WColumns);

    num_pixels_sat  = sum(sum( WINDOW>=MinSat ));
    num_pixels_dark = sum(sum( WINDOW<=MaxDark ));
    
    UMBRAL=WLines*WColumns*P/100;
    
    if     ( (num_pixels_sat >= UMBRAL) && (num_pixels_dark <= UMBRAL) )

        F(:,:) = 255;
		S=ones(WLines,WColumns);
		D=zeros(WLines,WColumns);

    elseif ( (num_pixels_sat <= UMBRAL) && (num_pixels_dark >= UMBRAL) )

        F(:,:) = 0;
		S=zeros(WLines,WColumns);
		D=ones(WLines,WColumns);

    elseif ( (num_pixels_sat <  UMBRAL) && (num_pixels_dark <  UMBRAL) ) 

		F=WINDOW;
		S=zeros(WLines,WColumns);
		D=zeros(WLines,WColumns);

    else
		for II=1:WLines
		for JJ=1:WColumns
			if( JJ<=(II*WColumns/WLines) )
				F(II,JJ)=255;
			else
				F(II,JJ)=0;
			end
		end
		end
		S=ones(WLines,WColumns);
		D=ones(WLines,WColumns);		
    end  
 
end
