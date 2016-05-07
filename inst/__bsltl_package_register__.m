%  Copyright (C) 2016 Carnë Draug <carandraug@octave.org>
%  Copyright (C) 2016  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
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

%  Undocumented internal function
%  Adapted-by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  original-work: __geometry_package_register__.m Carnë Draug <carandraug@octave.org>

%% PKG_ADD: __bsltl_package_register__ (1);
%% PKG_DEL: __bsltl_package_register__ (-1);

function subdir_paths = __bsltl_package_register__ (loading = 0)
	
%% loading = 0 :	Returns the installation paths of BSLTL pakage.
%% loading > 0 :	Add the BSLTL installation paths and 
%%					returns the installation paths of BSLTL pakage.
%% loading < 0 :	Remove the BSLTL installation paths and 
%%					returns the the remove paths of BSLTL pakage.

	%% Get full path, with luck we can retreive the package name from here
	base_pkg_path = fileparts (make_absolute_filename (mfilename ('fullpath')));

	subdir_paths = genpath(fullfile (base_pkg_path, 'mfiles'));

	if		(loading > 0)
		addpath (subdir_paths);
	elseif	(loading < 0)
		rmpath  (subdir_paths);
	endif

end
