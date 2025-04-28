-- -*- coding: utf-8 -*-

newPackage(
    "RankThreeTorics",
    AuxiliaryFiles => true,
    Version => "0.1",
    Date => "April 23, 2025",
    Authors => {{
            Name => "Zhengning Hu",
            Email => "zhengninghu@arizona.edu",
            HomePage => "https://sites.google.com/math.arizona.edu/zhengninghu/home"},
        {
	        Name => "Rohan Joshi",
	        Email => "rohansjoshi@math.ucla.edu",
            HomePage => "https://www.math.ucla.edu/~rohansjoshi"}
    },
    Headline => "Constructing Fano and weak Fano Picard rank 3 toric varieties",
    Keywords => {"Toric Geometry"},
    PackageExports => {"NormalToricVarieties", "ToricExtras"},
    PackageImports => {"NormalToricVarieties", "ToricExtras", "InvariantRing", "PrimaryDecomposition"},
    DebuggingMode => true
    )

export {
    -- from Invariants.m2:
    "betti4",
    "chernNumber",
    -- from Automate.m2:
    "areIsomorphic",
    "filterListRepeats",
    "calculateInvariants",
    "printList",
    "printListName",
    -- from Batyrev.m2:
    "FanoKleinschmidtVarieties",
    "weakFanoKleinschmidtVarieties",
    "FanoBatyrevVarieties",
    "weakFanoBatyrevVarieties",
    -- from ProjectiveBundles.m2:
    "projectiveBundleConstructor",
    "FanoProjectiveBundleVarieties",
    "weakFanoProjectiveBundleVarieties",
    -- from PrimitiveToMax.m2
    "toricMaxcones",
    "toricPrimitiveCollections",
    -- from "PrimitiveMori.m2"
    "primitiveBlowup",
    "primitiveBlowdown"
    }


------------------------------------------------------------------------------
-- CODE
------------------------------------------------------------------------------

load "./RankThreeTorics/Invariants.m2"

load "./RankThreeTorics/Automate.m2"

load "./RankThreeTorics/Batyrev.m2"

load "./RankThreeTorics/ProjectiveBundles.m2"

load "./RankThreeTorics/PrimitiveToMax.m2"

load "./RankThreeTorics/PrimitiveMori.m2"


------------------------------------------------------------------------------
-- DOCUMENTATION
------------------------------------------------------------------------------
beginDocumentation ()
doc ///
    Key
        RankThreeTorics
    Headline
        Constructing Fano and weak Fano Picard rank 3 toric varieties
    Description
        Text
	    This package implements routines for constructing smooth projective toric varieties of Picard rank 3., constructing them as projective bundles and Batyrev varieties, and automatically constructing all such Fano or weak Fano varieties in any dimension.

///

load "./RankThreeTorics/AutomateDocumentation.m2"

load "./RankThreeTorics/PrimitiveToMaxDocumentation.m2"

------------------------------------------------------------------------------
-- TESTS
------------------------------------------------------------------------------

-- test 0
TEST ///
    X = toricProjectiveSpace 1;
    assert isWellDefined X
///

load "./RankThreeTorics/RankThreeToricsTests.m2"


end---------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SCRATCH SPACE
------------------------------------------------------------------------------

-- XXX
uninstallPackage "RankThreeTorics";
restart
installPackage "RankThreeTorics"
viewHelp RankThreeTorics
check RankThreeTorics
check (RankThreeTorics, Verbose => true)

needsPackage "RankThreeTorics";
