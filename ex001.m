% example of the paper optdes

clear all

% network supply capacity design problem

% incidence matrix of digraph
nscd.A    = [ 1 -1  1 -1  0  0  0  0  0  0  0  0  0  0  0  0  0  0; ...  % node 1 (power plant 1)
			  0  0  0  0  1 -1  1 -1  0  0  0  0  0  0  0  0  0  0; ...  % node 2 (power plant 2)
			  0  0  0  0  0  0  0  0  1 -1  1 -1  0  0  0  0  0  0; ...  % node 3 (power plant 3)
			  0  0  0  0  0  0  0  0  0  0  0  0  1 -1  1 -1  0  0; ...  % node 4 (power plant 4)
		 	 -1  1  0  0 -1  1  0  0 -1  1  0  0 -1  1  0  0  1 -1; ...  % node n (nothern  district)
			  0  0 -1  1  0  0 -1  1  0  0 -1  1  0  0 -1  1 -1  1];     % node s (southern district)
nscd.k=4;  	    % number of power plants
nscd.tau=0.8;   % excess of tau percent of    arc capacity is accumulated
nscd.mu =0.9;   % excess of  mu percent of supply capacity is accumulated
nscd.gamma1=1;  % weight for    arc capacity excess
nscd.gamma2=3;  % weight for supply capacity excess
			  
			 
nscd.b = [50;40];                 	                               % demand at n and s
nscd.c = [ 1  1  1  1  2  2  3  3  2  2  2  2  3  3  2  2 6 6]';   % costs      1n 1s 2n 2s 3n 3s 4n 4s ns
nscd.u = [24 24 12 12 13 13 18 18 15 15 26 26 17 17 23 23 8 8]';   % capacities 1n 1s 2n 2s 3n 3s 4n 4s ns
nscd.a = [10 11 8 9]';                                             % cost of establishing one unit of powerplant capacity at 1 2 3 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optimizer design                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opt.dirlength1=30;
opt.dirlength2=20;
opt.offset_x=20;
opt.offset_y=1;
opt.name=mfilename;
opt.remark='Example of the paper optdes.';
opt.prob=nscd;
opt.probname='nscd';

%opt.print=true;

molp = nscd2molp(nscd);
slp  = molp2slp(molp);
x    = od(slp,opt);

if ~isempty(x)
	disp('');
	disp('Decision for power plant capacities:');
	for i=1:nscd.k
		fprintf('Power plant %d: %4.1f\n',[i,x(i)]);
	end
	fprintf(    'Sum          : %4.1f\n',[ones(1,size(x,1))*x]);
endif





