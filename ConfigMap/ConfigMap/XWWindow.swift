//
//  XWWindow.swift
//  ConfigMap
//
//  Created by key on 2020/5/18.
//  Copyright © 2020 key. All rights reserved.
//

import Cocoa
import AppKit

class XWWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notifaciont:)), name: NSWindow.willCloseNotification, object: nil)
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @objc func windowWillClose(notifaciont: NSNotification) {
        //停止模态，然后用户可以点击其他窗口
        NSApplication.shared.stopModal()
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
