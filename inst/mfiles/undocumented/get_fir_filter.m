%  Copyright (C) 2016   Fernando Pujaico Rivera
%
%  This file is a part of the Bio Speckle Laser Tool Library (BSLTL)
%  package.
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

function [h varargout]=get_fir_filter(ORDER,Wn,varargin)
%
%  This function returns a fir filter with an order and  cut-off specified.
%  Also can be configured the types of filter as: low pass, high pass, band pass  
%  and band stop. The filter also can be weighted by a window. Finally exist
%  a parameter that indicates if should be plotted the time and frequency  
%  impulse response.
%  
%  After starting the main routine just type the following command at the
%  prompt:
%
%  % By default it is low-pass, hamming window and not display the impulse response.
%          h=get_fir_filter(ORDER,Wn);
%  [h FTYPE]=get_fir_filter(ORDER,Wn);
%
%  % By default it uses hamming window and not display the impulse response.
%          h=get_fir_filter(ORDER,Wn,CTYPE);
%  [h FTYPE]=get_fir_filter(ORDER,Wn,CTYPE);
%
%  % By default it don't display the impulse response.
%          h=get_fir_filter(ORDER,Wn,CTYPE,WINDOW);
%  [h FTYPE]=get_fir_filter(ORDER,Wn,CTYPE,WINDOW);
%
%  % All parameters are configured.
%          h=get_fir_filter(ORDER,Wn,CTYPE,WINDOW,GRAPHON);
%  [h FTYPE]=get_fir_filter(ORDER,Wn,CTYPE,WINDOW,GRAPHON);
%
%
%  %% Low pass filter of order ORDER=20, cut-off at frequency to a*Fs/2, Hanning
%  %% windows
%  h=get_fir_filter(20,a,'low');
%
%  %% High pass filter of order ORDER=20, cut-off at frequency a*Fs/2, Hanning
%  %% windows
%  h=get_fir_filter(20,a,'high');
%
%  %% Band pass filter of order ORDER=40, cut-off at frequencies at 
%  %% [a1*Fs/2 a2*Fs/2], Hanning windows
%  h=get_fir_filter(40,[a1 a2],'bandpass');
%
%  %% Reject pass filter of order ORDER=40, cut-off at frequencies at [a1*Fs/2 a2*Fs/2], 
%  %% Hanning windows
%  h=get_fir_filter(40,[a1 a2],'stop');
%
%  
%  Input:
%  ORDER     is the a variable that content the order of filter, the length of 
%            filter will be equal to ORDER+1.
%  Wn        is a scalar variable or vector(1x2) that content the cut-off 
%            frequencies.
%  CTYPE     [optional] it is the cut-off type of the fir filter, it can be ser
%            'low', 'high', 'bandpass' or 'stop'. By default this value is 'low'.
%  WINDOW    [optional] it is a vector that represent the weighted values of the
%            the filter.
%  GRAPHON   [optional] enable or disable the display of the frequency  
%            impulse response.
%
%  Output:
%  h         it is a vector of length ORDER+1 that represent a fir filter of
%            order ORDER.
%  FTYPE     [optional] returns the type of the fir filter.
%            http://www.mathworks.com/help/signal/ug/fir-filter-design.html
%
%  For help, bug reports and feature suggestions, please visit:
%  http://www.nongnu.org/bsltl
%

%  Code developed by:  Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>               
%  Code documented by: Fernando Pujaico Rivera <fernando.pujaico.rivera@gmail.com>
%  Code reviewed by:   
%  
%  Date: 20 of August of 2016.
%

	%Checking parameters
    [Wn CUTOFF_TYPE WINDOW GRAPHON]=get_additional_params(ORDER,Wn,varargin{:});

    D=ORDER/2;
    n=linspace(-D,D,ORDER+1);

    if(strcmp(CUTOFF_TYPE,'low'))
        [h FTYPE]=get_lowpass_fir_filter(ORDER,Wn,WINDOW);

    elseif(strcmp(CUTOFF_TYPE,'high'))
        [h FTYPE]=get_highpass_fir_filter(ORDER,Wn,WINDOW);

    elseif(strcmp(CUTOFF_TYPE,'bandpass'))
        [h FTYPE]=get_bandpass_fir_filter(ORDER,Wn,WINDOW);

    elseif(strcmp(CUTOFF_TYPE,'stop'))
        [h FTYPE]=get_bandstop_fir_filter(ORDER,Wn,WINDOW);

    end

    if (GRAPHON==true)
        plot_filter_data(h,Wn);
    end

    if (nargout>=2)
        varargout{1}=FTYPE;
    end
