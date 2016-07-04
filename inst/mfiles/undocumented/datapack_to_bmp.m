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

function h=datapack_to_bmp(DATA,DIRECTORY,PRENAME)
%
%  This function save the images inside of datapack in a set of BMP files.
%  The formation rule of the BMP file names is:
%
%  NAME=fullfile(DIRECTORY,sprintf([PRENAME,'.bmp'],II));
%
%  Being II, the number of the saved image.
%
%  After starting the main routine just type the following command at the
%  prompt:
%
%  h = datapack_to_bmp(DATA,DIRECTORY,PRENAME);
%
%  %% To filenames: 'seed1.bmp', 'seed2,bmp', ..., 'seed128.bmp'
%  h = datapack_to_bmp(DATA,'','seed%d');
%
%  %% To filenames: 'img1coffee.bmp', 'img2coffee,bmp', ..., 'img100coffee.bmp'
%  h = datapack_to_bmp(DATA,'','img%dcoffee');
%
%  %% To filenames: 'img0001.bmp', 'img0002,bmp', ..., 'img0123.bmp'
%  h = datapack_to_bmp(DATA,'','img%04d');
%
%  
%  Input:
%  DATA      is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%            intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%            N(1,1) represents NLIN and
%            N(1,2) represents NCOL and
%            N(1,3) represents NTIMES.
%  DIRECTORY is the address where the BMP files will be saved.
%  PRENAME   is the format filename, example: if you search names as 
%            'fig1.bmp', then PRENAME='fig' or PRENAME='fig%d'. If PRENAME not
%            contain a format specifiers of family %d, them this format specifiers 
%            is added at the final of PRENAME string. The format string is similar
%            to the function printf of others programming languages.
%            Only are permitted format specifiers of family %d, given that will
%            be replaced a decimal number.
%
%  Output:
%  h         returns a struct with the fields,
%            h.file{i}: The name of i-th bmp file, 
%            h.format:  The format filename,
%            h.init:    The id of first element,
%            h.dir:     The directory where the images will be saved, and
%            h.nel:     The numbeer of images.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://www.nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>               
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 20 of February of 2016.
%  Review: 28 of March of 2016.
%
	%Checking parameters
	if(~(ischar(DIRECTORY)&&ischar(PRENAME)))


		if(~ischar(DIRECTORY))
			disp('Second parameter is not a string.');
		end
		if(~ischar(PRENAME))
			disp('Third parameter is not a string.');
		end
		
		error('Error in the parameters format of datapack function.');

	end

    NSIZE = size(DATA);
	NLIN  = NSIZE(1,1);
	NCOL  = NSIZE(1,2);
	NTIMES= NSIZE(1,3);

	DATA=uint8(DATA);

	if(length(strfind(PRENAME,'%'))==0)
		PRENAME=[PRENAME,'%d'];
	end

    mkdir(DIRECTORY);

    h.file=cell(1,NTIMES);
    h.format=[PRENAME,'.bmp'];
    h.init=1;
    h.dir=DIRECTORY;
    h.nel=NTIMES;

	for II=1:NTIMES
		h.file{II}=fullfile(DIRECTORY,sprintf(h.format,II));
		imwrite(DATA(:,:,II),h.file{II});
	end

end
