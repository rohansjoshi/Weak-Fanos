doc ///
    Key
        areIsomorphic
    Headline
        checks if two toric varieties are isomorphic
    Usage
        areIsomorphic(X1, X2)
    Inputs
        X1 : NormalToricVariety
        X2 : NormalToricVariety
    Description
    	Text
            Checks if there exists a toric isomorphism between two NormalToricVarieties
            by seeing if there is a linear map that maps the rays of one to (a permutation of)
            the rays of the others, such that all maximal cones are preserved and there is a 
            bijection of maximal cones.
        Example
            X1 = normalToricVariety({{1, -1}, {1, 0}, {1, 1}, {-1, 0}}, {{0, 1}, {1, 2}, {2, 3}, {0, 3}}) 
            X2 = hirzebruchSurface 2
            areIsomorphic(X1, X2)
///