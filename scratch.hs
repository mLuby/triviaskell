import Data.Char (digitToInt)

questions = ["Who has been nominated for the most Oscars?", "What's the closest planet to the Sun?"]

getIndex :: Int -> [a] -> a
getIndex index list = last $ take (index + 1) list

paramToInt :: a -> Int
paramToInt x = read x :: Int
