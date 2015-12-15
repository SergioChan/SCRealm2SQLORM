//
//  SCModel.h
//  realm-test
//
//  Created by 叔 陈 on 12/14/15.
//  Copyright © 2015 叔 陈. All rights reserved.
//

#import <Realm/Realm.h>

@interface SCModel : RLMObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<SCModel>
RLM_ARRAY_TYPE(SCModel)
