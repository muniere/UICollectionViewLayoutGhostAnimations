//
//  SimpleTextFieldViewController.swift
//  UICollectionViewLayoutGhostAnimations
//
//  Created by Hiromune Ito on 2017/05/14.
//  Copyright © 2017 Hiromune Ito. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - UIViewController
//
class SimpleTextFieldViewController: UIViewController {

  @IBOutlet fileprivate var textField: UITextField! {
    didSet {
      guard let v = self.textField else { return }
      v.text = nil
      v.delegate = self
      v.backgroundColor = .yellow
    }
  }

  @IBOutlet fileprivate var cancelButton: UIButton! {
    didSet {
      guard let v = self.cancelButton else { return }
      v.alpha = 0.0
      v.addTarget(self, action: #selector(self.cancel(_:)), for: .touchUpInside)
    }
  }

  @IBOutlet fileprivate var cancelButtonWidth: NSLayoutConstraint! {
    didSet {
      guard let v = self.cancelButtonWidth else { return }
      v.constant = 0.0
      v.isActive = true
    }
  }

  deinit {
    guard self.isViewLoaded else { return }
    
    self.textField.delegate = nil
    
    let nc = NotificationCenter.default
    nc.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    nc.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
}

//
// MARK: - Keyboard
//
extension SimpleTextFieldViewController {
  
  func keyboardWillShow(_ n: Notification) {
    self.cancelButtonWidth.constant = 80.0

    UIView.animate(
      withDuration: 0.25,
      delay: 0.0,
      options: [.curveEaseOut, .beginFromCurrentState],
      animations: {
        self.cancelButton.alpha = 1.0
        self.view.layoutIfNeeded()
      },
      completion: nil
    )
  }

  func keyboardWillHide(_ n: Notification) {
    self.cancelButtonWidth.constant = 0.0

    UIView.animate(
      withDuration: 0.25,
      delay: 0.0,
      options: [.curveEaseOut, .beginFromCurrentState],
      animations: {
        self.cancelButton.alpha = 0.0
        self.view.layoutIfNeeded()
      },
      completion: nil
    )
  }

  func cancel(_ sender: UIControl) {
    self.view.endEditing(true)
  }
}

//
// MARK: - UITextFieldDelegate
//
extension SimpleTextFieldViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
