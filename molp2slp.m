function slp = molp2slp(molp)	
	S = molp.feas;    % feasible set
	M = molp.obj;     % objective matrix
	C = molp.cone;    % order cone
	n1 = molp.n1;     % the first k vars are first-stage
	n2 = S.sdim - n1; % number of second stage vars
	q  = C.sdim;
	
	% graph F = {(x,y) | exits z : - M(x,z) + y in C, (x,z) in S}
	slp.F.graph = (C.inv([-M,eye(q,q)]) & S:space(q)).im([  eye(n1,n1), zeros(n1,n2), zeros(n1,q); ...
	                                                       zeros(q,n1), zeros( q,n2),   eye( q,q)]);
	slp.F.q     =  q; %     image space dimension
	slp.F.n     = n1; % pre-image space dimension
	
	% natural order cone K = { y | exists x : (x,y) in gr G, (x,0) in gr G}, G recession map  
	grG = slp.F.graph.recc;
	n   = slp.F.n;
	q   = slp.F.q;
endfunction

