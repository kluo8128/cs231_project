% [ccs, ccnum] = dfs(G)
%
% Performs depth-first-search to identify the connected components of the
% undirected graph with adjacency matrix G. Returns the vector of connected
% component indices and the number of connected components.
function [ccs, ccnum] = dfs(G)
    n = size(G, 1);
    visited = zeros(n, 1);
    ccs = zeros(n, 1);
    ccnum = 0;
    for i = 1:n
        if ~visited(i)
            ccnum = ccnum + 1;
            [visited, ccs] = visit(G, i, visited, ccs, ccnum);
        end
    end
end
