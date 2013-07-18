//
//  Info_horizontal.h
//  Antigua Wow!
//
//  Created by otoniel alejandro mendez hernandez on 23/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol infogeneralhordelegate <NSObject>
@optional
-(void)abrirsitiooficial;
@end

@interface Info_horizontal : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id<infogeneralhordelegate> delegate;


@end
