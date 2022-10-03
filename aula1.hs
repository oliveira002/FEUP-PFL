{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use splitAt" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use last" #-}
testaTriangulo :: Float -> Float -> Float -> Bool
testaTriangulo a b c = a < b + c && b < a +c && c < a +b

areaTriangulo :: Float -> Float -> Float -> Float
areaTriangulo a b c = sqrt(s*(s-a)*(s-b)*(s-c))
    where s = (a+b+c) / 2

metades :: [a]->([a],[a])
metades xs = (take tmp xs, drop tmp xs)
    where tmp = ((length xs) `div` 2)

newLast :: [a]-> a
newLast xs = head(reverse xs)


newLast2 :: [a]-> a
newLast2 xs = head(xx)
    where t = ((length xs) - 1)
          xx = drop(t) xs


newInit :: [a] -> [a]
newInit xs = reverse(drop 1 xx)
    where xx = (reverse xs)


newInit2 :: [a] -> [a]
newInit2 xs = take((length xs) - 1) xs


binom :: Integer -> Integer -> Integer
binom n k = product [1..n] `div` (product [1..k] * product [1..x])
    where x = n - k