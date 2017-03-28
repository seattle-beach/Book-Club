addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

addTwo :: Int -> Int -> Int
addTwo x y = x + y

addThreeCurried :: (Int -> Int -> Int) -> Int -> (Int -> Int)
addThreeCurried f x = f x
