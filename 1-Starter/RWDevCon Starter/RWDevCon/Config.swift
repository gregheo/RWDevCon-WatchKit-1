//
//  ScheduleTableViewCell.swift
//  RWDevCon
//
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation

let SessionDataUpdatedNotification = "com.razeware.rwdevcon.notification.sessionDataUpdated"

class Config {
  class func applicationDocumentsDirectory() -> NSURL {
    let fileManager = NSFileManager.defaultManager()

    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
    return urls[0]
  }
  
  class func userDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }

  class func favoriteSessions() -> [String: String] {
    if let favs = userDefaults().dictionaryForKey("favoriteSessions") as? [String: String] {
      return favs
    }
    return [:]
  }

  class func registerFavorite(session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = session.identifier

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }

  class func unregisterFavorite(session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = nil

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }

}
