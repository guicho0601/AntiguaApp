//
//  FBShowController.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 19/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBShowDelegate <NSObject>
@required
-(void)sendFB:(NSString *)mensaje;
-(void)cerrarFB;
@end

@interface FBShowController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *urlimage;
@property (weak, nonatomic) id<FBShowDelegate> delegate;
- (IBAction)Cancelar:(id)sender;
- (IBAction)Publicar:(id)sender;
@end
