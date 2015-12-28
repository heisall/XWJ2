//
//  XWJHttpComm.m
//  XWJ
//
//  Created by Sun on 15/12/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHttpComm.h"

@implementation XWJHttpComm

+ (instancetype) instance {
    static XWJHttpComm *_CTLClient;
    if ( _CTLClient==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _CTLClient=[[XWJHttpComm alloc] init ];
        });
    }

    return _CTLClient;
}

@end

