//
//  CarViewController.m
//  FMDBTestDemo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CarViewController.h"
#import "DataBase.h"
#import "Person.h"
#import "Car.h"

@interface CarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView    *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *carArray;

@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车库";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.dataArray = [[DataBase sharedDataBase] getAllPerson];
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        Person *person = self.dataArray[i];
        NSMutableArray *carArray =  [[DataBase sharedDataBase] getAllCarsFromPerson:person];
        [self.carArray addObject:carArray];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *carArray = self.carArray[section];
    return carArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableArray *carArray = self.carArray[indexPath.section];
    Car *car = carArray[indexPath.row];
    cell.textLabel.text = car.brand;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price $ %ld",car.price];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    Person *person = self.dataArray[section];
    NSLog(@"name--%@",person.name);
    label.text = [NSString stringWithFormat:@"%@ 的所有车",person.name];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

/**
 *  设置删除按钮
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        NSMutableArray *carArray = self.carArray[indexPath.section];
        
        Car *car = carArray[indexPath.row];
        
        Person *person = self.dataArray[indexPath.section];
        
        
        NSLog(@"car.id--%@,own_id--%@",car.car_id,car.own_id);
        
        [[DataBase sharedDataBase] deleteCar:car fromPerson:person];
        
        self.dataArray = [[DataBase sharedDataBase] getAllPerson];
        
        self.carArray = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < self.dataArray.count; i++) {
            Person *person = self.dataArray[i];
            NSMutableArray *carArray =  [[DataBase sharedDataBase] getAllCarsFromPerson:person];
            [self.carArray addObject:carArray];
            
        }
        
        [self.tableView reloadData];
        
    }
    
}

/*改变删除按钮的title*/

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

#pragma mark - Getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
    
}

- (NSMutableArray *)carArray{
    if (!_carArray) {
        _carArray = [[NSMutableArray alloc ] init];
    }
    return _carArray;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
