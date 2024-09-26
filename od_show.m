function od_show(P1,P2,Y1,Y2,opt)
	cm=colormap(prism);
	opt1.dirlength=opt.dirlength1;
	opt1.color=[.7 .7 .8];
	opt2.dirlength=opt.dirlength2;
	if strcmp(opt.status,'new') || strcmp(opt.status,'final')
		opt2.color=cm(1,:);
	elseif strcmp(opt.status,'single_decision')
		opt2.color=cm(2,:);
	elseif strcmp(opt.status,'multi_decision')
		opt2.color=cm(3,:);
	else 
		error('unexpected case.');
	endif	
	plot(P1,opt1);
	xlim([xlim()(1), xlim()(2)+opt.offset_x]);
	ylim([ylim()(1), ylim()(2)+opt.offset_y]);
	hold on
	if ~strcmp(opt.status,'new')
		plot(P2,opt2);
	endif
	if size(Y1,2)>0
		plot(Y1(1,:),Y1(2,:), 'ro'); 
		plot(Y2(1,:),Y2(2,:), 'bo'); 
	endif
	od__print(opt);
	hold off
end

function od__print(opt)
	if ~isfield(opt,"print")
		opt.print=false;
	endif
	if opt.print
		odp_print(opt);  % extern function
	endif
endfunction