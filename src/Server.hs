{-# LANGUAGE OverloadedStrings #-}

module Server (run) where

import Data.Monoid (mconcat)
import Data.Text.Lazy (unpack)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Web.Scotty

run :: IO ()
run = do
  scotty 3000 $ do
    middleware logStdoutDev
    routes

routes :: ScottyM()
routes = do
  get "/" $ text "hello world"

  get "/:questionId" $ do
    questionId <- param "questionId"
    let index = paramToInt questionId
    let question = questions !! index
    display ["<h1>Question ", questionId, ": ", question ,"</h1>"]

paramToInt x = read (unpack x) :: Int

questions = ["Who has been nominated for the most Oscars?","What's the closest planet to the Sun?"]

display array = html $ mconcat array