end

%
% Returns a low pass fir filter of order ORDER and cut-off Wn and window WINDOW.
%
function [h FTYPE]=get_lowpass_fir_filter(ORDER,Wn,WINDOW)

    D=ORDER/2;
    n=linspace(-D,D,ORDER+1);

    if (mod(ORDER,2)==0)
        FTYPE=1;
    else
        FTYPE=2;
    end
    h=sin(pi*Wn*n)./(eps+pi*n);
    if (mod(ORDER,2)==0)
        h(ORDER/2+1)=Wn;
    end 
    h=h.*WINDOW;
    for II=1:floor(length(h)/2)
        h(ORDER+2-II)=h(II);
    end
    h=h/sum(h);
end

%
% Returns a high pass fir filter of order ORDER and cut-off Wn and window WINDOW.
%
function [h FTYPE]=get_highpass_fir_filter(ORDER,Wn,WINDOW)
    if (mod(ORDER,2)==0)
        FTYPE=1;
    else
        fprintf('\nThis function creates a fir filte of type IV, \n');
        fprintf('Please see types of fir filter in:\n');
        fprintf('http://www.mathworks.com/help/signal/ug/fir-filter-design.html\n\n');
        FTYPE=4;
    end
    hl=get_fir_filter(ORDER,1-Wn,'low',WINDOW);
    for II=1:(ORDER+1)
        hl(II)=hl(II)*(-1)^(II-1);
    end
    
    if (hl(round(ORDER/2+1))<0)
        hl=-hl;
    end
    h=hl;
end

%
% Returns a band pass fir filter of order ORDER and cut-offs Wn and window WINDOW.
%
function [h FTYPE]=get_bandpass_fir_filter(ORDER,Wn,WINDOW)

    if (mod(ORDER,2)==0)    %% ORDER es par
        hl=get_fir_filter(ORDER,Wn(2),'low' ,ones(1,ORDER+1));
        hh=get_fir_filter(ORDER,Wn(1),'high',ones(1,ORDER+1));
        h=conv(hl,hh); % ORDER=length1+length2-1;
        h=h(ORDER/2+1:3*ORDER/2+1);
        FTYPE=1;
    else            %% ORDER es impar
        hl=get_fir_filter(ORDER  ,Wn(2),'low' ,ones(1,ORDER+1));
        hh=get_fir_filter(ORDER-1,Wn(1),'high',ones(1,ORDER  ));%high should has even order
        h=conv(hl,hh); % ORDER=length1+length2-1;
        h=h((ORDER+1)/2:(3*ORDER+1)/2);
        FTYPE=2;
    end

    h=h.*WINDOW;
    G=freqmod(h, 10/abs(Wn(2)-Wn(1)-round(Wn(2)-Wn(1))) );
    h=h/max(G);
end

%
% Returns a band stop fir filter of order ORDER and cut-offs Wn and window WINDOW.
%
function [h FTYPE]=get_bandstop_fir_filter(ORDER,Wn,WINDOW)
    if (mod(ORDER,2)==0)    %% ORDER es par
        h=get_fir_filter(ORDER,Wn,'bandpass' ,WINDOW);
        h=-h;
        h(ORDER/2+1)=1+h(ORDER/2+1);
        G=freqmod(h, 10/abs(Wn(2)-Wn(1)-round(Wn(2)-Wn(1))) );
        h=h/max(G);
        FTYPE=1;
    else

        fprintf(sprintf('\nThis function can''t creates a band stop fir filter with order %d of types I, II, III or IV.\n',ORDER));
        fprintf('Please see types of fir filter in:\n');
        fprintf('http://www.mathworks.com/help/signal/ug/fir-filter-design.html\n');
        warning(sprintf('Returning a band stop filter of order %d\n\n',ORDER+1));
        n=[1:length(WINDOW)];
        n2=linspace(min(n),max(n),length(n)+1);
        W = spline (n,WINDOW,n2);
        [h FTYPE]=get_fir_filter(ORDER+1,Wn,'stop' ,W);
    end
