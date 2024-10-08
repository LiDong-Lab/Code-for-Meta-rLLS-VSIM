function output = XxRotate3D(inArray, angle_y, angle_x, zx_aspratio, varargin)
%rotate3D rotate a 3D array by "angle" around the 1st dimension (y axis)
%   angle: angle in degrees to be rotated; in terms of physical geometry
%   zx_aspratio: ratio of z step size over x-y pixel size

% [Ny, Nx, Nz] = size(inArray);
% inArray = imresize3(inArray, [Ny, Nx, round(Nz * zx_aspratio)]);
% zx_aspratio = 1;

if nargin < 4, zx_aspratio = 1; end
if nargin < 3, angle_x = 0; end

z_trans = 0;
for k = 1 : length(varargin)
    switch k
        case 1
            % extra z-translate
            z_trans = varargin{k};
        otherwise
            disp('Unknown varargin index')
    end
end

center = (size(inArray)+1)/2;
T1 = [1 0 0                 0
      0 1 0                 0
      0 0 1                 0
      -center+[0 0 z_trans] 1];
% rescale the 3rd dimension (z)
T1a = [1 0 0           0
       0 1 0           0
       0 0 zx_aspratio 0
       0 0 0           1];
   
angleRad = angle_y*pi/180;
% rotate around the first dimension (y axis)
T2 = [1 0             0              0
      0 cos(angleRad) -sin(angleRad) 0
      0 sin(angleRad) cos(angleRad)  0
      0 0             0              1];
TSIZE_B = round(size(inArray) .* [1 1/cos(angleRad) zx_aspratio]);
T3 = [1 0 0 0
      0 1 0 0
      0 0 1 0
      (TSIZE_B+1)/2 1];

TSIZE_B = round(size(inArray) .* [1 1/cos(angleRad) zx_aspratio]);
T5 = [1 0 0 0
      0 1 0 0
      0 0 1 0
      (TSIZE_B+1)/2 1];

% angleRad = - atan(30/422);
angleRad = angle_x*pi/180;
T6 = [cos(angleRad) 0 -sin(angleRad) 0
      0 1 0 0
      sin(angleRad) 0 cos(angleRad)   0
      0 0 0 1];
TSIZE_B = round(size(inArray) .* [1/cos(angleRad) 1 zx_aspratio]);
T7 = [1 0 0 0
      0 1 0 0
      0 0 1 0
      (TSIZE_B+1)/2 1];

T = T1 * T1a * T2 * T3 * T5 * T6 * T7;

tform = affine3d(T);
% output = imwarp(inArray, tform, 'OutputView', imref3d(size(inArray)));
output = imwarp(inArray, tform);

end

