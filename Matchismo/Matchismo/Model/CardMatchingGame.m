//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kathryn Hodge on 06/22/14.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;    // make score writable in out private API
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property(nonatomic, readwrite) NSString *result;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (NSUInteger i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.score = 0;
    return self;
}

//#define MISMATCH_PENALTY 2            // it's a matter of preference what to use, however:
static const int MISMATCH_PENALTY = 2;  // this is typed so it will show in the debugger
static const int MATCH_BONUS = 2;
static const int COST_TO_CHOOSE = 1;

-(NSUInteger)gameMode {
    if (!_gameMode) {
        _gameMode = 2;
    }
    return _gameMode;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.result = [NSString stringWithFormat:@"%@ Selected", card.contents];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.result = [NSString stringWithFormat:@"%@ Unselected", card.contents];
        } else {
            NSMutableArray *otherCards = [NSMutableArray array];
            for (Card *otherCard in self.cards) {
                //add each chosen and unmatched card to the array
                if (otherCard.isChosen && !otherCard.isMatched){
                    [otherCards addObject:otherCard];
                }
            }
            if ([otherCards count] == self.gameMode - 1) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    // increase score
                    self.score += (matchScore * MATCH_BONUS);
                    
                    // mark cards as matched
                    card.matched = YES;
                    NSString *otherCardContents = @"";
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                        otherCardContents = [otherCardContents stringByAppendingFormat:@"%@", otherCard.contents];
                    }
                    self.result = [NSString stringWithFormat: @"Matched %@ %@ for %d points!", otherCardContents, card.contents, matchScore * MATCH_BONUS];
                } else {
                    // mismath penalty when cards do no match
                    self.score -= MISMATCH_PENALTY;
                    //flip over all of the other cards
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                    self.result = [NSString stringWithFormat: @"Mismatch! Penalty of %d", MISMATCH_PENALTY];
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
