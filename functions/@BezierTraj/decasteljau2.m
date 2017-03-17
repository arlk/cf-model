function Pout = decasteljau2(P,lambda)         
[m,n] = size(P);
n     = n-1;
A     = (1-lambda)*eye(n,n);
B     = lambda*eye(n,n);
C     = zeros(n+1,n);

C(1:n,:)   = C(1:n,:) + A; 
C(2:n+1,:) = C(2:n+1,:) + B;

Ptemp = P;
P1 = zeros(m,n);
P2 = zeros(m,n);

for i = n:-1:1
    Ptemp(:,1:i) = Ptemp(:,1:i+1)*C(1:i+1,1:i);
    P1(:,n+1-i)  = Ptemp(:,1);
    P2(:,i)      = Ptemp(:,i);
end

Pout = [P(:,1) P1 P2(:,2:end) P(:,end)];