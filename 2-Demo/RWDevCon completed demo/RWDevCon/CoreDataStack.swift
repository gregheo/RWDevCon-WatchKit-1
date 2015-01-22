/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import CoreData

// A date before the bundled plist date
private let beginningOfTimeDate = NSDate(timeIntervalSince1970: 1417348800)

public class CoreDataStack {
  
  public let context: NSManagedObjectContext
  let psc: NSPersistentStoreCoordinator
  let model: NSManagedObjectModel
  let store: NSPersistentStore?
  
  public init() {
    let modelName = "RWDevCon"
    
    let bundle = NSBundle.mainBundle()
    let modelURL =
    bundle.URLForResource(modelName, withExtension:"momd")!
    model = NSManagedObjectModel(contentsOfURL: modelURL)!
    
    psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc
    
    let documentsURL = Config.applicationDocumentsDirectory()
    let storeURL = documentsURL.URLByAppendingPathComponent("\(modelName).sqlite")

    NSLog("Store is at \(storeURL)")

    let options = [NSInferMappingModelAutomaticallyOption:true,
        NSMigratePersistentStoresAutomaticallyOption:true]

    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)

    if store == nil {
      var fileManagerError:NSError? = nil
      let didRemoveStore = NSFileManager.defaultManager().removeItemAtURL(storeURL, error: &fileManagerError)
      if !didRemoveStore {
        println("Error removing persistent store: \(fileManagerError)")
        abort()
      } else {
        println("Model has changed, removing.")
      }
      
      var error: NSError? = nil
      store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)
      if store == nil {
        println("Error adding persistent store: \(error)")
        abort()
      }
    }

    // If 0 sessions, start with the bundled plist data
    if Session.sessionCount(context) == 0 {
      if let conferencePlist = NSBundle.mainBundle().URLForResource("RWDevCon2015", withExtension: "plist") {
        loadDataFromPlist(conferencePlist)
      }
    }
  }

  func loadDataFromPlist(url: NSURL) {
    if let data = NSDictionary(contentsOfURL: url) {
      typealias PlistDict = [String: NSDictionary]
      typealias PlistArray = [NSDictionary]

      let metadata: NSDictionary! = data["metadata"] as? NSDictionary
      let sessions: PlistDict! = data["sessions"] as? PlistDict
      let people: PlistDict! = data["people"] as? PlistDict
      let rooms: PlistArray! = data["rooms"] as? PlistArray
      let tracks: [String]! = data["tracks"] as? [String]

      if metadata == nil || sessions == nil || people == nil || rooms == nil || tracks == nil {
        return
      }

      let lastUpdated = metadata["lastUpdated"] as? NSDate ?? beginningOfTimeDate
      Config.userDefaults().setObject(lastUpdated, forKey: "lastUpdated")

      var allRooms = [Room]()
      var allTracks = [Track]()
      var allPeople = [String: Person]()

      for (identifier, dict) in enumerate(rooms) {
        var room = Room.roomByRoomIdOrNew(identifier, context: context)

        room.roomId = Int32(identifier)
        room.name = dict["name"] as? String ?? ""
        room.image = dict["image"] as? String ?? ""
        room.roomDescription = dict["roomDescription"] as? String ?? ""
        room.mapAddress = dict["mapAddress"] as? String ?? ""
        room.mapLatitude = dict["mapLatitude"] as? Double ?? 0
        room.mapLongitude = dict["mapLongitude"] as? Double ?? 0

        allRooms.append(room)
      }

      for (identifier, name) in enumerate(tracks) {
        let track = Track.trackByTrackIdOrNew(identifier, context: context)

        track.trackId = Int32(identifier)
        track.name = name

        allTracks.append(track)
      }

      for (identifier, dict) in people {
        let person = Person.personByIdentifierOrNew(identifier, context: context)

        person.identifier = identifier
        person.first = dict["first"] as? String ?? ""
        person.last = dict["last"] as? String ?? ""
        person.active = dict["active"] as? Bool ?? false
        person.twitter = dict["twitter"] as? String ?? ""
        person.bio = dict["bio"] as? String ?? ""

        allPeople[identifier] = person
      }

      for (identifier, dict) in sessions {
        let session = Session.sessionByIdentifierOrNew(identifier, context: context)

        session.identifier = identifier
        session.active = dict["active"] as? Bool ?? false
        session.date = dict["date"] as? NSDate ?? beginningOfTimeDate
        session.duration = Int32(dict["duration"] as? Int ?? 0)
        session.column = Int32(dict["column"] as? Int ?? 0)
        session.sessionNumber = dict["sessionNumber"] as? String ?? ""
        session.sessionDescription = dict["sessionDescription"] as? String ?? ""
        session.title = dict["title"] as? String ?? ""

        session.track = allTracks[dict["trackId"] as Int]
        session.room = allRooms[dict["roomId"] as Int]

        var presenters = [Person]()
        if let rawPresenters = dict["presenters"] as? [String] {
          for presenter in rawPresenters {
            if let person = allPeople[presenter] {
              presenters.append(person)
            }
          }
        }
        session.presenters = NSOrderedSet(array: presenters)
      }

      saveContext()

      NSNotificationCenter.defaultCenter().postNotificationName(SessionDataUpdatedNotification, object: self)
    }
  }

  func saveContext() {
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
      println("Could not save: \(error), \(error?.userInfo)")
      abort()
    }
  }
  
}

