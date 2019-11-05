//
//  XXGLView.h
//  XXMediaPlayer
//
//  Created by viper on 2019/11/2.
//  Copyright © 2019 viper. All rights reserved.
//

/**
 基于OpenGL的显示范围
 */
#import <UIKit/UIKit.h>
#import "XXDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXGLView : UIView

- (id)initWithFrame:(CGRect)frame decoder:(XXDecoder *)decoder;

- (void)render:(XXVideoFrame *)frame;

@end

NS_ASSUME_NONNULL_END
