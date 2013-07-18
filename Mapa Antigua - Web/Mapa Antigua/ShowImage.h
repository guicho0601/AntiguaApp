//
//  ShowImage.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 18/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowImageDelegate <NSObject>
@required
-(void)cerrarshow;
@end

@interface ShowImage : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) NSString *nombreimagen;
@property (nonatomic) CGSize sizepop;
@property (weak,nonatomic) id<ShowImageDelegate> delegate;
@end
