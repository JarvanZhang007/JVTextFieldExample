//
//  ViewController.m
//  JVTextFieldExample
//
//  Created by Jarvan on 2017/3/29.
//  Copyright © 2017年 Jarvan. All rights reserved.
//

#import "ViewController.h"
#import "JVTextField.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet JVTextField *textField1;
@property (weak, nonatomic) IBOutlet JVTextField *textField2;
@property (weak, nonatomic) IBOutlet JVTextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.moveView=self.view;
    self.textField1.moveView=self.view;
    self.textField2.moveView=self.view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushNextViewController:(UIButton *)sender {
//     跳转到下一页之前 要关闭键盘，不然出现 keyboardToolBar不能隐藏的问题
    [self.view endEditing:YES];
    
    UIViewController *vc=[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor greenColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)dealloc{
    NSLog(@"当前被释放了 dealloc");
}

@end
