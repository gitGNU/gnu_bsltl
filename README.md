# BioSpeckle Laser Tool Library (BSLTL)


## Introduction

The BSLTL package is a free collection of OCTAVE/MATLAB routines for working with the
biospeckle laser technique.

Implemented technics:
* AVD,IM,COM,THSP, etc.
* FUJII,GD,PTD,STD, etc.
* FIR filters, DWT, IDWT, etc.

## Citations

To cite the BSLTL package in publications use:

	Roberto Alves Braga Júnior, Fernando Pujaico Rivera and Junio Moreira (2016).
	BSLTL: Biospeckle Laser Tool Library - version 1.0.1.
	URL http://www.nongnu.org/bsltl/

A BibTeX entry for LaTeX users is:

	@misc{BSLTL1,
		author    = {Braga J\'unior, Roberto Alves and 
					Pujaico Rivera, Fernando and 
					Moreira, Junio},
		title     = {{BSLTL:} Biospeckle Laser Tool Library - version 1.0.1},
		year      = {2016},
		url       = {http://www.nongnu.org/bsltl/}
	}

We have invested a lot of time and effort in creating BSLTL package, please 
cite it when using it.  See also `citation pkgname' for citing other Octave 
package with pkgname name.

## Dependencies

### Octave dependencies
Some functions inside BSLTL package depend of signal package and image package;
at the same time the signal package depends of control package.
Thus, we recommend install first the control package and later the signal package
with the following online OCTAVE installation commands.

	pkg install -forge control
	pkg install -forge signal
	pkg install -forge image

In operating systems based in GNU/Linux can be necessary install first the 
library liboctave-dev in the system, given that OCTAVE uses this library to install 
the control package. The next code is an example of command install in the system.

	sudo apt-get install liboctave-dev


## Installation

### Method 1: Online - Only in OCTAVE

The next OCTAVE code, install the last version of BSLTL package directly from 
octave-forge website in the default install directory.

	pkg install -forge -auto bsltl

With this method the package is configured for be loaded automatically when OCTAVE start.

### Method 2: Offline - Only in OCTAVE

The next OCTAVE code, install the BSLTL package, [bsltl.tar.gz](http://download.savannah.gnu.org/releases/bsltl/), 
in the directory: ~/lib/octmat
If the BSLTL package was downloaded in the directory: /download_path

	pkg prefix ~/lib/octmat
	pkg install -auto /download_path/bsltl.tar.gz

With this method the package is configured for be loaded automatically when OCTAVE start.

### Method 3: Offline - In MATLAB or OCTAVE

If the BSLTL package, [bsltl.tar.gz](http://download.savannah.gnu.org/releases/bsltl/), 
was uncompressed in the directory '/home/user/lib/octmat/bsltl'. 
For that this package can be used by a source file, it needs add the next code 
in the top of source file.

	BSLTL_DIR='/home/user/lib/octmat/bsltl';
	addpath(genpath(BSLTL_DIR));

The function genpath generates a list with the directories and sub directories.
The function addpath add directories to OCTAVE system path.

In this method we install (add to  Octave system path) the BSLTL package each 
time that we call our source files. 

## Using the BSLTL package

Many code examples  can be found in the [homepage](http://www.nongnu.org/bsltl)
of BSLTL library.

### Example code of method 1 and 2 - Getting the AVD value of line 240

	IMAGES_DIR = '/home/user/data/speckle/test1';

	DATA = datapack(IMAGES_DIR,'',1,129,'bmp'); % Datapack of 129 images. 
												% '1.bmp', '2.bmp', ...

	THSP = thsp(DATA,1,240);          % Getting the time history speckle pattern.
	COM  = coom(THSP);                % Getting the co-occurrence matrix.
	AVD  = avd(COM);                  % Getting the AVD value.

### Example code of method 3 - Getting the AVD value of column 100

	BSLTL_DIR = '/home/user/lib/octmat/bsltl';
	addpath(genpath(BSLTL_DIR));

	IMAGES_DIR = '/home/user/data/speckle/test1';

	DATA = datapack(IMAGES_DIR,'',1,129,'bmp'); % Datapack of 129 images.
												% '1.bmp', '2.bmp', ...

	THSP = thsp(DATA,2,100);          % Getting the time history speckle pattern.
	COM  = coom(THSP);                % Getting the co-occurrence matrix.
	AVD  = avd(COM);                  % Getting the AVD value.

## Contributing to the package

In the case that you want to include a new function in the library,
submissions will only be accepted when they have the source code documented
and they are accompanied by a tutorial 
(all these should be below General Public License or any compatible).
The tutorial can be made with Latex, Texinfo, Markdown, or any support that 
uses plain text.

### Contributing from mailing list
To contribute to BSLTL package from mailing list,
you can send a message to the
[mailing list](https://savannah.nongnu.org/mail/?group=bsltl)

### Contributing through a patch
To contribute to BSLTL package through a patch:

* Clone the package;
* Make your changes in the source code;
* Create the patch;
* Submit it to the [patch tracker](https://savannah.nongnu.org/patch/?func=additem&group=bsltl).

See the next example.

	#Clone the package;
	git clone http://git.savannah.gnu.org/r/bsltl.git
								# Make a local copy of BSLTL source repository
	cd bsltl
	
	# You should make your changes here. And later...
	
	git add *
	git commit -m "Here, you describe the modification made."
								# Commit the changeset into your local repository.
	
	# Create the patch;
	git format-patch -1 -o ../
								# Export the last changeset (commit) to a diff file.
	
	# Attach the created diff file to the patch tracker.

Submit the file in the [patch tracker](https://savannah.nongnu.org/patch/?func=additem&group=bsltl).

## Copyright

	Copyright (c) 2016 BSLTL project group.

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation; either version 2 of the
	License, or (at your option) any later version.
	 
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
	USA.

## Versions

The increment in the version number has a meaning. To a version number 
with the format 'va.b.c' (by example: v1.0.0).
An increment in 'c' indicates a modification or correction in the code.
An increment in 'b' indicates that at least a new function was added in the code.
An increment in 'c' is reserved to great modifications in the code.

## BSLTL project group - Authors

Roberto Alves Braga Júnior <robertobraga@deg.ufla.br>
Fernando Pujaico Rivera    <fernando.pujaico.rivera@gmail.com> 
Junio Moreira	           <juniomoreira@iftm.edu.br>

## Support or Contact

Having trouble with the package? Check out our 
[documentation](http://www.nongnu.org/bsltl/documentation.html) or 
[contact support](https://savannah.nongnu.org/mail/?group=bsltl).

## Home Page

[Home page of BSLTL project](http://www.nongnu.org/bsltl/).



