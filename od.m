function x = od(slp, opt=struct())
	fprintf('********************\n');
	fprintf('* Optimizer design *\n');
	fprintf('********************\n');
	fprintf(' - Click left in the graphics to select a new point.\n');
	fprintf(' - Click on existing point to delete it.\n');
	fprintf(' - Click right to undo last selection.\n');
	fprintf(' - Press ESC to quit. (graphics window must be active)\n\n');    
	fprintf(' - Gray region: all possible and better outcomes.\n');
	fprintf(' - Colored regions: outcomes which can be achieved together with selected points\n');
	fprintf('   + Yellow: not realizable by a single decision.\n'); 
	fprintf('   + Orange: realizable by single decision x.\n\n');
    
	F = slp.F;    % set-valued objective map
	q = slp.F.q;  % number of objectives
	n = slp.F.n;  % number of variables
    
	% check for existence of optimizers
	G       = od__recc(F);                       % recession map G of F
	[G0, x] = od_value_function(G, zeros(q, 1)); % returns the natural order cone K of F
	if isempty(x)                                % no optimizer, otherwise K == G(0)
		disp('Problem has no optimizer.');
		return; 
	end
    
	opt.fig      = figure;      % store figure handle
	opt.status   = 'new';       % status: new problem 
	opt.cnt      = 0;           % init plot counter
	%optimizers.z = zeros(n, 0);
	opt.res.z   = zeros(n, 0);%   = optimizers;  % empty set for storing the optimizers
	opt.input.Y  = {};
	
	od__print_expose(opt);      % init
	Y            = zeros(q, 0); % set Y to empty set

	do
		[Y1, Y2] = od_nondominated(Y, G0);
		[optval1, x] = od_value_function(slp.F, Y1);
		if strcmp(opt.status, 'new') % store the optimal value for background plot
			optval = optval1;
		end
		if isempty(x)
			disp('Further selections required.');
			opt.status = 'multi_decision';
		else
			fprintf('Optimizer x = [%s]\n', num2str(x', ' %.4g'));
			opt.status = 'single_decision';
			opt.res.z = [opt.res.z,x];
		end
		opt.input.Y{end+1} = Y;
		opt.cnt = opt.cnt + 1;
		od_show(optval, optval1, Y1, Y2, opt);
		[Y, control_status] = od_control(optval1, Y);
	until (strcmp(control_status, 'exit'))
	close(opt.fig);
    
	od__print_expose(opt);
endfunction

function optval = od__optval(F)
	q = F.q;
	n = F.n;
	M = [zeros(q, n), eye(q)];
	optval = eval(F.graph.im(M));
endfunction

function G = od__recc(F)
	G.graph = F.graph.recc;
	G.n     = F.n;
	G.q     = F.q;
endfunction

function od__print_expose(opt)
	if ~isfield(opt, 'print')
		opt.print = false;
	end
	if opt.print
		if opt.cnt>0 % print
			odp_print_expose(opt);  % extern function
		else % init
			fullname=["examples/",opt.name];
			system(['rm ',fullname,'/*']);
		endif
	end
endfunction
