import Card

incCard :: Suit -> Rank -> Int -> Card
incCard s r x = Card s (incRank r x)

incRank :: Rank -> Int -> Rank
incRank r x = toEnum (((fromEnum r) + x) `mod` 13)::Rank

-- Returns x suits higher than s
incSuit :: Suit -> Int -> Suit
incSuit s x = toEnum (((fromEnum s) + x) `mod` 4)::Suit