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

function [Y] = thsp_line(DATA,R,S)
%
%  This function creates the THSP (Time History Speckle Pattern)[1][2] of a set 
%  of pixels in a line in a data pack (DATA), (This function is an alias of 
%  thsp() function).
%
%  References:
%  [1]  OULOMARA, G.; TRIBILLON, J.; DUVERNOY, J. Biological activity measurements 
%       on botanical specimen surfaces using a temporal decorrelation effect of 
%       laser speckle. Journal of Moderns Optics, London, v. 36, n. 2, p. 136-179, 
%       Feb. 1989.
%
%  [2]  XU, Z.; JOENATHAN, C.; KHORANA, B. M. Temporal and spatial properties of 
%       the time-varying speckles of botanical specimens. Optical Enginnering, Virginia, 
%       v. 34, n. 5, p. 1487-1502, May 1995.
%
%  After starting the main routine just type the following command at the
%  prompt:
%  Y = thsp_line(DATA,R,S);
%  
%  Input:
%  DATA is the speckle datapack. Where DATA is a 3D matrix created grouping NTIMES 
%       intensity matrices with NLIN lines and NCOL columns. When N=size(DATA), then
%       N(1,1) represents NLIN and
%       N(1,2) represents NCOL and
%       N(1,3) represents NTIMES.
%  R    is a parameter of analysis: 
%       if R is equal to 1, you choose the lines from the images to create the THSP and
%       if R is equal to 2, you choose the columns of images to create the THSP.
%       In other cases it returns error.
%  S    is the line or column position used to create the time history speckle pattern.
%       The function do not verify if S is in the range, this must be checked by the user.
%
%  Output:
%  Y    is the time history speckle patterns matrix. Where Y is a 2D matrix with
%       M lines and NTIMES columns, being M equal to NCOL when R is 1 and M equal 
%       to NLIN when R is 2.
%       Y is a matrix where each column is a representation of one only line or column 
%       in the S position of DATA.
%
%
%  For help, bug reports and feature suggestions, please visit:
%  http://nongnu.org/bsltl/
%

%  Code developed by:  Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%  Code adapted by:    Junio Moreira <juniomoreira@iftm.edu.br>
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   Roberto Alves Braga Junior <robertobraga@deg.ufla.br>
%
%  Date: 09 of May of 2013.
%  Review: 28 of March of 2016.
%
	Y = thsp(DATA,R,S);
    
