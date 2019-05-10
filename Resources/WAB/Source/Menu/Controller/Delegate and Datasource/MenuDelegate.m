//
//  MenuDelegate.m
//  Walmart
//
//  Created by Bruno on 8/20/15.
//  Copyright (c) 2015 Marcelo Santos. All rights reserved.
//

#import "MenuDelegate.h"
#import "DepartmentMenuItem.h"

@interface MenuDelegate ()

@property (nonatomic, strong) WALMenuViewController *controller;

@end

@implementation MenuDelegate

- (id)initWithMenuReference:(WALMenuViewController *)controllerReference
{
    self = [super init];
    if (self)
    {
        _controller = controllerReference;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0 || section == 1) ? 52 : 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 0 || section == 1) ? 17 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((section == 0) || (section == 1))
    {
        UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 52)];
        headerBackgroundView.backgroundColor = [UIColor clearColor];
        
        UILabel *headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, tableView.frame.size.width - 16, 52)];
        headerNameLabel.backgroundColor = [UIColor clearColor];
        headerNameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
        headerNameLabel.textColor = RGBA(255, 255, 255, 1);

        switch (section) {
            case 0: {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Navegue pelo shopping" attributes:@{
                                                                                                                                                      NSFontAttributeName: [UIFont fontWithName:@"Roboto-Light" size:18.0f],
                                                                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithWhite:255.0f / 255.0f alpha:1.0f]
                                                                                                                                                      }];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18.0f] range:NSMakeRange(13, 8)];

                headerNameLabel.attributedText = attributedString;
                break;
            }
            case 1: {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Explore o aplicativo" attributes:@{
                                                                                                                                                     NSFontAttributeName: [UIFont fontWithName:@"Roboto-Bold" size:18.0f],
                                                                                                                                                     NSForegroundColorAttributeName: [UIColor colorWithWhite:255.0f / 255.0f alpha:1.0f]
                                                                                                                                                     }];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Light" size:18.0f] range:NSMakeRange(0, 9)];
                headerNameLabel.attributedText = attributedString;
                break;
            }
            default:
            break;
        }
        
        [headerBackgroundView addSubview:headerNameLabel];
        return headerBackgroundView;
    }
    else
    {
        UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 16)];
        headerBackgroundView.backgroundColor = [UIColor clearColor];
        return headerBackgroundView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((section == 0) || (section == 1))
    {
        UIView *footerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 17)];
        footerBackgroundView.backgroundColor = [UIColor clearColor];
        
        UIView *customDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 16, tableView.frame.size.width, 1)];
        customDivider.backgroundColor = RGBA(8, 103, 213, 1);
        [footerBackgroundView addSubview:customDivider];
        
        return footerBackgroundView;
    }
    else
    {
        UIView *footerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        footerBackgroundView.backgroundColor = [UIColor clearColor];
        return footerBackgroundView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SECTION 0 - SHOPPING
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.controller unselectHeaderButtons];
            _controller.currentIndexPath = indexPath;
            [_controller presentHomeWithAnimation:YES reset:NO];
        }
        else
        {
            DepartmentMenuItem *department = [_controller.departments objectAtIndex:indexPath.row];
            
            UTMIModel *utmi = [WMUTMIManager UTMI];
            [utmi setSection:_controller.currentUTMIIdentifier cleanOtherFields:YES];
            utmi.module = @"menu-lateral";
            utmi.modulePosition = [@(indexPath.row + 1) stringValue];
            utmi.moduleLabel = department.name;
            [WMUTMIManager storeUTMI:utmi];
            
            if (department.isAllDepartments.boolValue)
            {
                [self.controller unselectHeaderButtons];
                _controller.currentIndexPath = indexPath;
                [_controller presentAllShopping];
            }
            else
            {
                [_controller presentDepartment:department];
            }
        }
        
        [_controller checkMenuSelection];
    }
    
    //SECTION 1 - EXPLORE
    else if (indexPath.section == 1)
    {
        [self.controller unselectHeaderButtons];

        switch (indexPath.row)
        {
            case 0:
            {
                //Notificações
                _controller.currentIndexPath = indexPath;
                [_controller presentNotifications];
                break;
            }
            
            case 1:
            {
                //Ajuda
                _controller.currentIndexPath = indexPath;
                [FlurryWM logEvent_menu_help_btn];
                [_controller presentHowToUse];
                break;
            }
            
            case 2:
            {
                //Feedback
                _controller.currentIndexPath = indexPath;
                [FlurryWM logEvent_menu_feedback_btn];
                [_controller presentFeedback];
                break;
            }
            
            case 3:
            {
                //Avalie na App Store
                [FlurryWM logEvent_menuRating];
                [_controller rateInAppStore];
                break;
            }
            
            case 4:
            {
                //Sobre
                _controller.currentIndexPath = indexPath;
                [FlurryWM logEvent_menu_about_btn];
                [_controller presentAbout];
                break;
            }
            
            //Show Intern Control for test on menu
#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
            case 5:
            {
                
                LogInfo(@"Internal Control");
                _controller.currentIndexPath = indexPath;
                [_controller presentInternalControl];
            }
#endif
            default:
            break;
        }
    }
    
    //SECTION 2 - AJUDA
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            
            case 0:
            {
                //Walmart.com
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                [_controller checkMenuSelection];
                [_controller presentWalmartWebsite];
            }
            break;
            
            default:
            break;
        }
    }
}



@end
