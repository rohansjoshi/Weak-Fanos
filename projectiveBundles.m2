load "automate.m2"

-- This helper function returns all lists of length n 
-- whose entries are between l and u.
allLists = (n, l, u) -> (
    if n == 0 then { {} }
    else flatten (
         for x in (l..u) list (
              for L in allLists(n-1, l, u) list (
                  {x} | L
              )
         )
    )
);

-- This helper function returns all *nondecreasing* lists of length n 
-- whose entries are between l and u.
nondecreasingLists = (n, l, u) -> (
    if n == 0 then {{}}
    else flatten (
         for x in (l..u) list (
              for L in nondecreasingLists(n-1, x, u) list (
                  {x} | L
              )
         )
    )
);

checkDictionaryOrder = (b, c) -> (
    -- Assumes b and c have the same length.
    n := #b;
    for i from 0 to n-2 do (
        if (b#i == b#(i+1) and c#i > c#(i+1)) then return false;
    );
    true
);

makePairs = (b, c) -> (for i in (0..(length b)-1) list ({b#i, c#i}))

projectiveBundleConstructor = (d, a, ls) -> (
    -- change assert
    X = kleinschmidt(d, a);
    zeroD = toricDivisor(apply(toList(1..d+2), i -> 0), X);
    lineBundles = {zeroD};
    for l in ls do (lineBundles = append(lineBundles, toricDivisor(join({l#0}, apply(toList(1..d), i -> 0), {l#1}), X)));
    projectivizationOfBundle(lineBundles)
)

------- Steps:
-- Construct all (weak Fano) Kleinschmidts inputs (d', a_1, ... a_r)
-- For each input d', (a_1, ... a_r)
	-- Construct the variety X_d'(a_1, ... a_r)
	-- Create the list of possible bs
	-- Create the list of possible cs
	-- For each pair of b and c
		-- If the b and c actually satisfy the inequalities, and if it is in "dictionary order",
			-- Construct the associated projective bundle
			-- If it is Fano, add to Fano list
			-- If it is weak Fano, add to weak Fano list

wFanoRankThreePCThreeBased = (d, d') -> (
    wFanoList = {};
    for a in kleinschmidtInputsFixed(d') do (
        r = d' - length a;
        baseVariety = kleinschmidt(d', a);
        bs = nondecreasingLists(d-d', 0, d'-r+1);
        cs = allLists(d-d', -(r+1 - sum a), r+1 - sum a);
        for b in bs do (
            for c in cs do (
                if (sum b <= d' - r + 1) and (sum c - (d-d'-1)*(min c) <= r+1 - sum a) and (checkDictionaryOrder(b, c)) then (
                    X = projectiveBundleConstructor(d', a, makePairs(b, c));
                    if isNef(-toricDivisor X) then wFanoList = append(wFanoList, ((d', a, makePairs(b, c)), X))
                )
            )
        )
    );
    wFanoList
)

projectiveBundleVarieties = d -> (
    filterListRepeatsInvName(calculateInvariantsName(flatten(for d' in 2..d-1 list wFanoRankThreePCThreeBased(d, d')), invariantList))
)

end----

printListName(projectiveBundleVarieties(3))
printListName(projectiveBundleVarieties(4))
printListName(projectiveBundleVarieties(5))
-- printListName(projectiveBundleVarieties(6))
