//
//  TableViewController.m
//  ScrollViewToPDF
//
//  Created by azu on 10/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TableViewController.h"
#import "PDFImageConverter.h"
#import "ScrollViewToPDF.h"

@interface TableViewController ()

@end

@implementation TableViewController {
@private
    NSString *_pdfPath;
}


@synthesize pdfPath = _pdfPath;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self){
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openPath:(NSString *)pathString {

    NSURL *path = [NSURL fileURLWithPath:pathString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    webView.scalesPageToFit = YES;
    [webView loadRequest:urlRequest];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = webView;
    [self.navigationController pushViewController:viewController animated:YES];

    //system([[NSString stringWithFormat:@"open '%@'", self.pdfPath] cStringUsingEncoding:NSUTF8StringEncoding]);

}

- (IBAction)openAllOnePagePDF:(id)sender {
    UIImage *tableImage = [self screenShotScrollView:self.tableView];
    NSData *pdfData = [PDFImageConverter convertImageToPDF:tableImage];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *path = [tmpDirectory stringByAppendingPathComponent:@"image.pdf"];
    [pdfData writeToFile:path atomically:NO];

    [self openPath:path];
}

- (IBAction)openPerPagePDF:(id)sender {
    NSData *pdfData = [ScrollViewToPDF pdfDataOfScrollView:self.tableView];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *path = [tmpDirectory stringByAppendingPathComponent:@"image.pdf"];
    [pdfData writeToFile:path atomically:NO];

    [self openPath:path];
}

- (UIImage *)screenShotScrollView:(UIScrollView *)scrollView {
    /* スクリーンショット用の準備 */
    [scrollView setContentOffset:CGPointZero animated:NO];
    // インジケータを非表示にする
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 2.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;

        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();

        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();

    if (image != nil){
        return image;
    }
    return nil;
}


@end
