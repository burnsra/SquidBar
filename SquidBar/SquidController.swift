//
//  SquidController.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Cocoa

class SquidController: NSObject {

    private var squid: NSTask?
    private var active: Bool?
    private var restarting: Bool?

    let preferenceController = PreferenceController()
    let squidStartupArgs = ["-s", "-N"]
    let squidShutdownArgs = ["-k","shutdown"]

    func isSquidRunning() -> Bool {
        let taskRunning = NSTask()
        let pipe = NSPipe()

        taskRunning.launchPath = Global.Application.pgrepExecutable
        taskRunning.arguments = [Global.Application.squidProcess]
        taskRunning.standardOutput = pipe
        taskRunning.launch()

        taskRunning.waitUntilExit()
        if taskRunning.terminationStatus == 0 {
            return true
        } else {
            return false
        }
    }

    func startSquid() {
        if !self.isSquidRunning() {
            NSLog("\(Global.Application.statusStarting)")
            let squid = NSTask()
            let pipe = NSPipe()
            squid.launchPath = preferenceController.squidExecutable
            squid.arguments = squidStartupArgs
            squid.arguments?.append("-f")
            squid.arguments?.append(preferenceController.squidConfiguration!)
            squid.standardOutput = pipe
            squid.launch()
            active = true
            restarting = false
            self.squid = squid
            NSLog("\(Global.Application.statusStarted)")
            if let port = self.getPort() {
                NSLog("\(Global.Application.statusListening) \(port)")
            }
        } else {
            active = true
        }
    }

    func stopSquid() {
        if self.isSquidRunning() {
            NSLog("\(Global.Application.statusStopping)")
            if ((squid?.running) != nil) {
                guard let squid = squid else {
                    return
                }
                squid.terminate()
                squid.waitUntilExit()
            } else {
                NSLog("\(Global.Application.statusForceStop)")
                let taskStop = NSTask()
                taskStop.launchPath = preferenceController.squidExecutable
                taskStop.arguments = squidShutdownArgs
                taskStop.launch()
                taskStop.waitUntilExit()
            }
            active = false
            NSLog("\(Global.Application.statusStopped)")
        }
    }

    func restartSquid() {
        if restarting != true {
            restarting = true
            self.stopSquid()
            delay(8) {
                self.startSquid()
            }
        }
    }

    func getPort() -> String? {
        let configPath = preferenceController.squidConfiguration
        var ports = ""

        do {
            let content = try String(contentsOfFile: configPath!, encoding: NSUTF8StringEncoding)
            let contentArray = content.componentsSeparatedByString("\n")

            for (_, element) in contentArray.enumerate() {
                let lineContent = element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

                if ((lineContent.rangeOfString("http_port") != nil)) {
                    if let port = lineContent.componentsSeparatedByString(" ").last {
                        if (ports.characters.count > 1) {
                            ports.appendContentsOf(",")
                        }
                        ports.appendContentsOf(port.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    }
                }
            }
            if ports.characters.count != 0 {
                return ports
            }
        } catch _ as NSError {
            return nil
        }
        return nil
    }

}

