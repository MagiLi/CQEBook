//
//  CQReadView.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQReadView.h"
#import "CQMagnifierView.h"
#import "CQReadParser.h"
#import "UIImage+CQExtern.h"
#import "CQAppDelegate.h"
#import "CQNoteModel.h"

@interface CQReadView ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)CQMagnifierView *magnifierView;
@property(nonatomic,strong)NSMutableArray *arrayNotePath;
@property(nonatomic,strong)UIMenuController *menuController;
@property(nonatomic,weak)CQNoteModel *selNoteModel;
@end

@implementation CQReadView {
    NSRange _selectedRange;

    CGRect _leftRect;
    CGRect _rightRect;
    
    BOOL _selectState;
    BOOL _direction; //滑动方向  (0---左侧滑动 1 ---右侧滑动)
    
    CGRect _menuRect;
}
#pragma mark -
#pragma mark - longPressGestureRecognizer
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGesture {
    CGPoint touchPoint = [longPressGesture locationInView:self];
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        [self showMagnifierViewWithPoint:touchPoint];
        [self getTouchRectWithPoint:touchPoint];
    } else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        
        [self showMagnifierViewWithPoint:touchPoint];
        [self getTouchRectWithPoint:touchPoint];
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        
        [self hidenMagnifierView];
        [self showMenu];
    }
}
- (void)getTouchRectWithPoint:(CGPoint)touchPoint {
    CGRect rect = [CQReadParser praserRectInView:self atPoint:touchPoint selectedRange:&_selectedRange ctFrame:self.pageModel.ctFrame];
    if (!CGRectEqualToRect(rect, CGRectZero)) {
        _pathArray = @[NSStringFromCGRect(rect)];
        [self setNeedsDisplay];
    }

}
#pragma mark -
#pragma mark - panGestureRecognizer
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self];
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        [self showMagnifierViewWithPoint:point];
        if (_selectState) {
            NSArray *path = [CQReadParser parserRectsInView:self atPoint:point range:&_selectedRange ctFrame:self.pageModel.ctFrame paths:_pathArray direction:_direction];
            _pathArray = path;
            [self setNeedsDisplay];
        }
    }
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self hidenMagnifierView];
        [self showMenu];
        _selectState = NO;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_pathArray.count) {
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(_rightRect, point)||CGRectContainsPoint(_leftRect, point)) {
            if (CGRectContainsPoint(_leftRect, point)) {
                _direction = NO;   //从左侧滑动
            } else{
                _direction=  YES;    //从右侧滑动
            }
            _selectState = YES;
            return YES;
        }
        [self cancelEditState];
        return NO;
    }
    return NO;
}

