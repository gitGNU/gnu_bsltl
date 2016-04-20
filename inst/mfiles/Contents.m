%                   Bio Speckle Laser Tool Library
%  
%  Version: 1.0
% 
%  Code developers:  Roberto Alves Braga Junior  <robertobraga@deg.ufla.br>
%                    Fernando Pujaico Rivera  <fernando.pujaico.rivera@gmail.com>
%                    Junio Moreira 
%
%  data/             * Functions for to work with data packages.
%
%      datacut.m         - Cuts an image portion of a data package.
%      datapack.m        - Creates a data package from a image set.
%      datapack_to_gif.m - Creates a gif file from a image set.
%      
%  extras/           * Free functions without  category.
%
%      hbpmf.m           - Returns the entropy of a probability mass function.
%      stscorr.m         - Implements a correlation between images.
%      threshold2d.m     - Implements a threshold over a 2D matrix.
%
%  filter/           * Functions to the frequency processing.
%
%      datapack_conv.m   - No-Causal convolution.
%      firfilterbank.m   - FIR Filter Bank.
%      firsynthesisbank.m- FIR Synthesis Bank.
%      firsynthesispath.m- FIR Synthesis Path.
%      freqmod.m         - Frequency Module.
%      qmfmaker.m        - Quadrature Mirror Filter maker.
%      qmfmirror.m       - Mirror of Quadrature Mirror Filter.
%
%  graphic/          * Graphic functions of activity indicators.
%
%      moments/          * Graphical functions relative to inertia moment.
%
%          graphavd.m        - Implements the graphic AVD technique.
%          graphim.m         - Implements the graphic inertia moment technique.
%          graphptd.m        - Implements the graphic PTD technique.
%          graphrvd.m        - Implements the graphic RVD technique.
%
%      others/           * Free graphical functions without  category.
%
%          graphmhi.m        - Implements the MHI technique.
%
%      stats/            * Graphical functions relative to statistical moments
%
%          graphkurt.m       - Implements the graphic kurtosis technique.
%          graphskew.m       - Implements the graphic skewness technique.
%
%      fujii.m           - Implements the Fujii technique.
%      gendiff.m         - Implements the generalized differences technique.
%      stdcont.m         - Implements the contrast, std and mean technique.
%
%  numerical/        * Numerical functions of activity indicators.
%
%      extras/           * Extra functions
%
%          stscorr.m         - Correlation.
%          thsp2corr.m       - THSP to Correlation.
%
%      pmf/              * Probability mass function.
%
%          pmfad.m           - Returns the probability mass function of AVD.
%          pmfrd.m           - Returns the probability mass function of RVD.
%
%      thsp/             * Time history speckle pattern.
%
%          thsp.m            - Returns the time history speckle pattern (THSP).
%          thsp_gaussian.m   - Returns the THSP of a set of Gaussian points.
%          thsp_line.m       - Returns the THSP of a line of points.
%          thsp_random.m     - Returns the THSP of a set of random points.
%
%      avd.m             - Implements the absolute value of differences.
%      coom.m            - Implements the co-occurrence.
%      inertiamoment.m   - Implements the inertia moment.
%      numad.m           - Implements the numerical average difference.
%      rvd.m             - Implements the regular value of differences.
%
%  quality/          * Functions for the quality test.
%
%      homogeneity.m     - Implements a study of homogeneity.
%      satdark.m         - Implements a study of saturated and dark sections.
%      sscont.m          - Implements a study of spatial speckle contrast.
%
%  undocumented/     * Functions without description in the reference and user manual.
%
%      datapack_to_bmp.m - Saves the images inside of datapack in a set of BMP files
%



