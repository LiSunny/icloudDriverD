//
//  DocumentPickerViewController.m
//  icloudExt
//
//  Created by HeavenLi on 2017/5/3.
//  Copyright © 2017年 HeavenLi. All rights reserved.
//

#import "DocumentPickerViewController.h"

@interface DocumentPickerViewController ()

@end

@implementation DocumentPickerViewController

- (IBAction)openDocument:(id)sender {
    NSURL* documentURL = [self.documentStorageURL URLByAppendingPathComponent:@"Untitled.txt"];
    
    // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
    [self dismissGrantingAccessToURL:documentURL];
}

-(void)prepareForPresentationInMode:(UIDocumentPickerMode)mode {
    // TODO: present a view controller appropriate for picker mode here
}

@end
