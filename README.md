# Creating weak Fano toric varieties of Picard rank 3

**Authors:**
- Zhengning Hu
- Rohan Joshi

**Bibtex citation:**
```
@misc{weakFano-repo,
author = {Hu, Zhengning and Joshi, Rohan},
title = {{Weak-Fanos}},
howpublished = {\url{https://github.com/rohansjoshi/Weak-Fanos}},
year = {2025},
}
```

**Publication:**
* *Classifying toric weak Fano varieties of Picard rank 3*, Zhengning Hu and Rohan Joshi. In preparation, 2025.

This repository contains Macaulay 2 functions for constructive smooth projective toric varieties of Picard rank 3 (either as projective bundles or Batyrev varieties), following Batyrev. We also construct all such varieties that are weak Fano. Everything we have written is in a Macaulay2 package called `RankThreeTorics`. 

There are functions that automate the process of producing the classification in any dimension, and removing redundant isomorphic copies. For example, you can produce all smooth weak Fano toric varieties of Picard rank 3 with three primitive collections (which are projective bundles) of dimension 3, say, and print out the list as output by running

```
i1 : loadPackage "RankThreeTorics"

o1 = RankThreeTorics

o1 : Package

i2 : printListName(weakFanoProjectiveBundleVarieties(3))
1. (2, {0}, {{0, -2}}):       48        24        
2. (2, {0}, {{0, -1}}):       48        24        
3. (2, {0}, {{0, 0}}):       48        24        
4. (2, {0}, {{1, -2}}):       40        24        
5. (2, {0}, {{1, -1}}):       44        24        
6. (2, {0}, {{1, 1}}):       52        24        
7. (2, {0}, {{1, 2}}):       56        24        
8. (2, {0}, {{2, -2}}):       32        24        
9. (2, {0}, {{2, 2}}):       64        24        
10. (2, {1}, {{0, -1}}):       48        24        
11. (2, {1}, {{1, -1}}):       46        24        
12. (2, {1}, {{1, 0}}):       50        24        
13. (2, {1}, {{1, 1}}):       54        24        
14. (2, {1}, {{2, -1}}):       48        24        
15. (2, {1}, {{2, 0}}):       56        24        
16. (2, {1}, {{2, 1}}):       64        24        
17. (2, {2}, {{1, 0}}):       52        24        
18. (2, {2}, {{2, 0}}):       64        24   
```

Here the two columns are the computations of the Chern numbers $c_1^4$ and $c_1^2 c_2$. You can produce all smooth weak Fano toric varieties of Picard rank 3 with five primitive collections (Batyrev's construction) of dimension 3 by running

```
i3 : printListName(weakFanoBatyrevVarieties(3))
1. ({1, 1, 1, 1, 2}, {0}, {}):       46        24        
2. ({1, 1, 1, 1, 2}, {1}, {}):       48        24        
3. ({1, 1, 2, 1, 1}, {0}, {0}):       46        24        
4. ({1, 1, 2, 1, 1}, {0}, {1}):       46        24        
5. ({1, 1, 2, 1, 1}, {1}, {0}):       46        24        
6. ({1, 2, 1, 1, 1}, {0}, {}):       48        24        
7. ({1, 2, 1, 1, 1}, {1}, {}):       54        24        
8. ({1, 2, 1, 1, 1}, {2}, {}):       64        24        
9. ({2, 1, 1, 1, 1}, {1}, {}):       50        24        
10. ({2, 1, 1, 1, 1}, {2}, {}):       58        24   
```

There are many routines in the `RankThreeTorics` package which are generally useful for working with toric varieties. For example, the function `areIsomorphic`, which checks if two toric varieties are isomorphic. 

```
i1 : loadPackage "RankThreeTorics"

o1 = RankThreeTorics

o1 : Package

i2 : hirzebruchSurface 2

o2 = normalToricVariety ({{1, 0}, {0, 1}, {-1, 2}, {0, -1}}, {{0, 1}, {0, 3}, {1, 2}, {2, 3}})

o2 : NormalToricVariety

i3 : normalToricVariety({{1, -1}, {1, 0}, {1, 1}, {-1, 0}}, {{0, 1}, {1, 2}, {2, 3}, {0, 3}}) 

o3 = normalToricVariety ({{1, -1}, {1, 0}, {1, 1}, {-1, 0}}, {{0, 1}, {0, 3}, {1, 2}, {2, 3}})

o3 : NormalToricVariety

i4 : areIsomorphic(o2, o3)

o4 = true

```

Included in this repository is a package called `ToricExtras` which was written at the 2024 Macaulay2 workshop (and will eventually will be incorporated into `NormalToricVarieties`).