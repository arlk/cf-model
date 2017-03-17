function b = bernMatrix_a2b(n, t)

% This is like bernsteinMatrix, but it works for any time interval, i.e.
% from [a,b] rather than [0,1]
% time t at the input must be a column vector

if ~(isscalar(n) && isreal(n) && n == round(n) && n >= 0),
   error(message('symbolic:sym:bernsteinMatrix:ExpectingNonNegativeInteger1'));
end
if isempty(t) 
   b = ones(0, n+1);
   return
end
if ~isvector(t)
   error(message('symbolic:sym:bernsteinMatrix:ExpectingVector2'));
end

% compute B(j+1) = binomial(n, j), j = 0..n
B = ones(n+1, 1); 
for j = 1:ceil(n/2)
  B(j+1) = B(j)*(n+1-j)/j;
  B(n+1-j) = B(j+1);
end
% compute T(i, j) = t(i)^j, TT(i, j) = (1-t(i))^(n-j)
T = ones(length(t), n+1);
TT = ones(length(t), n+1);
% turn a row t into a column t so that 
% we can do diag(t)*T(:,j) by t.*T(:,j)
tp = reshape(t, length(t), 1)-t(1);
ttp = t(length(t)) - t;
for j = 1:n 
  T(:, j+1) = tp .* T(:, j); 
  T(:, j) = T(:, j) .* B(j);
 TT(:,n+1-j) = ttp .* TT(:,n+2-j);
end

b =  T.*TT./((t(length(t))-t(1))^n);


