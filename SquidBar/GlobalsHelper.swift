//
//  GlobalsHelper.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Foundation

struct Global {

    struct Application {

        static let bundleName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        static let bundleVersion: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        static let bundleBuild: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        static let bundleProject: String = "https://github.com/burnsra/\(Global.Application.bundleName)"

        static let pgrepExecutable: String = "/usr/bin/pgrep"
        static let squidProcess: String = "squid"

        static let statusListening: String = "Server listening on"
        static let statusUnknown: String = "Getting server status..."
        static let statusStarting: String = "Server starting..."
        static let statusStopping: String = "Server stopping..."
        static let statusForceStop: String = "Server force stop required..."
        static let statusStarted: String = "Server started"
        static let statusStopped: String = "Server stopped"
        static let statusRestartingNetwork: String = "Server restarting due to network changes"
        static let statusNetworkChange: String = "Network change detected"
        static let statusNetworkChangeValid: String = "Valid network change confirmed"
        static let statusNetworkChangeInvalid: String = "Invalid network change confirmed"
        static let statusNetworkChangeFlag: String = "File flag description:"
    }


}

