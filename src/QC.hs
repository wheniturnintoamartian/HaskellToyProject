{-# LANGUAGE FlexibleInstances #-}

module QC where

import Test.QuickCheck (oneof, Gen, elements, listOf, generate)
import Control.Monad (liftM, liftM2)

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