- (void)cancelEditState {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    _pathArray = nil;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - showMenu
- (void)showMenu {
    if (!CGRectEqualToRect(_menuRect, CGRectZero)) {
        if (!self.arrayNotePath.count) {
            [self showMenuWithCancelNote:NO withCancelScribe:NO];
        } else {
            for (CQNoteModel *obj in self.arrayNotePath) {
                if ([obj.arrayPath isEqual:_pathArray]) {
                    if (obj.type == NoteTypeLine) {
                        [self showMenuWithCancelNote:NO withCancelScribe:YES];
                    } else {
                        [self showMenuWithCancelNote:YES withCancelScribe:NO];
                    }
                    self.selNoteModel = obj;
                    break;
                } else {
                    self.selNoteModel = nil;
                    [self showMenuWithCancelNote:NO withCancelScribe:NO];
                }
            }
        }
    }
}
-(void)showMenuWithCancelNote:(BOOL)cancelNote withCancelScribe:(BOOL)cancelScrible {
    if ([self becomeFirstResponder]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
        NSString *noteTitle = cancelNote ? @"取消笔记": @"笔记";
        UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:noteTitle action:@selector(menuNote:)];
        NSString *scribeTitle = cancelScrible ? @"取消划线": @"划线";
        UIMenuItem *menuItemScribe = [[UIMenuItem alloc] initWithTitle:scribeTitle action:@selector(menuScribe:)];
        
        NSArray *menus = @[menuItemCopy,menuItemNote,menuItemScribe];
        [menuController setMenuItems:menus];
        CGRect rect = CGRectMake(CGRectGetMinX(_menuRect), self.height - CGRectGetMaxY(_menuRect), CGRectGetWidth(_menuRect), CGRectGetHeight(_menuRect));
        [menuController setTargetRect:rect inView:self];
        if (cancelScrible || cancelScrible) {
            [menuController setMenuVisible:YES animated:NO];
        } else {
            [menuController setMenuVisible:YES animated:YES];
        }
        self.menuController = menuController;
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(void)menuCopy:(id)sender {
    NSString *selectedString = [self.pageModel.pageContent substringWithRange:NSMakeRange(_selectedRange.location - self.pageModel.location, _selectedRange.length)];
//    NSString *selectedString = [self.chapterContent substringWithRange:_selectedRange];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:selectedString];
    if (selectedString.length) {
        [self showAlertTitle:@"复制内容" content:selectedString];
    }
}
-(void)menuNote:(UIMenuController *)sender {
    UIMenuItem *menuItem = sender.menuItems[1];
    if ([menuItem.title isEqualToString:@"取消笔记"]) {
        [self cancelNoteEdit];
    } else {
//        NSString *selectedString = [self.chapterContent substringWithRange:_selectedRange];
        NSString *selectedString = [self.pageModel.pageContent substringWithRange:NSMakeRange(_selectedRange.location - self.pageModel.location, _selectedRange.length)];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"笔记" message:selectedString  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入内容";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDate *currentDate = [NSDate date];
            NoteModel *noteModel = [NSEntityDescription insertNewObjectForEntityForName:@"NoteModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
            noteModel.currentPage = self.pageModel.currentPageForChapter;
            noteModel.currentChapter = self.chapter;
            noteModel.noteTitle = alertController.textFields.firstObject.text;
            noteModel.noteContent = selectedString;
            noteModel.location = _selectedRange.location;
            noteModel.length = _selectedRange.length;
            noteModel.type = NoteTypeRect;
            noteModel.date = currentDate;
            if ([self.delegate respondsToSelector:@selector(addNoteContentBtnClicked:)]) {
                [self.delegate addNoteContentBtnClicked:noteModel];
            }
            
            CQNoteModel *notePathModel = [[CQNoteModel alloc] init];
            notePathModel.type = NoteTypeRect;
            notePathModel.arrayPath = _pathArray;
            notePathModel.noteContent = selectedString;
            notePathModel.location = _selectedRange.location;
            notePathModel.currentPage = self.pageModel.currentPageForChapter;
            [self.arrayNotePath addObject:notePathModel];
            _pathArray = nil;
            [self setNeedsDisplay];
        }];
        [alertController addAction:cancel];
        [alertController addAction:conform];
        
        for (UIView *nextView = [self superview]; nextView; nextView = nextView.superview) {
            UIResponder *nextResponder = [nextView nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                [(UIViewController *)nextResponder presentViewController:alertController animated:YES completion:nil];
                break;
            }
        }
    }
}
- (void)cancelNoteEdit {
    for (NoteModel *noteModel in _noteModelSet) {
        if (noteModel.currentPage == self.selNoteModel.currentPage && noteModel.location == self.selNoteModel.location && noteModel.noteContent == self.selNoteModel.noteContent&& noteModel.type == self.selNoteModel.type) {
            _pathArray = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:DeleteNoteNotification_Key object:noteModel];
            break;
        }
    }
}
- (void)menuScribe:(UIMenuController *)sender {
    UIMenuItem *menuItem = [sender.menuItems lastObject];
    if ([menuItem.title isEqualToString:@"取消划线"]) {
        [self cancelNoteEdit];
    } else {
//        NSString *selectedString = [self.chapterContent substringWithRange:_selectedRange];
        NSString *selectedString = [self.pageModel.pageContent substringWithRange:NSMakeRange(_selectedRange.location - self.pageModel.location, _selectedRange.length)];
        NSDate *currentDate = [NSDate date];
        
        NoteModel *noteModel = [NSEntityDescription insertNewObjectForEntityForName:@"NoteModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
        noteModel.currentPage = self.pageModel.currentPageForChapter;
        noteModel.currentChapter = self.chapter;
        noteModel.noteContent = selectedString;
        noteModel.location = _selectedRange.location;
        noteModel.length = _selectedRange.length;
        noteModel.type = NoteTypeLine;
        noteModel.date = currentDate;
        if ([self.delegate respondsToSelector:@selector(addNoteContentBtnClicked:)]) {
            [self.delegate addNoteContentBtnClicked:noteModel];
        }
        
        CQNoteModel *notePathModel = [[CQNoteModel alloc] init];
        notePathModel.type = NoteTypeLine;
        notePathModel.arrayPath = _pathArray;
        notePathModel.noteContent = selectedString;
        notePathModel.location = _selectedRange.location;
        notePathModel.currentPage = self.pageModel.currentPageForChapter;
        [self.arrayNotePath addObject:notePathModel];
        _pathArray = nil;
        [self setNeedsDisplay];    
    }
}

#pragma mark -
#pragma mark - 绘制选中区域
-(void)drawSelectedPath:(NSArray *)array LeftDot:(CGRect *)leftDot RightDot:(CGRect *)rightDot{
    NSInteger count = array.count;
    if (!count) return;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    
    if (array.count == 1) {
        _menuRect = CGRectFromString([array firstObject]);
    } else {
        CGRect firstRect = CGRectFromString([array firstObject]);
        CGRect lastRect = CGRectFromString([array lastObject]);
        _menuRect = CGRectMake(0, CGRectGetMinY(lastRect), self.width, CGRectGetMaxY(firstRect) - CGRectGetMinY(lastRect));
    }
    for (int i = 0; i < count; i++) {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, rect);

        if (i == 0) {
            *leftDot = rect;
        }
        if (i == [array count]-1) {
            *rightDot = rect;
        }
        CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(ctx, rect.size.width + rect.origin.x, rect.origin.y);
        [[UIColor purpleColor] set];
        CGContextStrokePath(ctx);
    }
    
    CGContextAddPath(ctx, _path);
    [[UIColor lightGrayColor] setFill];
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    
}
-(void)drawDotWithLeft:(CGRect)Left right:(CGRect)right {
    if (CGRectEqualToRect(CGRectZero, Left) || (CGRectEqualToRect(CGRectZero, right))) return;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat dotSize = 15;
    _leftRect = CGRectMake(CGRectGetMinX(Left)-dotSize, self.height-CGRectGetMaxY(Left)-dotSize-10.0, dotSize*2, dotSize + CGRectGetHeight(Left) + 10.0);
    _rightRect = CGRectMake(CGRectGetMaxX(right)-dotSize,self.height- CGRectGetMaxY(right), dotSize*2, dotSize + CGRectGetHeight(right) + 10.0);
    
    CGImageRef img = [[UIImage alloc] creatRadiusImage:CGSizeMake(dotSize, dotSize) strokeColor:[UIColor whiteColor] fillColor:[UIColor blueColor]].CGImage;
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMinX(Left)-dotSize/2 - 1, CGRectGetMaxY(Left)-dotSize/2 + 5, dotSize, dotSize),img);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMaxX(right)-dotSize/2 + 1, CGRectGetMinY(right)-dotSize/2 - 6, dotSize, dotSize),img);
    
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor blueColor] setFill];
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMinX(Left)-2.0, CGRectGetMinY(Left) - 0.5,2.0, CGRectGetHeight(Left) + 0.5));
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMaxX(right), CGRectGetMinY(right) - 1.0 , 2.0, CGRectGetHeight(right) + 1.0));
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}

