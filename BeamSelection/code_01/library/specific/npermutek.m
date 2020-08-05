function [A, I] = npermutek(v,k)
% NPERMUTEK - permutations without repetitions.
% This function A = npermutek(v,k) returns all the possible permutations 
% of k elements from the vector v without repetitions. k should be less than
% or equal to number of elements in v.
% The function [A, I] = npermutek(v,k) returns both the matrix and indeces
% of the permuted matrix, such that A = v(I). Both matrices will be of the 
% size nPk-by-k where k = numel(v).
% 
% 
% Examples:
% 
% v = 1:4;
% k = 3;
% A = npermutek(v,k); % returns 24-by-3 matrix
%      1     2     3
%      1     2     4
%      1     3     2
%      1     3     4
%      1     4     2
%      1     4     3
%      2     1     3
%      2     1     4
%      2     3     1
%      2     3     4
%      2     4     1
%      2     4     3
%      3     1     2
%      3     1     4
%      3     2     1
%      3     2     4
%      3     4     1
%      3     4     2
%      4     1     2
%      4     1     3
%      4     2     1
%      4     2     3
%      4     3     1
%      4     3     2
% 
% v = 'abc';
% k = 2;
% [A,I] = npermutek(v,k) % returns 6-by-2 char array
% 
%     'ab'
%     'ac'
%     'ba'
%     'bc'
%     'ca'
%     'cb'
% 
%  and 6-by-2 matrix
% 
%      1     2
%      1     3
%      2     1
%      2     3
%      3     1
%      3     2
% 

narginchk(2,3);

nck = nchoosek(1:numel(v),k);
permutes = perms(1:k);
I = nck(:,permutes);
I = reshape(I,[],k);
I = sortrows(I,1:k);
A = v(I);
end
