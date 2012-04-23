/* 
 Copyright (c) 2012, Aaron Jubbal
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SpecifiedTableView.h"


@implementation SpecifiedTableView

@synthesize rootOfPlist;

#pragma mark -
#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		[self initWithStyle:UITableViewStyleGrouped viewContents:nil];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style viewContents:(NSArray *)viewContents {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		self.rootOfPlist = [viewContents retain];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (!rootOfPlist) {
        self.title = @"Credits";
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"plist"];
        rootOfPlist = [[NSArray alloc] initWithContentsOfFile:plistPath];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Helper Methods

-(BOOL)isDetailView:(NSDictionary *)cellSection {
	for (NSString *key in [cellSection allKeys]) {
		if ([key isEqualToString:@"View Title"]) {
			return YES;
		} else if ([key isEqualToString:@"Section Header"]) {
			return NO;
		}
	} //for allKeys
	return NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [rootOfPlist count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSDictionary *cellSection = [rootOfPlist objectAtIndex:section];
	if ([self isDetailView:cellSection]) {
		return 1;
	}
    return [[cellSection objectForKey:@"Items"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    // Configure the cell...
	NSDictionary *cellSection = [rootOfPlist objectAtIndex:indexPath.section];
	if ([self isDetailView:cellSection]) {
		CellIdentifier = @"detailView";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		NSString *viewTitle = [cellSection objectForKey:@"View Title"];
		cell.textLabel.text = viewTitle;
		cell.detailTextLabel.text = @"";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		NSArray *itemArray = [cellSection objectForKey:@"Items"];
		NSDictionary *item = [itemArray objectAtIndex:indexPath.row];
		NSArray *name = [item allKeys];
		cell.textLabel.text = [name objectAtIndex:0]; // grab the first and only string in this array
		NSArray *role = [item allValues];
		cell.detailTextLabel.text = [role objectAtIndex:0]; // grab the first and only string in this array
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *cellSection = [rootOfPlist objectAtIndex:section];
	if ([self isDetailView:cellSection]) {
		return @"";
	}
	return [cellSection objectForKey:@"Section Header"];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSDictionary *cellSection = [rootOfPlist objectAtIndex:indexPath.section];
    if ([self isDetailView:cellSection]) {
		NSArray *viewContents = [cellSection objectForKey:@"View Contents"];
		SpecifiedTableView *stv = [[SpecifiedTableView alloc] initWithStyle:UITableViewStyleGrouped 
                                                               viewContents:viewContents];
		[stv setTitle:[cellSection objectForKey:@"View Title"]];
		[self.navigationController pushViewController:stv animated:YES];
		[stv release];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[rootOfPlist release];
    [super dealloc];
}


@end

