//
//  FBShowController.m
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 19/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FBShowController.h"

@implementation FBShowController
@synthesize imageView;
@synthesize label;
@synthesize textView;
@synthesize urlimage,delegate;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setImageView:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(320, 230);
    NSURL *url = [NSURL URLWithString:urlimage];
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSArray *array = [urlimage componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
    /*
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:urlimage]];
        [data3 writeToFile:fotointerna atomically:YES];
    }*/
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [self.imageView setImage:thumbNail];
    //[textView setBackgroundColor:[UIColor clearColor]];
    //[label setBackgroundColor:[UIColor clearColor]];
    [textView becomeFirstResponder];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Cancelar:(id)sender {
    [self.delegate cerrarFB];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Publicar:(id)sender {
    [self.delegate sendFB:[textView text]];
    [self.delegate cerrarFB];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
