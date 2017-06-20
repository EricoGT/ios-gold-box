//
//  NotificationManager.swift
//  Project-Swift
//
//  Created by Erico GT on 20/06/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager:NSObject
{
    
    @available(iOS 10.0, *)
    class func deleteLocalNotification(requestIdentifier:String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[requestIdentifier])
    }
    
    @available(iOS 10.0, *)
    class func deleteAllLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    @available(iOS 10.0, *)
    class func deleteLocalNotificationsExcept(requestIdentifiersToMaintain:[String]) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notRequests:[UNNotificationRequest]) in
            for nr:UNNotificationRequest in notRequests {
                
                if (!requestIdentifiersToMaintain.contains(nr.identifier)) {
                    self.deleteLocalNotification(requestIdentifier: nr.identifier)
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    class func updateLocalNotification(notRequest:UNNotificationRequest) {
        UNUserNotificationCenter.current().add(notRequest, withCompletionHandler: nil)
    }
    
    @available(iOS 10.0, *)
    class func getAllPendingLocalNotifications(completionHandler: @escaping ([UNNotificationRequest]) -> Swift.Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notRequests:[UNNotificationRequest]) in
            return completionHandler(notRequests)
        }
    }
    
    @available(iOS 10.0, *)
    class func removeLocalNotificationFromUserHistory(requestidentifier:String) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestidentifier])
    }
    
    @available(iOS 10.0, *)
    class func createDemoNotification() {
        
        let requestIdentifier = "demoNotification"
        
        let content = UNMutableNotificationContent()
        content.title = "Teste de Notificação 3"
        content.subtitle = "– Thomas Edison"
        content.body = "Nossa maior fraqueza está em desistir. O caminho mais certo de vencer é tentar mais uma vez."
        content.badge = 1
        content.sound = UNNotificationSound.init(named: "alert.m4a")
        
        var contentInfo:Dictionary = [String : Any]()
        contentInfo["identifier"] = "remedio"
        //
        content.userInfo = contentInfo
        
        // If you want to attach any image to show in local notification
        let url = Bundle.main.url(forResource: "guardachuva", withExtension: ".jpeg")
        do {
            let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
            content.attachments = [attachment!]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        var dComponents:DateComponents = DateComponents.init()
        dComponents.timeZone = TimeZone.current
        dComponents.hour = 20
        let triggerCalendar = UNCalendarNotificationTrigger.init(dateMatching: dComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            
            if let err:Error = error {
                print(err)
            }
            
        })
    }
    
    
}
