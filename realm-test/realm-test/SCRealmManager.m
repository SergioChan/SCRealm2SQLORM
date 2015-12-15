//
//  SCRealmManager.m
//  realm-test
//    这是一个简单的realm的类似sqlite的数据库接口库。可以给熟悉sql语法，新入门realm的新手参考。
//    Realm 支持下列查询语法：
//    The comparison operands can be property names or constants. At least one of the operands must be a property name.
//    The comparison operators ==, <=, <, >=, >, !=, and BETWEEN are supported for int, long, long long, float, double, and NSDate property types. Such as age == 45
//    Identity comparisons ==, !=, e.g. [Employee objectsWhere:@”company == %@”, company]
//    The comparison operators == and != are supported for boolean properties.
//    For NSString and NSData properties, we support the ==, !=, BEGINSWITH, CONTAINS, and ENDSWITH operators, such as name CONTAINS ‘Ja’
//    Case insensitive comparisons for strings, such as name CONTAINS[c] ‘Ja’. Note that only characters “A-Z” and “a-z” will be ignored for case.
//    Realm supports the following compound operators: “AND”, “OR”, and “NOT”. Such as name BEGINSWITH ‘J’ AND age >= 32
//    The containment operand IN such as name IN {‘Lisa’, ‘Spike’, ‘Hachi’}
//    Nil comparisons ==, !=, e.g. [Company objectsWhere:@"ceo == nil"]. Note that Realm treats nil as a special value rather than the absence of a value, so unlike with SQL nil equals itself.
//    ANY comparisons, such as ANY student.age < 21
//    The aggregate expressions @count, @min, @max, @sum and @avg are supported on RLMArray properties, e.g. [Company objectsWhere:@"employees.@count > 5"] to find all companies with more than five employees.

//  Created by 叔 陈 on 12/14/15.
//  Copyright © 2015 叔 陈. All rights reserved.
//

#import "SCRealmManager.h"

@implementation SCRealmManager

+ (SCRealmManager *)sharedInstance {
    static SCRealmManager *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[SCRealmManager alloc] init];
    });
    return sInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.realm = [RLMRealm defaultRealm];
    }
    return self;
}

#pragma mark - Basic realm function
- (BOOL)writeObject:(id)object
{
    NSLog(@"writeObject: %@",object);
    NSError *error;
    // Add to Realm with transaction
    return [self.realm transactionWithBlock:^{
        [self.realm addObject:object];
    } error:(&error)];
}

- (BOOL)deleteObject:(id)object
{
    NSLog(@"deleteObject: %@",object);
    NSError *error;
    // Add to Realm with transaction
    return [self.realm transactionWithBlock:^{
        [self.realm deleteObject:object];
    } error:(&error)];
}

/**
 *  直接通过key-values字典写入对象
 *
 *  @param dictionary 对象的列名-值字典
 *  @param className  对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)writeObjectWithDictionary:(NSDictionary *)dictionary inTable:(NSString *)className
{
    // 直接通过key-values字典写入对象
    id t_object = [[NSClassFromString(className) alloc]initWithValue:dictionary];
    return [self writeObject:t_object];
}

/**
 *  通过where查询语句删除指定条件的对象
 *
 *  @param str       where查询语句
 *  @param className 对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)deleteObjectWithWhereStr:(NSString *)str inTable:(NSString *)className
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:str];
    RLMResults *results = [NSClassFromString(className) objectsWithPredicate:pred];
    
    NSError *error;
    return [self.realm transactionWithBlock:^{
        for(NSInteger i=0;i<results.count;i++)
        {
            [self.realm deleteObject:[results objectAtIndex:i]];
        }
    } error:(&error)];
}

/**
 *  通过where语句查询指定条件的对象
 *
 *  @param str       where查询语句
 *  @param className 对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:str];
    RLMResults *results = [NSClassFromString(className) objectsWithPredicate:pred];
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i=0;i<results.count;i++)
    {
        [array addObject:[results objectAtIndex:i]];
    }
    NSLog(@"queryWithWhereStr: %@ [sorted]",array);
    return array;
}

/**
 *  更新指定表中的满足指定条件的数据的指定字段的值
 *
 *  @param dictionary 需要更新的键值字典
 *  @param str        查询条件
 *  @param className  对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)updateWithValueDictionary:(NSDictionary *)dictionary whereStr:(NSString *)str inTable:(NSString *)className
{
    NSError *error;
    return [self.realm transactionWithBlock:^{
        NSPredicate *pred = [NSPredicate predicateWithFormat:str];
        RLMResults *results = [NSClassFromString(className) objectsWithPredicate:pred];

        for(NSInteger i=0;i<results.count;i++)
        {
            RLMObject *t_object = [results objectAtIndex:i];
            for(NSString *key in dictionary.allKeys)
            {
                [t_object setValue:[dictionary objectForKey:key] forKeyPath:key];
            }
        }
    } error:(&error)];
}

/**
 *  通过where语句查询指定条件的对象，可以根据某一列进行排序
 *
 *  @param str        where查询语句
 *  @param className  对象类名
 *  @param columnName 排序的列名
 *  @param asc        YES为升序，NO为降序
 *
 *  @return BOOL 事务是否执行成功
 */
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className sortedByColumn:(NSString *)columnName ascending:(BOOL)asc
{
    RLMResults *results = [[NSClassFromString(className) objectsWhere:str] sortedResultsUsingProperty:columnName ascending:asc];
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i=0;i<results.count;i++)
    {
        [array addObject:[results objectAtIndex:i]];
    }
    NSLog(@"queryWithWhereStr: %@ [sorted]",array);
    return array;
}

//allObjects

- (NSArray *)queryAllInTableName:(NSString *)className
{
    RLMResults *results = [NSClassFromString(className) allObjects];
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i=0;i<results.count;i++)
    {
        [array addObject:[results objectAtIndex:i]];
    }
    NSLog(@"queryAllInTableName: %@ [sorted]",array);
    return array;
}
@end
