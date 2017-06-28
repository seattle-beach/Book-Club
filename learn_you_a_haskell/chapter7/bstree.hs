data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
   | x == a = Node x left right
   | x < a = Node a (treeInsert x left) right
   | x > a = Node a left (treeInsert x right)

height :: Tree a -> Int
height EmptyTree = 0
height (Node _ left right) = 1 + max (height left) (height right)

isBalanced :: Tree a -> Bool
isBalanced EmptyTree = True
isBalanced (Node _ left right) = abs(lheight - rheight) <= 1 &&
      isBalanced left && isBalanced right
   where lheight = (height left)
         rheight = (height right)

toTree :: (Ord a) => [a] -> Tree a
toTree l = foldr treeInsert EmptyTree l

tryIt = do
   let t = toTree [8, 6, 4, 1, 7, 3, 5]
   let t2 = toTree [1, 3, 4, 5, 6, 7, 8]
   "The height of (" ++ (show t) ++ ") is " ++ (show (height t)) ++ ". " ++
      "The height of (" ++ (show t2) ++ ") is " ++ (show (height t2))
