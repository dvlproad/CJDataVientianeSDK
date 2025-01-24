//
//  CQTSSandboxSimulateUtil.h
//  CQDemoKit
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQTSSandboxUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface CQTSSandboxSimulateUtil : NSObject

#pragma mark - Copy Bundle File
/// 拷贝主工程中的文件到沙盒中
///
/// @param fileNameWithExtension        要拷贝的文件
/// @param inBundle                                     从项目中的哪个bundle中拷贝（nil时候为 [NSBundle mainBundle] ）
/// @param sandboxType                               要放到的沙盒位置
/// @param subDirectory                             要放到的沙盒的子目录
///
/// @return 返回存放后的文件路径信息（存放失败，返回nil）
+ (nullable NSDictionary *)copyFile:(NSString *)fileNameWithExtension
                           inBundle:(nullable NSBundle *)bundle
                      toSandboxType:(CQTSSandboxType)sandboxType
                       subDirectory:(nullable NSString *)subDirectory;

@end

NS_ASSUME_NONNULL_END
