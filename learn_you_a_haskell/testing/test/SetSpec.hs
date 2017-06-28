module SetSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Text.Printf (printf)

import Set

main :: IO ()
main = hspec spec

spec :: Spec
spec =
  describe "Set" $ do
    describe "isEmpty" $ do
      it "should report True for empty set" $ do
        isEmpty [] `shouldBe` True
      it "should report False for other sets" $ do
        isEmpty [1] `shouldBe` False
        isEmpty ["a", "b", "c"] `shouldBe` False
    describe "size" $ do
      it "should return 0 for the empty set" $ do
        size [] `shouldBe` 0
      it "should return 1 for a set with one element" $ do
        size [1] `shouldBe` 1
      it "should be >1 for a set with many elements" $ do
        size ["a","b","c"] `shouldSatisfy` (> 1)
    describe "contains" $ do
      it "should return True" $ do
        contains [1] 1 `shouldBe` True
        contains ["a","b","c"] "b" `shouldBe` True
      it "should return False" $ do
        contains [] 4 `shouldBe` False
        contains [2] 1 `shouldBe` False
        contains ["a","b","c"] "d" `shouldBe` False
    describe "remove" $ do
      it "should remove item" $ do
        remove [1] 1 `shouldBe` []
        remove [1,2,3,4] 2 `shouldBe` [1,3,4]
      it "should fail silently when removing nonesistant item" $ do
        remove [1,2,3,4] 5 `shouldBe` [1,2,3,4]
