# SCRealm2SQLORM
A realm ORM kit transferring realm usage to traditional SQLite usage. Just for learning and practicing.这是一个简单的realm的类似sqlite的数据库接口库。可以给熟悉sql语法，新入门realm的新手参考。

由于realm的framework文件太大，所以不附带在仓库中。你可以自行前往[realm.io](http://realm.io)下载静态库文件或者使用CocoaPods。

## API Usage

由于在realm中读取的数据源直接对应到model上，因此model就类似sqlite中的table的概念。因此这里提供了一套根据table名称写入，读取，更新，删除数据的API。  

```Objective-C
/**
 *  直接通过key-values字典写入对象
 *
 *  @param dictionary 对象的列名-值字典
 *  @param className  对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)writeObjectWithDictionary:(NSDictionary *)dictionary inTable:(NSString *)className;

/**
 *  通过where查询语句删除指定条件的对象
 *
 *  @param str       where查询语句
 *  @param className 对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)deleteObjectWithWhereStr:(NSString *)str inTable:(NSString *)className;

/**
 *  通过where语句查询指定条件的对象
 *
 *  @param str       where查询语句
 *  @param className 对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className;

/**
 *  更新指定表中的满足指定条件的数据的指定字段的值
 *
 *  @param dictionary 需要更新的键值字典
 *  @param str        查询条件
 *  @param className  对象类名
 *
 *  @return BOOL 事务是否执行成功
 */
- (BOOL)updateWithValueDictionary:(NSDictionary *)dictionary whereStr:(NSString *)str inTable:(NSString *)className;

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
- (NSArray *)queryWithWhereStr:(NSString *)str inTable:(NSString *)className sortedByColumn:(NSString *)columnName ascending:(BOOL)asc;

//allObjects

- (NSArray *)queryAllInTableName:(NSString *)className;

```
