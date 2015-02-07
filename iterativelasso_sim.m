addpath('../iterativelasso/');

[Xc,y] = generatedata(200, 1000,'nactivevox',200,'nsubjects',1,'dimensions',3,'snr',1);
cvblocks = bsxfun(@eq,repmat((1:10)',10,1),1:10);

for i = 1:length(Xc)
	X = Xc{i};
	if i > 1
		[finalModel(i,1),iterModels(i,:)] = iterativelasso(X,y,cvblocks);
	else
		[finalModel,iterModels] = iterativelasso(X,y,cvblocks);
	end
end


reshape([iterModels.dp],size(iterModels))
reshape([iterModels.df],size(iterModels))