//
//  ViewController.m
//  icloudDriverD
//
//  Created by HeavenLi on 2017/5/2.
//  Copyright © 2017年 HeavenLi. All rights reserved.
//

#import "ViewController.h"

//缓存文件路径
#define CachesFilePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

@interface ViewController ()<UIDocumentMenuDelegate,UIDocumentPickerDelegate>

@property (nonatomic,strong) UIDocumentPickerViewController * documentPickerVC;

@property (nonatomic,strong) UIDocumentMenuViewController * documentMenuVC;

@end

@implementation ViewController

//- (UIDocumentMenuViewController *)documentMenuVC
//{
//    if (!_documentMenuVC) {
//        _documentMenuVC = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.text",@"public.data"] inMode:UIDocumentPickerModeOpen];
//        _documentMenuVC.delegate = self;
//    }
//    return _documentMenuVC;
//}
//- (UIDocumentPickerViewController *)documentPickerVC
//{
//    if (!_documentPickerVC) {
//        _documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.text",@"public.data"] inMode:UIDocumentPickerModeOpen];
//        _documentPickerVC.delegate = self;
//    }
//    return _documentPickerVC;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getFile:(id)sender {
    
    self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.text",@"public.data"] inMode:UIDocumentPickerModeImport];
    self.documentPickerVC.delegate = self;
    
    
    self.documentMenuVC = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.text",@"public.data"] inMode:UIDocumentPickerModeImport];
    self.documentMenuVC.delegate = self;
    [self presentViewController:self.documentMenuVC animated:YES completion:^{
        
    }];
    
}

#pragma UIDocumentMenuDelegate
- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker
{
    
    [self presentViewController:self.documentPickerVC animated:YES completion:nil];
}
#pragma UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    //老老实实劳斯莱斯了算了算了
    NSLog(@"select url : %@",url);
    if (controller.documentPickerMode == UIDocumentPickerModeOpen) {
        [self openFile:url];
    }else if (controller.documentPickerMode == UIDocumentPickerModeImport){
        [self importFile:url];
    }
    
    
    
}
- (void)importFile:(NSURL *)url
{
    
//    iCloud.sfb.icloudDirverDemo
    
    
    //1.通过文件协调工具来得到新的文件地址，以此得到文件保护功能
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    [fileCoordinator coordinateReadingItemAtURL:url options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL * _Nonnull newURL) {
        
        //2.直接读取文件
        NSString *fileName = [newURL lastPathComponent];
        NSString *contStr = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:nil];
        
        //3.把数据保存在本地缓存
        [self saveLocalCachesCont:contStr fileName:fileName];
        
    }];
}

//读取文件
- (void)openFile:(NSURL *)url
{
    //1.获取文件安全访问权限
    BOOL accessing = [url startAccessingSecurityScopedResource];
    
    if(accessing){
        
        //2.通过文件协调器读取文件地址
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        [fileCoordinator coordinateReadingItemAtURL:url
                                            options:NSFileCoordinatorReadingWithoutChanges
                                              error:nil
                                         byAccessor:^(NSURL * _Nonnull newURL) {
                                             
                                             //3.读取文件协调器提供的新地址里的数据
                                             NSString *fileName = [newURL lastPathComponent];
                                             NSString *contStr = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:nil];
                                             
                                             NSLog(@" 获取地址数据 ==== %@",contStr);
                                             //4.把数据保存在本地缓存
                                             [self saveLocalCachesCont:contStr fileName:fileName];
                                             
                                         }];
        
    }
    
    //6.停止安全访问权限
    [url stopAccessingSecurityScopedResource];
}

//把文件保存在本地缓存
- (BOOL)saveLocalCachesCont:(NSString *)cont fileName:(NSString *)fileName
{
    NSString *filePath = [CachesFilePath stringByAppendingPathComponent: fileName];
    return [cont writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
