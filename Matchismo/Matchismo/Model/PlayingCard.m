//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kathryn Hodge on 06/22/14.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// override 'match' inherited from Card

// CONSTANTS!
static const int SUIT_MATCH = 2;
static const int RANK_MATCH = 8;
static const int MULTI_CARD_PENALTY = 2;



- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = SUIT_MATCH;
        } else if (self.rank == otherCard.rank) {
            score += RANK_MATCH;
        }
    } else {
        for (Card *otherCard in otherCards) {
            score += [self match:@[otherCard]] / MULTI_CARD_PENALTY;
            PlayingCard *otherCard = [otherCards firstObject];
            score += [otherCard match: [otherCards subarrayWithRange:NSMakeRange(1, [otherCards count] - 1)]];
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide the setter AND the getter

+ (NSArray *)validSuits
{
    return @[@"♣", @"♠", @"♦", @"♥"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return ([[PlayingCard rankStrings] count] - 1);
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
