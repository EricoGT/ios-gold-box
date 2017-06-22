//
//  AppDelegate.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, SideMenuDelegate {

    var window: UIWindow?
    //
    var activityView:LoadingView? = nil
    var viewSideMenu:SideMenuVC? = nil
    var soundPlayer:SoundManager = SoundManager.init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NSLog("%@", ToolBox.applicationHelper_InstalationDataForSimulator())
        //
        activityView = LoadingView.new(owner: self)
        
        //Side Menu
        let storyboardSM:UIStoryboard = UIStoryboard.init(name: "SideMenu", bundle: nil)
        viewSideMenu = storyboardSM.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
                // Handle Error
                
                if (granted) {
                    UNUserNotificationCenter.current().delegate = self
                }
            })
        } else {
            // Fallback on earlier versions
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 3
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Public functions
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        completionHandler([.alert, .sound, .badge])
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        print(response.notification)
    }
    
    //MARK: - Side Menu
    
    @objc private func showSideMenu() {
        
        if (!ToolBox.isNil(viewSideMenu)){
            self.window?.addSubview(viewSideMenu!.view)
            viewSideMenu!.show(type: .normal, delegate: self, actualGroup: "OPT_1")
        }        
    }
    
    func sideMenuOptionSelected(destinationType:SideMenuDestinationType, menuType:SideMenuType){
        
        print(destinationType)
        print(menuType)
        
        viewSideMenu?.hide(sender: nil)
    }
    
    func sideMenuLoadData() -> Array<SideMenuOption>{
        
        var list:Array<SideMenuOption> = Array.init()
        
        let option1:SideMenuOption = SideMenuOption.init()
        option1.level = 0
        option1.groupIdentifier = "OPT_1"
        option1.optionTitle = "Opção 1"
        option1.state = .expanded
        option1.blocked = false
        option1.subItems = Array.init()
        option1.destinationType = .home
        option1.badgeCount = 0
        //
        let option1B:SideMenuOption = SideMenuOption.init()
        option1B.level = 1
        option1B.groupIdentifier = "OPT_1_SUB"
        option1B.optionTitle = "Opção 1 - Sub"
        option1B.state = .simple
        option1B.blocked = false
        option1B.subItems = nil
        option1B.destinationType = .home
        option1B.badgeCount = 0
        option1.subItems?.append(option1B)
        
        //
        let option2:SideMenuOption = SideMenuOption.init()
        option2.level = 0
        option2.groupIdentifier = "OPT_2"
        option2.optionTitle = "Opção 2"
        option2.state = .simple
        option2.blocked = false
        option2.subItems = nil
        option2.destinationType = .home
        option2.badgeCount = 0
        //
        let option3:SideMenuOption = SideMenuOption.init()
        option3.level = 0
        option3.groupIdentifier = "OPT_3"
        option3.optionTitle = "Opção 3"
        option3.state = .simple
        option3.blocked = false
        option3.subItems = nil
        option3.destinationType = .home
        option3.badgeCount = 0
        //
        list.append(option1)
        list.append(option2)
        list.append(option3)
            
        return list
    }
    
    func sideMenuTextForTitle() -> String?{
        return "Erico GT"
    }
    
    func sideMenuTextForSubTitle() -> String?{
        return "erico.gimenes@gmail.com"
    }
    
    func sideMenuTextForDescription() -> String?{
        return "Atlantic Solutions"
    }
    
    func sideMenuImageForAvatar() -> UIImage?{
        return UIImage.init(named: "guardachuva.jpeg")
    }
    
    func sideMenuImageForHeaderBackground() -> UIImage?{
        return UIImage.init(named: "animal.jpeg")
    }
    
    /*
    public func layoutTabBarController() {
        
        // Assign tab bar item with titles:
        let tabBarController:UITabBarController = self.window?.rootViewController as! UITabBarController
        let tabBar = tabBarController.tabBar
        //
        let tabBarItem1 = tabBar.items?[0]
        let tabBarItem2 = tabBar.items?[1]
        let tabBarItem3 = tabBar.items?[2]
        let tabBarItem4 = tabBar.items?[3]
        //
        tabBarItem1?.title = "Item_1"
        tabBarItem2?.title = "Item_2"
        tabBarItem3?.title = "Item_3"
        tabBarItem4?.title = "Item_4"
        //
        tabBarItem1?.selectedImage = UIImage.init(named: "Sample1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem1?.image = UIImage.init(named: "Sample1")?.withRenderingMode(.alwaysOriginal)
        //etc, etc...
        
        // Change the tab bar background
        tabBar.backgroundImage = UIImage.init(named: "tabbar.png") ?? UIImage.init()
        tabBar.backgroundColor = UIColor.yellow
        tabBar.selectionIndicatorImage = UIImage.init(named: "tabbar_selected.png") ?? UIImage.init()
        
        // Change the title color of tab bar items
        tabBarItem1?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)], for: .normal)
        tabBarItem2?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)], for: .normal)
        tabBarItem3?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)], for: .normal)
        tabBarItem4?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)], for: .normal)
        
        //OBS: Preferencialmente chame este método uma vez no viewWillAppear do primeiro controller da aplicação
    }
    */

    //MARK: - FAKE-FACTORY
    
    public func createSideMenuItem() -> UIBarButtonItem{
        
        let button:UIButton = UIButton.init(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage.init(named: "icon-menu-hamburguer")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.gray
        button.frame = CGRect.init(x: 0.0, y: 0.0, width: 32.0, height: 32.0)
        button.clipsToBounds = true
        button.isExclusiveTouch = true
        button.addTarget(self, action: #selector(self.showSideMenu), for: .touchUpInside)
        //
        return UIBarButtonItem.init(customView: button)
    }
    
}

