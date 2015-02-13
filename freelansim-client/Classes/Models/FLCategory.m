//
//  FLCategory.m
//  freelansim-client
//
//  Created by Кирилл on 18.12.12.
//  Copyright (c) 2012 Kirill Kunst. All rights reserved.
//

#import "FLCategory.h"

@implementation FLCategory

-(id)initWithTitle:(NSString *)title subcategories:(NSString *)subcategories {
    self = [super init];
    if (self) {
        [self setTitle:title];
        [self setSubcategories:subcategories];
    }
    return self;
}

+(NSArray *)categories {
    NSMutableArray *categories = [NSMutableArray array];
    
    FLCategory *category = [[FLCategory alloc] initWithTitle:@"Разработка сайтов" subcategories:@"web_all_inclusive,web_design,web_html,web_programming,web_prototyping,web_test,web_other"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Разработка мобильных приложений" subcategories:@"mobile_ios,mobile_android,mobile_wp7,mobile_bada,mobile_blackberry,mobile_design,mobile_programming,mobile_prototyping,mobile_test,mobile_other"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Разработка ПО" subcategories:@"app_all_inclusive,app_scripts,app_bots,app_plugins,app_utilites,app_design,app_programming,app_prototyping,app_test,app_other"];
    [categories addObject:category];
    
    
    
    category = [[FLCategory alloc] initWithTitle:@"Контент" subcategories:@"content_copywriting,content_rewriting,content_article,content_reviews,content_news,content_translations,content_press_releases,content_documentation,content_scenarios,content_other,content_correction"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Администрирование" subcategories:@"admin_network,admin_servers,admin_databases,admin_other"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Дизайн и мультимедиа" subcategories:@"design_graphics,design_logos,design_illustrations,design_banners,design_prints,design_modeling,design_animation,design_presentations,design_photo,design_video,design_audio,design_other,design_icons"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Полиграфия" subcategories:@"printing_all_inclusive,printing_design,printing_makeup,printing_packaging_design,printing_corporate_identity,printing_outdoor_advertising,printing_others"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Инженерия" subcategories:@"engineering_development_electronics,engineering_programming_electronics,engineering_drawings_diagrams,engineering_architecture,engineering_other"];
    [categories addObject:category];
    
    category = [[FLCategory alloc] initWithTitle:@"Реклама и маркетинг" subcategories:@"advertising_seo,advertising_context,advertising_smo,advertising_smm,advertising_sem,advertising_other"];
    [categories addObject:category];

    category = [[FLCategory alloc] initWithTitle:@"Разное" subcategories:@"other_seo,other_smm,other_advertisement,other_jurisprudence,other_other"];
    [categories addObject:category];
    
    return categories;
}

@end
