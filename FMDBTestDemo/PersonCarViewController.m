//
//  PersonViewController.m
//  FMDBTestDemo
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PersonCarViewController.h"
#import "Person.h"
#import "Car.h"
#import "DataBase.h"

@interface PersonCarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *carArray;

@end

@implementation PersonCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.title = [NSString stringWithFormat:@"%@的所有车",self.person.name];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCar)];
    self.carArray = [[DataBase sharedDataBase ] getAllCarsFromPerson:self.person];

    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Car *car = self.carArray[indexPath.row];
    
    cell.textLabel.text = car.brand;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price: ￥%ld " ,car.price];
    return cell;
}

/**
 *  设置删除按钮
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        Car *car = self.carArray[indexPath.row];
        
        NSLog(@"car.id--%@,own_id--%@",car.car_id,car.own_id);
        [[DataBase sharedDataBase] deleteCar:car fromPerson:self.person];
        
        
        self.carArray = [[DataBase sharedDataBase] getAllCarsFromPerson:self.person];
        
        [self.tableView reloadData];
        
        
    }
    
}

/*改变删除按钮的title*/

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)addCar{
    NSLog(@"添加车辆");
    
    Car *car = [[Car alloc] init];
    car.own_id = self.person.ID;
    
    NSArray *brandArray = [NSArray arrayWithObjects:@"大众",@"宝马",@"奔驰",@"奥迪",@"保时捷",@"兰博基尼", nil];
    NSInteger index = arc4random_uniform((int)brandArray.count);
    car.brand = [brandArray objectAtIndex:index];
    
    car.price = arc4random_uniform(1000000);
    
    [[DataBase sharedDataBase] addCar:car toPerson:self.person];
    
    self.carArray = [[DataBase sharedDataBase] getAllCarsFromPerson:self.person];
    
    [self.tableView reloadData];
    
}

#pragma mark - Getter
- (NSMutableArray *)carArray{
    if (!_carArray) {
        _carArray = [[NSMutableArray alloc] init];
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
