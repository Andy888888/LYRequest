//
//  ViewController.m
//  testDownload
//
//  Created by Leon on 14-12-12.
//  Copyright (c) 2014年 __FULLNAME__. All rights reserved.
//

#import "ViewController.h"
#import "LYRequest.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet   UILabel        *label;
- (IBAction)uploadClick:(id)sender;
- (IBAction)downloadClick:(id)sender;
- (IBAction)getRequest:(id)sender;
- (IBAction)postRequest:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadClick:(id)sender{
    LYRequest *request = [LYRequest shareInstance];
    NSURL *url = [NSURL URLWithString:@"http://115.29.249.23:8081/Receive.ashx?operation=fqsp"]; // your fileupload address
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_1710.JPG" ofType:nil];
    NSDictionary *params = @{@"approvalid":@"9",
                             @"approvalname":@"ok",
                             @"categoryid":@"2",
                             @"contents":@"Try",
                             @"title":@"Leon",
                             @"userid":@"260",
                             @"username":@"admin",
                             @"workname":@"WorkApproval"};
    
    [request uploadWithURL:url filename:@"IMG_1710.JPG" params:params filePath:path progress:^(float progress) {
        self.label.text = [NSString stringWithFormat:@"%d%%",(int)progress];
    } finish:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result =%@", result);
    } error:^(NSURLConnection *connection, NSError *error) {
        NSLog(@"error");
    }];
}

- (IBAction)downloadClick:(id)sender{
    LYRequest *request = [LYRequest shareInstance];
    NSURL *url = [NSURL URLWithString:@"https://d.alipayobjects.com/sec/edit/beta/wkaliedit.dmg"];
    [request downloadWithURL:url progressBlock:^(float progress) {
        self.label.text = [NSString stringWithFormat:@"%d%%",(int)progress];
    } finishBlock:^(NSData *data) {
        NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:[url lastPathComponent]];
        [data writeToFile:filePath atomically:YES];
    } errorBlock:^(NSURLConnection *connection, NSError *error) {
        NSLog(@"error");
    }];    
}

- (IBAction)getRequest:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://114.215.101.94:83/service/ads.php?type=1&flag=1"];
    LYRequest *request = [LYRequest shareInstance];
    [request requestWithURL:url
                     params:nil
                     method:@"get"
                   useCache:NO
                finishBlock:^(NSData *data) {
                    id obj = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
                    NSLog(@"%@", obj);
                } errorBlock:^(NSURLConnection *connection, NSError *error) {
                    NSLog(@"error");
                }];
}

- (IBAction)postRequest:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://114.215.101.94:83/service/ads.php"];
    NSDictionary *dict = @{@"type":@"1", @"flag":@"1"};
    LYRequest *request = [LYRequest shareInstance];
    [request requestWithURL:url
                     params:dict
                     method:@"post"
                   useCache:NO
                finishBlock:^(NSData *data) {
                    id obj = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
                    NSLog(@"%@", obj);
                } errorBlock:^(NSURLConnection *connection, NSError *error) {
                    NSLog(@"error");
                }];
}


- (NSString*) getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path =%@",paths);
    return paths[0];
}
@end
