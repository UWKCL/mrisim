function [X,y] = generatedata(n,d,varargin)
  if n > d
    defaultNActVox = d;
  else
    defaultNActVox = n;
  end
  
  p = inputParser;
  addRequired(p,'n',@isnumeric);
  addRequired(p,'d',@isnumeric);
  addParameter(p,'groupsize',1,@isnumeric);
  addParameter(p,'nactivevox',defaultNActVox,@isnumeric);
  addParameter(p,'nactivegrp',1,@isnumeric);
  addParameter(p,'distributed',true,@islogical);
  addParameter(p,'snr',1,@isnumeric);
  addParameter(p,'nsubjects',1,@isnumeric);
	addParameter(p,'dimensions',1,@isnumeric);
	
  parse(p,n,d,varargin{:});

  gsz = p.Results.groupsize;
  nactivevox = p.Results.nactivevox;
  nactivegrp = p.Results.nactivegrp;

  if nactivevox > (nactivegrp * gsz)
    if gsz == 1
      nactivegrp = nactivevox;
    else
      error('Number of desired active voxels exceeds the total number voxels across desired active groups.')
    end
  end

  X = cell(p.Results.nsubjects,1);
  y = false(n,1);
  y(1:floor(n/2)) = true;

  r = mod(d,gsz);
  g = [1:d,nan(1,r)];
  G = reshape(g,(d+r)/gsz,gsz);

  if p.Results.distributed
    actgrp = randperm(size(G,1),nactivegrp);
  else
    actgrp = 1:nactivegrp;
  end

  z = G(actgrp,:);
  z = z(:);

	if p.Results.dimensions > 1
		x = randn(n,p.Results.dimensions);
		w = ones(p.Results.dimensions,1);
		y = x*w;
		[~,ix] = sort(y,'descend');
		y = y(ix) > 1;
		D = x(ix,:) * p.Results.snr;
		D = repmat(D,1,ceil(p.Results.nactivevox/p.Results.dimensions));
		D = D(:,1:p.Results.nactivevox);
	else
		D = double(y) * p.Results.snr;
		D = repmat(D,1,p.Results.nactivevox);
	end
	
  for i = 1:length(X)
    X{i} = zeros(n,d);
    activevox = z(randperm(length(z),nactivevox));
    X{i}(:,activevox) = D;
    X{i} = X{i} + randn(n,d);
  end
end
