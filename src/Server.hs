{-# LANGUAGE OverloadedStrings #-}

module Server (run) where

import Control.Monad.IO.Class (liftIO)
import Data.Text.Lazy (pack, Text, unpack)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import System.Random (getStdGen, randomRIO)
import Web.Scotty

run :: IO ()
run = do
  scotty 3000 $ do
    middleware logStdoutDev
    routes

routes :: ScottyM ()
routes = do
  get "/" $ text "hello world"

  get "/:questionId" $ do
    questionId <- param "questionId"
    let index = paramToInt questionId
    let question = questions !! index
    display ["<h1>Question ", questionId, ": ", question ,"</h1>"]

  get "/random" $ do
    index <- liftIO $ randomRIO (0 :: Int, 1 :: Int)
    let question = questions !! index
    let questionId = pack $ show index
    display ["<h1> Question ", questionId, ": ", question, "</h1>"]

paramToInt :: Text -> Int
paramToInt x = read (unpack x) :: Int

questions :: [Text]
questions = ["Who has been nominated for the most Oscars?","What's the closest planet to the Sun?"]

display :: [Text] -> ActionM ()
display array = html $ mconcat array
