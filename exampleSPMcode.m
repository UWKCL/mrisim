% Set data
%--------------------------------------------------------------------------
data_path = 'rawDataPath';
functScans = spm_select('FPList', fullfile(data_path,'RawEPI'), '^sM.*\.img$');
structScans = spm_select('FPList', fullfile(data_path,'Structural'), '^sM.*\.img$');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSICAL STATISTICAL ANALYSIS (PARAMETRIC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear matlabbatch

% Load onsets
%--------------------------------------------------------------------------
onsets = load(fullfile(data_path,'sots.mat'));

% Output directory
%--------------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'parametric';

% Model Specification
%--------------------------------------------------------------------------
batch_categ = load(fullfile(data_path,'categorical_spec.mat'));
matlabbatch{2} = batch_categ.matlabbatch{2};

matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name',{},'param',{},'poly',{});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod.name = 'Lag';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod.param = onsets.itemlag{2};
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod.poly = 2;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name',{},'param',{},'poly',{});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).pmod.name = 'Lag';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).pmod.param = onsets.itemlag{4};
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).pmod.poly = 2;
matlabbatch{2}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'parametric'));
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];

% Model Estimation
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'parametric','SPM.mat'));

% Inference
%--------------------------------------------------------------------------
matlabbatch{4}.spm.stats.con.spmmat = cellstr(fullfile(data_path,'parametric','SPM.mat'));
matlabbatch{4}.spm.stats.con.consess{1}.fcon.name = 'Famous Lag';
matlabbatch{4}.spm.stats.con.consess{1}.fcon.weights = [zeros(2,6) eye(2)];

matlabbatch{5}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'parametric','SPM.mat'));
matlabbatch{5}.spm.stats.results.conspec.contrasts = Inf;
matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FWE';

matlabbatch{6}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'parametric','SPM.mat'));
matlabbatch{6}.spm.stats.results.conspec.contrasts  = 9;
matlabbatch{6}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{6}.spm.stats.results.conspec.thresh     = 0.001;
matlabbatch{6}.spm.stats.results.conspec.extent     = 0;
matlabbatch{6}.spm.stats.results.conspec.mask.contrasts = 5;
matlabbatch{6}.spm.stats.results.conspec.mask.thresh    = 0.05;
matlabbatch{6}.spm.stats.results.conspec.mask.mtype     = 0;

% Run
%--------------------------------------------------------------------------
save('face_batch_parametric.mat','matlabbatch');
%spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);
