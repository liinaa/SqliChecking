//
//  DBManager.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 31/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
    @property (nonatomic, strong) NSString *documentsDirectory;
    @property (nonatomic, strong) NSString *databaseFilename;
    @property (nonatomic, strong) NSMutableArray *arrResults;
    @property (nonatomic, strong) NSMutableArray *arrColumnNames;
    @property (nonatomic) int affectedRows;
    @property (nonatomic) long long lastInsertedRowID;
    -(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
    -(void)copyDatabaseIntoDocumentsDirectory;
    -(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
    -(NSArray *)loadDataFromDB:(NSString *)query;
    -(void)executeQuery:(NSString *)query;

@end
