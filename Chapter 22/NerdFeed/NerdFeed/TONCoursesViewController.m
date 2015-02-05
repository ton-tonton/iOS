//
//  TONCoursesViewController.m
//  NerdFeed
//
//  Created by manit on 4/2/2558.
//  Copyright (c) พ.ศ. 2558 pddk. All rights reserved.
//

#import "TONCoursesViewController.h"
#import "TONWebViewController.h"

@interface TONCoursesViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation TONCoursesViewController

#pragma mark - initail

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.navigationItem.title = @"Courses";
        
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:conf
                                                 delegate:self
                                            delegateQueue:nil];
        
        [self fetchFeed];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [self.courses count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    NSDictionary *course = self.courses[indexPath.row];
    
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *url = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.url = url;
    self.webViewController.navigationItem.title = course[@"title"];
    
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

#pragma mark - web communicate

-(void)fetchFeed
{
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =[self.session dataTaskWithRequest:request
                                                     completionHandler:
            ^(NSData *data, NSURLResponse *response, NSError *err) {
                                          
                NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:nil];
                self.courses = jsonObj[@"courses"];
                NSLog(@"%@", self.courses);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
    
    [dataTask resume];
}

-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch"
                                                       password:@"AchieveNerdvana"
                                                    persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

@end
