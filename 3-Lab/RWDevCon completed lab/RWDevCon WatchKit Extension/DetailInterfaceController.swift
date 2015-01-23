
import Foundation
import WatchKit

class DetailInterfaceController: WKInterfaceController {

  @IBOutlet weak var titleLabel: WKInterfaceLabel!
  @IBOutlet weak var image: WKInterfaceImage!
  @IBOutlet weak var detailsLabel: WKInterfaceLabel!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    if let session = context as? Session {
      titleLabel.setText(session.title)
      detailsLabel.setText(session.sessionDescription)
      image.setHidden(true)
    }

    if let person = context as? Person {
      titleLabel.setText(person.fullName)
      detailsLabel.setText(person.bio)
      if let avatar = UIImage(named: person.identifier) {
        image.setImage(avatar)
      } else {
        image.setHidden(true)
      }
    }
  }

}
