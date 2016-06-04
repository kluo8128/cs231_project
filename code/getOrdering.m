% [ordering] = getOrdering(indices, tree)
%
% Given the adjacency matrix for a weighted forest (tree), finds an
% ordering on the specified indices (a single tree in the forest) that
% greedily maximizes the cumulative weight, i.e., starts with vertices with
% the highest edge weight, then expands outward along tree, adding the
% vertex sharing the highest edge weight in the fringe each time, until all
% vertices in the tree have been added. Returns a permutation of 1 to k
% corresponding to the indices of the ordering, where k is the number of
% vertices in the tree.
function [ordering] = getOrdering(indices, tree)
k = length(indices);
ordering = zeros(k, 1);
visited = zeros(k, 1);
subtree = tree(indices,indices);
edges = getEdges(subtree);
[~, index] = max(edges(3,:));
index_i = edges(1,index);
index_j = edges(2,index);
ordering(1) = index_i;
ordering(2) = index_j;
visited(index_i) = 1;
visited(index_j) = 1;
c = 2;

fringe = [];
for index = 1:k
    if subtree(index,index_j) > 0 && ~visited(index)
        fringe = [fringe, [index; index_j; subtree(index,index_j)]];
    end
end
while c < k
    for index = 1:k
        if subtree(index,index_i) > 0 && ~visited(index)
            fringe = [fringe, [index; index_i; subtree(index,index_i)]];
        end
    end
    [~, index] = max(fringe(3,:));
    index_i = fringe(1,index);
    fringe(:,index) = [];
    c = c + 1;
    ordering(c) = index_i;
    visited(index_i) = 1;
end
end
