needsPackage "NormalToricVarieties"
load "automate.m2"
load "batyrev.m2"
load "projectiveBundles.m2"

-- complete list of weak Fano
batyrev3PCWeakFano4folds = projectiveBundleVarieties(4);
batyrev3PCWeakFano4folds = for i from 0 to (#batyrev3PCWeakFano4folds - 1) list drop(batyrev3PCWeakFano4folds#i,{2,2});

-- list of Fano
batyrev3PCFano4folds = {};
for i from 0 to (#batyrev3PCWeakFano4folds - 1) do (
    X = batyrev3PCWeakFano4folds#i#1;
    if (isFano X) then (
        batyrev3PCFano4folds = append(batyrev3PCFano4folds, batyrev3PCWeakFano4folds#i)
    );
); 
batyrev3PCFano4folds;


-- list of weak Fano \ Fano
batyrev3PCwFano4folds = {};
for i from 0 to (#batyrev3PCWeakFano4folds - 1) do (
    X = batyrev3PCWeakFano4folds#i#1;
    if (isNef (-toricDivisor X)) and (not isFano X) then (
        batyrev3PCwFano4folds = append(batyrev3PCwFano4folds, batyrev3PCWeakFano4folds#i)
    );
);
batyrev3PCwFano4folds;
