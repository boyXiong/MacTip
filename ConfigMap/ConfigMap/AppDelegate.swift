//
//  AppDelegate.swift
//  ConfigMap
//
//  Created by key on 2020/5/18.
//  Copyright © 2020 key. All rights reserved.
//

import Cocoa
import AppKit



var TIMER = Timer()


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength )
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.button?.title = "tip"
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "setting", action: #selector(settingClicked), keyEquivalent: "1"))
//        NSApp.terminate(self)
        menu.addItem(NSMenuItem(title: "quit", action: #selector(quitClicked), keyEquivalent: "2"))

        statusItem.menu = menu
                
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // 关闭最后一个window 会自动退出
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    


}


extension AppDelegate {
    
    @objc func settingClicked() {
        let settingVC = SettingWindowController()
        guard let window = settingVC.window else {
            return
        }
        
        NSApplication.shared.runModal(for: window)
    }
    
    @objc func quitClicked() {
        NSApp.terminate(self)
    }
    
    
    
}

