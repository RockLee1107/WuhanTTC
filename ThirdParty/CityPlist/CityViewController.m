//
//  CityViewController.m
//  CityPlist
//
//  Created by cty on 14-2-21.
//  Copyright (c) 2014年 cty. All rights reserved.
//
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#import "CityViewController.h"
#import "City.h"
#import "CityViewController.h"
#import "HandleCityData.h"
//引入global
#import "Global.h"
#import "LocationUtil.h"
#import "LocationCityTableViewCell.h"
#import "HotCityTableViewCell.h"
#import "LXButton.h"
#import "SVProgressHUD.h"

#define SEARCHBAR_HEIGHT    44.0
#define NAVIBAR_HEIGHT      64.0
#define TABBAR_HEIGHT       49.0
//额外的2组，对应于当前与热门
#define EXTRA_SECTION       2
@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initDataArray
{
    self.letters = [[NSMutableArray alloc] init];
    self.fixArray = [[NSMutableArray alloc] init];
    self.tempArray = [[NSMutableArray alloc] init];//search出来的数据存放
    self.ChineseCities = [[NSMutableArray alloc] init];
    HandleCityData * handle = [[HandleCityData alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray * cityInforArray = [handle cityDataDidHandled];
    [self.letters addObject:@"当前"];
    [self.letters addObject:@"热门"];
    [self.letters addObjectsFromArray:[cityInforArray objectAtIndex:0]];//存放所有section字母
    [self.fixArray addObjectsFromArray:[cityInforArray objectAtIndex:1]];//存放所有城市信息数组嵌入数组和字母匹配
    [self.ChineseCities addObjectsFromArray:[cityInforArray objectAtIndex:2]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD dismiss];
    //navi title
    self.navigationItem.title = @"切换城市";
    self.isSearch = NO;
    [self initDataArray];
    [self initSearchBar];
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT + SEARCHBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAR_HEIGHT - SEARCHBAR_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
	// Do any additional setup after loading the view.
}
#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT, CGRectGetWidth(self.view.bounds), SEARCHBAR_HEIGHT)];
    
    
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"输入城市名或拼音";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}
#pragma mark tableViewDelegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.letters.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.tempArray.count;
    }
    if (section < EXTRA_SECTION) {
        return 1;
    }
    NSArray * letterArray = [self.fixArray objectAtIndex:section - EXTRA_SECTION];//对应字母所含城市数组
    return letterArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    return [self.letters objectAtIndex:section];
}

//右侧组名
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.isSearch) {
        return 1;
    }
    return index;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch != YES) {
        if (indexPath.section == 0) {
            LocationCityTableViewCell *locationCell = [[[NSBundle mainBundle] loadNibNamed:@"LocationCityTableViewCell" owner:nil options:nil] firstObject];
            if ([LocationUtil getInstance].cityName == nil) {
                [locationCell.locationCityButton setTitle:@"定位失败" forState:(UIControlStateNormal)];
                locationCell.locationCityButton.userInteractionEnabled = NO;
            } else {
                [locationCell.locationCityButton setTitle:[LocationUtil getInstance].cityName forState:(UIControlStateNormal)];
                locationCell.locationCityButton.userInteractionEnabled = YES;
                [locationCell.locationCityButton addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            return locationCell;
        }
        if (indexPath.section == 1) {
            HotCityTableViewCell *hotCell = [[[NSBundle mainBundle] loadNibNamed:@"HotCityTableViewCell" owner:nil options:nil] firstObject];
            [hotCell.city1 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city2 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city3 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city4 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city5 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city6 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city7 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city8 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city9 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city10 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            [hotCell.city11 addTarget:self action:@selector(cityButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            return hotCell;
        }
    }
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    City * city;
    if (self.isSearch) {
        city = [self.tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
    }else{
        NSArray * letterArray = [self.fixArray objectAtIndex:indexPath.section - EXTRA_SECTION];//对应字母所含城市数组
        city = [letterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

//单击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < EXTRA_SECTION && self.isSearch == NO) {
        return;
    }
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [_delegete cityViewdidSelectCity:cell.textLabel.text anamation:YES];
    [LocationUtil getInstance].locatedCityName = cell.textLabel.text;

//    [self dismissViewControllerAnimated:YES completion:Nil];
    [self goBackHome];
}

//是否高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < EXTRA_SECTION && self.isSearch == NO) {
        return NO;
    }
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 238.0;
    }
    if (indexPath.section == 0) {
        return 50.0;
    }
    return 44.0;
}

#pragma mark searchBarDelegete
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tempArray removeAllObjects];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (City * city in self.ChineseCities) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [self.tempArray addObject:city];
            }else if (letters.location != NSNotFound){
                [self.tempArray addObject:city];
            }
        }
    }
    [self.table reloadData];
}

//点击搜索按钮即完成搜索
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}

//热门城市与当前城市点击共用
- (void)cityButtonPress:(UIButton *)sender {
    [LocationUtil getInstance].locatedCityName = [sender titleForState:(UIControlStateNormal)];
    [self goBackHome];
}

//navi跳转首页
- (void)goBackHome {
    [self.vc fillArea];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
