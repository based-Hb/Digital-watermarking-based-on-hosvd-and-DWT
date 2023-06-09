%% Collapsing and Scaling Tensors
%
% <html>
% <p class="navigate">
% &#62;&#62; <a href="index.html">Tensor Toolbox</a> 
% &#62;&#62; <a href="working.html">Working with Tensors</a> 
% &#62;&#62; <a href="collapse_scale_doc.html">Collapsing and Scaling Tensors</a>
% </p>
% </html>
%
% The |tensor| and |sptensor| classes support the notion of collapsing and
% scaling dimensions, and the |tensor| class also supports centering (see
% below).

%% Examples of collapsing a tensor
rng('default'); %<-- Make this reproducible.
X = tenrand([4 3 2]) %<-- Generate some data.
%%
Y = collapse(X,[2 3]) %<-- Sum of entries in each mode-1 slice.
%%
Y = collapse(X,-1) %<-- Same as above.
%%
Z = collapse(X,2) %<-- Sum of entries in each row fiber.
%%
collapse(X,1:3) %<-- Sum of all entries.
%% Alternate accumulation functions for tensor
Y = collapse(X,[1 2],@max) %<-- Max entry in each mode-3 slice.
%%
Z = collapse(X,-3,@mean) %<-- Average entry in each mode-3 slice.
%% Examples of collapsing a sptensor
X = sptenrand([4 3 2],6) %<-- Generate some data.
%%
Y = collapse(X,[2 3]) %<-- Sum of entries in each mode-1 slice.
%%
Y = collapse(X,-1) %<-- Same as above.
%%
Z = collapse(X,2) %<-- Sum of entries in each row fiber.
%%
collapse(X,1:3) %<-- Sum of all entries.

%% Center tensor fibers for a dense tensor.
% Suppose that we want to center a tensor's fiber in mode-2 so
% that they each have mean zero. To do so, we can use |scale| function in
% an unusual way, passing it a function handle to do the differences. 
% (Note that |sptensor| does not support centering because it would cause
% the tensor to become dense.)
X = tensor(1:24,[4 3 2]) %<-- Generate some data.
%%
% Calculate the means in mode 2
mu = collapse(X,2,@mean) 
%%
% Show the means of the mode-2 fibers
Y = scale(X,mu,[1 3],@(x,y) x-y); 
mu_new = collapse(Y,2,@mean)

%% Alternate accumulation functions for sptensor
Y = collapse(X,[1 2],@min) %<-- Min *nonzero* entry in each mode-3 slice.
%%
Z = collapse(X,-3,@mean) %<-- Average *nonzero* entry in each mode-3 slice.
%% Scaling a tensor in different modes
X = tenones([3,4,5]); %<-- Generate data 
S = 10 * [1:5]'; Y = scale(X,S,3) %<-- Scale in mode-3
%%
S = tensor(10 * [1:5]',5); Y = scale(X,S,3) %<-- First argument is a tensor.
%%
S = tensor(1:12,[3 4]); Y = scale(X,S,[1 2]) %<-- Scale in two modes.
%%
S = tensor(1:12,[3 4]); Y = scale(X,S,-3) %<-- Same as above.
%%
S = tensor(1:60,[3 4 5]); Y = scale(X,S,1:3) %<-- Scale in every mode.
%%
Y = S .* X %<-- Same as above.

%% Scaling a sptensor in different modes
X = ones(sptenrand([3 4 5], 10)) %<-- Generate data.
%%
S = 10 * [1:5]'; Y = scale(X,S,3) %<-- Scale in one mode.
%%
S = tensor(10 * [1:5]',5); Y = scale(X,S,3) %<-- Same as above.
%%
S = tensor(1:12,[3 4]); Y = scale(X,S,[1 2]) %<-- Scale in two modes.
%%
S = tensor(1:12,[3 4]); Y = scale(X,S,-3) %<-- Same as above.
%%
Z = scale(X,Y,1:3) %<-- Scale by a sparse tensor.
%%
X .* Y %<-- Same as above.