-- data Tree a = EmptyTree | Node a (Tree a) (Tree a)
data TreeNode a = TreeNode a (Tree a) (Tree a)
data Tree a = EmptyTree | Node (TreeNode a)

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

root :: Tree a -> a
root EmptyTree = error "Can't get the root of an empty tree"
root (Node x _ _) = x


balance :: Tree a -> Tree a
balance EmptyTree = EmptyTree
-- TODO: Can we do this without unpacking and reassembling the node?
balance (Node x left right)
   | abs (lheight - rheight) <= 1 = Node x left right
   | lheight < rheight = balance (rotateLeft (Node x (balance left)  (balance right)))
   | otherwise = balance (rotateRight (Node x (balance left)  (balance right)))
   where lheight = height left
         rheight = height right

-- TODO: Can we write a type signature that only allows Nodes?
rotateRight :: Tree a -> Tree a
rotateRight EmptyTree = error "Can't right rotate an empty tree"
rotateRight (Node _ EmptyTree _) = error "Can't right rotate a tree with an empty left subtree"
rotateRight (Node x (Node y ll lr) right) = Node y ll n
   where n = Node x lr right

rotateLeft :: Tree a -> Tree a
rotateLeft EmptyTree = error "Can't left rotate an empty tree"
rotateLeft (Node _ _ EmptyTree) = error "Can't left rotate a tree with an empty right subtree"
rotateLeft (Node x left (Node y rl rr)) = Node y n rl
   where n = Node x left rr


tryIt = do
   let t = toTree [1, 3, 4, 5, 6, 7, 8]
   balance t
