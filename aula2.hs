-- 2.1a
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}

myand :: [Bool] -> Bool
myand [] = True
myand (x:xs) = x && myand xs 

-- 2.1b 

myor :: [Bool] -> Bool
myor [] = False
myor (x:xs) = x || myor xs

-- 2.1c

myconcat :: [[a]] -> [a]
myconcat [] = []
myconcat (x:xs) = x ++ myconcat xs


-- 2.1d
myreplicate :: Int -> a -> [a]
myreplicate 0 a = []
myreplicate n x = [x] ++ myreplicate(n-1) x


-- 2.1e
mye :: [a] -> Int -> a
mye [] a = error "erro"
mye(x:xs) 0 = x
mye(x:xs) a = mye(xs) (a-1)


-- 2.1f
myelem :: Eq a => a -> [a] -> Bool
myelem a [] = False
myelem a (x:xs) = a == x || myelem a (xs) 

-- 2.2
myinter :: a -> [a] -> [a]
myinter a [] = []
myinter a (x:xs) | length xs == 0 = [x]
                 | otherwise = [x] ++ [a] ++ myinter a xs


-- 2.3
mdc :: Int -> Int -> Int
mdc a b | b == 0 = a
        | otherwise = mdc b (a `mod` b)

-- 2.4a
myins :: Ord a => a -> [a] -> [a]
myins a [] = [a]
myins a (x:xs) | a < x = a : x : xs
               | otherwise = x: myins a (xs)


myisort :: Ord a => [a] -> [a]
myisort [] = []
myisort (x:xs) = myins x (myisort xs)

--2.6
mysum :: [Int] -> Int
mysum a = sum(map (^2) a)