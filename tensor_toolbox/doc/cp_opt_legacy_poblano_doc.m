%% All-at-once optimization for CP tensor decomposition (with Poblano)
% We explain how to use |cp_opt_legacy| with the Poblano toolbox. The default is
% to use L-BFGS-B (not Poblano), which is described <cp_opt_legacy_doc.html here>.

%% Newer version available
% This documentation is for the legacy implementation of CP-OPT. We
% recommend using the newer version, described <cp_opt_doc.html here>.

%% Poblano Optimization Toolbox
% Check that you have Poblano 1.1 (or later) installed. The output of your 'ver'
% command should look something like the following.
ver

%% Create an example problem. 
% Create an example 50 x 40 x 30 tensor with rank 5 and add 10% noise.
rng('default'); %<- Setting random seed for reproducibility of this script
R = 5;
info = create_problem('Size', [50 40 30], 'Num_Factors', R, 'Noise', 0.10);
X = info.Data;
M_true = info.Soln;

%% Create initial guess using 'nvecs'
M_init = create_guess('Data', X, 'Num_Factors', R, ...
    'Factor_Generator', 'nvecs');


%% Set up the optimization parameters
% It's genearlly a good idea to consider the parameters of the optimization
% method. The default options may be either too stringent or not stringent
% enough. The most important options to consider are detailed here. 

% Get the defaults
ncg_opts = ncg('defaults');
% Tighten the stop tolerance (norm of gradient). This is often too large.
ncg_opts.StopTol = 1.0e-6;
% Tighten relative change in function value tolearnce. This is often too large.
ncg_opts.RelFuncTol = 1.0e-20;
% Increase the number of iterations. 
ncg_opts.MaxIters = 10^4;
% Only display every 10th iteration
ncg_opts.DisplayIters = 10;
% Display the final set of options
ncg_opts

%% Call the |cp_opt_legacy| method
% Here is an example call to the cp_opt_legacy method. By default, each iteration
% prints the least squares fit function value (being minimized) and the
% norm of the gradient. The meaning of any line search warnings
% can be checked via <matlab:doc('cvsrch') doc cvsrch>.
[M,~,output] = cp_opt_legacy(X, R, 'init', M_init, ...
    'opt', 'ncg', 'opt_options', ncg_opts);

%% Check the output
% It's important to check the output of the optimization method. In
% particular, it's worthwhile to check the exit flag. 
% A zero (0) indicates successful termination with the gradient smaller
% than the specified StopTol, and a three (3) indicates a successful
% termination where the change in function value is less than RelFuncTol.
% The meaning of any other flags can be checked via 
% <matlab:doc('poblano_params') doc poblano_params>. 
exitflag = output.ExitFlag

%%
% The fit is the percentage of the data that is explained by the model.
% Because we have noise, we do not expect the fit to be perfect.
fit = output.Fit

%% Evaluate the output
% We can "score" the similarity of the model computed by CP and compare
% that with the truth. The |score| function on ktensor's gives a score in
% [0,1]  with 1 indicating a perfect match. Because we have noise, we do
% not expect the fit to be perfect. See <matlab:doc('ktensor/score') doc
% score> for more details.
scr = score(M,M_true)

%% Overfitting example
% Consider the case where we don't know R in advance. We might guess too
% high. Here we show a case where we guess R+1 factors rather than R.

% Generate initial guess of the corret size
M_plus_init = create_guess('Data', X, 'Num_Factors', R+1, ...
    'Factor_Generator', 'nvecs');

%% 

% Loosen the stop tolerance (norm of gradient). 
ncg_opts.StopTol = 1.0e-2;

%%

% Run the algorithm
[M_plus,~,output] = cp_opt_legacy(X, R+1, 'init', M_plus_init, ...
    'opt', 'ncg', 'opt_options', ncg_opts);
exitflag = output.ExitFlag
fit = output.Fit


%%

% Check the answer (1 is perfect)
scr = score(M_plus, M_true)

