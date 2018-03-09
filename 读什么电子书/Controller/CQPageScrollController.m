//
//  CQPageViewController.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPageScrollController.h"
#import "CQScrollView.h"
#import "CQReadViewController.h"
#import "CQCatalogViewController.h"
#import "CQTopMenuView.h"
#import "CQBottomMenuView.h"
#import "CQColorMenuView.h"
#import "CQReadParser.h"
#import "CQMainViewController.h"
#import "ReadModel+CoreDataClass.h"
#import "ChapterModel+CoreDataClass.h"
#import "RecorderModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import "CQPageModel.h"
#import "CQFrameSetterParser.h"
#import "CQPraserText.h"
#import "CQPraserEpub.h"
#import "CQThemeConfig.h"

typedef enum : NSUInteger {
    ScrollChapterNodeDefault = 0,
    ScrollChapterNodeLeft = 1,
    ScrollChapterNodeRight = 2,
} ScrollChapterNode;

@interface CQPageScrollController ()<CQScrollViewDelegate,UIGestureRecognizerDelegate,CQReadViewControllerDelegate,CQCatalogViewControllerDelegate, CQTopMenuViewDelegate, CQBottomMenuViewDelegate, CQColorMenuViewDelegate>
@property(nonatomic,strong)CQScrollView *scrollView;
@property(nonatomic,strong)CQReadViewController *readViewController;
@property(nonatomic,strong)CQReadViewController *lastViewController;

@property(nonatomic,strong)CQBottomMenuView *bottomView;
@property(nonatomic,strong)CQTopMenuView *topView;
@property(nonatomic,strong)CQColorMenuView *colorView;
@property(nonatomic,strong)UIButton *nigthBtn;
@property(nonatomic,strong)ZoomAnimation *zoomAnimation;
@property(nonatomic,strong)CQCatalogViewController *catalogVC;

@property(nonatomic,assign)BOOL toolMenuHidden;
@property(nonatomic,assign)NSInteger currentSection;
@property(nonatomic,assign)NSInteger currentChapter;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL typeSetterFinished; // 重新布局是否完成
@property(nonatomic,strong)ReadModel *readModel;
@property(nonatomic,strong)ChapterModel *chapterModel;
@property(nonatomic,assign)ScrollChapterNode scrollChapterNode; // 滑到了章节的节点(scroll模式下的特殊标记)
@property(nonatomic,strong)NSArray *arrayPage;
@property(nonatomic,assign)CGFloat batteryLevel;

@end

@implementation CQPageScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupReadModelData];
    self.topView.title = @"电子书的标题";
}

#pragma mark -
#pragma mark - 初始化数据
- (void)setupReadModelData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getModelData];
        if (self.readModel.currentFontSize != [CQThemeConfig sharedInstance].fontSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeFontSize:.0];
            
                [self.zoomAnimation removeFromSuperview];
                self.zoomAnimation = nil;
            });
            
        } else {
            [self updateChapterWithChapterNum:self.currentChapter];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.typeSetterFinished = YES;

                self.scrollView.contentSize = CGSizeMake(self.readModel.pageCountForAll * kScreen_W, kScreen_H);
                self.readViewController = [self readViewControllerWithChapter:self.currentChapter withPage:self.currentPage pageCountForAll:self.readModel.pageCountForAll];
                CGFloat offsetX = (_chapterModel.chapterOffset + _currentPage) * kScreen_W;
                self.readViewController.view.x = offsetX;
                self.scrollView.contentOffset = CGPointMake(offsetX, 0);
                [self addChildViewController:self.readViewController];
                [self.scrollView addSubview:self.readViewController.view];
                
                [self.zoomAnimation removeFromSuperview];
                self.zoomAnimation = nil;
            });
        }
    });
}

