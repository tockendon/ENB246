function constructMov(image, frames, k)
% construct Construct a movie of a reconstructed image
% 
% Example
%    construct('test.png', 10, 4)
% 
% Purpose:
% To provide a movie of the choosen image, showing frames the samples taken
% and the respective reconstruction.
%
% Record of Revisions:
%   Date         Engineer            Descriptions of Change
%  ======       ==========          ========================
%  10/05/2013   Terrance Ockendon   Original Code

% Define Variables:
%    image           -- Image file
%    frames          -- Set the number of frames for the total movie
%    k               -- 'k' is for k nearest undamaged pixels to sample
%                       close by the damaged pixel
% Add Reconstruct function directory
addpath Reconstruct
% Set function handles for distance and colour calculations
distanceFunc = @distanceEuc;
colourFunc = @colourAverage;
% Reads input image to RGB array
picMAT = imread(image);
% % Preallocate movie structure.
% frameSeq(1:frames) = struct('cdata', [], 'colormap', []);
prob = 1/frames;
probadder = 1;
for jj = 1:frames
    [imageFile] = picSampler(picMAT, probadder); 
    % Sampled image in the 1st position of the sub-plot
    subtightplot(1,2,1,0);
    iptsetpref('ImshowBorder', 'tight');
    title('Samples')
    imshow(imageFile,'InitialMagnification','fit');
    [pictureRecon] = reconstruct(imageFile, k, distanceFunc, colourFunc);
    fprintf('Rendered %d of %d frames\n',jj, frames) 
    % Reconstructed image in the 2nd position of the sub-plot
    subtightplot(1,2,2,0);
    iptsetpref('ImshowBorder', 'tight');
    title('Reconstruction')
    imshow(pictureRecon,'InitialMagnification','fit');
    % Gets the current figure and records to frame
    frameSeq(jj) = getframe(gcf);
    probadder = probadder - prob;
end
% Compiles the collected frames into an .avi file type
movie2avi(frameSeq, 'movie.avi', 'compression', 'None');
fprintf('AVI Created!\n')

% Helper Functions
function [output] = picSampler(picMAT, probadder)
% Samples the image depending on 'probadder'
if probadder < 1
    [picRow, picCol, ~] = size(picMAT);
    randBlack = randperm(picRow*picCol, ceil(probadder*picRow*picCol));
    for ii = 1:3
        picMAT(randBlack+(ii-1)*picRow*picCol) = 0;
    end
    blackMAT = picMAT;
    output = blackMAT;
else
    blackMAT = picMAT;
    output = blackMAT;
end
function [h] = subtightplot(m,n,p,gap,marg_h,marg_w,varargin)
%function h=subtightplot(m,n,p,gap,marg_h,marg_w,varargin)
%
% Functional purpose: A wrapper function for Matlab function subplot. Adds the ability to define the gap between
% neighbouring subplots. Unfotrtunately Matlab subplot function lacks this functionality, and the gap between
% subplots can reach 40% of figure area, which is pretty lavish.
%
% Input arguments (defaults exist):
%   gap- two elements vector [vertical,horizontal] defining the gap between neighbouring axes. Default value
%            is 0.01. Note this vale will cause titles legends and labels to collide with the subplots, while presenting
%            relatively large axis.
%   marg_h  margins in height in normalized units (0...1)
%            or [lower uppper] for different lower and upper margins
%   marg_w  margins in width in normalized units (0...1)
%            or [left right] for different left and right margins
%
% Output arguments: same as subplot- none, or axes handle according to function call.
%
% Issues & Comments: Note that if additional elements are used in order to be passed to subplot, gap parameter must
%       be defined. For default gap value use empty element- [].
%
% Usage example: h=subtightplot((2,3,1:2,[0.5,0.2])
% 
% Copyright (c) 2012, Felipe G. Nievinski
% Copyright (c) 2010, Pekka Kumpulainen
% Copyright (c) 2011, Nikolay S.
% All rights reserved.

if (nargin<4) || isempty(gap),    gap=0.01;  end
if (nargin<5) || isempty(marg_h),  marg_h=0.05;  end
if (nargin<5) || isempty(marg_w),  marg_w=marg_h;  end
if isscalar(gap),   gap(2)=gap;  end
if isscalar(marg_h),  marg_h(2)=marg_h;  end
if isscalar(marg_w),  marg_w(2)=marg_w;  end
gap_vert   = gap(1);
gap_horz   = gap(2);
marg_lower = marg_h(1);
marg_upper = marg_h(2);
marg_left  = marg_w(1);
marg_right = marg_w(2);

%note n and m are switched as Matlab indexing is column-wise, while subplot indexing is row-wise :(
[subplot_col,subplot_row]=ind2sub([n,m],p);

% note subplot suppors vector p inputs- so a merged subplot of higher dimentions will be created
subplot_cols=1+max(subplot_col)-min(subplot_col); % number of column elements in merged subplot
subplot_rows=1+max(subplot_row)-min(subplot_row); % number of row elements in merged subplot

% single subplot dimensions:
%height=(1-(m+1)*gap_vert)/m;
%axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh;
height=(1-(marg_lower+marg_upper)-(m-1)*gap_vert)/m;
%width =(1-(n+1)*gap_horz)/n;
%axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;
width =(1-(marg_left+marg_right)-(n-1)*gap_horz)/n;

% merged subplot dimensions:
merged_height=subplot_rows*( height+gap_vert )- gap_vert;
merged_width= subplot_cols*( width +gap_horz )- gap_horz;

% merged subplot position:
merged_bottom=(m-max(subplot_row))*(height+gap_vert) +marg_lower;
merged_left=(min(subplot_col)-1)*(width+gap_horz) +marg_left;
pos_vec=[merged_left merged_bottom merged_width merged_height];

% h_subplot=subplot(m,n,p,varargin{:},'Position',pos_vec);
% Above line doesn't work as subplot tends to ignore 'position' when same mnp is utilized
h=subplot('Position',pos_vec,varargin{:});

if (nargout < 1),  clear h;  end
