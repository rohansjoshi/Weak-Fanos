doc ///
    Key
        toricPrimitiveCollections
    Headline
        Computes list of primitive collections
    Usage
        (rayList, maxCones)
    Inputs
        rayList : List
        maxCones : List
    Description
    	Text
            Given the rays and maximal cones of a toric variety, returns the list of primitive collections
        Example
            X = hirzebruchSurface 2
            toricPrimitiveCollections(rays X, max X)
            Y = batyrevConstructor({1,1,1,1,1},{0},{})
            toricPrimitiveCollections(rays Y, max Y)
            length oo
///