- (void)getModelData {
    ReadModel *readModel;
    if (_indexPath.item == 0) {
        readModel = [CQReadUtilty queryReadModelWithUserID:@123 withBookID:@0];
        if (!readModel) {
            NSString *stringPath = [[NSBundle mainBundle] pathForResource:@"mdjyml" ofType:@"txt"];
            readModel = [CQPraserText insertReadModelWithUserID:@123 withBookID:@0 withBookName:@"鬼吹灯" withFilePath:stringPath];
            [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
        }
    } else {
        readModel = [CQReadUtilty queryReadModelWithUserID:@123 withBookID:@(_indexPath.item)];
        if (!readModel) {
            
            NSString *resource = [NSString stringWithFormat:@"epub%zd", _indexPath.item];
            NSString *stringPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"epub"];
            readModel =  [CQPraserEpub insertReadModelWithUserID:@123 withBookID:@(_indexPath.item) withBookName:@"清朝往事" withFilePath:stringPath];
            [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
        }
        
    }
    
    self.readModel = readModel;
    self.currentChapter = readModel.read_recoder.currentChapter;
    self.currentPage = readModel.read_recoder.currentPage;
}
- (CQReadViewController *)readViewControllerWithChapter:(NSUInteger)chapter withPage:(NSUInteger)page pageCountForAll:(NSUInteger)pageCountForAll {
    if (page > self.arrayPage.count - 1) { // 容错处理
        page = self.arrayPage.count - 1;
        self.currentPage = page;
        self.chapterModel.pageCountForChapter = page + 1;
        [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
    }
    CQReadViewController *readViewController = [[CQReadViewController alloc] init];
    readViewController.chapterModel = self.chapterModel;
    readViewController.pageModel = self.arrayPage[page];
    readViewController.chapter = chapter;
    readViewController.page = page;
    readViewController.pageCountForAll = self.typeSetterFinished ? pageCountForAll : 0;
    readViewController.delegate = self;
    readViewController.batteryLevel = self.batteryLevel;
    return readViewController;
}
#pragma mark -
#pragma mark - 重新分页
- (void)resetPaging {
    __weak typeof(self) weakSelf = self;
    [CQReadUtilty resetPagingWithReadModel:self.readModel completion:^(BOOL finished) {
        weakSelf.typeSetterFinished = YES;
//        weakSelf.readViewController.pageCountForAll = self.readModel.pageCountForAll;
//        [weakSelf.readViewController showLabIndex];
    }];

    [self updaterRecoderModelWithChapter:self.currentChapter withPage:_currentPage];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

//    self.currentChapter = indexPath.section;
//    self.currentPage = indexPath.row;
//    [self updaterRecoderModelWithChapter:indexPath.section withPage:indexPath.item];
//    NSLog(@"=========> %f, %@", scrollView.contentOffset.x, arr);
//    self.currentChapter = scrollView.contentOffset.x / scrollView.bounds.size.width;
//}
#pragma mark -
#pragma mark - 更新阅读记录
- (void)updaterRecoderModelWithChapter:(NSUInteger)chapter withPage:(NSUInteger)page {
    self.currentPage = page;
    self.currentChapter = chapter;
    self.readModel.read_recoder.currentChapter = chapter;
    self.readModel.read_recoder.currentPage = page;
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:nil];
}
#pragma mark -
#pragma mark - 更新章节
- (void)updateChapterWithChapterNum:(NSInteger)currentChapter {
    self.chapterModel = [CQReadUtilty queryChapterModelWithReadModel:self.readModel withChapter:currentChapter];
    NSAttributedString *attributedStr = [self getAttributeContentWithChapter:currentChapter];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
    self.arrayPage = [CQReadUtilty getPageArrayWithChapterModel:self.chapterModel withFrameSetter:frameSetter];
    CFRelease(frameSetter);
}

- (NSAttributedString *)getAttributeContentWithChapter:(NSInteger)chapter {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attributeTitle = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitle withContent:self.chapterModel.title];// 标题
    [attributedStr appendAttributedString:attributeTitle];
    
    if (self.chapterModel.chapter_cover) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@250, @"height", @170, @"width", nil];
        NSAttributedString *placeStr = [CQFrameSetterParser getPlaceholderStringWithDictionary:dict]; // 占位符
        [attributedStr appendAttributedString:placeStr];
    }
    if (self.chapterModel.titleH1.length) {
        NSAttributedString *attributeTitleH1 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH1 withContent:self.chapterModel.titleH1];// 副标题
        [attributedStr appendAttributedString:attributeTitleH1];
    }
    
    if (self.chapterModel.titleH2.length) {
        NSAttributedString *attributeTitleH2 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH2 withContent:self.chapterModel.titleH2];// 副标题
        [attributedStr appendAttributedString:attributeTitleH2];
    }
    
    NSAttributedString *attributeContent = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringDefault withContent:self.chapterModel.chapterContent];// 内容
    [attributedStr appendAttributedString:attributeContent];
    return attributedStr;
}
#pragma mark -
#pragma mark - NotificationObserver
- (void)deleteMarkObserver:(NSNotification *)noti {
    MarkModel *markModel = noti.object;
    NSPredicate *predicateTemp = [NSPredicate predicateWithFormat:@"currentChapter=%d&&currentPage=%d",markModel.currentChapter, markModel.currentPage];
    NSSet *markSetTemp = [self.readModel.read_mark filteredSetUsingPredicate:predicateTemp];
    
    if (self.currentChapter == markModel.currentChapter && markSetTemp.count <= 1) {
        CQPageModel *pageModel = self.arrayPage[markModel.currentPage];
        pageModel.markAdded = NO;
        if (markModel.currentPage == self.currentPage) {
//            [self.readViewController removeMark];
        }
    }
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext deleteObject:markModel];
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
    [_catalogVC reloadMarkData];
}
- (void)deleteNoteObserver:(NSNotification *)noti {
    
    NoteModel *noteModel = noti.object;
    
//    [self.readViewController drawReadViewWithNoteModel:noteModel];
    
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext deleteObject:noteModel];
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:nil];
    [_catalogVC reloadNoteData];
}

