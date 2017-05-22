module Set
  ( Set(..)
  , isEmpty
  , size
  ) where

data Set = Set deriving (Show)

size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + (size xs)

isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty _ = False
