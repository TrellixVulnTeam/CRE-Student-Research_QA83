function [l,dl,dsurr] = ll2bax(x,D,mu,nui,doprior,options);
% 
% [l,dl,surrugatedata] = ll2bax(x,D,mu,nui,doprior,options);
% 
% log likelihood (l) and gradient (dl) of simple RW model with irreducible noise
% and separate reward and loss sensitivities
% 
% Use this within emfit.m to tit RL type models to a group of subjects using
% EM. 
% 
% Guitart-Masip M, Huys QJM, Fuentemilla L, Dayan P, Duezel E and Dolan RJ
% (2012): Go and nogo learning in reward and punishment: Interactions between
% affect and effect.  Neuroimage 62(1):154-66 
%
% Quentin Huys 2011-2012 qhuys@gatsby.ucl.ac.uk

dodiff=nargout==2;
np = length(x);
beta 		= exp(x(1:2));				% sensitivity to rewards and losses
alfa 		= 1./(1+exp(-x(3)));		% learning rate
g    		= 1/(1+exp(-x(4)));		% irreducible noise 

% add Gaussian prior with mean mu and variance nui^-1 if doprior = 1 
[l,dl] = logGaussianPrior(x,mu,nui,doprior);

a = D.a; 
r = D.r; 
s = D.s; 

V=zeros(1,4); 
Q=zeros(2,4); 

dQdb = zeros(2,4,2);
dQde = zeros(2,4);

if options.generatesurrogatedata==1
	a = zeros(size(a));
	dodiff=0;
end

for t=1:length(a)
	rho = sum(s(t)==[1 3]);

	q = Q(:,s(t)); 

	l0 = q - max(q);
	la = l0 - log(sum(exp(l0)));
	p0 = exp(la); 
	pg = g*p0 + (1-g)/2;

	if options.generatesurrogatedata==1
		[a(t),r(t)] = generatera(pg',s(t));
	end
	l = l + log(pg(a(t)));
	er = beta(2-rho) * r(t);

	if dodiff
		for k=1:2
			tmp = (dQdb(:,s(t),k) );
			dl(k) = dl(k) + g*(p0(a(t)) * (tmp(a(t)) - p0'*tmp)) / pg(a(t));
			dQdb(a(t),s(t),k) = (1-alfa)*dQdb(a(t),s(t),k) + alfa*er * (k==2-rho);
		end

		tmp = (dQde(:,s(t)) );
		dl(3) = dl(3) + g*(p0(a(t)) * (tmp(a(t)) - p0'*tmp)) / pg(a(t));
		dQde(a(t),s(t)) = (1-alfa)*dQde(a(t),s(t)) + (er-Q(a(t),s(t)))*alfa*(1-alfa);

		dl(4) = dl(4) + g*(1-g)*(p0(a(t))-1/2)/pg(a(t));

	end

	Q(a(t),s(t)) = Q(a(t),s(t)) + alfa * (er - Q(a(t),s(t)));  

end
l  = -l;
dl = -dl;

if options.generatesurrogatedata==1
	dsurr.a = a; 
	dsurr.r = r; 
end


