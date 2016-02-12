//
//  UtilsHelper.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Cocoa
import Foundation

func showNotification(message: String) -> Void {
    let notification = NSUserNotification()
    notification.title = "\(Global.Application.bundleName)"
    notification.informativeText = message
    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
}

func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func getDir(canChooseFiles: Bool, canChooseDirectories: Bool) -> String {
    let browser: NSOpenPanel = NSOpenPanel()

    browser.allowsMultipleSelection = false
    browser.canChooseFiles = canChooseFiles
    browser.canChooseDirectories = canChooseDirectories

    let i = browser.runModal()

    let url = browser.URL
    let path: String

    if (url != nil) {
        path = url!.path!
    } else {
        path = ""
    }

    if (i == NSModalResponseOK) {
        return path
    } else {
        return ""
    }
}