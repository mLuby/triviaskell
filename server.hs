{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Data.Monoid (mconcat)
import Data.Text.Lazy (unpack)

paramToInt x = read (unpack x) :: Int

questions = ["Who has been nominated for the most Oscars?","What's the closest planet to the Sun?"]

display array = html $ mconcat array

main = scotty 3000 $ do
  get "/:questionId" $ do
    questionId <- param "questionId"
    let index = paramToInt questionId
    let question = questions !! index
    display ["<h1>Question ", questionId, ": ", question ,"</h1>"]
