function [D,Gamma,err,gerr] = ksvd(params,varargin)
%KSVD K-SVD dictionary training.
%  [D,GAMMA] = KSVD(PARAMS) runs the K-SVD dictionary training algorithm on
%  the specified set of signals, returning the trained dictionary D and the
%  signal representation matrix GAMMA.
%
%  KSVD has two modes of operation: sparsity-based and error-based. For
%  sparsity-based minimization, the optimization problem is given by
%
%      min  |X-D*GAMMA|_F^2      s.t.  |Gamma_i|_0 <= T
%    D,Gamma
%
%  where X is the set of training signals, Gamma_i is the i-th column of
%  Gamma, and T is the target sparsity. For error-based minimization, the
%  optimization problem is given by
%
%      min  |Gamma|_0      s.t.  |X_i - D*Gamma_i|_2 <= EPSILON
%    D,Gamma
%
%  where X_i is the i-th training signal, and EPSILON is the target error.
%
%  [D,GAMMA,ERR] = KSVD(PARAMS) also returns the target function values
%  after each algorithm iteration. For sparsity-constrained minimization,
%  the returned values are given by
%
%    ERR(D,GAMMA) = RMSE(X,D*GAMMA) = sqrt( |X-D*GAMMA|_F^2 / numel(X) ) .
%
%  For error-constrained minimization, the returned values are given by
%
%    ERR(D,GAMMA) = mean{ |Gamma_i|_0 } = |Gamma|_0 / size(X,2) .
%
%  Error computation slightly increases function runtime.
%
%  [D,GAMMA,ERR,GERR] = KSVD(PARAMS) computes the target function values on
%  the specified set of test signals as well, usually for the purpose of
%  validation (testing the generalization of the dictionary). This requires
%  that the field 'testdata' be present in PARAMS (see below). The length
%  of ERR and GERR is identical.
%
%  [...] = KSVD(...,VERBOSE) where VERBOSE is a character string, specifies
%  messages to be printed during the training iterations. VERBOSE should
%  contain one or more of the characters 'i', 'r' and 't', each of which
%  corresponds to a certain piece of information:
%           
%    i - iteration number
%    r - number of replaced atoms
%    t - target function value (and its value on the test data if provided)
%
%  Specifying either 'r', 't' or both, also implies 'i' automatically. For
%  example, KSVD(PARAMS,'tr') prints the iteration number, number of
%  replaced atoms, and target function value, at the end of each iteration.
%  The default value for VERBOSE is 't'. Specifying VERBOSE='' invokes
%  silent mode, and cancels all messages.
%
%  [...] = KSVD(...,MSGDELTA) specifies additional messages to be printed
%  within each iteration. MSGDELTA should be a positive number representing
%  the interval in seconds between messages. A zero or negative value
%  indicates no such messages (default). Note that specifying VERBOSE=''
%  causes KSVD to run in silent mode, ignoring the value of MSGDELTA.
%
%
%  Required fields in PARAMS:
%  --------------------------
%
%    'data' - Training data.
%      A matrix containing the training signals as its columns.
%
%    'Tdata' / 'Edata' - Sparse coding target.
%      Specifies the number of coefficients (Tdata) or the target error in
%      L2-norm (Edata) for coding each signal. If only one is present, that
%      value is used. If both are present, Tdata is used, unless the field
%      'codemode' is specified (below).
%
%    'initdict' / 'dictsize' - Initial dictionary / no. of atoms to train.
%      At least one of these two should be present in PARAMS.
%
%      'dictsize' specifies the number of dictionary atoms to train. If it
%      is specified without the parameter 'initdict', the dictionary is
%      initialized with dictsize randomly selected training signals.
%
%      'initdict' specifies the initial dictionary for the training. It
%      should be either a matrix of size NxL, where N=size(data,1), or an
%      index vector of length L, specifying the indices of the examples to
%      use as initial atoms. If 'dictsize' and 'initdict' are both present,
%      L must be >= dictsize, and in this case the dictionary is
%      initialized using the first dictsize columns from initdict. If only
%      'initdict' is specified, dictsize is set to L.
%
%
%  Optional fields in PARAMS:
%  --------------------------
%
%    'testdata' - Validation data.
%      If present, specifies data on which to compute generalization error.
%      Should be a matrix containing the validation signals as its columns.
%
%    'iternum' - Number of training iterations.
%      Specifies the number of K-SVD iterations to perform. If not
%      specified, the default is 10.
%
%    'memusage' - Memory usage.
%      This parameter controls memory usage of the function. 'memusage'
%      should be one of the strings 'high', 'normal' (default) or 'low'.
%      When set to 'high', the fastest implementation of OMP is used, which
%      involves precomputing both G=D'*D and DtX=D'*X. This increasese
%      speed but also requires a significant amount of memory. When set to
%      'normal', only the matrix G is precomputed, which requires much less
%      memory but slightly decreases performance. Finally, when set to
%      'low', neither matrix is precomputed. This should only be used when
%      the trained dictionary is highly redundant and memory resources are
%      very low, as this will dramatically increase runtime. See function
%      OMP for more details.
%
%    'codemode' - Sparse-coding target mode.
%      Specifies whether the 'Tdata' or 'Edata' fields should be used for
%      the sparse-coding stopping criterion. This is useful when both
%      fields are present in PARAMS. 'codemode' should be one of the
%      strings 'sparsity' or 'error'. If it is not present, and both fields
%      are specified, sparsity-based coding takes place.
%
%    'exact' - Exact K-SVD update.
%      Specifies whether the exact or approximate dictionary update
%      should be used. By default, the approximate computation is used,
%      which is significantly faster and requires less memory. Specifying a
%      nonzero value for 'exact' causes the exact computation to be used
%      instead, which slows down the method but provides slightly improved
%      results. The exact update uses SVD to solve the rank-1 minimization
%      problem, while the approximate upate performs alternate-optimization
%      to solve this problem.
%
%
%  Optional fields in PARAMS - advanced:
%  -------------------------------------
%
%    'maxatoms' - Maximal number of atoms in signal representation.
%      When error-based sparse coding is used, this parameter can be used
%      to specify a hard limit on the number of atoms in each signal
%      representation (see parameter 'maxatoms' in OMP2 for more details).
%
%    'muthresh' - Mutual incoherence threshold.
%      This parameter can be used to control the mutual incoherence of the
%      trained dictionary, and is typically between 0.9 and 1. At the end
%      of each iteration, the trained dictionary is "cleaned" by discarding
%      atoms with correlation > muthresh. The default value for muthresh is
%      0.99. Specifying a value of 1 or higher cancels this type of
%      cleaning completely. Note: the trained dictionary is not guaranteed
%      to have a mutual incoherence less than muthresh. However, a method
%      to track this is using the VERBOSE parameter to print the number of
%      replaced atoms each iteration; when this number drops near zero, it
%      is more likely that the mutual incoherence of the dictionary is
%      below muthresh.
%
%
%   Summary of all fields in PARAMS:
%   --------------------------------
%
%   Required:
%     'data'                   training data
%     'Tdata' / 'Edata'        sparse-coding target
%     'initdict' / 'dictsize'  initial dictionary / dictionary size
%
%   Optional (default values in parentheses):
%     'testdata'               validation data (none)
%     'iternum'                number of training iterations (10)
%     'memusage'               'low, 'normal' or 'high' ('normal')
%     'codemode'               'sparsity' or 'error' ('sparsity')
%     'exact'                  exact update instead of approximate (0)
%     'maxatoms'               max # of atoms in error sparse-coding (none)
%     'muthresh'               mutual incoherence threshold (0.99)
%
%
%  References:
%  [1] M. Aharon, M. Elad, and A.M. Bruckstein, "The K-SVD: An Algorithm
%      for Designing of Overcomplete Dictionaries for Sparse
%      Representation", the IEEE Trans. On Signal Processing, Vol. 54, no.
%      11, pp. 4311-4322, November 2006.
%  [2] M. Elad, R. Rubinstein, and M. Zibulevsky, "Efficient Implementation
%      of the K-SVD Algorithm using Batch Orthogonal Matching Pursuit",
%      Technical Report - CS, Technion, April 2008.
%
%  See also KSVDDENOISE, OMPDENOISE, OMP, OMP2.


