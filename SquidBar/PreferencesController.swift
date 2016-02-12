//
//  PreferencesController.swift
//  SquidBar
//
//  Created by Robert Burns on 2/11/16.
//  Copyright © 2016 Robert Burns. All rights reserved.
//

import Foundation

private let squidExecutableKey = "squidExecutable"
private let squidConfigurationKey = "squidConfiguration"
private let squidLaunchKey = "squidStartOnLaunch"
private let squidWatchNetworkKey = "squidWatchNetwork"

class PreferenceController {

    private let userDefaults = NSUserDefaults.standardUserDefaults()

    func registerDefaultPreferences() {
        let defaults = [ squidExecutableKey : "/usr/local/opt/squid/sbin/squid", squidConfigurationKey  : "/usr/local/etc/squid.conf", squidLaunchKey : true, squidWatchNetworkKey : false ]
        userDefaults.registerDefaults(defaults)
    }

    func resetDefaultPreferences() {
        userDefaults.removeObjectForKey(squidExecutableKey)
        userDefaults.removeObjectForKey(squidConfigurationKey)
        userDefaults.removeObjectForKey(squidLaunchKey)
        userDefaults.removeObjectForKey(squidWatchNetworkKey)
        registerDefaultPreferences()
    }

    func synchronizePreferences() {
        userDefaults.synchronize()
    }

    init() {
        registerDefaultPreferences()
    }

    var squidExecutable: String? {
        set (newSquidExecutable) {
            userDefaults.setObject(newSquidExecutable, forKey: squidExecutableKey)
        }
        get {
            return userDefaults.objectForKey(squidExecutableKey) as? String
        }
    }

    var squidConfiguration: String? {
        set (newSquidConfiguration) {
            userDefaults.setObject(newSquidConfiguration, forKey: squidConfigurationKey)
        }
        get {
            return userDefaults.objectForKey(squidConfigurationKey) as? String
        }
    }

    var squidStartOnLaunch: Bool? {
        set (newSquidStartOnLaunch) {
            userDefaults.setObject(newSquidStartOnLaunch, forKey: squidLaunchKey)
        }
        get {
            return userDefaults.objectForKey(squidLaunchKey) as? Bool
        }
    }

    var squidWatchNetwork: Bool? {
        set (newSquidWatchNetwork) {
            userDefaults.setObject(newSquidWatchNetwork, forKey: squidWatchNetworkKey)
        }
        get {
            return userDefaults.objectForKey(squidWatchNetworkKey) as? Bool
        }
    }

}