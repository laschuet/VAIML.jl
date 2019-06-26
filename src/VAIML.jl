module VAIML

using Distances

export
    # clustering.jl
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    centers,
    constraints,
    data,
    θ,
    weights,
    # difference.jl
    PartitionalClusteringDifference,
    backward, ∇,
    forward, Δ,
    # kmeans.jl
    kmeans!

include("clustering.jl")
include("difference.jl")
include("kmeans.jl")
include("measures.jl");
include("utils.jl")

end # module VAIML
