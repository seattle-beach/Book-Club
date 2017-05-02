data Tree a = EmptyTree | Node a (Tree a) (Tree a)

instance Functor Tree where
   fmap f EmptyTree = EmptyTree
   fmap f (Node value left right) = Node (f value) (fmap f left) (fmap f right)

instance (Show a) => Show (Tree a) where
   show t = showSubtree t ""

showSubtree :: (Show a) => Tree a -> String -> String
showSubtree EmptyTree _ = ""
showSubtree (Node value left right) prefix = (showSubtree left nextPrefix) ++
   prefix ++ (show value) ++ "\n" ++
   (showSubtree right nextPrefix)
   where nextPrefix = prefix ++ "   "

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
   | x == a = Node x left right
   | x < a = Node a (treeInsert x left) right
   | x > a = Node a left (treeInsert x right)

toTree :: (Ord a) => [a] -> Tree a
toTree l = foldr treeInsert EmptyTree l


tryIt = do
   let t = toTree [8, 6, 4, 1, 7, 3, 5]
   fmap show t
