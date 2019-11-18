abstract type Clustering end

"""
    PartitionalClustering{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering

Partitional clustering model.
"""
struct PartitionalClustering{Tx<:Real,Tc<:Integer,Tw<:Real,Ty<:Real,Tm<:Real} <: Clustering
    X::Matrix{Tx}
    i::Vector{Int}
    j::Vector{Int}
    C::Matrix{Tc}
    W::Matrix{Tw}
    Y::Matrix{Ty}
    M::Matrix{Tm}

    function PartitionalClustering{Tx,Tc,Tw,Ty,Tm}(X::Matrix{Tx},
                                                i::Vector{<:Integer},
                                                j::Vector{<:Integer},
                                                C::Matrix{Tc}, W::Matrix{Tw},
                                                Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx<:Real,Tc<:Integer,Tw<:Real,
                                                                                    Ty<:Real,Tm<:Real}
        mx, nx = size(X)
        nc = size(C, 2)
        nw = size(W, 2)
        ky, ny = size(Y)
        mm, km = size(M)
        if nx > 0
            nx == ny || throw(DimensionMismatch("number of data instances must match"))
        end
        if mx > 0
            mx == mm || throw(DimensionMismatch("number of data features must match"))
        end
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        ky == km || throw(DimensionMismatch("number of clusters must match"))
        return new(X, i, j, C, W, Y, M)
    end
end
PartitionalClustering(X::Matrix{Tx}, i::Vector{Ti}, j::Vector{Tj},
                    C::Matrix{Tc}, W::Matrix{Tw}, Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx,Ti,Tj,Tc,Tw,Ty,Tm} =
    PartitionalClustering{Tx,Tc,Tw,Ty,Tm}(X, i, j, C, W, Y, M)

function PartitionalClustering(X::Matrix{Tx}, C::Matrix{Tc}, W::Matrix{Tw},
                    Y::Matrix{Ty}, M::Matrix{Tm}) where {Tx,Tc,Tw,Ty,Tm}
    sz = size(X)
    i = collect(1:sz[1])
    j = collect(1:sz[2])
    return PartitionalClustering{Tx,Tc,Tw,Ty,Tm}(X, i, j, C, W, Y, M)
end

# Partitional clustering model equality operator
Base.:(==)(a::PartitionalClustering, b::PartitionalClustering) =
    (a.X == b.X && a.i == b.i && a.j == b.j && a.C == b.C && a.W == b.W
            && a.Y == b.Y && a.M == b.M)

# Compute hash code
Base.hash(a::PartitionalClustering, h::UInt) =
    hash(a.X, hash(a.i, hash(a.j, hash(a.C, hash(a.W, hash(a.Y, hash(a.M,
        hash(:PartitionalClustering, h))))))))

"""
    HierarchicalClustering{Tx<:Real,Tc<:Integer,Tw<:Real} <: Clustering

Hierarchical clustering model.
"""
struct HierarchicalClustering{Tx<:Real,Tc<:Integer,Tw<:Real} <: Clustering
    X::Matrix{Tx}
    i::Vector{Int}
    j::Vector{Int}
    C::Array{Tc,3}
    W::Array{Tw,3}

    function HierarchicalClustering{Tx,Tc,Tw}(X::Matrix{Tx},
                                            i::Vector{<:Integer},
                                            j::Vector{<:Integer},
                                            C::Array{Tc,3}, W::Array{Tw,3}) where {Tx<:Real,Tc<:Integer,Tw<:Real}
        mx, nx = size(X)
        nc = size(C, 2)
        nw = size(W, 2)
        nc == nw || throw(DimensionMismatch("dimensions of constraints and weights must match"))
        if nc > 0 && nx > 0
            nc == nx || throw(DimensionMismatch("number of data instances and maximum number of constraints must match"))
        end
        return new(X, i, j, C, W)
    end
end
HierarchicalClustering(X::Matrix{Tx}, i::Vector{Ti}, j::Vector{Tj},
                    C::Array{Tc,3}, W::Array{Tw,3}) where {Tx,Ti,Tj,Tc,Tw} =
    HierarchicalClustering{Tx,Tc,Tw}(X, i, j, C, W)

function HierarchicalClustering(X::Matrix{Tx}, C::Array{Tc,3}, W::Array{Tw,3}) where {Tx,Ti,Tj,Tc,Tw}
    sz = size(X)
    i = collect(1:sz[1])
    j = collect(1:sz[2])
    return HierarchicalClustering{Tx,Tc,Tw}(X, i, j, C, W)
end

"""
    data(a::Clustering)

Access the data.
"""
data(a::Clustering) = a.X

"""
    instances(a::Clustering)

Access the instance indices.
"""
instances(a::Clustering) = a.j

"""
    features(a::Clustering)

Access the feature indices.
"""
features(a::Clustering) = a.i

"""
    constraints(a::Clustering)

Access the contraints.
"""
constraints(a::Clustering) = a.C

"""
    weights(a::Clustering)

Access the weights.
"""
weights(a::Clustering) = a.W

"""
    assignments(a::PartitionalClustering)

Access the assignments of the data instances to the clusters.
"""
assignments(a::PartitionalClustering) = a.Y

"""
    centers(a::PartitionalClustering)

Access the centers.
"""
centers(a::PartitionalClustering) = a.M

"""
    θ(c::PartitionalClustering)

Access the parameters.
"""
θ(a::PartitionalClustering) = (a.M)
