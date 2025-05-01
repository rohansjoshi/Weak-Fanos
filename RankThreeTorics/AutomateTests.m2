TEST ///
    -- Zhengning's example

    -- the first fan
    F1_rays = {{1, 0, 2},
            {0, 1, 0},
            {-1, 0, 0},
            {0, -1, 0},
            {0, 0, -1},
            {0, 0, 1}}

    F1_mcones = {{0, 1, 4},
                {0, 1, 5},
                {4, 2, 1},
                {0, 3, 4},
                {0, 3, 5},
                {5, 2, 3},
                {1, 2, 5},
                {2, 3, 4}}

    -- the second fan
    F2_rays = {{1, 0, 0},
            {0, 1, 0},
            {-1, 2, 0},
            {0, -1, 0},
            {0, 0, -1},
            {0, 0, 1}}

    F2_mcones = {{5, 0, 1},
                {0, 1, 4},
                {4, 2, 1},
                {0, 3, 4},
                {3, 0, 5},
                {2, 5, 3},
                {2, 5, 1},
                {2, 4, 3}}

    X1 = normalToricVariety(F1_rays, F1_mcones)
    X2 = normalToricVariety(F2_rays, F2_mcones)
    assert(areIsomorphic(X1, X2)) -- should be true
///
TEST ///
    F3_rays = {{0, 0, 1, -1},
            {0, 0, 1, 1},
            {-1, -1, -1, 0},
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}}

    F3_mcones = {{0, 2, 3, 4},
                {0, 2, 3, 5},
                {0, 2, 4, 5},
                {0, 3, 4, 5},
                {1, 2, 3, 5},
                {1, 2, 3, 6},
                {1, 2, 4, 5},
                {1, 2, 4, 6},
                {1, 3, 4, 5},
                {1, 3, 4, 6},
                {2, 3, 4 ,6}}

    F4_rays = {{1, 0, 0, -1},
            {0, 0, 1, 1},
            {-1, -1, -1, 0},
            {1, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}}
            
    F4_mcones = {{0, 2, 3, 4},
                {0, 2, 3, 5},
                {0, 2, 4, 5},
                {0, 3, 4, 5},
                {1, 2, 3, 5},
                {1, 2, 3, 6},
                {1, 2, 4, 5},
                {1, 2, 4, 6},
                {1, 3, 4, 5},
                {1, 3, 4, 6},
                {2, 3, 4 ,6}}

    X3 = normalToricVariety(F3_rays, F3_mcones)
    X4 = normalToricVariety(F4_rays, F4_mcones)

    assert(not areIsomorphic(X3, X4)) -- should be false
///
TEST ///
    assert(areIsomorphic(kleinschmidt(3, {0}), kleinschmidt(3, {0,0}))) -- should be true
    assert(not areIsomorphic(kleinschmidt(3, {0}), kleinschmidt(3, {0, 1}))) -- should be false
///