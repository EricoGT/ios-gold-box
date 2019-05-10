//
//  MenuDataSource.m
//  Walmart
//
//  Created by Bruno on 8/19/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "MenuDataSource.h"
#import "DepartmentMenuItemCell.h"
#import "DepartmentMenuItem.h"

@interface MenuDataSource ()

@property (nonatomic, strong) NSArray *exploreSectionItems;
@property (nonatomic, strong) NSArray *iconsExploreSection;
@property (nonatomic, strong) NSArray *contactSectionItems;
@property (nonatomic, strong) NSArray *iconsContactSection;

@end

@implementation MenuDataSource

- (id)initWithDepartments:(NSArray *)departmentsSection
{
    self = [super init];
    if (self)
    {
        [self setupStaticContent];
        _departments = departmentsSection;
    }
    return self;
}

- (void)setupStaticContent
{
    UIImage *iconNotifications = [UIImage imageNamed:@"ic_sidebarmenu_notifications"];
    UIImage *iconHelp = [UIImage imageNamed:@"ic_sidebarmenu_help"];
    UIImage *iconOpinion = [UIImage imageNamed:@"ic_sidebarmenu_feedback"];
    UIImage *iconRating = [UIImage imageNamed:@"ic_sidebarmenu_rating"];
    UIImage *iconAbout = [UIImage imageNamed:@"ic_sidebarmenu_about"];
    UIImage *iconWalmart = [UIImage imageNamed:@"ic_sidebarmenu_site"];
    
    self.exploreSectionItems = @[@"Notificações",@"Como utilizar",@"Dê sua opinião",@"Avalie na App Store",@"Sobre o aplicativo"];
    self.iconsExploreSection = @[iconNotifications, iconHelp, iconOpinion, iconRating, iconAbout];

    //Show Intern Control for test on menu
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
    UIImage *iconConfig = [UIImage imageNamed:@"ic_features_sku_pressed"];
    self.exploreSectionItems = @[@"Notificações",@"Como utilizar",@"Dê sua opinião",@"Avalie na App Store",@"Sobre o aplicativo",@"Controle Interno"];
    self.iconsExploreSection = @[iconNotifications, iconHelp, iconOpinion, iconRating, iconAbout, iconConfig];
#endif
    
    
    self.contactSectionItems = @[@"Ir para o site do Walmart"];
    self.iconsContactSection = @[iconWalmart];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSInteger departmentsCount = _departments ? _departments.count : 0;
        return departmentsCount;
    }
    else if (section == 1)
    {
        return _exploreSectionItems.count;
    }
    else if (section == 2)
    {
        return _contactSectionItems.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdenfierDepartment = @"cellDepartmentMenuItem";
    DepartmentMenuItemCell *departmentCell = [tableView dequeueReusableCellWithIdentifier:reuseIdenfierDepartment forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //Inicio
            UIImage *homeIcon = [UIImage imageNamed:@"ic_sidebarmenu_home"];
            [departmentCell setupWithMenuName:self.departments[0] image:homeIcon];
        }
        else
        {
            DepartmentMenuItem *item = [self.departments objectAtIndex:indexPath.row];
            [departmentCell setupWithDepartmentMenuItem:item];
        }
    }
    else if (indexPath.section == 1)
    {
        [departmentCell setupWithMenuName:self.exploreSectionItems[indexPath.row] image:self.iconsExploreSection[indexPath.row]];
    }
    else if (indexPath.section == 2)
    {
        [departmentCell setupWithMenuName:self.contactSectionItems[indexPath.row] image:self.iconsContactSection[indexPath.row]];
    }
    
    return departmentCell;
}

@end
