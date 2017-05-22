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