%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs
%
%  August 2009


global CODE_SPARSITY CODE_ERROR codemode
global MEM_LOW MEM_NORMAL MEM_HIGH memusage
global ompfunc ompparams exactsvd

CODE_SPARSITY = 1;
CODE_ERROR = 2;

MEM_LOW = 1;
MEM_NORMAL = 2;
MEM_HIGH = 3;


%%%%% parse input parameters %%%%%


data = params.data;

ompparams = {'checkdict','off'};

% coding mode %

if (isfield(params,'codemode'))
  switch lower(params.codemode)
    case 'sparsity'
      codemode = CODE_SPARSITY;
      thresh = params.Tdata;
    case 'error'
      codemode = CODE_ERROR;
      thresh = params.Edata;
    otherwise
      error('Invalid coding mode specified');
  end
elseif (isfield(params,'Tdata'))
  codemode = CODE_SPARSITY;
  thresh = params.Tdata;
elseif (isfield(params,'Edata'))
  codemode = CODE_ERROR;
  thresh = params.Edata;

else
  error('Data sparse-coding target not specified');
end


% max number of atoms %

if (codemode==CODE_ERROR && isfield(params,'maxatoms'))
  ompparams{end+1} = 'maxatoms';
  ompparams{end+1} = params.maxatoms;
