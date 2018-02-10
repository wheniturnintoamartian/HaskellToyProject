{-# LANGUAGE FlexibleInstances #-}

module QC where

import Test.QuickCheck (oneof, Gen, elements, listOf, generate, verboseCheck, quickCheck)
import Control.Monad (liftM, liftM2)
import Data.List (intersperse)

class Arbitrary a where
    arbitrary :: Gen a

instance Arbitrary Char where
    arbitrary = elements (['A'..'Z'] ++ ['a'..'z'] ++ " ~!@#$%^&*()")

instance Arbitrary String where
    arbitrary = listOf (arbitrary :: Gen Char)

-- instance Arbitrary Doc where
--     arbitrary = do 
--         n <- choose (1, 6) :: Gen Int
--         case n of 
--             1 -> return Empty
--             2 -> do x <- arbitrary
--                     return (Char x)
--             3 -> do x <- arbitrary
--                     return (Text x)
--             4 -> return Line
--             5 -> do x <- arbitrary
--                     y <- arbitrary
--                     return (Concat x y)
--             6 -> do x <- arbitrary
--                     y <- arbitrary
--                     return (Union x y)

data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
           deriving (Show, Eq)

instance Arbitrary Doc where
    arbitrary = oneof [ return Empty
                      , liftM Char arbitrary
                      , liftM Text arbitrary
                      , return Line
                      , liftM2 Concat arbitrary arbitrary
                      , liftM2 Union arbitrary arbitrary ]

instance Arbitrary [Doc] where
    arbitrary = listOf (arbitrary :: Gen Doc)

empty :: Doc
empty = Empty

(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y     = x `Concat` y

char :: Char -> Doc
char = Char

text :: String -> Doc
text "" = Empty
text s  = Text s

line :: Doc
line = Line

prop_empty_id :: Doc -> Bool
prop_empty_id x = empty <> x == x && x <> empty == x

prop_char :: Char -> Bool
prop_char c = char c == Char c

prop_text :: String -> Bool
prop_text s = text s == if null s then Empty else Text s

prop_line :: Bool
prop_line = line == Line

double :: Double -> Doc
double n = text (show n)

prop_double :: Double -> Bool
prop_double d = double d == text (show d)

fold :: (Doc -> Doc -> Doc) -> [Doc] -> Doc
fold f = foldr f empty

hcat :: [Doc] -> Doc
hcat = fold (<>)

prop_hcat :: [Doc] -> Bool
prop_hcat xs = hcat xs == glue xs
    where glue []     = empty
          glue (d:ds) = d <> glue ds

punctuate :: Doc -> [Doc] -> [Doc]
punctuate p []     = []
punctuate p [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

prop_punctuate :: Doc -> [Doc] -> Bool
prop_punctuate s xs = punctuate s xs == intersperse s xs

prop_punctuate' s xs = punctuate s xs == combine (intersperse s xs)
    where combine []           = []
          combine [x]          = [x]
          combine (x:Empty:ys) = x : combine ys
          combine (Empty:y:ys) = y : combine ys
          combine (x:y:ys)     = x `Concat` y : combine ys