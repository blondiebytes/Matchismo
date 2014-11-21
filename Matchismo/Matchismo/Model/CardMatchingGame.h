//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kathryn Hodge on 06/22/14.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score; // make score read only in public API
@property (nonatomic) NSUInteger gameMode; // 2 for two-card; 3 for three-card
@property(nonatomic, readonly) NSString *result;

@end