end


% memory usage %

if (isfield(params,'memusage'))
  switch lower(params.memusage)
    case 'low'
      memusage = MEM_LOW;
    case 'normal'
      memusage = MEM_NORMAL;
    case 'high'
      memusage = MEM_HIGH;
    otherwise
      error('Invalid memory usage mode');
  end
else
  memusage = MEM_NORMAL;
end


% iteration count %

if (isfield(params,'iternum'))
  iternum = params.iternum;
else
  iternum = 10;
end


% omp function %

if (codemode == CODE_SPARSITY)
  ompfunc = @omp;
else
  ompfunc = @omp2;
end


% status messages %

printiter = 0;
printreplaced = 0;
printerr = 0;
printgerr = 0;

verbose = 't';
msgdelta = -1;

for i = 1:length(varargin)
  if (ischar(varargin{i}))
    verbose = varargin{i};
  elseif (isnumeric(varargin{i}))
    msgdelta = varargin{i};
  else
    error('Invalid call syntax');
  end
end

for i = 1:length(verbose)
  switch lower(verbose(i))
    case 'i'
      printiter = 1;
    case 'r'
      printiter = 1;
      printreplaced = 1;
    case 't'
      printiter = 1;
      printerr = 1;
      if (isfield(params,'testdata'))
        printgerr = 1;
      end
  end
end

if (msgdelta<=0 || isempty(verbose))
  msgdelta = -1; 
end

ompparams{end+1} = 'messages';
ompparams{end+1} = msgdelta;



% compute error flag %

comperr = (nargout>=3 || printerr);


% validation flag %

testgen = 0;
if (isfield(params,'testdata'))
  testdata = params.testdata;
  if (nargout>=4 || printgerr)
    testgen = 1;
  end
end


% data norms %

XtX = []; XtXg = [];
if (codemode==CODE_ERROR && memusage==MEM_HIGH)
  XtX = colnorms_squared(data);
  if (testgen)
    XtXg = colnorms_squared(testdata);
  end
end


% mutual incoherence limit %

if (isfield(params,'muthresh'))
  muthresh = params.muthresh;
else
  muthresh = 0.99;
end
if (muthresh < 0)
  error('invalid muthresh value, must be non-negative');
end


% exact svd computation %

exactsvd = 0;
if (isfield(params,'exact') && params.exact~=0)
  exactsvd = 1;
end


% determine dictionary size %

