//
//  PostFB.h
//  Antigua Wow!
//
//  Created by Rh_M on 16/07/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PostFB : NSObject
-(void)postwall:(int)idlocal nombre:(NSString*)name;
@end
