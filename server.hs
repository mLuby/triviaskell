{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Monoid (mconcat)
import Data.Text.Lazy (toStrict)
--import Data.Char (digitToInt)

--paramToInt :: a -> Int
--paramToInt x = digitToInt $ head $ show x
paramToInt x = read (show (toStrict x)) :: Int

getIndex :: Int -> [a] -> a
getIndex index list = last $ take (index + 1) list

questions = ["Who has been nominated for the most Oscars?","What's the closest planet to the Sun?"]

main = scotty 3000 $ do
  get "/:questionId" $ do
    questionId <- param "questionId"
    let index = paramToInt questionId
    let question = getIndex index questions
    html $ mconcat ["<h1>Question ", questionId, ": ", question ,"</h1>"]
