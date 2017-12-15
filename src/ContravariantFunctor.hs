{-# LANGUAGE UnicodeSyntax #-}

module ContravariantFunctor where

import Control.Applicative
import Data.Functor.Contravariant (Contravariant (..))

-- show
newtype Predicate a = Predicate { getPredicate :: a -> Bool }

instance Contravariant Predicate where
    contramap g (Predicate p) = Predicate (p . g)

veryOdd :: Predicate Integer
veryOdd = contramap (`div` 2) (Predicate odd)

otherFunc :: IO ()
otherFunc = print $ getPredicate veryOdd <$> [0 .. 11]
-- /show

