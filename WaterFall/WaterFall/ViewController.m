//
//  ViewController.m
//  WaterFall
//
//  Created by 王阳阳 on 16/4/25.
//  Copyright © 2016年 王阳阳. All rights reserved.
//

#import "ViewController.h"
#import "ModelData.h"
#define kVIEWBOUNDS self.view.bounds.size
typedef enum:NSInteger {
    LEFT = 2000,
    RIGHT
}TABLEVIEW_TAG;
@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    CGFloat _currentHeight[2];
    NSMutableArray *_modelDataArr;
    NSMutableArray *_dataArr;
    UIScrollView *_bgScrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self createView];
    [self refreshData];
}
//初始化数据
- (void)initData{
    _currentHeight[0] = 0.f;
    _currentHeight[1] = 0.f;
    _modelDataArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i<100; i++) {
        ModelData *modelData = [[ModelData alloc] init];
        modelData.width = arc4random()%200+200;
        modelData.height = arc4random()%200+300;
        [_modelDataArr addObject:modelData];
        NSLog(@"23456789");
    }
    _dataArr = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
}
//创建界面
- (void)createView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    for (NSInteger i = 0; i<2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kVIEWBOUNDS.width/2, 0, kVIEWBOUNDS.width/2, kVIEWBOUNDS.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (0==i) {
            tableView.tag = LEFT;
            tableView.backgroundColor = [UIColor yellowColor];
        }else {
            tableView.tag = RIGHT;
            tableView.backgroundColor = [UIColor orangeColor];
        }
        [scrollView addSubview:tableView];
    }
    _bgScrollView = scrollView;
}
//刷新数据
- (void)refreshData {
    for (NSInteger i = 0; i<_modelDataArr.count; i++) {
        NSInteger  index = _currentHeight[0]<=_currentHeight[1]?0:1;
        
        ModelData *modeData = _modelDataArr[i];
        CGFloat  widthPic = modeData.width;
        CGFloat  height = modeData.height;
        height = (145/widthPic) *height;
        CGFloat currentHeight = _currentHeight[index];
        currentHeight +=height+10;
        _currentHeight[index] = currentHeight;
        [_dataArr[index] addObject:@(i)];
    }
    CGFloat maxHeight = _currentHeight[0]<_currentHeight[1]?_currentHeight[1]:_currentHeight[0];
    _bgScrollView.contentSize = CGSizeMake(0, maxHeight+200);
    for (NSInteger i = 0; i<2; i++) {
        UITableView *table = [_bgScrollView viewWithTag:2000+i];
        if (maxHeight<table.contentSize.height) {
            maxHeight = table.contentSize.height;
        }
        [table reloadData];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView *leftTable = [scrollView viewWithTag:LEFT];
    UITableView *rightTable = [scrollView viewWithTag:RIGHT];
    leftTable.contentOffset = scrollView.contentOffset;
    rightTable.contentOffset = scrollView.contentOffset;
    CGFloat width = kVIEWBOUNDS.width;
    CGFloat  height = kVIEWBOUNDS.height;
    leftTable.center = CGPointMake(width/4, leftTable.contentOffset.y+height/2);
    rightTable.center = CGPointMake(width*3/4.0, rightTable.contentOffset.y+height/2);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = (tableView.tag==LEFT)?LEFT:RIGHT;
    NSArray *arr = _dataArr[index-2000];
    if (arr.count !=0) {
        return arr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = (tableView.tag==LEFT)?LEFT:RIGHT;
    NSArray *arr = _dataArr[index-2000];
    if (arr.count !=0) {
        NSNumber *num = arr[indexPath.row];
        ModelData *data = _modelDataArr[num.intValue];
        CGFloat widthPic = data.width;
        CGFloat heightPic = data.height;
        heightPic = 145 *heightPic/widthPic;
        return heightPic+10;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        UIView *view = [cell viewWithTag:1000];
        [view removeFromSuperview];
    }
    NSInteger  index = (tableView.tag==LEFT)?LEFT:RIGHT;
    NSArray *arr = _dataArr[index - 2000];
    if (arr.count !=0) {
        NSNumber *num = arr[indexPath.row];
        ModelData *data = _modelDataArr[num.intValue];
        if (data) {
            CGFloat width = data.width;
            CGFloat height = data.height;
            height = 145*height/width;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 135, height)];
            view.tag = 1000;
            view.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:view];
        }
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
