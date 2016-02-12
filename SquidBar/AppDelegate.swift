//
//  AppDelegate.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferencesWindow: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        // Insert code here to enter the foreground state
    }

    func applicationWillResignActive(notification: NSNotification) {
        // Insert code here to leave the foreground state
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    override func awakeFromNib() {
        let icon = NSImage(named: NSImageNameQuickLookTemplate)
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.toolTip = "\(Global.Application.bundleName) \(Global.Application.bundleVersion)"
    }

    @IBAction func toggleLoginItem(sender: NSButton) {
        setLaunchAtStartup(Bool(sender.state))
    }

    @IBAction func clickQuit(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

    @IBAction func openAbout(sender: NSMenuItem) {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(sender)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }

    @IBAction func openPreferences(sender: NSMenuItem) {
        self.preferencesWindow!.orderFront(self)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }


}

