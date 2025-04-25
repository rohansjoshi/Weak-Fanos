
-- Various helper functions for computing invariants of toric varieties, etc.
-- These might be useful incorporations into the NormalToricVarieties package

needsPackage "NormalToricVarieties"


-- Anticanonical degree of a toric variety, i.e. (-K)^n where n is the dimension of the variety and K is the canonical divisor. 
-- This is also the Chern number c_1 ^ n, since c_1 of the tangent bundle is c_1 of the determinant of the tangent bundle, 
-- so it is (-1)^n times the determinant of the cotangent bundle (i.e. the canonical bundle), so it is (-1)^n * K^n = (-K)^n  

anticanonicalDegree = method();
anticanonicalDegree(NormalToricVariety) := X -> (
    n := dim X;
    K := toricDivisor X;
    c1 := chern(1, OO (-K));
    return integral (c1^n);
)

-- The "genus" of a variety is the number g that satisfies 2g-2 = d, where d is the anticanonical degree.
-- It really only has a geometric interpretation that makes sense in the case of Fano 3-folds. For a Fano 3-fold X, 
-- its anticanonical divisor is ample, and so (a multiple of it) defines an embedding into some projective space. 
-- Then a smooth hyperplane section of X is a surface S whose canonical divisor is zero by the adjunction formula: 
-- K_S = (K_X + H)_H = 0, since H is linearly equivalent to -K_X. So is a Calabi-Yau surface (I believe it can be 
-- proved S is a K3 surface). Anyway, if we intersect S with a hyperplane section, we get a curve C, and by the adjunction 
-- formula for surfaces we have 2g(C)-2 = (0+H_S).H = (H.H).H = H^3 = (-K_X)^3, which is the anticanonical degree
 
genusOfFanoThreefold = method();
genusOfFanoThreefold(NormalToricVariety) := X -> (
    assert isFano X;
    assert (dim X == 3);
    return 1 + (anticanonicalDegree X)/2;
)


-- Checks if two toric varieties are the same by a permutation of rays
-- sufficient, but not necessary for isomorphism (??)
-- (this is the "sameToricVariety" function written by the Projective Bundle group)

permutationIsomorphic = method();
permutationIsomorphic(NormalToricVariety, NormalToricVariety) := (X, Y) -> (
    areIsomorphicVia := (X, Y, m) -> (
        try (f := inducedMap map(X, Y, m)) then f ideal X == ideal Y else false
    );
    return (
        X === Y or fan X == fan Y or any(permutations(d := dim X), perm -> areIsomorphicVia(X, Y, id_(ZZ^d)_perm))
    );  
);


-- Constructs the sheaf Omega^1 tensor O(D), by doing Hom(O(-D), Omega^1)
Omega1D = method();
Omega1D(NormalToricVariety, ToricDivisor) := (X, D) -> (
    rank1 := OO (-D); 
    omega := cotangentSheaf(X); 
    prune sheafHom(rank1, omega)
);


-- Calculates the tensor product of two sheaves on toric varieties, using Hom-tensor adjunction: 
-- F tensor G = Hom(F^*, G) = Hom(Hom(F, O), G)
-- When I tried ** it didn't work
tensor2Sheaves = method();
tensor2Sheaves(NormalToricVariety, CoherentSheaf, CoherentSheaf) := (X, sheaf1, sheaf2) -> (prune sheafHom(prune sheafHom(sheaf1, sheaf(X, ring X)), sheaf2));


-- Calculates the dimension of H^0(TX), i.e. the dimension of the space of global vector fields on X, using Serre duality
-- Serre duality: H^i(T_X) = H^{n-i}(Omega^1(K_X))
vectorFields = method();
vectorFields(NormalToricVariety) := X -> (
    j := dim X; -- j = n-i
    return rank HH^j(X, Omega1D(X, toricDivisor X));
);

-- Calculates the dimension of H^1(TX), i.e. the dimension of the space of infinitesimal deformations of X
deformationSpace = method();
deformationSpace(NormalToricVariety) := X -> (
    j := dim X - 1; -- j = n-i
    return rank HH^j(X, Omega1D(X, toricDivisor X));
);

-- Calculates the dimension of H^2(TX), i.e. the dimension of the obstruction space of X
obstructionSpace = method();
obstructionSpace(NormalToricVariety) := X -> (
    j := dim X - 2; -- j = n-i
    return rank HH^j(X, Omega1D(X, toricDivisor X));
);


-- Returns the set of all primitive collections of rays of X

primitiveCollections = method();
primitiveCollections(NormalToricVariety) := X -> (
    n := #(rays X);
    maxConez := max X;
    isCone := c -> (for maxCone in maxConez do 
	(if isSubset(c, maxCone) then return true);
	return false;
    );
    pcollections := {};
    for subset in subsets(n) do (
	isValid := true;
	if isCone(subset) then (isValid = false)
	else for i from 0 to #subset-1 do (
	    a := subset_{0..i-1};
	    b := subset_{i+1..#subset-1};
	    trycone := join(a, b);
	    if not isCone(trycone) then (isValid = false; break)  
	);
    	if isValid then pcollections = append(pcollections, subset);
    );
    return pcollections;
);



end--

-- Tests:

anticanonicalDegree(toricProjectiveSpace 2) 	-- should be 9
anticanonicalDegree(hirzebruchSurface 0)    	-- should be 8
anticanonicalDegree(hirzebruchSurface 1)     	-- should be 8
anticanonicalDegree(hirzebruchSurface 2)     	-- should be 8
anticanonicalDegree(toricProjectiveSpace 3) 	-- should be 64



F26 = batyrevConstructor({2,1,1,1,1}, {0}, {}); -- 3-26 on Fanography
F26p = batyrevConstructor({1,1,2,1,1}, {0}, {0}); -- isomorphic to V26 above

anticanonicalDegree(F26) -- 46, as on Fanography
genusOfFanoThreefold(F26) -- 24

permutationIsomorphic(F26, F26p) -- true!


primitiveCollections(batyrevConstructor({1,1,1,1,1}, {0}, {})) -- 5 pc
primitiveCollections(prod) -- 3 pc
