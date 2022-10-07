import Data.List
import Data.Char 

--2.1a
myand :: [Bool] -> Bool
myand [] = True
myand(x:xs) = x && myand xs

--2.1b
myor :: [Bool] -> Bool
myor [] = False
myor(x:xs) = x && myor xs

--2.1c
myconcat :: [[a]] -> [a]
myconcat [] = []
myconcat(x:xs) = x ++ myconcat xs

--2.1d
myreplicate :: Int -> a -> [a]
myreplicate 0 a = []
myreplicate b a = [a] ++ myreplicate (b-1) a

--2.1e
myidx :: [a] -> Int -> a
myidx (x:xs) 0 = x
myidx (x:xs) n = myidx(xs) (n-1)

--2.1f
myele :: Eq a => a -> [a] -> Bool
myele a [] = False
myele e (x:xs) = (x == e) || myele e (xs) 

--2.2
myint :: a -> [a] -> [a]
myint a [] = []
myint a (x:xs) | (not (null xs)) = [x] ++ [a] ++ myint a xs
               | otherwise = [x]

--2.3
mdc :: Integer -> Integer -> Integer
mdc a b =
    if (b == 0) then a
    else mdc b (mod a b)

--2.4a
insert2 :: Ord a => a -> [a] -> [a]
insert2 x [] = [x]
insert2 n (x:xs) | n < x = [n] ++ [x] ++ xs
                | otherwise = [x] ++ insert2 n xs

--2.4b
isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)

--2.5a
mini :: Ord a => [a] -> a
mini [x] = x
mini (x:xs) = if (x < mini xs) then x
              else mini xs

--2.5b
del :: Eq a => a -> [a] -> [a]
del n [] = []
del n (x:xs) | x == n = xs
             | otherwise = x : del n xs

--2.5c
ssort :: Ord a => [a] -> [a] 
ssort [] = []
ssort a = mini a : ssort (del (mini a) a)

--2.6
-- sum([x^2 | x<-[1..100]])
-- sum(map (^2) [1..100])


--2.7a
aproxi :: Int -> Double
aproxi n = 4 * sum([(-1)^k /  fromIntegral (2*k + 1) | k<-[0..n]]) -- why fromIntegral?

--2.7b
aproxii :: Int -> Double
aproxii n = sqrt(12 * sum( [(-1)^k / fromIntegral(k + 1)^2 | k<-[0..n]]))

--2.8
dotprod :: [Float] -> [Float] -> Float
dotprod a b = sum[x * y | (x,y) <- zip a b]
--dotprod [] [] = 0
--dotprod (x:xs) (y:ys) = x * y + dotprod xs ys

--2.9
divprop :: Integer -> [Integer]
divprop n = [x | x<-[1..n-1], n `mod` x == 0]
--divprop n = filter (\x -> n `mod` x == 0) [1..n-1]

--2.10
perfeitos :: Integer -> [Integer]
--perfeitos n = [x | x<-[1..n], (sum (divprop x) == x)]
perfeitos n = filter (\x -> sum(divprop x) == x) [1..n]

--2.11
pitagoricos :: Integer -> [(Integer,Integer,Integer)]
pitagoricos n = [(x,y,z) | x<-[1..n], y<-[1..n],z<-[1..n], x^2+y^2==z^2]

--2.12
primo :: Integer -> Bool
primo a | elem 1 (divprop a) && length (divprop a) == 1 = True
        | otherwise = False

--2.13 
mersennes :: [Int]
mersennes = [2^x - 1| x<-[1..30], primo (2^x - 1)]

--2.14
binom :: Integer -> Integer -> Integer
binom n k = product [1..n] `div` (product [1..k] * product [1..x])
    where x = n - k

pascal :: Integer -> [[Integer]]
pascal n = [[binom x y | y <- [0 .. x]] | x <- [0..n]]

--extra
permut :: [Integer] -> [[Integer]]
permut [] = [[]]
permut xs = [x:l | x <- xs, l <- permut(xs \\ [x])]

--2.15
nxtLetra :: Int -> Char -> Char
nxtLetra k a | a == ' ' = ' '
             | ord a + k > 122 = chr (ord 'a' + (tmp - 123))
             | otherwise = chr (tmp)
             where tmp = ord a + k



cifrar :: Int -> String -> String
cifrar k "" = ""
cifrar k (x:xs) = (nxtLetra k x) : (cifrar k xs)
--cifrar k xs = [nxtLetra k x | x<-xs]

--2.16
lconcat :: [[a]] -> [a]
lconcat l = [x | sublist <- l, x <- sublist]

lrepli :: Int -> a -> [a]
lrepli n val = [val | _<-[1..n]]

lidx :: [a] -> Int -> [a]
lidx xs n = [x | (x,y) <- zip xs [0..n],y==n]

--2.18
mindiv :: Int -> Int
mindiv n | null ([x | x<-[2..tmp], mod n x == 0]) = n
         | otherwise = head [x | x<-[2..tmp], mod n x == 0]
         where tmp = round (sqrt (fromIntegral n))
          
qprimes :: Int -> Bool
qprimes n = (n > 1) && (mindiv n == n)

--2.19
nub2 :: Eq a => [a] -> [a]
nub2 []  = []
nub2 (x:xs) = x: nub2 [y | y<-xs ,y /=x] 

--2.21
algRev :: Int -> [Int]
algRev n = [read [x] | x <-(show n)]

algrT :: Int -> [Int] -- vem ao contrario
algrT n = if (n < 10) then [n]
         else [(mod n 10)] ++ algrT(div n 10)

algr :: Int -> [Int]
algr n = reverse (algrT n)