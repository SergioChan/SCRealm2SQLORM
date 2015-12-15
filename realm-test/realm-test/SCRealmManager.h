//
//  SCRealmManager.h
//  realm-test
//
//  Created by 叔 陈 on 12/14/15.
//  Copyright © 2015 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SCRealmManager : NSObject

@property (nonatomic,strong) RLMRealm *realm;
+ (SCRealmManager *)sharedInstance;

- (BOOL)writeObject:(id)object;
- (BOOL)writeObjectWithDictionary:(NSDictionary *)dictionary inTable:(NSString *)className;
- (BOOL)deleteObject:(id)object;
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className;
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className sortedByColumn:(NSString *)columnName ascending:(BOOL)asc;
- (NSArray *)queryAllInTableName:(NSString *)className;
@end
