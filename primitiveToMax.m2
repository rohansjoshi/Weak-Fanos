-- The function "toricMaxcones" will return the maximal cones
-- of a given projective toric variety
-- with input ray generators and primitive collections

toricMaxcones = method();
toricMaxcones(List, List) := (pRays, primitiveCollections) -> (
    n := #pRays;
    x := symbol x;
    R := ZZ/2[x_0..x_(n - 1)];
    Xs := apply(first entries vars R, i -> index i);
    Ps := apply(primitiveCollections, i -> ideal apply(i, j -> x_j));
    I := intersect Ps;
    maxConesComp := apply(first entries gens I, i -> apply(support i, j -> index j));
    maxCones := apply(maxConesComp, i -> toList(set Xs - set i));
    return maxCones;
)

-- The function "toricPrimitiveCollections" will return 
-- the primitive collections defining a given projective toric variety
-- with input ray generators and maximal cones

toricPrimitiveCollections = method();
toricPrimitiveCollections(List, List) := (pRays, maxCones) -> (
    n := #pRays;
    x := symbol x;
    R := ZZ/2[x_0..x_(n - 1)];
    Xs := apply(first entries vars R, i -> index i);
    maxConesComp := apply(maxCones, i -> toList(set Xs - set i));
    I := ideal apply(maxConesComp, i -> product apply(i, j -> x_j));
    Ps := primaryDecomposition I;
    primitiveCollections := apply(Ps, i -> apply(first entries gens i, j -> index j));
    return primitiveCollections;
)
