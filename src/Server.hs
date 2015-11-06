{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Server (run) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Logger (runStderrLoggingT, LoggingT)
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Database.Persist.MySQL (defaultConnectInfo, runMigration, runSqlConn, withMySQLConn, SqlPersistT)
import Database.Persist.TH (mkMigrate, mkPersist, persistLowerCase, share, sqlSettings)
import Data.Text.Lazy (pack, unpack, Text)
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import System.Random (randomRIO)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Web.Scotty

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    firstName String
    lastName String
    age Int
    deriving Show
|]

runDb :: SqlPersistT (ResourceT (LoggingT IO)) a -> IO a
runDb query = runStderrLoggingT . runResourceT . withMySQLConn defaultConnectInfo . runSqlConn $ query

{-readPosts :: IO [Entity Post]-}
{-readPosts = (runDb $ selectList [] [LimitTo 10])-}

{-blaze = S.html . renderHtml-}

data Question = Question { questionId :: Int, questionText :: String } deriving (Show, Generic)
instance ToJSON Question
instance FromJSON Question

allQuestions :: [Question]
allQuestions =  [ Question { questionId = 1, questionText = "What time is it?"}
                , Question { questionId = 2, questionText = "Where are we?"}
                , Question { questionId = 3, questionText = "Who are you?"}]

matchesId :: Int -> Question -> Bool
matchesId id question = questionId question == id

getQuestionText :: Int -> String
getQuestionText id = questionText . head $ filter (\q -> questionId q == id) allQuestions

run = do
  putStrLn "Running migrations..."
  runDb $ runMigration migrateAll
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
      json (filter (matchesId id) allQuestions)

    {-S.get "/create/:title" $ do-}
      {-_title <- S.param "title"-}
      {-now <- liftIO getCurrentTime-}
      {-liftIO $ runDb $ insert $ Post _title "some content" now-}
      {-S.redirect "/"-}

    {-S.get "/" $ do-}
      {-_posts <- liftIO readPosts-}
      {-let posts = map (postTitle . entityVal) _posts-}
      {-blaze $ do-}
        {-ul $ do-}
          {-forM_ posts $ \post -> li (toHtml post)-}
