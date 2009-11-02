//
//  CustomViewController.m
//  mySettings
//
//  Created by Kåre Morstøl on 02.11.09.
//  Copyright 2009 NotTooBad Software. All rights reserved.
//

#import "CustomViewController.h"


@implementation CustomViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView {
	[super loadView];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 260, 50)];
	label.numberOfLines = 2;
	label.textAlignment = UITextAlignmentCenter;
	label.text = @"Your own view.\nDo whatever you want.";
	label.font = [UIFont systemFontOfSize:20];
	[self.view addSubview:label];
	[label release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
