//
//  Info_horizontal.m
//  Antigua Wow!
//
//  Created by otoniel alejandro mendez hernandez on 23/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Info_horizontal.h"

@implementation Info_horizontal
@synthesize imageView,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)regreso:(UITapGestureRecognizer*)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regreso:)];
    tap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tap];
    [self.imageView setUserInteractionEnabled:YES];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (IBAction)abrirurl:(id)sender {
    [delegate abrirsitiooficial];
}

@end