#pragma mark -
#pragma mark - CQCatalogViewControllerDelegate
- (void)openChapter:(NSInteger)chapter page:(NSInteger)page{
    [self updateChapterWithChapterNum:chapter];
    [self updaterRecoderModelWithChapter:chapter withPage:page];
}

#pragma mark -
#pragma mark - CQToolMenuViewDelegate
- (void)backButtonClicked {
//    CQMainViewController *mainVC = (CQMainViewController *)self.parentViewController;
//    mainVC.view.userInteractionEnabled = NO;
//    mainVC.imgView.hidden = NO;
//    [UIView animateWithDuration:OpenBookAnimationDuration animations:^{
//        CATransform3D pageViewTransform = CATransform3DIdentity;
//        pageViewTransform.m42 = -_transformY;
//        pageViewTransform.m41 = -_transformX;
//        self.view.layer.transform = CATransform3DScale(pageViewTransform, 1 / _scaleX, 1 / _scaleY, 1.0);
//        
//        mainVC.imgView.layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
//        [self removeFromParentViewController];
//        [self.view removeFromSuperview];
//        mainVC.imgView.hidden = YES;
//        mainVC.view.userInteractionEnabled = YES;
//    }];
}
- (void)toolMenuViewHidden {
    if ([self.delegate respondsToSelector:@selector(statusBarHiddenEvent:)]) {
        [self.delegate statusBarHiddenEvent:YES];
    }
}
- (void)marksButtonClicked:(UIButton *)sender {
    self.bottomView.markBtnEnble = NO;
    CQPageModel *pageModel = self.arrayPage[self.currentPage];
    pageModel.markAdded = YES;
    
    MarkModel *markModel =  [NSEntityDescription insertNewObjectForEntityForName:@"MarkModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    markModel.currentChapter = self.currentChapter;
    markModel.currentPage = self.currentPage;
    markModel.markTitle = self.chapterModel.title;
    markModel.location = pageModel.location;
    markModel.mark_chapter = self.chapterModel;
    markModel.mark_read = self.readModel;
    markModel.markContent = pageModel.pageContent;
    markModel.date = [NSDate date];
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
//    [self.readViewController addMark];
    [_catalogVC reloadMarkData];
}
- (void)chapterListButtonClicked {
    [self hiddenToolMenuViewAnimation:NO];
    [self addChildViewController:self.catalogVC];
    [self.catalogVC showAnimation];
}
- (void)changeThemeBackgroundColor {
    self.colorView.hidden = NO;
    self.nigthBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.nigthBtn.alpha = 1.0;
        self.bottomView.y = kScreen_H;
        self.colorView.y = kScreen_H - ColorMenuView_H;
    }];
}
- (void)fontButtonClicked:(UIButton *)sender {
    CGFloat fontSize = [[CQThemeConfig sharedInstance] getFontSizeWithTag:sender.tag];
    [CQThemeConfig sharedInstance].fontSize = fontSize;
    [self changeFontSize:fontSize];
}
- (void)colorButtonClicked:(UIButton *)sender {
    [CQThemeConfig sharedInstance].theme = sender.backgroundColor;
    if ([CQThemeConfig sharedInstance].isNight) {
        self.nigthBtn.selected = NO;
        [CQThemeConfig sharedInstance].isNight = NO;
    }
   [self changeCurrentPageColor];
}
- (void)nightButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [CQThemeConfig sharedInstance].isNight = sender.selected;
    [self changeCurrentPageColor];
}
- (void)changeCurrentPageColor {
    [self updateChapterWithChapterNum:self.currentChapter];
//    [self.pageViewController setViewControllers:@[[self readViewControllerWithChapter:self.currentChapter withPage:self.currentPage pageCountForAll:self.readModel.pageCountForAll]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    if ([CQThemeConfig sharedInstance].isNight) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [CQThemeConfig sharedInstance].theme;
    }
}
- (void)changeFontSize:(CGFloat)fontSize {
    self.typeSetterFinished = NO;
    self.chapterModel = [CQReadUtilty queryChapterModelWithReadModel:self.readModel withChapter:self.currentChapter];
    
    NSAttributedString *attributedStr = [self getAttributeContentWithChapter:self.currentChapter];
    CQPageModel *pageModel = self.arrayPage[self.currentPage];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
    self.arrayPage = [CQReadUtilty getPageArrayWithChapterModel:self.chapterModel withFrameSetter:frameSetter withPage:&_currentPage withLocation:pageModel.location];
    CFRelease(frameSetter);
    
    [self resetPaging];
}

