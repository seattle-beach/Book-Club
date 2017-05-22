module Set
  ( Set(..)
  , isEmpty
  ) where

--data Set = A | Nothing deriving (Show)
data Set = Set deriving (Show)

--items :: a -> Contents
--items a = Contents a

isEmpty :: Set -> [a] -> Bool
isEmpty _ [] = True
isEmpty _ _ = False
