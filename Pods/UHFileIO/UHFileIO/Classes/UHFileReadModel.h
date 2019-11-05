//
//  UHFileReadModel.h
//  UHFileIO_Example
//
//  Created by macRong on 2019/5/9.
//  Copyright © 2019 MacRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHFileType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UHFileReadModel : NSObject

///根据业务去查找文件 文件名
@property (nonatomic, copy) NSString *fileName;
///业务名
@property (nonatomic, assign) UHFileType fileType;


@end

NS_ASSUME_NONNULL_END

/**
 具体业务模块，待项目稳定明确后在定
 
 */
