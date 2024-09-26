function molp = nscd2molp(nscd)
	A      = nscd.A;         % incidence matrix of digraph
	n      = size(A,1);      % number of nodes
	m      = size(A,2);      % number of arcs
	k      = nscd.k;         % number of supply nodes
	l      = n-k;            % number of demand nodes
	A_supp = A(1:k,:);       % rows of supply nodes
	A_dem  = A(k+1:k+l,:);   % rows of demand nodes
	u      = nscd.u;         % arc capacities
	b      = nscd.b;         % demand at demand nodes
	c      = nscd.c;         % costs of flow along arcs
	a      = nscd.a;         % costs for establishing one unit of supply capacity 
	tau    = nscd.tau;       % excess of tau percent of    arc capacities is accumulated
	mu     = nscd.mu;        % excess of  mu percent of supply capacities is accumulated
	g1     = nscd.gamma1;    % weight for the arc excesses
	g2     = nscd.gamma2;    % weight for the supply excesses

	% 1st-stage vars: z in R^k
	% 2nd-stage vars: x in R^m
	% in order to resolve the w^+=max{w,0} terms, there are additional 2nd-stage vars: xi in R^m, zeta in R^k
	% variable vector: (z, x, xi, zeta) >= 0
	
	% first and secod objective function: costs and acumulated excesses
	f1 = [         a;          c;    zeros(m,1);    zeros(k,1)];
	f2 = [zeros(k,1); zeros(m,1);  g1*ones(m,1);  g2*ones(k,1)];
	
	% feasible set
	%                 z    |        x  |       xi     |        zeta
	rep.B = [    zeros(k,k),    -A_supp,    zeros(k,m),    zeros(k,k); ...  %      - A_supp x             >= 0
	             zeros(l,k),     A_dem ,    zeros(l,m),    zeros(l,k); ...  %        A_dem  x             == b
	               eye(k,k),     A_supp,    zeros(k,m),    zeros(k,k); ...  %    z + A_supp x             >= 0
	             zeros(m,k),   eye(m,m),     -eye(m,m),    zeros(m,k); ...  %               x - xi        <= tau u
	            mu*eye(k,k),     A_supp,    zeros(k,m),      eye(k,k)];     % mu z + A_supp x      + zeta >= 0
	rep.l = [    zeros(k,1); zeros(m,1);    zeros(m,1);    zeros(k,1)];	    % z,x,xi,zeta >= 0
	rep.u = [ Inf*ones(k,1);          u; Inf*ones(m,1); Inf*ones(k,1)];	    % z,x,xi,zeta >= 0	  
			 
	rep.a = [   zeros(k,1); b;    zeros(k,1); -Inf*ones(m,1);    zeros(k,1)]; % lower bounds
	rep.b = [Inf*ones(k,1); b; Inf*ones(k,1);          tau*u; Inf*ones(k,1)]; % upper bounds
	
	molp.obj        = [f1,f2]';       % objective matrix
	molp.feas       = polyh(rep,'h'); % feasible set
	molp.cone       = cone(2);        % order cone
	molp.n1         = k;              % the first n1 vars are first-stage
endfunction
 
		
		
		
		
		
		

