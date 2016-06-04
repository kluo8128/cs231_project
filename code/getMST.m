% [tree] = getMST(G)
%
% Returns the adjacency matrix of the maximum spanning tree of the
% undirected graph with weighted adjacency matrix G.
function [tree] = getMST(G)
n = size(G, 1);
ccs = (1:n)'; % list of component number of each vertex
components = cell(n, 1);
for i = 1:n
    components{i} = i;
end
tree = zeros(n);
numEdges = 0;
[values, indices] = sort(G(:), 'descend');
for k = 1:length(indices)
    if values(k) > 0
        i = mod(indices(k) - 1, n) + 1;
        j = ceil(indices(k) / n);
        if ccs(i) ~= ccs(j)
            tree(i,j) = values(k);
            tree(j,i) = values(k);
            components{ccs(i)} = [components{ccs(i)}; components{ccs(j)}];
            ccs(components{ccs(j)}) = ccs(i);
            numEdges = numEdges + 1;
        end
    end
    if numEdges == n - 1
        break;
    end
end
end
