-- Various invariants
-- Load this file

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
    tensor2 := X -> (prune sheafHom(prune sheafHom(cotangentSheaf(X), sheaf(X, ring X)), cotangentSheaf(X)));
    return rank HH^1(X, tensor2(X));
)

-- Constructs the sheaf Omega^1 tensor O(D), by doing Hom(O(-D), Omega^1)
Omega1D = method();
Omega1D(NormalToricVariety, ToricDivisor) := (X, D) -> (
    rank1 := OO (-D); 
    omega := cotangentSheaf(X); 
    prune sheafHom(rank1, omega)
);

vanishesOnFanoInvariant = method();
vanishesOnFanoInvariant(NormalToricVariety) := X -> (
    return rank HH^1(X, Omega1D(X, -toricDivisor X));
)

