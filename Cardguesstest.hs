--  File     : Cardguesstest.hs
--  Author   : Peter Schachte
--  Purpose  : Test program for cardguess project

module Main (main) where

import Data.List
import Card
import Cardguess
import Response
import System.Exit
import System.Environment

type Selection = [Card]
type Feedback = (Int, Int, Int, Int, Int)


-- | Main program for use inside ghci.  Do something like
--
--     guessTest "4C 9D"
--
--   to use initialGuess and nextGuess to guess the answer 4C, 9D.

guessTest :: String -> IO ()
guessTest answerString = do
    let answer = map read $ words answerString
    if validSelection answer then do
        let (guess,other) = initialGuess $ length answer
        loop answer guess other 1
    else do
      putStrLn "Invalid answer:  input must be a string of one or more"
      putStrLn "distinct cards separated by whitespace, where each card"
      putStrLn "is a single character rank 2-9, T, J, Q, K or A, followed"
      putStrLn "by a single character suit C, D, H, or S."
    


-- | Main program.  Gets the answer from the command line (as separate
--   command line arguments, each a rank character (2-9, T, J, Q, K or
--   A) followed by a suit letter (C, D, H, or S).  Runs the user's
--   initialGuess and nextGuess functions repeatedly until they guess
--   correctly.  Counts guesses, and prints a bit of running
--   commentary as it goes.

main :: IO ()
main = do
  args <- getArgs
  let answer = map read args
  if validSelection answer then do
      let (guess,other) = initialGuess $ length answer
      loop answer guess other 1
    else do
      putStrLn "Usage:  Cardguesstest c1 ... cn"
      putStrLn "   where c1 ... cn are different cards between 2C and AS"
      exitFailure


-- | The guessing loop.  Repeatedly call nextGuess until the correct answer 
--   is guessed.

loop :: Selection -> Selection -> GameState -> Int -> IO ()
loop answer guess other guesses = do
    putStrLn $ "Your guess " ++ show guesses ++ ":  " ++ show guess
    if validSelection guess && length answer == length guess then do
        let result = response answer guess
        putStrLn $ "My answer:  " ++ show result
        if successful guess result then do
            putStrLn $ "You got it in " ++ show guesses ++ " guesses!"
            putStrLn $ "Approximate quality = " 
              ++ show (100 * (qualityFraction $ fromIntegral guesses))
              ++ "%"
          else do
            let (guess',other') = nextGuess (guess,other) result
            loop answer guess' other' (guesses+1)
      else do
        putStrLn "Invalid guess"
        exitFailure

-- | Compute the proportion of possible marks that should be awarded for 
--   quality given the average number of guesses needed to guess the
--   right answer.  The number will always be between 0 and 1 inclusive.
--   The scheme is that an average of 4 guesses per answer should score
--   100%, and for every doubling of the number of guesses, 1/8th of the
--   marks are lost, so 8 doublings = 1024 guesses scores 0 for quality.

qualityFraction :: Double -> Double
qualityFraction guesses =
    min 1 $ max 0 $ 1.25 - log guesses / (4 * log 4)


-- | Returns whether or not the feedback indicates the guess was correct.

successful :: Selection -> Feedback -> Bool
successful sel (right,_,_,_,_) = right == length sel


-- | Returns whether or not a guess or answer is valid, ie, has no repeats.

validSelection sel = sel == nub sel && length sel > 0
