-- Various invariants
-- Load this file

-- The "genus" of a variety is the number g that satisfies 2g-2 = d, where d is the anticanonical degree.
-- It really only has a geometric interpretation that makes sense in the case of Fano 3-folds. For a Fano 3-fold X, its anticanonical divisor is ample, and so (a multiple of it) defines an embedding into some projective space. Then a smooth hyperplane section of X is a surface S whose canonical divisor is zero by the adjunction formula: K_S = (K_X + H)_H = 0, since H is linearly equivalent to -K_X. So is a Calabi-Yau surface (I believe it can be proved S is a K3 surface). Anyway, if we intersect S with a hyperplane section, we get a curve C, and by the adjunction formula for surfaces we have 2g(C)-2 = (0+H_S).H = (H.H).H = H^3 = (-K_X)^3, which is the anticanonical degree --
 
genusOfFanoThreefold = method();
genusOfFanoThreefold(NormalToricVariety) := X -> (
    assert isFano X;
    assert (dim X == 3);
    return 1 + (anticanonicalDegree X)/2;
)


betti4 = method();
betti4(NormalToricVariety) := X -> (
    d0 := 1;
    d1 := #orbits(X,3);
    d2 := #orbits(X,2);
    return d2 - 3*d1 + 6*d0;
)

-- note that 2nd Betti number equals the Picard number = 3

-- anticanonical degree (in Helper Functions) gives one Chern number c_1^n
-- This gives another Chern number, c_1 ^(n-2) * c_2
-- For 3-fold it is c_1c_2, for a 4-fold it is c_1^2 c_2
chernNumber = method();
chernNumber(NormalToricVariety) := X -> (
    K := toricDivisor X;
    c1 := chern(1, OO (-K));
    c2 := chern(2, prune sheafHom(cotangentSheaf(X), sheaf(X, ring X)));
    return integral (c1^(dim(X)-2)*c2);
)

randomInvariantP = method(); -- maybe change the name of this later
randomInvariantP(NormalToricVariety) := X -> (
    tensor2(NormalToricVariety) := X -> (prune sheafHom(prune sheafHom(cotangentSheaf(X), sheaf(X, ring X)), cotangentSheaf(X)));
    return rank HH^1(X, tensor2(X));
)

-- Constructs the sheaf Omega^1 tensor O(D), by doing Hom(O(-D), Omega^1)
Omega1D = method();
Omega1D(NormalToricVariety, ToricDivisor) := (X, D) -> (
    rank1 := OO (-D); 
    omega := cotangentSheaf(X); 
    prune sheafHom(rank1, omega)
);

omegaInvariant = method();
omegaInvariant(NormalToricVariety) := X -> (
    return rank HH^1(X, Omega1D(X, -toricDivisor X));
)

