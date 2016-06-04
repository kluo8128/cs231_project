% [visited, ccs] = visit(G, i, visited, ccs, ccnum)
%
% Visits node i in the undirected graph with adjacency matrix G, then
% recursively visits neighboring nodes in the graph. Updates and returns
% a binary vector indicating if a node has been visited, and a vector of
% connected component indices, where ccnum is the index for the current
% connected component.
function [visited, ccs] = visit(G, i, visited, ccs, ccnum)
    n = size(G, 1);
    visited(i) = 1;
    ccs(i) = ccnum;
    for j = 1:n
        if (G(i,j) > 0 || G(j,i) > 0) && ~visited(j)
            [visited, ccs] = visit(G, j, visited, ccs, ccnum);
        end
    end
end
