--needsPackage "NormalToricVarieties";
--needsPackage "ToricExtras"
--needsPackage "InvariantRing";
--load "Invariants.m2"

-- Generate permutation matrices
-- Unfortunately, permutationMatrix in the InvariantRing package only takes input in the form of cycle notation
-- and permutationMatrix in the SpechtModule package produces permutation matrices over Q, not Z
-- so I am forced to implement permutation matrices myself. Feel free to optimize this (or look at the source code of the above implementations for reference)

genRow = (i, n) -> (
    l := {};
    for ind from 0 to n-1 do (
        if ind == i then l = append(l, 1) else l = append(l, 0);
    );
    l
)

permMatrix = perm -> (
    n := length perm;
    mat := {};
    for i in perm do (
        mat = append(mat, genRow(i, n));
    );
    matrix mat
)
-- technically this is the transpose i.e. I permuted the rows, not the columns, with the permutation
-- but it plays well with the later functions, which use rows of the matrix for the vectors in generating rays in the fan

--- Given a list of toric varieties (possibly with invariants calculated) filter the list such that
-- each isomorphism type appears only once


-- NEW VERSION
areIsomorphic = (X1, X2) -> (
    dim X1 == dim X2 and length rays X1 == length rays X2 and length max X1 == length max X2 and any(
        permutations length rays X1, 
        perm -> (all(max X1, kone -> isMember(set apply(kone, i -> perm#i), apply(max X2, set)))) and
        -- don't need to do other direction assuming toric varieties are well defined with no repeated cones
        -- because a permutation is bijective, so the map on cones is injective (no two cones can be permuted to the same cone), and because the number of cones for X1 is same as X2
        -- it is also surjective, so it is a bijection on the sets of cones
        ( -- check that there is a matrix sending v_i to w_sigma(i) for all i
            V := matrix rays X1;
            W := matrix rays X2;
            Wsig := (permMatrix perm) * W;
            T := solve(V, Wsig, MaximalRank=>true); -- 'solve' uses row reduction over ZZ. Already implemented in Macaulay2 (InvariantRing package)
            diffMatrix := V*T - Wsig;
            diffMatrix == 0 and (try inverse T then true else false) -- to make sure inverse is also defined over ZZ
        )
    )
)

-- areIsomorphic = permutationIsomorphic;
areIsomorphicInv = (P1, P2) -> (
    (X1, l1) := P1;
    (X2, l2) := P2;
    assert(length(l1) == length(l2));
    for i in 0 .. length(l1)-1 do (
        if l1#i != l2#i then return false;
    );
    return areIsomorphic(X1, X2);
)
areIsomorphicInvName = (P1, P2) -> (
    (N1, X1, l1) := P1;
    (N2, X2, l2) := P2;
    assert(length(l1) == length(l2));
    for i in 0 .. length(l1)-1 do (
        if l1#i != l2#i then return false;
    );
    return areIsomorphic(X1, X2);
)


filterListRepeats = l -> (
    currList := {};
    for entry in l do (
        isInList := false;
        for entry2 in currList do (
            if areIsomorphic(entry, entry2) then (
                isInList = true;
                break;
            );
        );
        if not isInList then (
            currList = append(currList, entry)
        );
    );
    return currList;
)

filterListRepeatsInv = l -> (
    currList := {};
    for entry in l do (
        isInList := false;
        for entry2 in currList do (
            if areIsomorphicInv(entry, entry2) then (
                isInList = true;
                break;
            );
        );
        if not isInList then (
            currList = append(currList, entry)
        );
    );
    return currList;
)

filterListRepeatsInvName = l -> (
    currList := {};
    for entry in l do (
        isInList := false;
        for entry2 in currList do (
            if areIsomorphicInvName(entry, entry2) then (
                isInList = true;
                break;
            );
        );
        if not isInList then (
            currList = append(currList, entry)
        );
    );
    return currList;
)

filterListRepeatsInvNameVerbose = l -> (
    currList := {};
    for entry in l do (
        isInList := false;
        for entry2 in currList do (
            if areIsomorphicInvName(entry, entry2) then (
                isInList = true;
                << entry#0 << " is isomorphic to " << entry2#0 << endl;
                break;
            );
        );
        if not isInList then (
            currList = append(currList, entry)
        );
    );
    return currList;
)


invariantList = {anticanonicalDegree, chernNumber} --, vectorFields, deformationSpace, obstructionSpace, omegaInvariant}
calculateInvariants = (l, invList) -> apply(l, X -> (X, apply(invList, inv -> inv(X))))
calculateInvariantsName = (l, invList) -> apply(l, P -> (P#0, P#1, apply(invList, inv -> inv(P#1))))

printList = l -> (
    counter := 1;
    for entry in l do (
        << counter << ". ";
        invariantNumbers := entry#1;
        if length entry > 2 then (
            for invariant in invariantNumbers do (  -- what is invariantNumbers here?
                << invariant << "\t";
            );
        );
        << endl;
        counter = counter + 1;
    );
) 

printListName = l -> (
    counter := 1;
    for entry in l do (
        << counter << ". ";
        << entry#0 << ":\t";
        if length entry > 2 then (
            invariantNumbers := entry#2;
            for invariant in invariantNumbers do (  
                << invariant << "\t";
            );
        );
        << endl;
        counter = counter + 1;
    );
) 


end--------