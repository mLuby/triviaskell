{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Server where

import GHC.Generics
import Web.Scotty
import Data.Text.Lazy (pack, Text, unpack)
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)

data Question = Question { questionId :: Int, questionText :: String } deriving (Show, Generic)
instance ToJSON Question
instance FromJSON Question

secondManOnTheMoon :: Question
secondManOnTheMoon = Question { questionId = 1, questionText = "Who was the second man on the moon?" }

closestPlanetToTheSun :: Question
closestPlanetToTheSun = Question { questionId = 2, questionText = "What is the closest planet to the Sun?" }

allQuestions :: [Question]
allQuestions =  [ Question { questionId = 1, questionText = "What time is it?"}
                , Question { questionId = 2, questionText = "Where are we?"}
                , Question { questionId = 3, questionText = "Who are you?"}]

matchesId :: Int -> Question -> Bool
matchesId id question = questionId question == id

getQuestionText :: Int -> [Char]
getQuestionText id = questionText (head (filter (matchesId id) allQuestions))

run = do
  putStrLn "Starting Server..."
  scotty 3000 $ do
    --get "/hello/:name" $ do
    --    name <- param "name"
    --    text ("hello " <> name <> "!")

    get "/questions" $ do
      json allQuestions

    get "/questions/:id" $ do
      id <- param "id"
      let theQuestionText = getQuestionText id
      text ("Riddle me this: " <> pack theQuestionText)
      --json (filter (matchesId id) allQuestions)
