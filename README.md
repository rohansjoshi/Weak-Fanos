# Creating weak Fano toric varieties of Picard rank 3

**Authors:**
- Zhengning Hu
- Rohan Joshi

**Publication:**
* *Classifying toric weak Fano varieties of Picard rank 3*, Zhengning Hu and Rohan Joshi. In preparation, 2025.

This repository contains functions for constructive smooth projective toric varieties of Picard rank 3 (either as projective bundles or Batyrev varieties), following Batyrev. We also construct all such varieties that are weak Fano. There are functions that automate the process of producing the classification in any dimension, and removing redundant isomorphic copies.

For example, you can produce all smooth weak Fano toric varieties of Picard rank 3 with three primitive collections (which are projective bundles) of dimension 3, say, and print out the list as output by running

```
load "projectiveBundles.m2"
printListName(projectiveBundleVarieties(3))
```

You can produce all smooth weak Fano toric varieties of Picard rank 3 with five primitive collections (Batyrev's construction) of dimension 3 by running

```
load "batyrev.m2"
printListName(batyrevVarieties(3))
```

Some generally useful functions/invariants are in `Invariants.m2`. The function `areIsomorphic`, which checks if two toric varieties are isomorphic is in `automate.m2`. 

Included in this repository is a package called `ToricExtras` which was written at the 2024 Macaulay2 workshop (and will eventually will be incorporated into `NormalToricVarieties`).
