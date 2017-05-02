data Wrapper a = Wrapper a

instance (Show a) => Show (Wrapper a) where
   show (Wrapper v) = "Wrapper around " ++ (show v)
