{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Server (run) where

import GHC.Generics
import Web.Scotty
import Data.Text.Lazy (pack, Text, unpack)
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)
import Control.Monad.IO.Class (liftIO)
import System.Random (randomRIO)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)

data Question = Question { questionId :: Int, questionText :: String } deriving (Show, Generic)
instance ToJSON Question
instance FromJSON Question

allQuestions :: [Question] -- as map
allQuestions =  [ Question { questionId = 1, questionText = "What time is it?"}
                , Question { questionId = 2, questionText = "Where are we?"}
                , Question { questionId = 3, questionText = "Who are you?"}]

matchesId :: Int -> Question -> Bool
matchesId id question = questionId question == id

getQuestionText :: Int -> String
getQuestionText id = questionText . head $ filter (\q -> questionId q == id) allQuestions

run = do
  putStrLn "Starting Server..."
  scotty 3000 $ do
    middleware logStdoutDev
    get "/" $ do
      text ("hello world")

    get "/questions" $ do
      json allQuestions

    get "/questions/random" $ do
      id <- liftIO $ randomRIO (1 :: Int, 2 :: Int)
      let theQuestionText = getQuestionText id
      text . pack $ "Riddle me this: " ++ theQuestionText

    get "/questions/:id" $ do
      id <- param "id"
      let theQuestionText = getQuestionText id
      text ("Riddle me this: " <> pack theQuestionText)
      --json (filter (matchesId id) allQuestions)
