//
//  ViewController.m
//  Project-ObjectiveC
//
//  Created by Erico GT on 17/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SQLiteManager *sqliteM = [SQLiteManager new];
    
    if (![sqliteM databaseExists]){
        
        [sqliteM copyDBToUserDocuments];
        
        [sqliteM executeScriptFromFile:@"script_sqlite"];
        
    }
}

@end
