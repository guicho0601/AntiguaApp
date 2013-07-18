//
//  FBShowControlleriPad.h
//  Aqui en Antigua
//
//  Created by otoniel alejandro mendez hernandez on 19/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBShowiPadDelegate <NSObject>
-(void)sendFB:(NSString *)mensaje;
@end

@interface FBShowControlleriPad : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, retain) NSString *urlimage;
@property (weak, nonatomic) id<FBShowiPadDelegate> delegate;
- (IBAction)Cancelar:(id)sender;
- (IBAction)Publicar:(id)sender;
@end
