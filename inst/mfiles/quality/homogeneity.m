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

function [Y X] = homogeneity(DATA,WLines  ,WColumns,Type)
%
%  Homogeneity of spatial variability [1]. This function divides the
%  data pack (DATA) in spatial regions of WLines lines and WColumns 
%  columns, in these regions are calculated activity indicators selected 
%  with the variable Type, over these values are calculate the homogeneities.
%  Known an activity indicator value A(i,j) in the window (i,j), the homogeneity 
%  value H(i,j) is calculated as
%
%  $Z=\{A(i,j-1), A(i-1,j), A(i,j), A(i+1,j), A(i,j+1)\}$
%
%  $H(i,j) = \frac{StandardDeviation\{Z\}}{Mean\{Z\}}$
%
%  * Is used the populational case of standard deviation.
%
%  References:
%  [1]  Cardoso, R.R. ; Braga, R.A. ; Rabal, H.J. Alternative protocols on 
%       dynamic speckle laser analysis. SPIE 8413, V International Conference 
%       on Speckle Metrology. 2012
%
%  [2]  BRAGA, R.A. et al. Evaluation of activity through dynamic laser speckle 
%       using the absolute value of the differences, Optics Communications, v. 284, 
%       n. 2, p. 646-650, 2011.
%
%  [3] R. Nothdurft and G. Yao, 'Imaging obscured subsurface inhomogeneity using 
%      laser speckle,' Opt. Express  13, 10034-10039 (2005). 
%
%  [4]  ARIZAGA, R. et al. Speckle time evolution characterization by the 
%       co-occurrence matrix analysis. Optics and Laser Technology, Amsterdam, 
%       v. 31, n. 2, p. 163-169, 1999.
%
%  [5]  BRAGA R.A. CARDOSO, R.R. Enhancement of the robustness on dynamic speckle 
%       laser numerical analysis. Optics and Lasers in Engineering, 
%       63(Complete):19-24, 2014.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  [Y X] = homogeneity(DATA,WLines,WColumns,Type);
%  
%  Input:
%  DATA     is the speckle datapack. Where DATA is a 3D matrix created grouping NTIMES 
%           intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%           N(1,1) represents NLIN and
%           N(1,2) represents NCOL and
%           N(1,3) represents NTIMES.
%  WLines   is the number of lines in the analysed window.
%  WColumns is the number of columns in the analysed window.
%  Type     If Type is 1, it is used as activity indicator the AVD [2] technique.
%           If Type is 2, it is used as activity indicator the Temporal S. Std. Deviation [3].
%           In other case it is used as activity indicator the inertia moment [4] technique.
%           In the cases of AVD and/or inertia moment indicators, it is used the Cardoso[5] normalization
%           over co-occurrence matrix. In all cases, the activity indicators
%           were calculated as a mean over all points of each window, not only over a line.
%
%  Output:
%  Y        is the homogeneity percentages in the analysed windows [1].
%           The homogeneity value H(i,j) is represented as a window (matrix) 
%           with WLines x WColumns pixels inside Y. 
%
%  X        is the activity indicator value in the analysed windows. The activity 
%           indicator value A(i,j) is represented as a window (matrix) with 
%           WLines x WColumns  pixels inside X.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://www.nongnu.org/bsltl
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of August of 2015.
%  Review: 28 of March of 2016.
%
    NSIZE = size(DATA);
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

	if (Type==1)
		GMETHOD=graphavd(DATA,'off');
		NAME='AVD';
	elseif (Type==2)
		[TMP GMETHOD]=stdcont(DATA,'off');
		NAME='Deviation';
	else
		GMETHOD=graphim(DATA,'off');
		NAME='Inertia Moment';
	end

    X = zeros(NLIN,NCOL);
    Y = zeros(NLIN,NCOL);
    
	LINESSTEPS   = 1 : WLines   : NLIN-(WLines  -1);
	COLUMNSSTEPS = 1 : WColumns : NCOL-(WColumns-1);
	LSTEPS=length(LINESSTEPS);
	CSTEPS=length(COLUMNSSTEPS);
    H = zeros(LSTEPS,CSTEPS);

	II=1;
    for lin = LINESSTEPS
		JJ=1;
	    for col = COLUMNSSTEPS

			LINES   = lin:lin+(WLines-1);
			COLUMNS = col:col+(WColumns-1);

			AVD  = mean2(GMETHOD(LINES,COLUMNS)); 

			X(LINES,COLUMNS)  = AVD;
			H(II,JJ)          = AVD;

			JJ=JJ+1;
    	end	
		II=II+1;
    end


	II=2;
    for lin = WLines+1: WLines : (LSTEPS-1)*WLines
		JJ=2;
	    for col = WColumns+1: WColumns : (CSTEPS-1)*WColumns

			VEC=[H(II,JJ-1) H(II-1,JJ) H(II,JJ) H(II+1,JJ) H(II,JJ+1) ];

			LINES   = lin:lin+(WLines-1);
			COLUMNS = col:col+(WColumns-1);

			Y(LINES,COLUMNS)  = std(VEC,1)/(mean(VEC)+eps);

			JJ=JJ+1;
    	end	
		II=II+1;
    end

	Y=100*(1.0-Y/max(max(Y)));
    
    figure(1);
    imagesc(X);    colorbar;
    title(['Activity indicator: ',NAME]);
	daspect([1 1 1]);

    figure(2);
    imagesc(Y);    colorbar;
    title('Homogeneity test in analysis windows');
	daspect([1 1 1]);

end 

