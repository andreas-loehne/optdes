function [Y1,Y2]=od_nondominated(Y,cone)
	% split Y in non-dominated points Y1 and dominated points Y2
	if size(Y,2)>0
		conv_Y_plus_C=polyh(struct('V',Y),'v')+cone;
		Y1=conv_Y_plus_C.vrep.V;
		Y2=od__col_minus(Y,Y1);
	else
		Y1=Y;
		Y2=Y;
	endif

endfunction

function C=od__col_minus(A,B,eps=1e-4)
	cols_to_remove = false(1, size(A, 2));
	for i = 1:size(A, 2)
	    if min(vecnorm(B-A(:,i)*ones(1,size(B,2))))<eps
	        cols_to_remove(i) = true;
		endif
	endfor
	C = A(:, ~cols_to_remove);
endfunction

