//
//  WeiboModel.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

//- (void)setText:(NSString *)text
//{
//    /*
//        1、能够接受的字符串//<image url = 'wxhl.png'>
//        2、现有的字符串[哈哈]
//        3、把 2 转换成 1
//     */
//    if (_text != text) {
//        
////        1、定制正则表达式，找到[哈哈]
//        NSString *regex = @"\\[\\w+\\]";
//        NSArray *arr = [text componentsMatchedByRegex:regex];
////        2、找到图片对应的plist
////        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
//        NSString *path = [NSHomeDirectory()
//                          stringByAppendingPathComponent:@"documents/emotions.plist"];
//        NSArray *emoarr = [NSArray arrayWithContentsOfFile:path];
//        
//        for (NSString *faceName in arr) {
//            
////注意，用谓词的时候，里面的字符串当使用单引号，只要是这个对象在array当中，查询的数据包含谓词条件，返回的是查询条件所在的对象
//#warning 谓词
//            //查询谓词条件
//            NSString *str = [NSString stringWithFormat:@"value='%@'",faceName];
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
//            NSArray *items = [emoarr filteredArrayUsingPredicate:predicate];
//            //替换字符串 从[哈哈]-><image url = 'haha.png'>
//            if (items.count > 0) {
//                NSDictionary *dic = items[0];
//                
//                NSString *image = dic[@"url"];
//                
//                NSString *str = [NSString stringWithFormat:@"<image url = '%@'>",image];
//                
//                text = [text stringByReplacingOccurrencesOfString:faceName withString:str];
// 
//            }
//        }
//        _text = text;
//    }
//}

@end
