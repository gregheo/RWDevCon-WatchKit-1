
import Foundation
import CoreData
import WatchKit

class ScheduleController: WKInterfaceController {
  lazy var coreDataStack = CoreDataStack()
  var sessions = [Session]()
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    if let conferencePlist = NSBundle.mainBundle().URLForResource("RWDevCon2015", withExtension: "plist") {
      Config.loadDataFromPlist(conferencePlist, context: coreDataStack.context)
      coreDataStack.saveContext()
    }
  }

  override func willActivate() {
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

}
