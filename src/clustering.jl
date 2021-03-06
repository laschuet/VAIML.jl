"""
    AbstractClustering

Supertype for clusterings.
"""
abstract type AbstractClustering end

"""
    PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: AbstractClustering

Partitional clustering.
"""
struct PartitionalClustering{Tc<:Integer,Tw<:Real,Ty<:Real} <: AbstractClustering
    r::Vector{Int}
    c::Vector{Int}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    p::NamedTuple

    function PartitionalClustering{Tc,Tw,Ty}(r::Vector{Int}, c::Vector{Int},
                                            C::Matrix{Tc}, W::Matrix{Tw},
                                            Y::Matrix{Ty}, p::NamedTuple) where {Tc<:Integer,Tw<:Real,Ty<:Real}
        size(C, 2) == size(W, 2) || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(r, c, C, W, Y, p)
    end
end
PartitionalClustering(r::Vector{Int}, c::Vector{Int}, C::Matrix{Tc},
                    W::Matrix{Tw}, Y::Matrix{Ty}, p::NamedTuple) where {Tc,Tw,Ty} =
    PartitionalClustering{Tc,Tw,Ty}(r, c, C, W, Y, p)

function PartitionalClustering(clust::KmeansResult)
    r = Int[]
    c = Int[]
    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Float64}(undef, 0, 0)
    k = size(clust.centers, 2)
    n = length(clust.assignments)
    Y = zeros(Int, k, n)
    for i = 1:n
        Y[clust.assignments[i], i] = 1
    end
    p = (centers=clust.centers, costs=clust.costs, counts=clust.counts,
            wcounts=clust.wcounts, totalcost=clust.totalcost,
            iterations=clust.iterations, converged=clust.converged)
    return PartitionalClustering(r, c, C, W, Y, p)
end
function PartitionalClustering(clust::KmedoidsResult)
    r = Int[]
    c = Int[]
    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Float64}(undef, 0, 0)
    k = length(clust.medoids)
    n = length(clust.assignments)
    Y = zeros(Int, k, n)
    for i = 1:n
        Y[clust.assignments[i], i] = 1
    end
    p = (medoids=clust.medoids, costs=clust.costs, counts=clust.counts,
            totalcost=clust.totalcost, iterations=clust.iterations,
            converged=clust.converged)
    return PartitionalClustering(r, c, C, W, Y, p)
end
function PartitionalClustering(clust::FuzzyCMeansResult)
    r = Int[]
    c = Int[]
    C = Matrix{Int}(undef, 0, 0)
    W = Matrix{Float64}(undef, 0, 0)
    Y = permutedims(clust.weights)
    p = (centers=clust.centers, iterations=clust.iterations,
            converged=clust.converged)
    return PartitionalClustering(r, c, C, W, Y, p)
end

# Partitional clustering equality operator
Base.:(==)(a::PartitionalClustering, b::PartitionalClustering) =
    (a.r == b.r && a.c == b.c && a.C == b.C && a.W == b.W && a.Y == b.Y
            && a.p == b.p)

# Compute hash code
Base.hash(a::PartitionalClustering, h::UInt) =
    hash(a.r, hash(a.c, hash(a.C, hash(a.W, hash(a.Y, hash(a.p,
        hash(:PartitionalClustering, h)))))))

"""
    HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering

Hierarchical clustering.
"""
struct HierarchicalClustering{Tc<:Integer,Tw<:Real} <: AbstractClustering
    r::Vector{Int}
    c::Vector{Int}
    C::Array{Tc,3}
    W::Array{Tw,3}
    p::NamedTuple

    function HierarchicalClustering{Tc,Tw}(r::Vector{Int}, c::Vector{Int},
                                        C::Array{Tc,3}, W::Array{Tw,3},
                                        p::NamedTuple) where {Tc<:Integer,Tw<:Real}
        size(C, 2) == size(W, 2) || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        return new(r, c, C, W, p)
    end
end
HierarchicalClustering(r::Vector{Int}, c::Vector{Int}, C::Array{Tc,3},
                    W::Array{Tw,3}, p::NamedTuple) where {Tc,Tw} =
    HierarchicalClustering{Tc,Tw}(r, c, C, W, p)

"""
    axes(a::AbstractClustering[, d])

Access the feature and instance identifiers. Optionally, specify dimension `d`
to get the identifiers of that dimension only.
"""
Base.axes(a::AbstractClustering) = a.r, a.c
Base.axes(a::AbstractClustering, d) = d::Integer <= 2 ? axes(a)[d] : Int[]

"""
    features(a::AbstractClustering)

Access the feature identifiers.
"""
features(a::AbstractClustering) = axes(a, 1)

"""
    instances(a::AbstractClustering)

Access the instance identifiers.
"""
Base.instances(a::AbstractClustering) = axes(a, 2)

"""
    constraints(a::AbstractClustering)

Access the contraints.
"""
constraints(a::AbstractClustering) = a.C

"""
    weights(a::AbstractClustering)

Access the weights.
"""
weights(a::AbstractClustering) = a.W

"""
    parameters(c::PartitionalClustering)

Access the parameters.
"""
parameters(a::AbstractClustering) = a.p

"""
    assignments(a::PartitionalClustering)

Access the assignments.
"""
assignments(a::PartitionalClustering) = a.Y
