//
//  EditQuestionController.m
//  classesHome
//
//  Created by fawks96 on 16/10/20.
//  Copyright © 2016年 陈锦华. All rights reserved.
//

#import "EditQuestionController.h"
#import "SVProgressHUD.h"
#import "Question.h"
#import "Server.h"

@interface EditQuestionController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage *selectedImage;
}

@property (strong, nonatomic) IBOutlet UITextField *questionTf;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTV;
- (IBAction)onConfirm:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImageView:)];
    [_imageView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)onTapImageView:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:NO];
    [self presentViewController:imagePicker
                                            animated:YES completion:^{
                                            }];
}

- (IBAction)onConfirm:(id)sender {
    if (!_questionTf.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写问题"];
        return;
    }
    if (!_descriptionTV.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写描述"];
        return;
    }
    
    Question *ques = [[Question alloc]init];
    ques.user = CURRENT_USER;
    ques.time = [NSDate date];
    ques.course = _course;
    ques.question = _questionTf.text;
    ques.image = selectedImage;
    ques.questionDetail = _descriptionTV.text;
    ques.answerArr = [NSMutableArray array];
    
    [DEFAULT_SERVER addQuestion:ques result:^(BOOL success, id resultObj, NSString *msg) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];
}


#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image = selectedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
