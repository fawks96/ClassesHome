//
//  personDataController.m
//  classesHome
//
//  Created by fawks96 on 16/3/23.
//  Copyright © 2016年 fawks96. All rights reserved.
//

#import "personDataController.h"
#import "testViewController.h"
@interface personDataController ()

@end

@implementation personDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *str1 = [NSString stringWithFormat:@"section:%d",indexPath.section];
   // NSString *str2 = [NSString stringWithFormat:@"row:%d",indexPath.row];
   if (indexPath.section == 1)
   {
       if (indexPath.row == 0) {
           UIViewController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"MyMaterialViewController"];
           [self.navigationController pushViewController:vc animated:YES];
       }else if (indexPath.row == 1){
           UIViewController *vc = [[UIStoryboard storyboardWithName:@"Sub" bundle:nil] instantiateViewControllerWithIdentifier:@"MyScoreRecordViewController"];
           [self.navigationController pushViewController:vc animated:YES];
       }
   }else if (indexPath.section == 3){
       
   }
 //else if (indexPath.section ==  && indexPath)
}


@end
