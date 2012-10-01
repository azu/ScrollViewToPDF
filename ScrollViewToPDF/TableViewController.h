//
//  TableViewController.h
//  ScrollViewToPDF
//
//  Created by azu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface TableViewController : UITableViewController

@property(nonatomic, copy) NSString *pdfPath;

- (IBAction)openAllOnePagePDF:(id)sender;
- (IBAction)openPerPagePDF:(id)sender;

@end