- (void)drawNotePath {
    if (!_arrayNotePath.count) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    for (CQNoteModel *notePathModel in _arrayNotePath) {
        if (notePathModel.type == NoteTypeRect) {
            for (NSString *stringRect in notePathModel.arrayPath) {
                CGRect rect = CGRectFromString(stringRect);
                CGPathAddRect(_path, NULL, rect);
            }
        } else {
            for (NSString *stringRect in notePathModel.arrayPath) {
                CGRect rect = CGRectFromString(stringRect);
                CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
                CGContextAddLineToPoint(ctx, rect.size.width + rect.origin.x, rect.origin.y);
                [[UIColor purpleColor] set];
                CGContextStrokePath(ctx);
            }
        }
    }
    CGContextAddPath(ctx, _path);
    [[UIColor cyanColor] setFill];
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}
- (void)setNoteModelSet:(NSMutableSet *)noteModelSet {
    _noteModelSet = noteModelSet;
    [self.arrayNotePath removeAllObjects];
    if (noteModelSet.count) {
        for (NoteModel *noteModel in noteModelSet) {
            // ctFrame是否包含选中的笔记
            NSUInteger rightLocation = _pageModel.location + _pageModel.currentLength;
            NSUInteger selRightLocation = noteModel.location + noteModel.length;
            BOOL containLeft = noteModel.location >= _pageModel.location && noteModel.location < rightLocation;
            BOOL containRight = selRightLocation >= _pageModel.location && selRightLocation < rightLocation;
            if (containLeft||containRight) {
                NSArray *array = [CQReadParser praserRectsSelectedRange:NSMakeRange(noteModel.location, noteModel.length) ctFrame:self.pageModel.ctFrame];
                CQNoteModel *notePathModel = [[CQNoteModel alloc] init];
                notePathModel.type = noteModel.type;
                notePathModel.arrayPath = array;
                notePathModel.location = noteModel.location;
                notePathModel.noteContent = noteModel.noteContent;
                notePathModel.currentPage = noteModel.currentPage;
                [self.arrayNotePath addObject:notePathModel];
            }
        }
    }
}
- (void)needDrawReadViewWithNoteModel:(NoteModel *)noteModel {

    for (CQNoteModel *model in _arrayNotePath) {
        if ([model.noteContent isEqualToString:noteModel.noteContent]) {
            [_arrayNotePath removeObject:model];
            break;
        }
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    if (!self.pageModel.ctFrame) return;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    _menuRect = CGRectZero;
    CGRect leftDot = CGRectZero,rightDot = CGRectZero;
    [self drawSelectedPath:_pathArray LeftDot:&leftDot RightDot:&rightDot];
    [self drawNotePath];
    CTFrameDraw(self.pageModel.ctFrame, ctx);
    
    [self drawDotWithLeft:leftDot right:rightDot];
    
    // 绘制出图片
    if (self.pageModel.coverModel) {
        UIImage *image = [UIImage imageWithData:self.pageModel.coverModel.cover];
        if (image) {
            CGRect rect = CGRectFromString(self.pageModel.coverModel.stringRect);
            CGContextDrawImage(ctx, rect, image.CGImage);
        }
    }
}
- (void)showAlertTitle:(NSString *)title content:(NSString *)string {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
#pragma clang diagnostic pop
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [self addGestureRecognizer:longPressGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
    }
    return self;
}
- (void)showMagnifierViewWithPoint:(CGPoint)touchPoint
{
    if (!_magnifierView) {
        _magnifierView = [[CQMagnifierView alloc] init];
        _magnifierView.displayView = self;
        [self addSubview:_magnifierView];
    }
    self.magnifierView.touchPoint = touchPoint;
}

- (void)hidenMagnifierView
{
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}
- (NSMutableArray *)arrayNotePath {
    if (!_arrayNotePath) {
        _arrayNotePath = [NSMutableArray array];
    }
    return _arrayNotePath;
}
- (void)dealloc {
    NSLog(@"-----readView-------");
}
@end
