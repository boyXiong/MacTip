//
//  SettingWindowController.swift
//  TimeTip
//
//  Created by key on 2020/5/19.
//  Copyright © 2020 key. All rights reserved.
//

import Cocoa
import AppKit
import RxCocoa
import RxSwift
import SnapKit
import UserNotifications

class SettingWindowController: NSWindowController {
    
    
    let timeStoreKey = "timeStoreKey"
    let titleStoreKey = "titleStoreKey"
    let bodyStoreKey = "bodyStoreKey"

    
    @IBOutlet weak var minF: NSTextField!
    @IBOutlet weak var tipF: NSTextField!
    @IBOutlet weak var bodyF: NSTextField!
    
    
    var time:Int = 15
    var title:String = ""
    var body: String = ""
    
    
    var notiContent = UNMutableNotificationContent()
    
    var timer:Timer = Timer()
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("SettingWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        print("windowDidLoad")
        
//        self.time = UserDefaults.standard.set(<#T##value: Int##Int#>, forKey: <#T##String#>)
        
        self.time = UserDefaults.standard.integer(forKey: timeStoreKey)
        self.title = UserDefaults.standard.string(forKey: titleStoreKey) ?? "要喝水了"
        self.body = UserDefaults.standard.string(forKey: bodyStoreKey) ?? "🍡🍺🍺🧑‍🔬"

        self.minF.stringValue = "\(self.time)"
        self.tipF.stringValue = self.title
        self.bodyF.stringValue = self.body
        
        
        self.addNotifaction()
        _ = self.minF.rx.text.orEmpty.subscribe { [weak self] (event) in
            if let str = event.element {
                self?.time = Int(str) ?? 30
            }
        }
        
        _ = self.tipF.rx.text.orEmpty.subscribe { [weak self] (event) in
                   if let str = event.element {
                       self?.title = str
                   }
               }
        
        _ = self.bodyF.rx.text.orEmpty.subscribe { [weak self] (event) in
                   if let str = event.element {
                       self?.body = str
                   }
               }
    
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBAction func sureClicked(_ sender: Any) {
        //        self.time = UserDefaults.standard.set(<#T##value: Int##Int#>, forKey: <#T##String#>)
        UserDefaults.standard.set(self.time, forKey: timeStoreKey)
        UserDefaults.standard.set(self.title, forKey: titleStoreKey)
        UserDefaults.standard.set(self.body, forKey: bodyStoreKey)
        UserDefaults.standard.synchronize()
        
        
        TIMER = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.time * 60), repeats: true, block: { (timer) in
            
            let content = UNMutableNotificationContent()
            
            content.title = self.title
            content.body = self.body

            content.userInfo = ["method": "new"]

            content.sound = UNNotificationSound.default
            
            content.categoryIdentifier = "NOTIFICATION_DEMO"
            
            let acceptAction = UNNotificationAction(identifier: "SHOW_ACTION", title: "延迟10分钟", options: .init(rawValue: 0))
            let declineAction = UNNotificationAction(identifier: "CLOSE_ACTION", title: "关闭", options: .init(rawValue: 1))
            let testCategory = UNNotificationCategory(identifier: "NOTIFICATION_DEMO",
                                                   actions: [acceptAction, declineAction],
                                                   intentIdentifiers: [],
                                                   hiddenPreviewsBodyPlaceholder: "",
                                                   options: .customDismissAction)

            let request = UNNotificationRequest(identifier: "NOTIFICATION_DEMO_REQUEST",
                                             content: content,
                                             trigger: nil)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.setNotificationCategories([testCategory])
            notificationCenter.add(request) { (error) in
             if error != nil {
                 // Handle any errors.
             }
            }
            
        })
//        TIMER.fire()
        
        
        RunLoop.current.add(TIMER, forMode: .default)
        
        self.window?.close()
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.window?.close()
    }
    
   
}

extension SettingWindowController : NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        print("didDeliver")

    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        
        print("shouldPresent")
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        print("didActivate")

    }
    
}



extension SettingWindowController {
    
    func addNotifaction() {
           _ = NotificationCenter.default.rx.notification(NSWindow.didBecomeKeyNotification).takeUntil(self.rx.deallocated).subscribe({ (event) in
                   print("didBecomeKeyNotification")
               })
               
               _ = NotificationCenter.default.rx.notification(NSWindow.didMiniaturizeNotification).takeUntil(self.rx.deallocated).subscribe({ (event) in
                        print("didMiniaturizeNotification")
                    })
               
               _ = NotificationCenter.default.rx.notification(NSWindow.willCloseNotification).takeUntil(self.rx.deallocated).subscribe({ (event) in
                NSApplication.shared.stopModal()
                        print("willCloseNotification: event:\(event)")
                    })
               
               
               _ = NotificationCenter.default.rx.notification(NSWindow.didResizeNotification).takeUntil(self.rx.deallocated).subscribe({ (event) in
                   if let noti = event.element, let window = noti.object as! NSWindow? {
                       print(window.frame)

                   }
               })
               
               _ = NotificationCenter.default.rx.notification(NSWindow.didMoveNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { (noti) in
                         if let window = noti.object as! NSWindow? {
                             print(window.frame)
                         }
                     }, onError: nil, onCompleted: nil, onDisposed: nil)
               
       }
}

extension SettingWindowController: UNUserNotificationCenterDelegate {

    // 用户点击弹窗后的回调
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        switch response.actionIdentifier {
        case "SHOW_ACTION":
            print(userInfo)
        case "CLOSE_ACTION":
            print("Nothing to do")
        default:
            break
        }
        completionHandler()
    }

    // 配置通知发起时的行为 alert -> 显示弹窗, sound -> 播放提示音
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
