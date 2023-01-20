import Data.List
--3.1
--[f x | x<-[xs],p x]

--3.2
dec2int :: [Int] -> Int
dec2int l = foldl (\x y -> 10*x + y) 0 l

--3.3
mzip :: (a -> b -> c) -> [a] -> [b] -> [c]
mzip f [] x = []
mzip f x [] = []
mzip f (x:xs) (y:ys) = f x y : mzip f xs ys

--3.4
misort :: Ord a => [a] -> [a]
misort x = foldr insert [] x

--3.5 (mm coisa para o foldr)
mini :: Ord a => [a] -> a
mini l = foldl1 (\x y -> if x<y then x else y) l

maxi :: Ord a => [a] -> a
maxi l = foldl1 (\x y -> if x<y then y else x) l

--3.5b
mfoldr:: (a -> a -> a)  -> [a] -> a
mfoldr f xs = foldr f (last xs) (init xs) 

mfoldl1 :: (a -> a -> a)  -> [a] -> a
mfoldl1 f xs = foldl f (head xs) (tail xs)

--3.7a
cc :: [a] -> [a] -> [a]
cc x y = foldr (:) y x

ccat :: [[a]] -> [a]
ccat x = foldr (++) [] x

rev :: [a] -> [a]
rev l = foldr (\x y -> y ++ [x]) [] l

rev2 :: [a] -> [a]
rev2 l = foldl (\x y -> [y] ++ x) [] l

melem :: Eq a => a -> [a] -> Bool
melem n l = any (==n) l

--3.8a
palavras :: String -> [String]
palavras [] = []
palavras s = [x | x <- p] : palavras nxt
           where p = takeWhile (/= ' ') s
                 nxt = drop 1 (dropWhile (/= ' ') s)

--3.9
ms :: (b -> a -> b) -> b -> [a] -> [b]
ms f z [] = [z]
ms f z (x:xs) = z : ms f tmp xs
                   where tmp = f z x