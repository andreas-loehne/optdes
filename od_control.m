function [Y, status] = od_control(P, Y) % Last column in Y is a proposal
	while true
		[y1, y2, button] = ginput(1);
		if button == 1 % Left mouse button
			z   = [y1; y2];
			idx = od__find_col_in(z, Y);
			if idx > 0 % Delete point on which was clicked
				Y(:, idx) = []; 
			else % Add a new point
				z = od__project(P, z); % If not in P, use projection
				Y = [Y, z];
			end
			status = 'clicked';
			return;
		elseif button == 3 % Right mouse button
			Y = Y(:, 1:end-1); % Delete last point
			status = 'clicked';
			return;
		elseif button == 27 % ESC key
			status = 'exit';
			return;
		else
			status = 'unknown';
			disp('Click on graphics or quit by ESC.');
		end
	endwhile
endfunction

function idx = od__find_col_in(z, Y, eps = 1e-2)
	dx = xlim()(2) - xlim()(1); % Width of graphics
	dy = ylim()(2) - ylim()(1); % Height of graphics
	idx = 0;
	if size(Y, 2) > 0
		D        = Y - z * ones(1, size(Y, 2));
		D_scaled = [1/dx; 1/dy] * ones(1, size(Y, 2)) .* D;
		dist     = vecnorm(D_scaled);
		[val, pos] = min(dist);
		if val <= eps
			idx = pos;
		end
	end
endfunction

function z = od__project(P, y, eps = 1e-2)
	PP   = (P - point(y)).eval;
	x0   = getpoint(PP);
	dx   = xlim()(2) - xlim()(1); % Width of graphics
	dy   = ylim()(2) - ylim()(1); % Height of graphics
	H    = [(1/dx)^2,0;0,(1/dy)^2];
	z    = qp(x0, H, [], [], [], [], [], [], PP.hrep.B, PP.hrep.b);
	V    = PP.vrep.V;
	idx  = od__find_col_in(z, V, eps);
	if idx > 0 % Choose close vertex
		z = V(:, idx) + y;
	else % Project arbitrarily on boundary
		z = y + z;
	end
endfunction

