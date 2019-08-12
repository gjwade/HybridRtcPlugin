//
//  UpdateNameViewController.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/10.
//

#import "UpdateNameViewController.h"

@interface UpdateNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation UpdateNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

-(void)initialSetup {
    self.title = @"修改群名称";
    [self addRightBtn];
}

- (void)addRightBtn {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)saveButtonClick {
    NSLog(@"saveButtonClick---");
    if ([self isBlankString:self.nameTextField.text]) {
        [self alertVcShowWithTitle:@"提示" message:@"输入字符不能为空" handler:nil];
        return;
    }
    if (self.nameTextField.text.length > 15) {
        [self alertVcShowWithTitle:@"提示" message:@"输入字符不能超过15个字符" handler:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(updateNameViewController:saveButtonDidClick:)]) {
        [self.delegate updateNameViewController:self saveButtonDidClick:self.nameTextField.text];
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)isBlankString: (NSString *)object {
    if (object == nil || object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (void)alertVcShowWithTitle: (NSString *)title message: (NSString *)message handler:(void(^)(UIAlertAction *))action {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: action]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
