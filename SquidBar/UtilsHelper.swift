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