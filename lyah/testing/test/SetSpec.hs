module SetSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Text.Printf (printf)

import Set

main :: IO ()
main = hspec spec

spec :: Spec
spec =
  describe "isEmpty" $ do
    it "should report True for empty set" $ do
      isEmpty Set [] `shouldBe` True
    it "should report False for other sets" $ do
      isEmpty Set [1] `shouldBe` False
      isEmpty Set ["a", "b", "c"] `shouldBe` False
