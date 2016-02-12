//
//  AppDelegate.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var preferencesWindow: NSWindow!

    @IBOutlet weak var serverStatusMenuItem: NSMenuItem!
    @IBOutlet weak var serverStartMenuItem: NSMenuItem!
    @IBOutlet weak var serverStopMenuItem: NSMenuItem!

    @IBOutlet weak var configurationFileTextfield: NSTextField!
    @IBOutlet weak var executableFileTextField: NSTextField!
    @IBOutlet weak var startOnLaunchCheckBox: NSButton!
    @IBOutlet weak var watchNetworkCheckBox: NSButton!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let preferenceController = PreferenceController()
    let squidController = SquidController()

    var	monitor = nil as FileSystemEventMonitor?
    var	queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        if !squidController.isSquidRunning() {
            if (preferenceController.squidStartOnLaunch == true) {
                showNotification(Global.Application.statusStarting)
                squidController.startSquid()
            }
        }
        delay(4) {
            self.updateStatusMenuItems()
        }
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        // Insert code here to enter the foreground state
        let	onEvents = { (events:[FileSystemEvent]) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                for ev in events {
                    if (ev.path.containsString("resolv.conf")) {
                        showNotification(Global.Application.statusRestartingDNS)
                        if (self.preferenceController.squidWatchNetwork == true) {
                            self.squidController.restartSquid()
                        }
                    }
                }
            }
        }
        monitor	= FileSystemEventMonitor(pathsToWatch: ["/etc/resolv.conf", "/private/var/run/resolv.conf"], latency: 0, watchRoot: false, queue: queue, callback: onEvents)

        updateStatusMenuItems()
    }

    func applicationWillResignActive(notification: NSNotification) {
        // Insert code here to leave the foreground state
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        monitor	= nil
        squidController.stopSquid()
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

    @IBAction func openDocumentation(sender: NSMenuItem) {
        if let url: NSURL = NSURL(string: "\(Global.Application.bundleProject)") {
            NSWorkspace.sharedWorkspace().openURL(url)
        }
    }

    @IBAction func openPreferences(sender: NSMenuItem) {
        self.preferencesWindow!.orderFront(self)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)

        if preferenceController.squidExecutable != nil {
            executableFileTextField.stringValue = preferenceController.squidExecutable!
        }

        if preferenceController.squidConfiguration != nil {
            configurationFileTextfield.stringValue = preferenceController.squidConfiguration!
        }

        if preferenceController.squidStartOnLaunch != nil {
            if (preferenceController.squidStartOnLaunch! == true) {
                startOnLaunchCheckBox.state = NSOnState
            } else {
                startOnLaunchCheckBox.state = NSOffState
            }
        }

        if preferenceController.squidWatchNetwork != nil {
            if (preferenceController.squidWatchNetwork! == true) {
                watchNetworkCheckBox.state = NSOnState
            } else {
                watchNetworkCheckBox.state = NSOffState
            }
        }
    }

    @IBAction func resetPreferences(sender: NSButton) {
        preferenceController.resetDefaultPreferences()
        preferenceController.synchronizePreferences()
        executableFileTextField.stringValue = preferenceController.squidExecutable!
        configurationFileTextfield.stringValue = preferenceController.squidConfiguration!
        if (preferenceController.squidStartOnLaunch == true) {
            startOnLaunchCheckBox.state = NSOnState
        } else {
            startOnLaunchCheckBox.state = NSOffState
        }
        if (preferenceController.squidWatchNetwork == true) {
            watchNetworkCheckBox.state = NSOnState
        } else {
            watchNetworkCheckBox.state = NSOffState
        }
        preferenceController.synchronizePreferences()
    }

    @IBAction func browseConfigurationLoc(sender: NSButton) {
        configurationFileTextfield.stringValue = getDir(true, canChooseDirectories: false)
        preferenceController.squidConfiguration = configurationFileTextfield.stringValue
        preferenceController.synchronizePreferences()
    }

    @IBAction func browseExecutableLoc(sender: NSButton) {
        executableFileTextField.stringValue = getDir(true, canChooseDirectories: false)
        preferenceController.squidExecutable = executableFileTextField.stringValue
        preferenceController.synchronizePreferences()
    }

    @IBAction func startOnLaunch(sender: NSButton) {
        if startOnLaunchCheckBox.state == NSOnState {
            preferenceController.squidStartOnLaunch = true
        } else if (startOnLaunchCheckBox.state == NSOffState) {
            preferenceController.squidStartOnLaunch = false
        }
        preferenceController.synchronizePreferences()
    }

    @IBAction func watchNetwork(sender: NSButton) {
        if watchNetworkCheckBox.state == NSOnState {
            preferenceController.squidWatchNetwork = true
        } else if (watchNetworkCheckBox.state == NSOffState) {
            preferenceController.squidWatchNetwork = false
        }
        preferenceController.synchronizePreferences()
    }

    @IBAction func serverStart(sender: NSMenuItem) {
        resetServerStatusMenuItem()
        squidController.restartSquid()
        delay(8) {
            self.updateStatusMenuItems()
        }
    }

    @IBAction func serverStop(sender: NSMenuItem) {
        resetServerStatusMenuItem()
        squidController.stopSquid()
        delay(4) {
            self.updateStatusMenuItems()
        }
    }

    func resetServerStatusMenuItem() {
        self.serverStatusMenuItem.title = "\(Global.Application.statusUnknown)"
        self.serverStatusMenuItem.hidden = false
        self.serverStartMenuItem.hidden = true
        self.serverStopMenuItem.hidden = true
    }

    func updateStatusMenuItems() {
        if squidController.isSquidRunning() {
            self.serverStatusMenuItem.hidden = false
            self.serverStartMenuItem.hidden = true
            self.serverStopMenuItem.hidden = false
            if let port = squidController.getPort() {
                self.serverStatusMenuItem.title = "\(Global.Application.statusListening) \(port)"
            }
        } else {
            self.serverStatusMenuItem.title = "\(Global.Application.statusUnknown)"
            self.serverStatusMenuItem.hidden = true
            self.serverStartMenuItem.hidden = false
            self.serverStopMenuItem.hidden = true
        }
    }


}

