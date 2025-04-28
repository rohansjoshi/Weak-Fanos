-- Fano Kleinschmidts
TEST ///
    assert(length FanoKleinschmidtVarieties(3) == 4)
///
TEST ///
    assert(length FanoKleinschmidtVarieties(4) == 9)
///

-- weakFano Kleinschmidts
TEST ///
    assert(length weakFanoKleinschmidtVarieties(3) == 7)
///
TEST ///
    assert(length weakFanoKleinschmidtVarieties(4) == 14)
///


-- Fano Batyrevs
TEST ///
    assert(length FanoBatyrevVarieties(2) == 1)
///
TEST ///
    assert(length FanoBatyrevVarieties(3) == 2)
///
TEST ///
    assert(length FanoBatyrevVarieties(4) == 9)
///
TEST ///
    assert(length FanoBatyrevVarieties(5) == 25)
///
TEST ///
    assert(length FanoBatyrevVarieties(6) == 69)
///

-- weakFano Batyrevs
TEST ///
    assert(length weakFanoBatyrevVarieties(2) == 2)
///
TEST ///
    assert(length weakFanoBatyrevVarieties(3) == 10)
///
TEST ///
    assert(length weakFanoBatyrevVarieties(4) == 33)
///
TEST ///
    assert(length weakFanoBatyrevVarieties(5) == 94)
///
TEST ///
    assert(length weakFanoBatyrevVarieties(6) == 226)
///

-- Fano projective bundles
TEST ///
    assert(length FanoProjectiveBundleVarieties(3) == 5)
///
TEST ///
    assert(length FanoProjectiveBundleVarieties(4) == 19)
///

-- weak Fano projective bundles
TEST ///
    assert(length weakFanoProjectiveBundleVarieties(3) == 18)
///
TEST ///
    assert(length weakFanoProjectiveBundleVarieties(4) == 81)
///