if (isfield(params,'initdict'))
  if (any(size(params.initdict)==1) && all(iswhole(params.initdict(:))))
    dictsize = length(params.initdict);
  else
    dictsize = size(params.initdict,2);
  end
end
if (isfield(params,'dictsize'))    % this superceedes the size determined by initdict
  dictsize = params.dictsize;
end

if (size(data,2) < dictsize)
  error('Number of training signals is smaller than number of atoms to train');
end


% initialize the dictionary %

if (isfield(params,'initdict'))
  if (any(size(params.initdict)==1) && all(iswhole(params.initdict(:))))
    D = data(:,params.initdict(1:dictsize));
  else
    if (size(params.initdict,1)~=size(data,1) || size(params.initdict,2)<dictsize)
      error('Invalid initial dictionary');
    end
    D = params.initdict(:,1:dictsize);
  end
else
  data_ids = find(colnorms_squared(data) > 1e-6);   % ensure no zero data elements are chosen
  perm = randperm(length(data_ids));
  D = data(:,data_ids(perm(1:dictsize)));
end


% normalize the dictionary %

D = normcols(D);

err = zeros(1,iternum);
gerr = zeros(1,iternum);

if (codemode == CODE_SPARSITY)
  errstr = 'RMSE';
else
  errstr = 'mean atomnum';
end



%%%%%%%%%%%%%%%%%  main loop  %%%%%%%%%%%%%%%%%


for iter = 1:iternum
  
  G = [];
  if (memusage >= MEM_NORMAL)
    G = D'*D;
  end
  
  
  %%%%%  sparse coding  %%%%%
  
  Gamma = sparsecode(data,D,XtX,G,thresh);
  
  
  %%%%%  dictionary update  %%%%%
  
  replaced_atoms = zeros(1,dictsize);  % mark each atom replaced by optimize_atom
  
  unused_sigs = 1:size(data,2);  % tracks the signals that were used to replace "dead" atoms.
                                 % makes sure the same signal is not selected twice
  
  p = randperm(dictsize);
  tid = timerinit('updating atoms', dictsize);
  for j = 1:dictsize
    [D(:,p(j)),gamma_j,data_indices,unused_sigs,replaced_atoms] = optimize_atom(data,D,p(j),Gamma,unused_sigs,replaced_atoms);
    Gamma(p(j),data_indices) = gamma_j;
    if (msgdelta>0)
      timereta(tid, j, msgdelta);
    end
  end
  if (msgdelta>0)
    printf('updating atoms: iteration %d/%d', dictsize, dictsize);
  end
  
  
  %%%%%  compute error  %%%%%
  
  if (comperr)
    err(iter) = compute_err(D,Gamma,data);
  end
  if (testgen)
    if (memusage >= MEM_NORMAL)
      G = D'*D;
    end
    GammaG = sparsecode(testdata,D,XtXg,G,thresh);
    gerr(iter) = compute_err(D,GammaG,testdata);
  end
   
  
  %%%%%  clear dictionary  %%%%%
  
  [D,cleared_atoms] = cleardict(D,Gamma,data,muthresh,unused_sigs,replaced_atoms);
  
  
  %%%%%  print info  %%%%%
  
  info = sprintf('Iteration %d / %d complete', iter, iternum);
  if (printerr)
    info = sprintf('%s, %s = %.4g', info, errstr, err(iter));
  end
  if (printgerr)
    info = sprintf('%s, test %s = %.4g', info, errstr, gerr(iter));
  end
  if (printreplaced)
    info = sprintf('%s, replaced %d atoms', info, sum(replaced_atoms) + cleared_atoms);
  end
  
  if (printiter)
    disp(info);
    if (msgdelta>0), disp(' '); end
  end
  
end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            optimize_atom             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [atom,gamma_j,data_indices,unused_sigs,replaced_atoms] = optimize_atom(X,D,j,Gamma,unused_sigs,replaced_atoms)

global exactsvd

% data samples which use the atom, and the corresponding nonzero
% coefficients in Gamma
[gamma_j, data_indices] = sprow(Gamma, j);