#pragma mark -
#pragma mark - CQReadViewControllerDelegate
- (void)addNoteContentEvent:(NoteModel *)noteModel {
    noteModel.note_read = self.readModel;
    noteModel.note_chapter = self.chapterModel;
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
    [_catalogVC reloadNoteData];
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) return NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CQTopMenuView"]) return NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CQBottomMenuView"]) return NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CQColorMenuView"]) return NO;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) return NO;
    CGPoint touchPoint = [touch locationInView:self.view];
    if (!self.toolMenuHidden) {
        [self hiddenToolMenuViewAnimation:YES];
        return NO;
    }
    CGRect validRect = CGRectMake((self.view.width - 150.0) * 0.5, 0, 150.0, kScreen_H);
    if (CGRectContainsPoint(validRect, touchPoint)) return YES; 
    return NO;
}

#pragma mark -
#pragma mark - tapGestureRecognizer
- (void)tapGestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(statusBarHiddenEvent:)]) {
        [self.delegate statusBarHiddenEvent:!self.toolMenuHidden];
    }
//    self.bottomView.markBtnEnble = !self.readViewController.markShow;
    if (self.toolMenuHidden) {
        [self showToolMenuViewAnimation:YES];
    } else {
        [self hiddenToolMenuViewAnimation:YES];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)showToolMenuViewAnimation:(BOOL)animation {
    self.toolMenuHidden = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    [UIView animateWithDuration:animation ? 0.2 : .0 animations:^{
        self.topView.y = 0;
        self.bottomView.y = kScreen_H - BottomMenuView_H;
    }];
}
- (void)hiddenToolMenuViewAnimation:(BOOL)animation {
    self.toolMenuHidden = YES;
    [UIView animateWithDuration:animation ? 0.2 : .0 animations:^{
        self.topView.y = -TopMenuView_H;
        self.bottomView.y = kScreen_H;
        self.colorView.y = kScreen_H;
        self.nigthBtn.alpha = .0;
    }completion:^(BOOL finished) {
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.colorView.hidden = YES;
        self.nigthBtn.hidden = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(statusBarHiddenEvent:)]) {
        [self.delegate statusBarHiddenEvent:YES];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - 初始化页面
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([CQThemeConfig sharedInstance].isNight) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [CQThemeConfig sharedInstance].theme;
    }
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.colorView];
    [self.view addSubview:self.nigthBtn];
    [self.view addSubview:self.zoomAnimation];
    [self.zoomAnimation startAnimation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMarkObserver:) name:DeleteMarkNotification_Key object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNoteObserver:) name:DeleteNoteNotification_Key object:nil];
    
    [self setBatteryLevel];
}
- (void)setBatteryLevel {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryLevelDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
//        weakSelf.batteryLevel = device.batteryLevel;
//        [weakSelf.readViewController setBatteryLevel:weakSelf.batteryLevel];
    }];
    self.batteryLevel = device.batteryLevel;
}
- (CQScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[CQScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H)];
        _scrollView.scrollDelegate = self;
    }
    return _scrollView;
}
- (CQTopMenuView *)topView {
    if (!_topView) {
        _topView = [[CQTopMenuView alloc] initWithFrame:CGRectMake(0, -TopMenuView_H, kScreen_W, TopMenuView_H)];
        _topView.delegate = self;
        _topView.hidden = YES;
        _toolMenuHidden = YES;
    }
    return _topView;
}
- (CQBottomMenuView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CQBottomMenuView alloc] initWithFrame:CGRectMake(0, kScreen_H, kScreen_W, BottomMenuView_H)];
        _bottomView.delegate = self;
        _bottomView.hidden = YES;
    }
    return _bottomView;
}
- (CQColorMenuView *)colorView {
    if (!_colorView) {
        _colorView = [[CQColorMenuView alloc] initWithFrame:CGRectMake(0, kScreen_H, kScreen_W, ColorMenuView_H)];
        _colorView.hidden = YES;
        _colorView.delegate = self;
    }
    return _colorView;
}
- (ZoomAnimation *)zoomAnimation {
    if (!_zoomAnimation) {
        _zoomAnimation = [[ZoomAnimation alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H)];
    }
    return _zoomAnimation;
}
- (CQCatalogViewController *)catalogVC {
    if (!_catalogVC) {
        _catalogVC = [[CQCatalogViewController alloc] init];
        _catalogVC.model = self.readModel;
        _catalogVC.catalogDelegate = self;
        [self.view addSubview:_catalogVC.view];
    }
    return _catalogVC;
}
- (UIButton *)nigthBtn {
    if (!_nigthBtn) {
        CGFloat nightW = 50.0;
        _nigthBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_W - nightW - 15.0, kScreen_H - ColorMenuView_H - nightW -10.0, nightW, nightW)];
        _nigthBtn.backgroundColor = [UIColor blackColor];
        [_nigthBtn addTarget:self action:@selector(nightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([CQThemeConfig sharedInstance].isNight) {
            _nigthBtn.selected = YES;
        }
        
        [_nigthBtn setTitle:@"夜" forState:UIControlStateNormal];
        [_nigthBtn setTitle:@"白" forState:UIControlStateSelected];
        _nigthBtn.layer.cornerRadius = nightW * 0.5;
        _nigthBtn.layer.masksToBounds = YES;
        _nigthBtn.alpha = .0;
        _nigthBtn.hidden = YES;
    }
    return _nigthBtn;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"ddddddddd");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
