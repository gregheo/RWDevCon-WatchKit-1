//
//  DetailInterfaceController.swift
//  RWDevCon
//
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController: WKInterfaceController {
  @IBOutlet weak var titleLabel: WKInterfaceLabel!
  @IBOutlet weak var iconImage: WKInterfaceImage!
  @IBOutlet weak var descriptionLabel: WKInterfaceLabel!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    if let session = context as? Session {
      titleLabel.setText(session.title)
      descriptionLabel.setText(session.sessionDescription)
      iconImage.setHidden(true)
    }

    if let person = context as? Person {
      titleLabel.setText(person.fullName)
      descriptionLabel.setText(person.bio)
      if let avatar = UIImage(named: person.identifier) {
        iconImage.setImage(avatar)
      } else {
        iconImage.setHidden(true)
      }
    }
  }
}
