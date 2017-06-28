module Set
  ( Set(..)
  , isEmpty
  , size
  , contains
  , remove
  ) where

data Set = Set deriving (Show)

remove :: (Eq a) => [a] -> a -> [a]
remove [] _ = []
remove (x:xs) y
  | x == y = xs
  | otherwise = x:(remove xs y)

contains :: (Eq a) => [a] -> a -> Bool
contains [] _ = False
contains (x:xs) y
  | x == y = True
  | otherwise = contains xs y

size :: [a] -> Int
size [] = 0
size (_:xs) = 1 + (size xs)

isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty _ = False
