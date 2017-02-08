//
//  ViewController.m
//  FMDBTestDemo
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "DataBase.h"
#import "Person.h"
#import "Car.h"
#import "CarViewController.h"
#import "PersonCarViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView    *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame style: UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"车库" style:UIBarButtonItemStylePlain target:self action:@selector(watchCars)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataArray = [[DataBase sharedDataBase] getAllPerson];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Person *person = self.dataArray[indexPath.row];
    if (person.number == 0) {
        cell.textLabel.text = person.name;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@(第%ld次更新)",person.name, person.number];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"age: %ld",person.age];
    
    return cell;
}

/**
 *  设置删除按钮
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        Person *person = self.dataArray[indexPath.row];
        
        [[DataBase sharedDataBase] deletePerson:person];
        [[DataBase sharedDataBase] deleteAllCarsFromPerson:person];
        self.dataArray = [[DataBase sharedDataBase] getAllPerson];
        [self.tableView reloadData];
    }
}

/*改变删除按钮的title*/

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCarViewController *pcvc = [[PersonCarViewController alloc] init];
    pcvc.person = self.dataArray[indexPath.row];
    
    [self.navigationController pushViewController:pcvc animated:YES];

}

#pragma mark - Action
/**
 *  添加数据到数据库
 */
- (void)addData{
    
    NSLog(@"addData");
    
    int nameRandom = arc4random_uniform(1000);
    NSInteger ageRandom  = arc4random_uniform(100) + 1;
    
    NSString *name = [NSString stringWithFormat:@"person_%d号",nameRandom];
    NSInteger age = ageRandom;
    
    Person *person = [[Person alloc] init];
    person.name = name;
    person.age = age;
    
    
    [[DataBase sharedDataBase] addPerson:person];
    
    self.dataArray = [[DataBase sharedDataBase] getAllPerson];
    
    [self.tableView reloadData];
}

- (void)watchCars{
    
    CarViewController *carVc = [[CarViewController alloc] init];
    [self.navigationController pushViewController:carVc animated:YES];
}

#pragma mark - Getter
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
