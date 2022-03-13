function Fire_series = PCNN_oscillation(I,N,P)
%------------------------------
V_L = P(1);
alpha_L = P(2);
V_F = P(3);
alpha_F = P(4);
V_T = P(5);
alpha_T = P(6);
theata0 = P(7);
beta = P(8);
W=[0.5 1 0.5;1 0 1;0.5 1 0.5];
%-------------------------
[m,n] = size(I);
S = I;
Y = zeros(m,n);
Y = double(Y);
L = zeros(m,n);
L = double(L);
F = zeros(m,n);
F = double(F);
theata = theata0.*ones(m,n);
Fire_series = zeros(m,n);
for i=1:N
    L = exp(-alpha_L).*L + V_L.*conv2(Y,W,'same');
    F = exp(-alpha_F).*F + V_F.*conv2(Y,W,'same') + S;
    U = F.*(1+beta.*L);
    Y = (U >theata);
    Y = double(Y);
    Fire_series = Fire_series + Y;
    theata = exp(-alpha_T).*theata + V_T.*Y;
end

