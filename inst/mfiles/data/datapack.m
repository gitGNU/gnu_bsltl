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

function [DATA] = datapack(IMGDIR,IMGNAME,IMGN1,IMGN2,IMGFMT,varargin)
%  This function creates a data pack (3D matrix) from a set of images in a directory. 
%  All images should have the same number of lines and columns, and similar format.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  DATA = datapack(IMGDIR,IMGNAME,IMGN1,IMGN2,IMGFMT);
%
%  %% To filenames: 'seed1.bmp', 'seed2,bmp', ..., 'seed128.bmp'
%  DATA = datapack('/user/images/sample1','seed',1,128,'bmp');
%
%  %% To filenames: 'img1coffee.bmp', 'img2coffee,bmp', ..., 'img100coffee.bmp'
%  DATA = datapack('/user/images/sample1','img%dcoffee',1,100,'bmp');
%
%  %% To filenames: 'img0001.bmp', 'img0002,bmp', ..., 'img0123.bmp'
%  DATA = datapack('/user/images/sample1','img%04d',1,123,'bmp');
%
%  Input:
%  IMGDIR  is a directory path where the images are, with format names as
%          NAME=[IMGNAME,'.',IMGFMT].
%  IMGNAME is the format filename, example: if the files in IMGDIR have names as 
%          'fig1.bmp', then IMGNAME='fig' or IMGNAME='fig%d'. If IMGNAME not
%          contain a format specifiers of family %d, them this format specifiers 
%          is added at the final of IMGNAME string. The format string is similar
%          to the function printf of others programming languages.
%          Only are permitted format specifiers of family %d, given that will
%          be replaced a decimal number.
%  IMGN1   is the index of the first image, example: if the files have names from 
%          'fig1.bmp' until 'fig4.bmp', then IMGN1=1.
%  IMGN2   is the index of the last image, example: if the files have names from 
%          'fig1.bmp' until 'fig4.bmp', then IMGN2=4.
%  IMGFMT  is the filetype of the image files, example: if the files have names 
%          as 'fig1.bmp', then IMGFMT='bmp'. Current is only permitted IMGFMT='bmp'.
%  LPOS    [Optional] This value is optional. It is the first line position for a window
%          analysis.
%  CPOS    [Optional] This value is optional. It is the first column position for a window
%          analysis.
%  NLIN    [Optional] This value is optional. It is the number of lines of a window under analysis.
%  NCOL    [Optional] This value is optional. It is the number of columns of a window under analysis.
%
%  Output:
%  DATA    is the speckle data. Where DATA is a 3D matrix created grouping NTIMES=IMGN2-IMGN1+1
%          matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%          N(1,1) represents NLIN and
%          N(1,2) represents NCOL and
%          N(1,3) represents NTIMES.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%                      Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>
%  Code documented by: Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%
%  Date:   09 of May of 2013.
%  Review: 13 of March of 2016.
%

	% Verify the presence of 9 parameters
	if((nargin==6)||(nargin==7)||(nargin==8))
		error('For window mode it is necessary 9 parameters: datapack(IMGDIR,IMGNAME,IMGN1,IMGN2,IMGFMT,LPOS,CPOS,NLIN,NCOL);');
	end
       
	%Verify if the obligatory parameters are correct
	if(~(ischar(IMGDIR)&&ischar(IMGNAME)&&isnumeric(IMGN1)&&isnumeric(IMGN2)&&ischar(IMGFMT)))

		if(~ischar(IMGDIR))
			disp('First parameter is not a string.');
		end
		if(~ischar(IMGNAME))
			disp('Second parameter is not a string.');
		end
		if(~isnumeric(IMGN1))
			disp('Third parameter is not a integer.');
		end
		if(~isnumeric(IMGN2))
			disp('4th parameter is not a integer.');
		end
		if(~ischar(IMGFMT))
			disp('5th parameter is not a string.');
		end
		error('Error in the parameters format of datapack function.');

	end

	if(strcmp(IMGFMT,'bmp')==0)
		error('5th parameter should be equal to string: bmp');
	end

	IMGN1=round(IMGN1);
	IMGN2=round(IMGN2);

    IMGDIR=replace_tild_home(IMGDIR);

	%Verify the existence of the directory
	if(exist(IMGDIR)~=7)
		error(['No exist directory: ', IMGDIR]);
	end

	if(length(strfind(IMGNAME,'%'))==0)
		IMGNAME=[IMGNAME,'%d'];
	end
	PRENAME=[IMGNAME,'.',IMGFMT];
	FIRSTFILE=fullfile(IMGDIR,sprintf(PRENAME,IMGN1));

	%Verify if at least the first file exists
	if(exist(FIRSTFILE)~=2)
		error(['No exist the file: ',FIRSTFILE]);
	end

    IMGTEMP = imread (FIRSTFILE);
    SizeIMG = size(IMGTEMP);

	if(size(IMGTEMP,3)~=1)
		error('The image should be a grayscale image!!!.');
	end
    
    
    Nlines   = SizeIMG(1,1);
    Ncolumns = SizeIMG(1,2);   

	if(nargin>=9)
		% Verify if the optional input is integer
		if(~(isnumeric(varargin{1})&&isnumeric(varargin{2})&&isnumeric(varargin{3})&&isnumeric(varargin{4})))
			error('The optional arguments should be integers');
		end

		LPOS=varargin{1};
		CPOS=varargin{2};
		NLIN=varargin{3};
		NCOL=varargin{4};

		if((LPOS+NLIN-1)>Nlines)
			error('Selected line in window out of range.');
		end
		if((CPOS+NCOL-1)>Ncolumns)
			error('Selected column in window out of range.');
		end
		WINDOW=1;
	else
		WINDOW=0;
	end  
    
	numImages=IMGN2-IMGN1+1;
    
	% Begin 
    disp(['Loading images from:',IMGDIR]);
    disp('Please wait...');
    
    
    if WINDOW == 0

        DATA = zeros(Nlines,Ncolumns,numImages);
        for II = 1:numImages
            nome = fullfile(IMGDIR,sprintf(PRENAME,IMGN1+II-1));
            DATA(:,:,II) = imread(nome);            
        end

    else

        DATA = zeros(NLIN,NCOL,numImages);
        for II = 1:numImages
            nome = fullfile(IMGDIR,sprintf(PRENAME,IMGN1+II-1));
            TODO= imread(nome);
            DATA(:,:,II) = TODO(LPOS:(NLIN+LPOS-1),CPOS:(NCOL+CPOS-1));
        end    

    end
    
 	disp('DATA Pack loaded...[OK]');
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newpath=replace_tild_home(oldpath)
%% Replaces the initial text '~/' in the variable oldpath, by the home path in 
%% gnu-linux or win, the function returns the result in the newpath variable.

    newpath=oldpath;
    if(length(oldpath)>=2)
    if(strcmp(oldpath(1:2),'~/'))
        if    ( length(getenv('HOME'))>0 )
            if(length(oldpath)>2)
                newpath=fullfile(getenv('HOME'),oldpath(3:end));
            else
                newpath=fullfile(getenv('HOME'));
            end
        elseif( length(getenv('HOMEPATH'))>0 )
            if(length(oldpath)>2)
                newpath=fullfile(getenv('HOMEDRIVE'),getenv('HOMEPATH'),oldpath(3:end));
            else
                newpath=fullfile(getenv('HOMEDRIVE'),getenv('HOMEPATH'));
            end
        else
            newpath=oldpath;
        end
    end
    end
end

