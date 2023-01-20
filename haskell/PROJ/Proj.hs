module Proj where

{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

import Data.List.Split
import Data.Char
import Data.List 

{- Internal Representation of Monomial -}
data Term = Term Integer [String] [Integer] deriving(Show)

{-get the coeficient of a term-}
coeficiente :: Term -> Integer  
coeficiente (Term c _ _) = c

{-get a list of variables present in a term-}
var :: Term -> [String]  
var (Term _ c _) = c

{-get a list of expoents present in a term-}
expoent :: Term -> [Integer]  
expoent (Term _ _ c) = c

{-function sums the coeficient of 2 terms
should only be called when is known that 2 terms have the same variables and expoents-}
sumTerms :: Term -> Term -> Term
sumTerms a b = Term (num) (var a) (expoent a)
            where num  = coeficiente a + coeficiente b

{-removes white spaces while parsing a input of a polynomial -}
remWhite :: String -> String
remWhite [] = []
remWhite (x:xs) | x == ' ' = remWhite xs
                | otherwise = [x] ++ remWhite xs


{-returns a list of strings that contain in plain text the term given as input-}
parseInput :: String -> [String]
parseInput s = [x | x<- split (oneOf "+-") (remWhite s), x /= ""]

{-makes sure parsers is working-}
fixParser :: [String] -> [String]
fixParser [] = []
fixParser [a] = [a]
fixParser (x:y:xs) | x /= "+" && x/= "-" = x : fixParser (y:xs)
             | otherwise = (x ++ y) : fixParser xs

{-calls fuctions that will return a list of terms but as plain text ready to be interperted-}
fullParser :: String -> [String]
fullParser s = fixParser (parseInput s)

{-translates a given string to a list of terms-}
funcInput :: String -> [Term]
funcInput "" = []
funcInput s = map translateTerm (fullParser s)

{-translates a single string to the respective term-}
translateTerm :: String -> Term
translateTerm "" = Term 0 [] []
translateTerm y = Term (getCoe y) (sort (getVar y)) (fixIdx y)

{-translates the coeficient of a term as plain text to integer-}
getCoe :: String -> Integer
getCoe "" = 1
getCoe s = if a == "-" then -1
           else if a == "" then 1
           else read a :: Integer
            where a = parseNum s

{-saves the coeficient of a monomial as a string-}
parseNum :: String -> String
parseNum "" = ""
parseNum (x:xs) = if ord x >= 48 && ord x<= 57 || x == '-' then x : parseNum xs
                  else if x == '+' then parseNum xs
                  else parseNum ""

{-get the expoent of monomial-}
getEx :: String -> Integer
getEx "" = 1
getEx (x:xs) = if (x == '^') then getCoe xs
               else getEx xs

{-gets all variables represented in a string-}
getVar :: String -> [String]
getVar "" = []
getVar(x:xs) = if (ord x >= 65 && ord x<= 90) || (ord x >= 97 && ord x<= 122) then [x] : getVar xs
                   else getVar xs


{-get all the respective expoents of the given string as a list-}
getExpFull :: String -> [Integer]
getExpFull "" = []
getExpFull [x] = if (ord x >= 65 && ord x<= 90) || (ord x >= 97 && ord x<= 122) then [1] else getExpFull ""
getExpFull (x:y:xs) | (ord x >= 65 && ord x<= 90) || (ord x >= 97 && ord x<= 122) && (y /= '^' ) = [1] ++ getExpFull (y:xs)
            | (ord x >= 65 && ord x<= 90) || (ord x >= 97 && ord x<= 122) && y == '^' = [a] ++ getExpFull (xs)
            | otherwise = getExpFull (y : xs)
            where a = read (parseNum xs) :: Integer


{-get the terms that have the same variables & expoents and sums them-}
getSameExp :: Term -> [Term] -> Term
getSameExp a [] = a
getSameExp t l = if null lista then t
                else
                sumTerms (foldl1 (sumTerms) lista) t
                where lista = [x | x<-l, (var x == var t) && (expoent x == expoent t)]

{- gets the remaining list of monomials-}
getRestList :: Term -> [Term] -> [Term]
getRestList a [] = []
getRestList t l = [x | x<-l, (var x /= var t) || (expoent x /= expoent t)]

{-normalizes the input and returns it as a string-}
normalizeInput :: String -> String
normalizeInput a = funcOutput (normalize (funcInput a))

{-normalizes the input-}
normalize :: [Term] -> [Term]
normalize [] = []
normalize (x:xs) = getSameExp x xs : normalize(l)
                where l = getRestList x xs

{-outputs a string that represents the sum of 2 polynomials-}
addInput :: String -> String -> String
addInput a b = funcOutput (normalize (funcInput a ++ funcInput b))

{-returns the list of expoents-}
retExp :: [(String,Integer)] -> [Integer]
retExp [] = []
retExp (x:xs) = snd x : retExp xs

{-returns the list of variables-}
retVar :: [(String,Integer)] -> [String]
retVar [] = []
retVar (x:xs) = fst x : retVar xs

{-finds the index of a given variable in the variables list-}
fixIdx :: String -> [Integer]
fixIdx s = retExp (sort lista)
    where lista = zip (getVar s) (getExpFull s)

{-multiplicates 2 given polynomial-}
multiplication :: [Term] -> [Term] -> [Term]
multiplication [] a = []
multiplication a [] = []
multiplication x (y:ys) = normalize( multiTerm x y ++ multiplication x ys)

{-receives 2 polynomials and multiplies them-}
multiInput :: String -> String -> String
multiInput a b = funcOutput (multiplication (funcInput a) (funcInput b))

{-multiplicates a monomial with polinomial-}
multiTerm :: [Term] -> Term -> [Term]
multiTerm [] _ = []
multiTerm (x:xs) t = singleTerm x t : multiTerm xs t

{-multiplicates 2 single terms-}
singleTerm :: Term -> Term -> Term
singleTerm x y = Term (coeficiente x * coeficiente y) (retVar a) (retExp a)
                    where a = multiVar x y

{-returns the variable part of a multiplication of 2 terms-}
multiVar :: Term -> Term -> [(String,Integer)]
multiVar a b = sort (getMultiVar c)
               where c = zip (var a) (expoent a) ++ zip (var b) (expoent b)

{-returns the list of variables and the expoents multiplicated-}
getMultiVar :: [(String,Integer)] -> [(String,Integer)]
getMultiVar []=[]
getMultiVar (x:xs) = v : getMultiVar (takeVar x xs)
                    where v = sumExp x xs
{-removes the occorence of a variables in a list-}
takeVar :: (String,Integer) -> [(String,Integer)] -> [(String,Integer)] 
takeVar _ [] = []
takeVar a (x:xs) = if fst a == fst x
                   then takeVar a xs
                   else x : takeVar a  xs
{-sum the expoents-}
sumExp :: (String,Integer) -> [(String,Integer)] -> (String,Integer)
sumExp a [] = a
sumExp w (x:xs) = if fst w == fst x 
                  then sumExp (fst w,snd w + snd x) xs
                  else sumExp w xs


{- derive a term -}
deriveTermi :: Term -> String -> Term
deriveTermi x s | null (var x) = Term (0) [] []
                | elem s (var x) == False = Term (0) [] []
                | (expoent x)!!idx == 1 = Term (coeficiente x) (v) (l) 
                | otherwise = Term (coeficiente x * (expoent x!!idx)) (var x) (l)
                where idx = getIndexElem s (var x) 
                      l = [x | x<- take idx (expoent x) ++ [n] ++ drop (idx + 1) (expoent x), x /= 0]
                      n = ((expoent x)!!idx) - 1
                      v = take idx (var x) ++ drop (idx + 1) (var x)

{- derive a polynomial and returns it as a string -}
deriveInput :: String -> String -> String
deriveInput a b = funcOutput (derivePol (funcInput a) b)

{- derive a polynomial -}
derivePol :: [Term] -> String -> [Term]
derivePol [] s = []
derivePol (x:xs) s = normalize f
                  where f = deriveTermi x s : derivePol xs s

{- find index of a variable in a list of variables, doesn't work if it's not there -}
getIndexElem :: String -> [String] -> Int
getIndexElem e [] = 0
getIndexElem e (x:xs) | (x /= e) = 1 + getIndexElem e xs
                      | otherwise = getIndexElem e []

{-given a equation outputs it as a string-}
funcOutput :: [Term] -> String
funcOutput [] = ""
funcOutput (x:xs) = if coeficiente x > 0 then show (coeficiente x) ++ outVars (var x) (expoent x) ++ handleElements xs
                    else if coeficiente x == 1 && (null (var x)) then " + 1" ++  outVars (var x) (expoent x) ++ handleElements xs
                    else if coeficiente x == 1 then " + " ++ outVars (var x) (expoent x) ++ handleElements xs
                    else if coeficiente x == -1 && (null (var x)) then " - 1" ++  outVars (var x) (expoent x) ++ handleElements xs
                    else if coeficiente x == -1 then " - " ++ outVars (var x) (expoent x) ++ handleElements xs
                    else if coeficiente x == 0 then handleElements xs
                    else "-" ++ show (abs (coeficiente x)) ++ outVars (var x) (expoent x) ++ handleElements xs

{-return the terms as a string -}
handleElements  :: [Term] -> String
handleElements [] = ""
handleElements (x:xs) = if coeficiente x > 1 then " + " ++ show (coeficiente x) ++ outVars (var x) (expoent x) ++ handleElements xs
                        else if coeficiente x == 0 then handleElements xs
                        else if coeficiente x == 1 && (null (var x)) then " + 1" ++  outVars (var x) (expoent x) ++ handleElements xs
                        else if coeficiente x == 1 then " + " ++ outVars (var x) (expoent x) ++ handleElements xs
                        else if coeficiente x == -1 && (null (var x)) then " - 1" ++  outVars (var x) (expoent x) ++ handleElements xs
                        else if coeficiente x == -1 then " - " ++ outVars (var x) (expoent x) ++ handleElements xs
                        else " - " ++ show (abs (coeficiente x)) ++ outVars (var x) (expoent x) ++ handleElements xs

{-outputs a single variable-}
outVars :: [String] -> [Integer] -> String
outVars [] [] = ""
outVars (a:as) (b:bs) = if b /= 1 then a ++ "^" ++ show b ++ outVars as bs
                        else a++ outVars as bs

