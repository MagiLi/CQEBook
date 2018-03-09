//
//  CQCatalogViewController.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQCatalogViewController.h"
#import "CQChapterController.h"
#import "CQMarksController.h"
#import "CQNoteController.h"

@interface CQCatalogViewController ()<CQPagerViewControllerDataSource, CQChapterControllerDelegate, CQMarksControllerDelegate, CQNoteControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSArray *arrayTitle;
@property(nonatomic,strong)NSMutableArray *arrayVC;
@property(nonatomic,weak) CQNoteController *noteVC;
@property(nonatomic,weak) CQMarksController *marksVC;
@end

@implementation CQCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CQChapterController *chapterVC = [[CQChapterController alloc] init];
    chapterVC.readModel = self.model;
    chapterVC.chapterDelegate = self;
    [self.arrayVC addObject:chapterVC];
    CQNoteController *noteVC = [[CQNoteController alloc] initWithStyle:UITableViewStyleGrouped];
    noteVC.readModel = self.model;
    noteVC.noteDelegate = self;
    self.noteVC = noteVC;
    [self.arrayVC addObject:noteVC];
    CQMarksController *marksVC = [[CQMarksController alloc] initWithStyle:UITableViewStyleGrouped];
    marksVC.readModel = self.model;
    marksVC.markDelegate = self;
    self.marksVC = marksVC;
    [self.arrayVC addObject:marksVC];

    self.dataSource = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAnimation)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (void)reloadMarkData {
    [self.marksVC setMarkData];
}
- (void)reloadNoteData {
    [self.noteVC setNoteData];
}
- (void)hiddenAnimation {
    self.alphaView.alpha = .0;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bigView.x = -self.bigView.width;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
    }];
}

- (void)showAnimation {
    self.view.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.bigView.x = 0;
        self.alphaView.alpha = 1.0;
    }];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (fabs(translation.x) > fabs(translation.y)) {
            if (translation.x >= 0) {
                self.bigView.x = .0;
                self.alphaView.alpha = 1.0;
            } else {
                self.bigView.x = translation.x;
                self.alphaView.alpha = 1.0 + translation.x / 50.0;
            }
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.bigView.x < -50.0) {
            [self hiddenAnimation];
        } else {
            [self showAnimation];
        }
    } else if (panGesture.state == UIGestureRecognizerStateCancelled) {
        if (self.bigView.x < -50.0) {
            [self hiddenAnimation];
        } else {
            [self showAnimation];
        }
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) return NO;
    return YES;
}
#pragma mark -
#pragma mark - CQChapterControllerDelegate
- (void)chapterDidSelectedChapter:(NSInteger)chapter page:(NSInteger)page{
    [self hiddenAnimation];
    if ([self.catalogDelegate respondsToSelector:@selector(openChapter:page:)]) {
        [self.catalogDelegate openChapter:chapter page:page];
    }
}
#pragma mark -
#pragma mark - CQMarksControllerDelegate
- (void)markDidSelectedChapter:(NSInteger)chapter page:(NSInteger)page {
    [self chapterDidSelectedChapter:chapter page:page];
}

#pragma mark -
#pragma mark - CQNoteControllerDelegate
- (void)noteDidSelectedChapter:(NSInteger)chapter page:(NSInteger)page {
    [self chapterDidSelectedChapter:chapter page:page];
}

#pragma mark -
#pragma mark - CQPagerViewControllerDataSource
- (NSInteger)numberOfViewControllers {
    return self.arrayTitle.count;
}
-(NSString *)pagerViewController:(CQPagerViewController *)pagerViewController withTitleIndex:(NSInteger)index {
    return self.arrayTitle[index];
}
- (UIViewController *)pagerViewController:(CQPagerViewController *)pagerViewController withViewControllerIndex:(NSInteger)index {
    return self.arrayVC[index];
}


- (NSArray *)arrayTitle {
    if (!_arrayTitle) {
        _arrayTitle = @[@"目录",@"笔记",@"书签"];
    }
    return _arrayTitle;
}
- (NSMutableArray *)arrayVC {
    if (!_arrayVC) {
        _arrayVC = [NSMutableArray array];
    }
    return _arrayVC;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
