//
//  SquidController.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Cocoa

class SquidController: NSObject {

    let preferenceController = PreferenceController()
    let squidStartupArgs = ["-s","-d","1"]
    let squidShutdownArgs = ["-s","-d","1","-k","shutdown"]

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
            let taskStart = NSTask()
            taskStart.launchPath = preferenceController.squidExecutable
            taskStart.arguments = squidStartupArgs
            taskStart.arguments?.append("-f")
            taskStart.arguments?.append(preferenceController.squidConfiguration!)
            taskStart.launch()
        }
    }

    func stopSquid() {
        if self.isSquidRunning() {
            let taskStop = NSTask()
            taskStop.launchPath = preferenceController.squidExecutable
            taskStop.arguments = squidShutdownArgs
            taskStop.arguments?.append("-f")
            taskStop.arguments?.append(preferenceController.squidConfiguration!)
            taskStop.launch()
            taskStop.waitUntilExit()
        }
    }

    func restartSquid() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 6 * Int64(NSEC_PER_SEC))
        self.stopSquid()
        dispatch_after(time, dispatch_get_main_queue()) {
            self.startSquid()
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

