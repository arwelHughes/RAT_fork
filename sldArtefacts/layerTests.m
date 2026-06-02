
% Testing of layer SLD artefacts...

z = 0:200;
l = 50; 
r = 80;
Sigma_L = 4;
Sigma_R = 30;
height = 1;

%[VF,r] = erf_layer(z,l,30,1,3,3);

a = (z-l)./((2^0.5) * Sigma_L);
b = (z-r)./((2^0.5) * Sigma_R);

left = erf(a);
right = -erf(b);

figure(1); clf, subplot(1,2,1)
plot(z,left,'LineWidth',2.0)
hold on
plot(z,right,'LineWidth',2.0);
ylim([-1.2 1.2]); grid on
xlabel('z'); title('Error Functions');

VF = (height/2) * (erf(a) - erf(b));
subplot(1,2,2)
plot(z,VF,'LineWidth',2.0)
ylim([-0.2 1.2]); grid on
xlabel('z'); title('sum(erf) = Volume Fraction');

height = 1;






% -------------------------------------------------------------------------

function [VF, r] = erf_layer(z, prevLaySurf, thickness, height, Sigma_L, Sigma_R)

l = prevLaySurf;
r = prevLaySurf + thickness;

a = (z-l)./((2^0.5) * Sigma_L);
b = (z-r)./((2^0.5) * Sigma_R);

VF = (height/2) * (erf(a) - erf(b));

end

% -------------------------------------------------------------------------

function [VF, r] = tanh_layer(z, prevLaySurf, thickness, height, Sigma_L, Sigma_R)

l = prevLaySurf;
r = prevLaySurf + thickness;

a = (z-l)./((2^0.5) * Sigma_L);
b = (z-r)./((2^0.5) * Sigma_R);

leftFun = erf(a);
rightFun = -tanh(b);

% Do a correction for when the tanh function over runs.
% essentially, set the tanh to 1 before this happens (this does leave a small
% step artefact as it is rather crude....)

% Put our functions into the format that 'interX' expects....
allLeft = [z ; leftFun];      % Left side (error function)
allRight = [z ; rightFun];     % right side (tanh function)

% Find the intersection between the two curves....
inter = InterX(allLeft,allRight);

% First value of output is z at the intersection. Find the index of this...
zz = find(z <= inter(1));
zz = zz(end);

% Set everithing in the tanh before this to 1....
rightFun(1:zz) = 1;

% Finally make the overall Volume Fraction....
VF = (height / 2) * (leftFun + rightFun);


end

% -------------------------------------------------------------------------

function P = InterX(L1,varargin)
%INTERX Intersection of curves
%   P = INTERX(L1,L2) returns the intersection points of two curves L1 
%   and L2. The curves L1,L2 can be either closed or open and are described
%   by two-row-matrices, where each row contains its x- and y- coordinates.
%   The intersection of groups of curves (e.g. contour lines, multiply 
%   connected regions etc) can also be computed by separating them with a
%   column of NaNs as for example
%
%         L  = [x11 x12 x13 ... NaN x21 x22 x23 ...;
%               y11 y12 y13 ... NaN y21 y22 y23 ...]
%
%   P has the same structure as L1 and L2, and its rows correspond to the
%   x- and y- coordinates of the intersection points of L1 and L2. If no
%   intersections are found, the returned P is empty.
%
%   P = INTERX(L1) returns the self-intersection points of L1. To keep
%   the code simple, the points at which the curve is tangent to itself are
%   not included. P = INTERX(L1,L1) returns all the points of the curve 
%   together with any self-intersection points.
%   
%   Example:
%       t = linspace(0,2*pi);
%       r1 = sin(4*t)+2;  x1 = r1.*cos(t); y1 = r1.*sin(t);
%       r2 = sin(8*t)+2;  x2 = r2.*cos(t); y2 = r2.*sin(t);
%       P = InterX([x1;y1],[x2;y2]);
%       plot(x1,y1,x2,y2,P(1,:),P(2,:),'ro')

%   Author : NS
%   Version: 3.0, 21 Sept. 2010

%   Two words about the algorithm: Most of the code is self-explanatory.
%   The only trick lies in the calculation of C1 and C2. To be brief, this
%   is essentially the two-dimensional analog of the condition that needs
%   to be satisfied by a function F(x) that has a zero in the interval
%   [a,b], namely
%           F(a)*F(b) <= 0
%   C1 and C2 exactly do this for each segment of curves 1 and 2
%   respectively. If this condition is satisfied simultaneously for two
%   segments then we know that they will cross at some point. 
%   Each factor of the 'C' arrays is essentially a matrix containing 
%   the numerators of the signed distances between points of one curve
%   and line segments of the other.

    %...Argument checks and assignment of L2
    error(nargchk(1,2,nargin));
    if nargin == 1,
        L2 = L1;    hF = @lt;   %...Avoid the inclusion of common points
    else
        L2 = varargin{1}; hF = @le;
    end
       
    %...Preliminary stuff
    x1  = L1(1,:)';  x2 = L2(1,:);
    y1  = L1(2,:)';  y2 = L2(2,:);
    dx1 = diff(x1); dy1 = diff(y1);
    dx2 = diff(x2); dy2 = diff(y2);
    
    %...Determine 'signed distances'   
    S1 = dx1.*y1(1:end-1) - dy1.*x1(1:end-1);
    S2 = dx2.*y2(1:end-1) - dy2.*x2(1:end-1);
    
    C1 = feval(hF,D(bsxfun(@times,dx1,y2)-bsxfun(@times,dy1,x2),S1),0);
    C2 = feval(hF,D((bsxfun(@times,y1,dx2)-bsxfun(@times,x1,dy2))',S2'),0)';

    %...Obtain the segments where an intersection is expected
    [i,j] = find(C1 & C2); 
    if isempty(i),P = zeros(2,0);return; end;
    
    %...Transpose and prepare for output
    i=i'; dx2=dx2'; dy2=dy2'; S2 = S2';
    L = dy2(j).*dx1(i) - dy1(i).*dx2(j);
    i = i(L~=0); j=j(L~=0); L=L(L~=0);  %...Avoid divisions by 0
    
    %...Solve system of eqs to get the common points
    P = unique([dx2(j).*S1(i) - dx1(i).*S2(j), ...
                dy2(j).*S1(i) - dy1(i).*S2(j)]./[L L],'rows')';
              
    function u = D(x,y)
        u = bsxfun(@minus,x(:,1:end-1),y).*bsxfun(@minus,x(:,2:end),y);
    end
end