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

function hf=imagesc_with_points(MAT, POINTS,varargin)

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
%  Code reviewed by:   
%  
%  Date: 20 of February of 2016.
%  Review: 28 of March of 2016.
%

	if (nargin>2)
		if(~ischar(varargin{1}))
			error('The third parameter should be a string.');
		else
			OPTIONS=varargin{1};
		end
	else
		OPTIONS='r';
	end

	hf=0;

	SIZE=size(MAT);
	M = size(POINTS,1);
	L = size(POINTS,2);

	if (L==2)
		lin=POINTS(:,1);
		col=POINTS(:,2);
	else
		[lin, col] = ind2sub (SIZE, POINTS(:,1));
	end

	hf=imagesc(MAT);
	hold on;
	scatter(col,lin,OPTIONS);
	hold off;
end
