{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use splitAt" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Use last" #-}


-- 1.1
testaTriangulo :: Float -> Float -> Float -> Bool
testaTriangulo a b c = a < b + c && b < a +c && c < a +b

-- 1.2
areaTriangulo :: Float -> Float -> Float -> Float
areaTriangulo a b c = sqrt(s*(s-a)*(s-b)*(s-c))
    where s = (a+b+c) / 2

-- 1.3
metades :: [a]->([a],[a])
metades xs = (take tmp xs, drop tmp xs)
    where tmp = ((length xs) `div` 2)

-- 1.4a
newLast :: [a]-> a
newLast xs = head(reverse xs)

-- 1.4a
newLast2 :: [a]-> a
newLast2 xs = head(xx)
    where t = ((length xs) - 1)
          xx = drop(t) xs

-- 1.4b
newInit :: [a] -> [a]
newInit xs = reverse(drop 1 xx)
    where xx = (reverse xs)

-- 1.4b
newInit2 :: [a] -> [a]
newInit2 xs = take((length xs) - 1) xs

-- 1.5a
binom :: Integer -> Integer -> Integer
binom n k = product [1..n] `div` (product [1..k] * product [1..x])
    where x = n - k

-- 1.6

raizes :: Float -> Float -> Float -> (Float, Float)
raizes a b c | x < 0 = error "no real square roots"
             | x > 0 = ((-b + sqrt(x)) / (2*a),(-b - sqrt(x)) / (2*a))
             | otherwise = (-b / (2*a),-b / (2*a))
    where x = b*b - 4*a*c


-- 1.9
classifica :: Int -> String
classifica a | a <= 9 = "reprovado"
             | a >= 10 && a <= 12 = "suficiente"
             | a >= 13 && a <= 15 = "bom"
             | a >= 16 && a <= 18 = "muito bom"
             | a >= 19 && a <= 20 = "muito bom com distinção"
             | otherwise = "error"

-- 1.10
classificap :: Float -> Float -> String
classificap a b = 
    if x < 18.5 then "baixo peso"
    else if (x >= 18.5 && x < 25) then "peso normal"
    else if (x >= 25 && x < 30) then "excesso de peso"
    else if (x >= 30) then "obesidade"
    else "error"
    where x = a / (b*b)


-- 1.11a
max3 :: Ord a => a -> a -> a -> a
max3 a b c =
    if(a > b && a > c) then a
    else if(b > a && b > c) then b
    else c

min3 :: Ord a => a -> a -> a -> a
min3 a b c =
    if(a < b && a < c) then a
    else if(b < a && b < c) then b
    else c

-- 1.11b
max3b :: Ord a => a -> a -> a -> a
max3b a b c = max a (max b c)

min3b :: Ord a => a -> a -> a -> a
min3b a b c = min a (min b c)


-- 1.12
myxor :: Bool -> Bool -> Bool
myxor True False = True
myxor False True = True
myxor _ _ = False

myxor2 :: Bool -> Bool -> Bool
myxor2 a b =
    if(a == True && b == False) then True
    else if(a == False && b == True) then True
    else False

myxor3 :: Bool -> Bool -> Bool
myxor3 a b | (a == True && b == False) = True
           | (a == False && b == True) = True
           | otherwise = False

-- 1.13
safetail :: [a] -> [a]
safetail a | (length a == 0) = [] -- ou null a 
           | otherwise = tail a

safetail2 :: [a] -> [a]
safetail2 a = 
    if null a then []
    else tail a


safetail3 :: [a] -> [a]
safetail3 [] = []
safetail3 a = tail a


-- 1.14a
curta :: [a] -> Bool 
curta a | (length a == 0 || length a == 1 || length a == 2) = True
        | otherwise = False

-- 1.14b
curta2 :: [a] -> Bool 
curta2 [] = True
curta2 [_] = True
curta2 [_,_] = True
curta2 (_:_:_) = False


-- 1.15a
mediana :: Float -> Float -> Float -> Float
mediana a b c | ((a < b && b < c) || (c < b && b < a)) = b 
              | ((b < a && a < c) || (c < a && a < b)) = a 
              | otherwise = c

-- 1.15b
mediana2 :: Float -> Float -> Float -> Float
mediana2 a b c = x - (max a (max b c)) - (min a (min b c))
    where x = a+b+c