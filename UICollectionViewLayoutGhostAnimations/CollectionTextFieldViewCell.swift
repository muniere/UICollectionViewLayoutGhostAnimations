//
//  CollectionTextFieldViewCell.swift
//  UICollectionViewLayoutGhostAnimations
//
//  Created by Hiromune Ito on 2017/05/14.
//  Copyright © 2017 Hiromune Ito. All rights reserved.
//

import UIKit

//
// MARK: - UICollectionViewCell
//
class CollectionTextFieldViewCell: UICollectionViewCell {

  @IBOutlet internal var textField: UITextField! {
    didSet {
      guard let v = self.textField else { return }
      v.text = nil
      v.delegate = self
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    self.contentView.backgroundColor = .blue
    self.textField.backgroundColor = .yellow
  }
}

//
// MARK: - UITextFieldDelegate
//
extension CollectionTextFieldViewCell: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