if (length(data_indices) < 1)
  maxsignals = 5000;
  perm = randperm(length(unused_sigs));
  perm = perm(1:min(maxsignals,end));
  E = sum((X(:,unused_sigs(perm)) - D*Gamma(:,unused_sigs(perm))).^2);
  [d,i] = max(E);
  atom = X(:,unused_sigs(perm(i)));
  atom = atom./norm(atom);
  gamma_j = zeros(size(gamma_j));
  unused_sigs = unused_sigs([1:perm(i)-1,perm(i)+1:end]);
  replaced_atoms(j) = 1;
  return;
end

smallGamma = Gamma(:,data_indices);
Dj = D(:,j);

if (exactsvd)

  [atom,s,gamma_j] = svds(X(:,data_indices) - D*smallGamma + Dj*gamma_j, 1);
  gamma_j = s*gamma_j;
  
else
  
  atom = collincomb(X,data_indices,gamma_j') - D*(smallGamma*gamma_j') + Dj*(gamma_j*gamma_j');
  atom = atom/norm(atom);
  gamma_j = rowlincomb(atom,X,1:size(X,1),data_indices) - (atom'*D)*smallGamma + (atom'*Dj)*gamma_j;

end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             sparsecode               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Gamma = sparsecode(data,D,XtX,G,thresh)

global CODE_SPARSITY codemode
global MEM_HIGH memusage
global ompfunc ompparams

if (memusage < MEM_HIGH)
  Gamma = ompfunc(D,data,G,thresh,ompparams{:});
  
else  % memusage is high
  
  if (codemode == CODE_SPARSITY)
    Gamma = ompfunc(D'*data,G,thresh,ompparams{:});
    
  else
    Gamma = ompfunc(D'*data,XtX,G,thresh,ompparams{:});
  end
  
end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             compute_err              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function err = compute_err(D,Gamma,data)
  
global CODE_SPARSITY codemode

if (codemode == CODE_SPARSITY)
  err = sqrt(sum(reperror2(data,D,Gamma))/numel(data));
else
  err = nnz(Gamma)/size(data,2);
end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           cleardict                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [D,cleared_atoms] = cleardict(D,Gamma,X,muthresh,unused_sigs,replaced_atoms)

use_thresh = 4;  % at least this number of samples must use the atom to be kept

dictsize = size(D,2);

% compute error in blocks to conserve memory
err = zeros(1,size(X,2));
blocks = [1:3000:size(X,2) size(X,2)+1];
for i = 1:length(blocks)-1
  err(blocks(i):blocks(i+1)-1) = sum((X(:,blocks(i):blocks(i+1)-1)-D*Gamma(:,blocks(i):blocks(i+1)-1)).^2);
end

cleared_atoms = 0;
usecount = sum(abs(Gamma)>1e-7, 2);

for j = 1:dictsize
  
  % compute G(:,j)
  Gj = D'*D(:,j);
  Gj(j) = 0;
  
  % replace atom
  if ( (max(Gj.^2)>muthresh^2 || usecount(j)<use_thresh) && ~replaced_atoms(j) )
    [y,i] = max(err(unused_sigs));
    D(:,j) = X(:,unused_sigs(i)) / norm(X(:,unused_sigs(i)));
    unused_sigs = unused_sigs([1:i-1,i+1:end]);
    cleared_atoms = cleared_atoms+1;
  end
end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            misc functions            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function err2 = reperror2(X,D,Gamma)

% compute in blocks to conserve memory
err2 = zeros(1,size(X,2));
blocksize = 2000;
for i = 1:blocksize:size(X,2)
  blockids = i : min(i+blocksize-1,size(X,2));
  err2(blockids) = sum((X(:,blockids) - D*Gamma(:,blockids)).^2);
end

end


function Y = colnorms_squared(X)

% compute in blocks to conserve memory
Y = zeros(1,size(X,2));
blocksize = 2000;
for i = 1:blocksize:size(X,2)
  blockids = i : min(i+blocksize-1,size(X,2));
  Y(blockids) = sum(X(:,blockids).^2);
end

end
