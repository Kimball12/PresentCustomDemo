//
//  ViewController.m
//  PresentCustomDemo
//
//  Created by 韩金波 on 15/10/30.
//  Copyright © 2015年 Psylife. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "KBTranslation.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property(nonatomic,copy)KBTranslation *trans;
@end

@implementation ViewController

-(KBTranslation *)trans{
    if (!_trans) {
        _trans=[[KBTranslation alloc] initWithView:_btnView];
    }
    return _trans;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btrnclick:(id)sender {
    SecondViewController *secondVC=[[SecondViewController alloc] initWithNibName:nil bundle:nil];
    secondVC.transitioningDelegate=self;
    [self presentViewController:secondVC animated:YES completion:nil];
    [self performSelector:@selector(finishTransition) withObject:nil afterDelay:2];
}
- (void)finishTransition
{
    [self.trans stopAnimation];
}
#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.trans.reverse = YES;
    return self.trans;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    self.trans.reverse = NO;
    return self.trans;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
