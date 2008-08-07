function [energy, grad] = gmmreg_L2_tps_costfunc(param, init_affine, basis,  kernel, scene, scale, alpha, beta, n, d)
if isempty(init_affine) %% which implies opt_affine is true
    affine_param = reshape(param(1:d*(d+1)),d,d+1);
    affine_param = affine_param';
    tps_param = reshape(param(d*(d+1)+1:d*n),d,n-d-1);
    tps_param = tps_param';
else %% which implies that affine_param is fixed
    tps_param = reshape(param(1:d*n-d*(d+1)),d,n-d-1);
    tps_param = tps_param';
    affine_param = reshape(init_affine,d,d+1);
    affine_param = affine_param';
end
after_tps = basis*[affine_param;tps_param];
bending = trace(tps_param'*kernel*tps_param);
[energy,grad] = general_costfunc(after_tps, scene, scale);
energy = alpha*energy + beta * bending;
grad = alpha*basis'*grad;
grad(d+2:n,:) = grad(d+2:n,:) + 2*beta*kernel*tps_param;
if isempty(init_affine) %% which implies opt_affine is true
    grad = grad';
    grad = reshape(grad,1,d*n);
else %% which implies that affine_param is fixed
    grad(1:d+1,:) = [ ];
    grad = grad';
    grad = reshape(grad,1,d*(n-d-1));
end

function [f, g] = general_costfunc(A, B, scale)
[f1, g1] = GaussTransform(A,A,scale);
[f2, g2] = GaussTransform(A,B,scale);
f =  f1 - 2*f2;
g = 2*g1 - 2*g2;
