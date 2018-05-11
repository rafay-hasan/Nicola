//
//  ViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 4/30/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)skipButtonAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textViewHeight.constant = self.introTextView.contentSize.height;
    [self.view setNeedsLayout];
    self.scrollviewContainerHeight.constant = self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 16;
    [self.view setNeedsLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)skipButtonAction:(id)sender {
}
@end
