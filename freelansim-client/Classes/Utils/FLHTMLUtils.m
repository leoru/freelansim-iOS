//
//  FLHTMLUtils.m
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLHTMLUtils.h"

@implementation FLHTMLUtils

+(NSString *)CSS {
    NSString *css = [NSString stringWithFormat:@"\n"
                     "body {font-family: Helvetica Neue; background-color:transparent;  font-size:14px; color: #5D6577;}"
                     "\n"];
    return css;
}


+ (NSString *)formattedDescription:(NSString *)HTML filesInfo:(NSString *)filesInfo {
    filesInfo = filesInfo ? filesInfo : @"";
    HTML = HTML ? HTML : @"";
    NSString *htmlCode = [NSString stringWithFormat:@" \n"
                          "<html> \n"
                          "     <head> \n"
                          "     <title></title> \n"
                          "     <style>%@</style></head> \n" //CSS
                          "     <body> \n"
                          "         %@   "
                          "         %@   "
                          "     </body> \n"
                          "</html>  \n",[self CSS], HTML, filesInfo];
    return htmlCode;
}

+(NSString *)descriptionForbidden:(NSString *)HTML{
    NSString *htmlCode = @" \n <html> \n"
                          "     <head> \n"
                          "     <title></title> \n"
                          "     <style>\n"
                          "body {font-family: Helvetica-Light; color:DimGray; background-color:transparent; font-size:18px;}"
                          "\n</style></head> \n"
                          "     <body> \n <div align =\"center\"> "
                          "         Данные пользователя скрыты  "
                          "     </div></body> \n"
                          "</html>  \n";
    return htmlCode;
}


@end
