module VAIML

using Distances
using OrderedCollections
using SparseArrays

import Base: -, ==
import Base: replace, replace!
import Base: diff, hash, instances, show

export
    # clustering.jl
    AbstractClustering,
    HierarchicalClustering,
    PartitionalClustering,
    assignments,
    centers,
    constraints,
    data,
    features,
    θ,
    weights,
    # difference.jl
    AbstractClusteringDifference,
    PartitionalClusteringDifference,
    backwarddiff,
    forwarddiff,
    # kmeans.jl
    kmeans,
    # pckmeans.jl
    #pckmeans
    # utils.jl
    MatrixDifference,
    SetDifference,
    added,
    common,
    modified,
    removed

include("utils.jl")
include("clustering.jl")
include("difference.jl")
include("kmeans.jl")
#include("pckmeans.jl")

end # module VAIML
