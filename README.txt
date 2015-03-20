CARDGUESS README

Intro and usage
This cardguess program works in conjunction with an answerer module to provide guesses in response to feedback provided by the answerer. These guesses are restricted to TWO CARDS, three and four card implementations have not been built in.
The initial guess is narrowed to a two card list with a 6 and 10 of Clubs, which results in four cards higher and lower, and three cards in between. This configuration means that a small number of guesses are needed to guess the correct ranks of the answer cards, whilst setting both to Clubs allows the traversal of the suits in a small number of guesses as well. The algorithm is described below.
The order of the cards in the guess list is important. The card in the first slot will always be less than or equal to the card in the second slot. This configuration means that no computation has to occur to determine which card is correct/higher/lower and so on. This configuration could be changed, however it would require extra steps in order to compute the higher rank.

Algorithm - Guessing the Ranks
The first guess is given, and the first lot of feedback is received. Mainly, the high, low, and equal values are used. The "correct" value is not used until the final step in the process of guessing both the suit and ranks. The following scenarios represent every possible combination of high (H), low (L), and equal (E) rank feedback values.
Both the first and second cards are handled completely separate.

	- If E is 2, then both cards hold the correct ranks, so no changing of ranks needs to occur and this section is skipped.
	- If H is 2, then both answer cards are higher than the highest card in the guess, so both cards are set to the highest rank in the guess, with the second card being one higher (this avoids setting both cards to the same card, giving an invalid guess).
	- If L is 2, then the opposite of the above occurs, both cards are set to the lowest rank in the guess, with the first being one lower.
	- In the case that both L and H equal 1, then one answer card is lower than the lowest in the guess, and the other is higher than the highest in the guess. This means that no cards in between the guess cards (inclusive) are correct, and both cards are moved outwards in rank (high is made higher, low is made lower)
	- If both L and H equal 0, and E is also 0, then the correct ranks must be located between the two guess cards. Both cards are moved inwards (high is made lower, low is made higher)
	- If L is 1, and the rest are 0, then both cards are decremented
	- If H is 1, and the rest are 0, then both cards are incremented

In the case that one is equal, but it cannot determined which of the two is correct, then a “turn” variable comes into play. The card (first or second, initially first) stored in the turn variable is incremented (if low) or decremented (if high) and the turn variable is flipped. This situation essentially means that one card is brought in, then the other, then the other, and so on until the are both equal.
If the card that IS equal in changed, the setup of feedback will be altered to one of the above situations, for example if the high card is the correct one and it is decremented, then we are left with a h=1 l=0 e=0 situation, causing both cards to be incremented, and so on until both cards are equal. In this case, even choosing the wrong card to change will simply fix itself, only requiring one extra turn.

Guessing the Suits
Suits are incredibly straightforward. Both cards are set to the lowest suit, clubs, and the following happens:

	- If none are correct, both cards’ suits are incremented to the next suit (C->D for example)
	- If one is correct, the first card is locked in, and the second card’s suit is incremented
	- Continue until both correct

Now this unveils a problem where both Rank Equal is 2, and Suit Equal is 2, but neither is correct because the suits are around the wrong way. In this case, when E=2, S=2, and C=0, the suits are flipped, resulting in a correct guess!

Other problems solved incidentally
If both cards are of equal ranks, the correct guess is still calculated correctly as the second card can be higher or EQUAL to the first (low) card. If the two cards are equal, say 5,5, but the answer is 4,4, then both will be decremented as L=2, and vice versa for H=2.