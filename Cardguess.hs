-- TODO: Finish the initial guess function

module Cardguess (initialGuess, nextGuess, GameState) where

import Card
import Debug.Trace

data GameState = GameState { 
	correct :: [Card],
	high :: Rank,
	low :: Rank,
	suspect :: Maybe Card,
	guessLen :: Int,
	turn :: Int
}
							 
instance Show GameState where
    show (GameState a b c d e f) = 
 		"\nCorrect: " ++ (show a) ++
    	"\nHigh: " ++ (show b) ++ ", Low: " ++ (show c) ++
    	"\nSuspect: " ++ (show d) ++
    	"\nLength: " ++ (show e) ++ " cards long\n"
	
							 
initialGuess :: Int -> ([Card],GameState)
initialGuess x
	| x < 1 = trace ("WARN> initialGuess called less than 1 ("++show x++")") (initialGuess 1)
	| x > 2 = trace ("WARN> initialGuess called more than 2 ("++show x++")") (initialGuess 2)
	| otherwise = 
		let gs = GameState { 
			correct = [],
			high = Ace,
			low = R2,
			suspect = Nothing, 
			guessLen = x,
			turn = 0
			} in trace "NOTE> Success on initialGuess" (sample x, gs)


-- nextGuess = 0
nextGuess :: ([Card],GameState) -> (Int,Int,Int,Int,Int) -> ([Card],GameState)

nextGuess (pGuess,gs) (fb_correct, fb_lower, fb_equal, fb_higher, fb_suits) = 
	([Card s1 r1, Card s2 r2], GameState cor hi lo sus len tur)
	where
		-- Grab len, and switch turn if needed
		len = guessLen gs
		tur 
			| fb_lower == 0 && fb_equal == 1 && fb_higher == 0 = switchT (turn gs)
			| otherwise = turn gs
		
		-- Following are not used for 2 cards
		cor = []
		hi = R2
		lo = R2
		sus = Nothing
		-- ###################################
		
		-- Start by evaluating high, low, and equal, and determining the ranks
		-- Equal only has two states in here, so categorise by that
		-- r1 IS THE LOWER RANKED CARD
		r1 
			| fb_equal == 2 = rank (pGuess !! 0)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 2 = (highest pGuess)
			| fb_lower == 0 && fb_equal == 1 && fb_higher == 1 = rank (pGuess !! 0)
			| fb_lower == 1 && fb_equal == 0 && fb_higher == 1 = incRank (lowest pGuess) (-1)
			| fb_lower == 1 && fb_equal == 1 && fb_higher == 0 = incRank (lowest pGuess) (-1)
			| fb_lower == 2 && fb_equal == 0 && fb_higher == 0 = incRank (lowest pGuess) (-1)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 0 = incRank (lowest pGuess) 1
			| fb_lower == 0 && fb_equal == 1 && fb_higher == 0 = if (turn gs) == 0 then incRank (lowest pGuess) 1 else rank (pGuess !! 0)
			| fb_lower == 1 && fb_equal == 0 && fb_higher == 0 = rank (pGuess !! 0)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 1 = incRank (lowest pGuess) 1
		
		-- r2 IS THE HIGHER RANKED CARD
		r2 
			| fb_equal == 2 = rank (pGuess !! 1)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 2 = incRank (highest pGuess) 1
			| fb_lower == 0 && fb_equal == 1 && fb_higher == 1 = incRank (highest pGuess) 1
			| fb_lower == 1 && fb_equal == 0 && fb_higher == 1 = incRank (highest pGuess) 1
			| fb_lower == 1 && fb_equal == 1 && fb_higher == 0 = rank (pGuess !! 1)
			| fb_lower == 2 && fb_equal == 0 && fb_higher == 0 = (lowest pGuess)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 0 = incRank (highest pGuess) (-1)
			| fb_lower == 0 && fb_equal == 1 && fb_higher == 0 = if (turn gs) == 1 then incRank (highest pGuess) (-1) else rank (pGuess !! 1)
			| fb_lower == 1 && fb_equal == 0 && fb_higher == 0 = incRank (highest pGuess) (-1)
			| fb_lower == 0 && fb_equal == 0 && fb_higher == 1 = rank (pGuess !! 1)
		
		-- s1 IS THE SUIT OF THE LOWER CARD
		s1
			| fb_suits == 0 = incSuit (suit (pGuess !! 0)) 1
			| fb_suits == 1 = suit (pGuess !! 0)
			| fb_suits == 2 && fb_equal == 2 && fb_correct < 2 = suit (pGuess !! 1)
			| otherwise = suit (pGuess !! 0)
		
		-- s2 IS THE SUIT OF THE HIGHER CARD	
		s2
			| fb_suits == 0 = incSuit (suit (pGuess !! 1)) 1
			| fb_suits == 1 = incSuit (suit (pGuess !! 1)) 1
			| fb_suits == 2 && fb_equal == 2 && fb_correct < 2 = suit (pGuess !! 0)
			| otherwise = suit (pGuess !! 1)


-- Make a complete deck of 52 cards in the form [(suit,rank), ...]
fillDeck :: [Card]
fillDeck = [Card x y | x <- [minBound::Suit ..],  y <- [minBound::Rank ..]]

-- Multiply each element of list by a number
mult x ys = map (x *) ys

-- Grab a list of cards (fixed at the moment), x cards long
sample :: Int -> [Card]
sample x = take x [Card Club R6, Card Club R10] 

-- Gets the lowest rank from a list of cards
lowest :: [Card] -> Rank
lowest cards = minimum (eR cards)

-- Gets the highest rank from a list of cards
highest :: [Card] -> Rank
highest cards = maximum (eR cards)

-- Extracts just the ranks from a list of cards and returns a list of the ranks
eR :: [Card] -> [Rank]
eR [] = []
eR (x:xs) = [(rank x)] ++ (eR xs) 

-- Returns x ranks higher than r
incRank :: Rank -> Int -> Rank
incRank r x = toEnum (((fromEnum r) + x) `mod` 13)::Rank

-- Returns x suits higher than s
incSuit :: Suit -> Int -> Suit
incSuit s x = toEnum (((fromEnum s) + x) `mod` 4)::Suit

-- Switches turn
switchT x = case x of
	0 -> 1
	1 -> 0

