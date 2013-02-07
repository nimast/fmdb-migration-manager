//
//  FmdbMigrationColumn.m
//  fmdb-migration-manager
//
//  Created by Dr Nic on 6/09/08.
//  Copyright 2008 Mocra. All rights reserved.
//

#import "FmdbMigrationColumn.h"


@implementation FmdbMigrationColumn
@synthesize columnName=columnName_, columnType=columnType_, defaultValue=defaultValue_, allowNulls=allowNulls_;

#pragma mark -
#pragma mark Constructor helpers


+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType
{
	FmdbMigrationColumn* column = [[[FmdbMigrationColumn alloc] init] autorelease];
	column.columnName = columnName;
	column.columnType = columnType;
	return column;
}

+ (FmdbMigrationColumn*)columnWithColumnName:(NSString*)columnName
                                  columnType:(NSString*)columnType
                                defaultValue:(id)defaultValue
{
	FmdbMigrationColumn* column = [self columnWithColumnName:columnName columnType:columnType];
	column.defaultValue = defaultValue;
	return column;
}

+ (FmdbMigrationColumn *)columnWithColumnName:(NSString *)columnName
                                   columnType:(NSString *)columnType
                                 defaultValue:(id)defaultValue
                                   allowNulls:(BOOL)allowNulls
{
    FmdbMigrationColumn* column = [self columnWithColumnName:columnName columnType:columnType defaultValue:defaultValue];
    column.allowNulls = allowNulls;
    return column;
}

+ (FmdbMigrationColumn *)columnWithColumnName:(NSString *)columnName
                                   columnType:(NSString *)columnType
                                   allowNulls:(BOOL)allowNulls
{
    FmdbMigrationColumn* column = [self columnWithColumnName:columnName columnType:columnType];
    column.allowNulls = allowNulls;
    return column;
}


- (id)init
{
    self = [super init];
    if (self) {
        allowNulls_ = true;
    }

    return self;
}

// Notes from http://www.sqlite.org/lang_altertable.html:
// Column-def may take any of the forms permissable in a CREATE TABLE statement, with the following restrictions:
//  * The column may not have a PRIMARY KEY or UNIQUE constraint.
//  * The column may not have a default value of CURRENT_TIME, CURRENT_DATE or CURRENT_TIMESTAMP.
//  * If a NOT NULL constraint is specified, then the column must have a default value other than NULL.
- (NSString *)sqlDefinition
{
    NSString *nullString = self.allowNulls ? @"NULL" : @"NOT NULL";
    NSMutableArray *statements = [NSMutableArray arrayWithArray: @[
            self.columnName,
            self.columnTypeDefinition,
            nullString
    ]];

    if (self.defaultValue) {
        [statements addObject:[NSString stringWithFormat:@"default %@", self.defaultValue]];
    }

    NSString *sql = [statements componentsJoinedByString:@" "];

	return sql;
}

- (NSString *)columnTypeDefinition
{
	return self.columnType;
}

- (void)dealloc
{
	[columnName_ release];
	[columnType_ release];
	[defaultValue_ release];

	[super dealloc];
}
@end
