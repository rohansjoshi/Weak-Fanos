needsPackage "NormalToricVarieties"
loadPackage("ToricExtras", Reload=>true)
load "primitive2max.m2"

-- An updated version 2025-3-12
-- which can deal with repeated elements

minimalElements = method();
minimalElements(List) := (L) -> (
    -- with input a list (of lists), the function will return another list 
    -- consisting of only minimal elements with respect to inclusion
    d := #L; -- length of the list
    minimal = {};
    for i from 0 to (d - 1) list (
        Li := L#i;
        flag := true;
        for j from 0 to (d - 1) do (
            if i != j and isSubset(L#j, Li) and #(L#j) != #Li then (
                flag = false;
                break;
            )
        );
        if flag then (minimal = append(minimal, Li))
    );
    minimal = unique(minimal);
    return minimal
)

-- A version where we don't delete while scanning

minimalElementsAlt = method();
minimalElementsAlt(List) := (L) -> (
    -- with input a list (of lists), the function will return another list 
    -- consisting of only minimal elements with respect to inclusion
    d := #L; -- length of the list
    newList = L;
    deleteList = {};
    for i from 0 to (d - 1) do (
        for j from 0 to (d - 1) do (
            if i != j and isSubset(L#j, L#i) and #(L#i) > #(L#j) then (
                deleteList = append(deleteList, i);
                break;
            );
        );
    );
    for k from 0 to (#deleteList - 1) do (
        newList = delete(newList, deleteList#(#deleteList-1-k))
    )
    return newList
)

primitiveBlowup = method();
primitiveBlowup(NormalToricVariety, List) := (toricVariety, blowupCone) -> (
    -- the inputs are: a normal toric variety, and a cone contained in its fan
    -- the function returns the toric variety after star subdivision along the blowup cone
    X := toricVariety;
    sigma := blowupCone;
    pRays := rays X;
    mCones := max X;
    d := #pRays#0; -- dimension of the fan

    -- check if the star subdivision is legitimate
    count = 0;
    for i from 2 to d do (
        if isMember(sigma, orbits(X, d - i)) then count = count + 1
    );
    if count == 0 then (
        erP := "Not a cone in the fan!";
        error erP;
    );

    x = (for i from 0 to d - 1 list 0); 
    for i from 0 to (#sigma - 1) do x = x + (pRays#(sigma#i));
    newRays = append(pRays, x); -- set of rays for the blowup 

    pCollections = toricPrimitiveCollections(pRays, mCones); -- the original set of PCs

    -- the new set of primitive collections contains 3 parts:
    -- 1. the cone along which we blow up
    P1 = {sigma};
    -- 2. the original PCs which do not contain the cone sigma
    P2 = {};
    for i from 0 to (#pCollections - 1) do (
        if not isSubset(sigma, pCollections#i) then P2 = append(P2, pCollections#i)
    );
    -- 3. the minimal elements of original PC with element in sigma replaced by the ray x
    tempP3 = {};
    for i from 0 to (#pCollections - 1) do (
        if #(set(pCollections#i) * set(sigma)) > 0 then tempP3 = append(tempP3, toList(set(pCollections#i) - set(sigma)))
    );
    tempP3 = minimalElements(tempP3);
    P3 = for i from 0 to (#tempP3 - 1) list append(tempP3#i, #newRays - 1);
    
    -- New primitive collections after star subdivision
    newP = toList(set P1 + set P2 + set P3);

    -- Resulting toric variety after blowup
    newToricVariety = normalToricVariety(newRays, toricMaxcones(newRays, newP));

    -- Return the new toric variety
    return newToricVariety
)

primitiveBlowdown = method();
primitiveBlowdown(NormalToricVariety, List) := (toricVariety, blowdownPC) -> (
    -- the inputs are: a normal toric variety, and a primitive collection
    -- the function returns the toric variety after contraction along the given PC
    X := toricVariety;
    sigma := blowdownPC;
    -- sigmaRays = for i from 0 to (#sigma - 1) list pRays#(sigma#i); sigmaRays;
    pRays := rays X;
    mCones := max X;
    d := #pRays#0; -- dimension of the fan
    pCollections = toricPrimitiveCollections(pRays, mCones);
    pCollectionsSet = for i from 0 to (#pCollections - 1) list set(pCollections#i);

    -- check if the blowdown is legitimate
    if not isMember(set(sigma), pCollectionsSet) then (
        erP := "Not a primitive collection!";
        error erP;
    );

    x = (for i from 0 to d - 1 list 0);
    for i from 0 to (#sigma - 1) do x = x + (pRays#(sigma#i));
    -- legitimate check
    if not isMember(x, pRays) then (
        erQ := "Vector not in the ray set!";
        error erQ;
    );

    newRays = delete(x, pRays);
    posDelete = position(pRays, i -> i == x);

    -- the new set of primitive collections contains 2 parts:
    -- 1. the original PCs excluding sigma, not containing ray x
    P1 = {};
    for i from 0 to (#pCollections - 1) do (
        raysPC = for j from 0 to (#pCollections#i - 1) list pRays#(pCollections#i#j);
        if set(pCollections#i) =!= set(sigma) and not isMember(x, raysPC) then P1 = append(P1, pCollections#i)
    );
    -- shift 
    shiftP1 = for i from 0 to (#P1 - 1) list (
        PC = {};
        for j from 0 to (#P1#i - 1) do (
            if P1#i#j > posDelete then PC = append(PC, P1#i#j - 1)
            else PC = append(PC, P1#i#j)
        ); 
        PC
    );

    -- 2. replace x by sigma, for original PCs including x but
    --    replacing x by any subset of sigma is not contained in the original sets of PCs
    tempP2 = {};
    for i from 0 to (#pCollections - 1) do (
        raysPC = for j from 0 to (#pCollections#i - 1) list pRays#(pCollections#i#j);
        if isMember(x, raysPC) then (
            pos = position(pRays, k -> k == x);
            tempP2 = append(tempP2, delete(pos, pCollections#i))
        );
    );
    S = subsets(sigma);
    P2 = {};
    for i from 0 to (#tempP2 - 1) do (
        union = set(for j from 0 to (#S - 1) list set(tempP2#i) + set(S#j));
        if #(union * set(pCollectionsSet)) == 0 then P2 = append(P2, toList(set(tempP2#i) + set(sigma))) 
    );
    -- shift 
    shiftP2 = for i from 0 to (#P2 - 1) list (
        PC = {};
        for j from 0 to (#P2#i - 1) do (
            if P2#i#j > posDelete then PC = append(PC, P2#i#j - 1)
            else PC = append(PC, P2#i#j)
        );
        PC
    );
    
    -- New primitive collections after blowdown
    newP = toList(set shiftP1 + set shiftP2);

    -- Resulting toric variety after blowdown
    newToricVariety = normalToricVariety(newRays, toricMaxcones(newRays, newP));

    -- Return the new toric variety
    return newToricVariety
)

end----

-- Test
testL = {{1,2},{2},{3,4,6},{1}};
minimalElements(testL)

-- Test
X7 = batyrevConstructor({1,1,1,2,1}, {0,0}, {});
blowupX7_test1 = primitiveBlowup(X7, {3,4})
isWellDefined blowupX7_test1, isSmooth blowupX7_test1, isProjective blowupX7_test1, isNef (-toricDivisor blowupX7_test1)
blowupX7_test2 = primitiveBlowup(X7, {0,1}) -- cone not in the fan!

-- Test
X7 = batyrevConstructor({1,1,1,2,1}, {0,0}, {});
sigma1 = {1,2};
blowdownX7_test1 = primitiveBlowdown(X7, sigma1)
toricPrimitiveCollections(rays blowdownX7_test1, max blowdownX7_test1)
sigma2 = {3,4,5};
blowdownX7_test2 = primitiveBlowdown(X7, sigma2)
toricPrimitiveCollections(rays blowdownX7_test2, max blowdownX7_test2)

-- An fourfold example
Wb50 = batyrevConstructor({1,2,2,1,1},{0},{0});
toricPrimitiveCollections(rays Wb50, max Wb50)
-- first contraction: x0 + x1 + x2 = x5
Wb50blowdown1 = primitiveBlowdown(Wb50, {0,1,2}); -- Picard rank 2
isWellDefined Wb50blowdown1, isFano Wb50blowdown1, isNef (-toricDivisor Wb50blowdown1) -- TTT
-- second contraction: x1 + x2 + x3 + x4 = x6
Wb50blowdown2 = primitiveBlowdown(Wb50, {1,2,3,4}); -- Picard rank 2
isWellDefined Wb50blowdown2, isFano Wb50blowdown2, isNef (-toricDivisor Wb50blowdown2) -- TTT
-- blowup along {1,2} then blowdown along {5,6}: an Atiyah flop
Wb50up = primitiveBlowup(Wb50, {1,2})
Wb50flop = primitiveBlowdown(Wb50up, {5,6})
isWellDefined Wb50flop, isFano Wb50flop, isNef (-toricDivisor Wb50flop), picardGroup Wb50flop -- weak Fano, Picard rank 3
#(toricPrimitiveCollections(rays Wb50flop, max Wb50flop)) -- 3 primitive collection!
