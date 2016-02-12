//
//  UtilsHelper.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

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