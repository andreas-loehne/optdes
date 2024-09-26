function [val,x] = od_value_function(F,Y)
	% value fuction of set-valued map F at finite set Y
	% 	return the value "val"
	% 	return x such that F(x) supseteq Y, if one exists
	X=od__level_set(F,Y);
	val=od__svm_value(F,X);
	
	% try to find x such that F(x) supseteq Y
	YY=val.vrep.V;
	XX=od__level_set(F,YY);
	[~,x]=pcpsolve(sumnorm(F.n),XX);	
endfunction

function X = od__level_set(F,Y) % X = {x | Y \subseteq F(x) }
	k=size(Y,2);
	if k > 0
		C=cell(k,1);
		for i=1:k
			C{i}=od__svm_inv_value(F,Y(:,i));
		endfor
		X=intsec(C);
	else
		X=space(F.n);
	endif
endfunction

function Y = od__svm_value(F,X)
	Y=eval((F.graph&(X:space(F.q))).im([zeros(F.q,F.n),eye(F.q)]));
endfunction

function X = od__svm_inv_value(F,y)
	X=((F.graph)&(space(F.n):point(y))).im([eye(F.n),zeros(F.n,F.q)]);
endfunction





