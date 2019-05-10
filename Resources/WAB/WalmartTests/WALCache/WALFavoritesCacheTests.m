//
//  WALFavoritesCacheTests.m
//  Walmart
//
//  Created by Bruno Delgado on 6/30/16.
//  Copyright © 2016 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALFavoritesCache.h"

@interface WALFavoritesCacheTests : XCTestCase

@property (nonatomic, strong) WALFavoritesCache *cacheInstance;

@end

@implementation WALFavoritesCacheTests

- (void)setUp
{
    [super setUp];
    self.cacheInstance = [WALFavoritesCache new];
}

- (void)tearDown
{
    self.cacheInstance = nil;
    [super tearDown];
}

- (void)testSave
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
}

- (void)testClean
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);

    [WALFavoritesCache clean];
    favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertTrue(favoritesFromCache.count == 0);
}

- (void)testInsert
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
    XCTAssertTrue(favoritesFromCache.count == favorites.count);

    [WALFavoritesCache insert:@4];
    favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertTrue(favoritesFromCache.count == favorites.count + 1);
}

- (void)testGetFavorites
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
    XCTAssertTrue(favoritesFromCache.count == favorites.count);

    [WALFavoritesCache cleanInMemoryFavorites];
    favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
    XCTAssertTrue(favoritesFromCache.count == favorites.count);
}

- (void)testRemove
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
    XCTAssertTrue(favoritesFromCache.count == favorites.count);

    [WALFavoritesCache remove:@3];
    favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertTrue(favoritesFromCache.count == favorites.count - 1);
}

- (void)testRemoveList
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    NSArray *favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertNotNil(favoritesFromCache);
    XCTAssertTrue(favoritesFromCache.count == favorites.count);

    [WALFavoritesCache removeSKUs:@[@1,@2]];
    favoritesFromCache = [WALFavoritesCache favorites];
    XCTAssertTrue(favoritesFromCache.count == favorites.count - 2);
}

- (void)testIsFavorite
{
    NSArray *favorites = nil;
    XCTAssertNil(favorites);

    favorites = @[@1,@2,@3];
    XCTAssertNotNil(favorites);

    [WALFavoritesCache save:favorites];
    XCTAssertTrue([WALFavoritesCache isFavorite:@1]);
    XCTAssertFalse([WALFavoritesCache isFavorite:@99]);
}

@end
