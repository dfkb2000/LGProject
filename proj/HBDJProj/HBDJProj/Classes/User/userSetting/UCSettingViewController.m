//
//  UCSettingViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCSettingViewController.h"
#import "UCSettingModel.h"
#import "UCSettingTableViewCell.h"

static NSString * const settingCell = @"UCSettingTableViewCell";

@interface UCSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) UIButton *logOut;
@property (strong,nonatomic) NSArray *array;
@end

@implementation UCSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [_tableView registerNib:[UINib nibWithNibName:settingCell bundle:nil] forCellReuseIdentifier:settingCell];
//    [_tableView registerClass:[UCSettingTableViewCell class] forCellReuseIdentifier:settingCell];
    
    // UCSetting.pilst
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 200, 0)];
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 313;
    UIButton *logOut = [[UIButton alloc] initWithFrame:
                        CGRectMake((kScreenWidth - buttonWidth) * 0.5,
                                   CGRectGetMaxY(_tableView.frame) -  buttonHeight,
                                   buttonWidth,
                                   buttonHeight)];
    [_tableView addSubview:logOut];
    [logOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logOut.titleLabel.font = [UIFont systemFontOfSize:24];
    [logOut addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    _logOut = logOut;
    
    self.array = [UCSettingModel loadLocalPlist];
    
    [self.tableView reloadData];
    
}
- (void)logOut:(id)sender{
    NSLog(@"退出邓丽 -- ");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCSettingModel *model = _array[indexPath.row];
    UCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end