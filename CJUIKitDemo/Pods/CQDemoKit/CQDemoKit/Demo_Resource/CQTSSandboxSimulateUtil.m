//
//  CQTSSandboxSimulateUtil.m
//  CQDemoKit
//
//  Created by lcQian on 2020/4/7.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "CQTSSandboxSimulateUtil.h"
#import "CQTSResourceUtil.h"

@implementation CQTSSandboxSimulateUtil

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
                       subDirectory:(nullable NSString *)subDirectory
{
    NSDictionary *result = [CQTSResourceUtil extractFileNameAndExtensionFromFileName:fileNameWithExtension];
    NSString *fileName = result[@"fileName"];
    NSString *fileExtension = result[@"fileExtension"];
    
    // 获取原始图片的路径
    if (bundle == nil) {
        bundle = [NSBundle mainBundle];
    }
    NSURL *imageURL = [bundle URLForResource:fileName withExtension:fileExtension];
    if (!imageURL) {
        NSLog(@"Image not found in bundle");
        return nil;
    }

    // 创建目标路径（共享资源目录下的目标文件路径）:相对路径
    NSString *relativePath = @"";
    if (subDirectory != nil && subDirectory.length > 0) {
        relativePath = subDirectory;
    }
    NSString *newFileName = [NSString stringWithFormat:@"%@.%@", fileName, fileExtension];
    relativePath = [relativePath stringByAppendingPathComponent:newFileName];
    // 绝对路径
    NSString *sandboxPath = [CQTSSandboxUtil sandboxPath:sandboxType];
    NSURL *sandboxURL = [NSURL fileURLWithPath:sandboxPath];
    NSURL *destinationURL = [sandboxURL URLByAppendingPathComponent:relativePath];

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 检查目标文件是否已存在，如果存在则删除它
    if ([fileManager fileExistsAtPath:destinationURL.path]) {
        if (![fileManager removeItemAtURL:destinationURL error:&error]) {
            NSLog(@"Failed to remove existing file: %@", error.localizedDescription);
            return nil;
        }
    }

    // 检查并创建目标路径的父目录（一次性创建所有中间目录）
    NSURL *parentDirectory = [destinationURL URLByDeletingLastPathComponent];
    if (![fileManager fileExistsAtPath:parentDirectory.path]) {
        if (![fileManager createDirectoryAtURL:parentDirectory
                   withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Failed to create directory: %@", error.localizedDescription);
            return nil;
        }
    }
    
    // 将图片从源目录复制到共享目录
    if (![fileManager copyItemAtURL:imageURL toURL:destinationURL error:&error]) {
        NSLog(@"Failed to copy file: %@", error.localizedDescription);
        return nil;
    }

    NSLog(@"File copied to shared directory: %@", destinationURL.path);
    return @{
        @"fileName": fileName,
        @"fileExtension": fileExtension,
        @"absoluteFilePath": destinationURL.path,
        @"relativeFilePath": relativePath
    };
}

@end
