needsPackage "NormalToricVarieties"
load "automate.m2"
load "batyrev.m2"
load "projectiveBundles.m2"

-- complete list of weak Fano
batyrev5PCWeakFano4folds = batyrevVarieties(4);
batyrev5PCWeakFano4folds = for i from 0 to (#batyrev5PCWeakFano4folds - 1) list drop(batyrev5PCWeakFano4folds#i,{2,2});
-- #batyrev5PCWeakFano4folds -- 33


-- list of Fano
batyrev5PCFano4folds = {};
for i from 0 to (#batyrev5PCWeakFano4folds - 1) do (
    X = batyrev5PCWeakFano4folds#i#1;
    if (isFano X) then (
        batyrev5PCFano4folds = append(batyrev5PCFano4folds, batyrev5PCWeakFano4folds#i)
    );
); 
batyrev5PCFano4folds;

-- list of weak Fano \ Fano
batyrev5PCwFano4folds = {};
for i from 0 to (#batyrev5PCWeakFano4folds - 1) do (
    X = batyrev5PCWeakFano4folds#i#1;
    if (isNef (-toricDivisor X)) and (not isFano X) then (
        batyrev5PCwFano4folds = append(batyrev5PCwFano4folds, batyrev5PCWeakFano4folds#i)
    );
);
batyrev5PCwFano4folds;
