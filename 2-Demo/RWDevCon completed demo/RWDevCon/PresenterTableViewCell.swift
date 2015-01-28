//
//  ScheduleTableViewCell.swift
//  RWDevCon
//
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PresenterTableViewCell: UITableViewCell {

  @IBOutlet weak var squareImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var twitterButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    twitterButton?.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllTouchEvents)
  }
}
