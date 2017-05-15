//
//  FMDBDefine.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/5/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#ifndef FMDBDefine_h
#define FMDBDefine_h

#define DB_NAME         @"schoolData.sqlite"

#define DB_NEWVERSIONV1                1.0
#define DB_NEWVERSIONV2                2.0
#define DB_NEWVERSIONV3                3.0

//表名
#define TABLE_NAME_SCHOOL         @"schoolTable"
#define TABLE_NAME_CLASS         @"classTable"

#define DB_CREATE_SCHOOL @"CREATE TABLE IF NOT EXISTS schoolTable (classId INTEGER primary key AUTOINCREMENT,className text,teacherName text,stutentNumber int,boyNumber int,girlNumber int)"

#define DB_CREATE_CLASS @"CREATE TABLE IF NOT EXISTS classTable (studentId INTEGER primary key AUTOINCREMENT,name text,sex text,age int,score double)"

#endif /* FMDBDefine_h */
