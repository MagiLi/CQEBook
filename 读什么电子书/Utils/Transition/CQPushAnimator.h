//
//  CQPushAnimator.h
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import "CQBaseAnimator.h"

@interface CQPushAnimator : CQBaseAnimator
@property (nonatomic, assign)CGRect imgViewFrame;
@property(nonatomic,weak)UIView *bigView;
@property(nonatomic,weak)UIImageView *imgView;
@end
