load "automate.m2"


-- Following along the lines of Kleinschmidt's paper "A classification of toric varieties with few generators",
-- we see that a Kleinschmidt toric variety has exactly two primitive collections (these are U and V) as described in section 2
-- And the corresponding primitive relations are:
-- \sum x_i = 0
-- \sum v_i = \sum a_i x_i
-- Let us calculate the degrees of these primitive relations (as defined in Sato's paper on weakened 3-folds)
-- The degree of the first relation is r+1, while the degree of the the second is s - \sum a_i
-- According to Sato, a toric variety is Fano (weak Fano) is deg > 0 (>= 0) for all primitive relations
-- r+1 > 0 always. s = d-r+1. So the condition is d-r+1 - \sum a_i > 0 (>= 0) for Fano (weak Fano) 
-- this is stated on the Macaulay2 Kleinschmidt page

expandNondecreasingList = (l, total) -> (
    newl = {};
    lastelem = l#-1;
    s = sum l;
    for i from lastelem to total-s do (
        newl = append(newl, join(l, {i}))
    );
    newl
);

kleinschmidtInputs = d -> (
    bigList = {};
    for i in 0 .. d do bigList = append(bigList, {i});
    currList = bigList;
    for lenList in 2 .. d-1 do (
        newCurrList = {};
        for l in currList do (
            newCurrList = join(newCurrList, expandNondecreasingList(l, d-lenList+1))
        );
        bigList = join(bigList, newCurrList);
        currList = newCurrList
    );
    bigList
);

kleinschmidtInputsFixed = d -> select(kleinschmidtInputs(d), l -> l#-1 != 0 or length l <= d/2)


-- Generating valid Batyrev inputs
-- Use Sato's theorem that Fano (resp weak Fano) if deg > 0 (>= 0)
-- Function to check if a given sequence (p, b, c) represents a weak Fano variety
-- isWeakFano = (p, b, c) -> (
--     -- Check the inequalities for weak Fano condition
--     return (p#0 + p#1 - c - b - p#3 >= 0) and 
--            (p#1 + p#2 - p#4 >= 0) and 
--            (p#2 + p#3 >= 0) and 
--            (p#3 + p#4 - p#1 >= 0) and 
--            (p#4 + p#0 - c - b >= 0)
-- )

-- Function to check if a given sequence (p, b, c) represents a Fano variety
-- isFano = (p, b, c) -> (
--     -- Check the inequalities for Fano condition
--     return (p#0 + p#1 - c - b - p#3 > 0) and 
--            (p#1 + p#2 - p#4 > 0) and 
--            (p#2 + p#3 > 0) and 
--            (p#3 + p#4 - p#1 > 0) and 
--            (p#4 + p#0 - c - b > 0)
-- )

-- Helper function to generate all lists of a given length with elements between min and max
generateLists = (len, minx, maxx) -> (
    if len == 0 then return {{}};
    lists := {}; -- need := since it's a local variable
    subLists = generateLists(len - 1, minx, maxx);
    for i from minx to maxx do (
        for sublist in subLists do (
            lists = append(lists, prepend(i, sublist));
        );
    );
    lists
);

-- Helper function to generate all *nondecreasing* lists of a given length with elements between min and max
generateNondecreasingLists = (len, minx, maxx) -> (
    if len == 0 then return {{}};
    lists := {}; -- need := since it's a local variable
    for i from minx to maxx do (
        subLists = generateLists(len - 1, i, maxx);
        for sublist in subLists do (
            lists = append(lists, prepend(i, sublist));
        );
    );
    lists
);

-- Function to generate all valid sequences (p, B, C) for a given d
batyrevInputs = d -> (
    -- Initialize an empty list to store valid sequences
    validSequences = {};

    -- Generate all possible lists p of length 5 with sum d + 3
    for p0 from 1 to d + 3 do
        for p1 from 1 to d + 3 - p0 do
            for p2 from 1 to d + 3 - p0 - p1 do
                for p3 from 1 to d + 3 - p0 - p1 - p2 - 1 do (
                    p4 := d + 3 - p0 - p1 - p2 - p3;
                    p = {p0, p1, p2, p3, p4};

                    -- Check if p2 - 1 >= 0 (to ensure C has nonnegative length)
                    if p2 - 1 >= 0 then (
                        -- Generate all possible lists B of length p3
                        Bs = generateNondecreasingLists(p3, 0, d + 3);

                        -- Generate all possible lists C of length p2 - 1
                        Cs = generateNondecreasingLists(p2 - 1, 0, d + 3);

                        -- Iterate over all combinations of B and C
                        for B in Bs do (
                            for C in Cs do (
                                -- Compute sums b and c
                                b := sum B;
                                c := sum C;

                                -- Check the inequalities
                                if (p0 + p1 - c - b - p3 >= 0) and
                                   (p1 + p2 - p4 >= 0) and
                                   (p3 + p4 - p1 >= 0) and 
                                   (p4 + p0 - c - b >= 0) then (
                                    -- Add the valid sequence to the list
                                    validSequences = append(validSequences, (p, B, C));
                                );
                            );
                        );
                    );
                );

    -- Return the list of valid sequences
    validSequences
);

invariantList = {anticanonicalDegree, chernNumber} --, vectorFields, deformationSpace, obstructionSpace, omegaInvariant}

batyrevVarietiesUnfiltered = d -> apply(batyrevInputs(d), inputs -> (inputs, batyrevConstructor(inputs)));
batyrevVarieties = d -> filterListRepeatsInvName(calculateInvariantsName(apply(batyrevInputs(d), inputs -> (inputs, batyrevConstructor(inputs))), invariantList));
batyrevVarietiesVerbose = d -> filterListRepeatsInvNameVerbose(calculateInvariantsName(apply(batyrevInputs(d), inputs -> (inputs, batyrevConstructor(inputs))), invariantList));


end----



batyrevVarietiesUnfiltered(3)
printListName(batyrevVarieties(3))
printListName(batyrevVarieties(4))
printListName(batyrevVarietiesUnfiltered(4))

printListName(batyrevVarietiesVerbose(3))
printListName(batyrevVarietiesVerbose(4))
printListName(batyrevVarietiesVerbose(5))


length batyrevVarieties(5) -- 94
-- So we have a number for 5-folds