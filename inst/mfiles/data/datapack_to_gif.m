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

function h=datapack_to_gif(DATA,Filename,Frames,varargin)
%
%  This function creates a gif file from the data pack (DATA).
%
%  After starting the main routine just type the following command at the
%  prompt:
%  datapack_to_gif(DATA,Filename,Frames);
%  datapack_to_gif(DATA,Filename,Frames,Map);
%  datapack_to_gif(DATA,Filename,Frames,Map,Time);
%  
%  Input:
%  DATA     is the speckle data pack. Where DATA is a 3D matrix created grouping NTIMES 
%           intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%           N(1,1) represents NLIN and
%           N(1,2) represents NCOL and
%           N(1,3) represents NTIMES.
%  Filename is the name of gif file.
%  Frames   is the number of frames in the gif file. In the number of images (NTIMES) 
%           is less than the number of frames (Frames), then overwrite Frames=NTIMES;
%  Map      [Optional] is the colormap, this value can be: jet, gray, hsv, ..., etc.
%           By default: jet. See: colormap('list')
%  Time     [Optional] is the time between frames in the gif file. By default: 0.5 sec.
%
%  Output:
%  h        is the name of gif file.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>      
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by: Roberto A Braga Jr <robertobraga@deg.ufla.br>
%  
%  Date: 09 of July of 2015.
%  Review: 25 of February of 2016.
%

	NTIMES = size(DATA,3);
	Step   = round(NTIMES/Frames);

	if(Step == 0)
		Step=1;
	end
		
	Max=max(max(max(DATA)));

	D=(DATA*64/Max);


	if (nargin<4)
		map = jet;
	else
		if(ismatrix(varargin{1}))
			map=varargin{1};
		else
			map=jet;
		end
	end

	Time=0.5;
	if(nargin>4)
		if(isscalar(varargin{2}))
			Time=varargin{2};
		end
	end


	%Write the first frame to a file named animGif.gif
	imwrite(	D(:,:,1),map,Filename,'gif','LoopCount',...
				inf,'DelayTime',Time);

    NFRAMES=1;

	%Loop through and write the rest of the frames
	for ii=2:Step:NTIMES
	     imwrite(D(:,:,ii),map,Filename,'gif','writemode',...
				'append','DelayTime',Time);

        NFRAMES=NFRAMES+1;
        if(NFRAMES == Frames)   break;
	end

	h=Filename;

end
