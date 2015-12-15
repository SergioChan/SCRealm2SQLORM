//
//  ViewController.m
//  realm-test
//
//  Created by 叔 陈 on 12/14/15.
//  Copyright © 2015 叔 陈. All rights reserved.
//

#import "ViewController.h"
#import "SCModel.h"
#import "SCRealmManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SCRealmManager sharedInstance] writeObjectWithDictionary:@{@"name":@"fuck1",@"title":@"duck2"} inTable:@"SCModel"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)queryButtonPressed:(id)sender {
    [[SCRealmManager sharedInstance] queryAllInTableName:@"SCModel"];
}
- (IBAction)query1ButtonPressed:(id)sender {
    [[SCRealmManager sharedInstance] queryWithWhereStr:@"name = 'fuck1'" inTable:@"SCModel"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
