//
//  Global.m
//  Hiaggo
//
//  Created by XinMa on 8/12/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "Global.h"

static Global * _sharedManager = nil;
@implementation Global
@synthesize username, user_email , user_id , isFirstLogin , count;

+ (id)sharedInstance
{
    if (_sharedManager == nil)
    {
        @synchronized(self)
        {
            _sharedManager = [[Global alloc] init];
        }
    }
    return _sharedManager;
}

-(id) init {
    if(self = [super init])
    {
//        isFirstLogin = TRUE;
    }
    return self;
}

- (void) setCount:(int)countref
{
    count = countref;
}

- (int) getCount{
    return count;
}

-(void) formatCarArray{
//    [self.carArray removeAllObjects];
}

@end
