import WatchKit
import Foundation

class ScheduleInterfaceController: WKInterfaceController {
  lazy var coreDataStack = CoreDataStack()
  var sessions = [Session]()

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    // Configure interface objects here.
  }

  func showAllSessions() {
    sessions = Session.allSessionsInContext(coreDataStack.context)

    // Configure the display of all sessions here.
  }

  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

}
