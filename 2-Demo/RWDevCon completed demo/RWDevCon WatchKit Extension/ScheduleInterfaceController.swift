import WatchKit
import Foundation

class ScheduleInterfaceController: WKInterfaceController {
  lazy var coreDataStack = CoreDataStack()
  var sessions = [Session]()

  @IBOutlet weak var table: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    showAllSessions()
  }

  func showAllSessions() {
    sessions = Session.allSessionsInContext(coreDataStack.context)

    table.setNumberOfRows(sessions.count, withRowType: "ScheduleRow")

    for (index, session) in enumerate(sessions) {
      if let row = table.rowControllerAtIndex(index) as? ScheduleRow {
        row.timeLabel.setText(session.startDateTimeShortString)
        row.titleLabel.setText(session.title)
      }
    }
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
