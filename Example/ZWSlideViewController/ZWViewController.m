//
//  ZWViewController.m
//  ZWSlideViewController
//
//  Created by square on 02/17/2016.
//  Copyright (c) 2015 square. All rights reserved.
//

#import "ZWViewController.h"

@interface ZWViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ZWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ZWSlideViewController";
}

- (void)loadData
{
    self.menuTitles = @[@"Drama", @"Family", @"Fantasy", @"Thriller", @"Horror", @"Comedy"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Style" style:UIBarButtonItemStyleDone target:self action:@selector(switchStyle:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Move" style:UIBarButtonItemStyleDone target:self action:@selector(moveManually:)];
}

#pragma mark - Events

- (void)switchStyle:(id)sender
{
    // if you have a asynchronous loading requests data to refresh the slide page
//    self.menuTitles = @[@"Drama", @"Family", @"Fantasy", @"Thriller", @"Horror", @"Comedy"];
    
    self.sectionBar.highlightedTextColor = [UIColor blueColor];
    self.sectionBar.textColor = [UIColor redColor];
    self.sectionBar.backgroundColor = [UIColor blackColor];
    self.sectionBar.indicatorHeight = 5.0f;
    self.menuHeight = 64.0f;
    
    self.useTransform3DEffects = YES;

    [self refreshViews];
}

- (void)moveManually:(id)sender
{
    [self.pagingView moveToPageAtFloatIndex:arc4random() % (self.menuTitles.count - 1) animated:YES];
}

#pragma mark - ZWSPagingViewDataSource

- (ZWSPage *)pagingView:(ZWSPagingView *)pagingView pageForIndex:(NSUInteger)index
{
    ZWSPage *page = [super pagingView:pagingView pageForIndex:index];
    return page;
}

- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:page.bounds];

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kCellIdentifier"];
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor colorWithRed:0.5 green:0.1*index blue:0.2*index alpha:1];
    
    return tableView;
}

// Example 2
//- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index
//{
//    UIView *view = [[UIView alloc] init];
//    
//    view.backgroundColor = [UIColor colorWithRed:0.5 green:0.1*index blue:0.2*index alpha:1];
//    
//    return view;
//}

//- (UIView *)menuItemWithTitle:(NSString *)title
//{
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
//    iv.image = [UIImage imageNamed:@"menu"];
//    return iv;
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"For Test......";
    
    return cell;
}

@end
