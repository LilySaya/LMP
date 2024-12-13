clear


H = diag([0.1, 0.1, 0.1])
H = inv(H)
A = [-1, 1, 0;
     -1, 0, 1;
     0, 1, -1]

X = H*A
B_susceptance = [H(1,1)+H(3,3), -H(1,1), -H(3,3);
                 -H(1,1), H(2,2)+H(1,1), -H(2,2);
                 -H(2,2), -H(3,3), H(2,2)+H(3,3)]
B_susceptance_prime = B_susceptance(1:2,1:2)
temp = [inv(B_susceptance_prime), zeros(2,1);zeros(1,2), 0]
T = X*temp