end

%
% This function returns additional parameters to calculates the filter.
% Wnout       is a sort version in ascending order of Wn.
% CUTOFF_TYPE is the cut-of type of filter, it can be 'low', 'high', 'bandpass' 
%              or 'stop'.
%
function [Wnout CUTOFF_TYPE WINDOW GRAPHON]=get_additional_params(ORDER,Wn,varargin)
    if(~isscalar(ORDER))
        error('The first parameter should be a scalar.');
    end
    if(~isvector(Wn))
        error('The second parameter should be a row of 1x1 or 1x2.');
    elseif(size(Wn,1)~=1)        
        error('The second parameter should be a row of 1x1 or 1x2.');        
    elseif(length(Wn)>2)
        error('The second parameter should be a row of 1x1 or 1x2.');
    end

    Wnout=sort(Wn);

    GRAPHON=false;
    WINDOW=hamming(ORDER+1);
    
    if(length(Wnout)==1)
        CUTOFF_TYPE='low';
    else
        CUTOFF_TYPE='bandpass';
    end

    if(nargin>2)
        for II=1:(nargin-2)
            if(isvector(varargin{II})&&isnumeric(varargin{II}))
                if(length(varargin{II})==(ORDER+1))
                    WINDOW=varargin{II};
                else
                    error(['The window parameter should have the same length of ORDER+1=',num2str(ORDER+1)]);
                end
            elseif(ischar(varargin{II}))
                if strcmp(varargin{II},'on')
                    GRAPHON=true;
                elseif strcmp(varargin{II},'off')
                    GRAPHON=false;
                elseif strcmp(varargin{II},'low')
                    CUTOFF_TYPE='low';
                    if(length(Wn)~=1)
                        error('The second parameter should be a scalar number.');
                    end
                elseif strcmp(varargin{II},'high')
                    CUTOFF_TYPE='high';
                    if(length(Wn)~=1)
                        error('The second parameter should be a scalar number.');
                    end
                elseif strcmp(varargin{II},'stop')
                    CUTOFF_TYPE='stop';
                    if(length(Wn)~=2)
                        error('The second parameter should be a row of 1x2.');
                    end
                elseif strcmp(varargin{II},'bandpass')
                    CUTOFF_TYPE='bandpass';
                    if(length(Wn)~=2)
                        error('The second parameter should be a row of 1x2.');
                    end
                else
                    error('The filter type parameter should be: ''low'',''high'',''stop'',''bandpass''.');
                end
            else
                error('The additionals parameter should be or rows or strings.');
            end
        end
    end

    if(size(WINDOW,1)~=1)
        WINDOW=WINDOW';
    end

    if(length(WINDOW)~=(ORDER+1))
        error('Window has different size of ORDER+1.');
    end

end

%
% This functions retuns two figures about the impulse responnse of the filter h.
%
function plot_filter_data(h,Wn)
    ORDER=length(h)-1;
    D=ORDER/2;
    n=linspace(-D,D,ORDER+1);

    %%%%%%plot(n,h,'-o');grid;    xlim([min(n) max(n)]);
    
    if (length(Wn)==2)
        BW=Wn(2)-Wn(1);
    else
        BW=Wn;
    end

    %%%%%%figure(gcf+1);
    
    % if BW<0.5 then exist 20 dots in the plot until Wn.
    % if BW>=0.5 then exist 20 dots in the plot later of Wn.
    [G f]=freqmod(h,20/(abs(BW-round(BW))));
    if (length(Wn)==2)
        plot(f,abs(G),  [0 1],[0.5 0.5], ...
                        [Wn(1) Wn(1) Wn(1) Wn(1) Wn(1)],[0 0.25 0.5 0.75 1.0], ...
                        [Wn(2) Wn(2) Wn(2) Wn(2) Wn(2)],[0 0.25 0.5 0.75 1.0]); grid;
    else
        plot(f,abs(G),[0 1],[0.5 0.5],[Wn Wn Wn Wn Wn],[0 0.25 0.5 0.75 1.0]); grid;
    end
    xlim([0 1]);ylim([0 1.2]);

end
