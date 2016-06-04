% [edges] = getEdges(G)
%
% Returns a list of weighted edges (i, j, w) of the undirected graph with
% adjacency matrix G.
function [edges] = getEdges(G)
n = size(G, 1);
edges = zeros(3, n * (n - 1) / 2);
c = 0;
for i = 1:n
    for j = i + 1:n
        if G(i,j) > 0
            c = c + 1;
            edges(:,c) = [i; j; G(i,j)];
        end
    end
end
edges = edges(:,1:c);
end
