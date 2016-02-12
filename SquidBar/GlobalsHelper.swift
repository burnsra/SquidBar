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

        static let statusListening: String = "Listening on"
        static let statusUnknown: String = "Getting status..."
        static let statusStarting: String = "Server starting..."
        static let statusRestartingDNS: String = "Restarting due to DNS changes..."
    }


}

