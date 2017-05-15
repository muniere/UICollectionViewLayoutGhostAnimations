//
//  CollectionTextFieldViewController.swift
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
class CollectionTextFieldViewController: UIViewController {

  @IBOutlet fileprivate var collectionView: UICollectionView! {
    didSet {
      guard let v = self.collectionView else { return }
      v.register(UINib(nibName: String(describing: CollectionTextFieldViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CollectionTextFieldViewCell.self))
      v.backgroundColor = .red
      v.dataSource = self
      v.delegate = self
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

  fileprivate var textField: UITextField? {
    guard
      let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? CollectionTextFieldViewCell
    else {
      return nil
    }

    return cell.textField
  }

  deinit {
    guard self.isViewLoaded else { return }
    
    self.collectionView.dataSource = nil
    self.collectionView.delegate = nil
    
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

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    self.collectionView.collectionViewLayout.invalidateLayout()
  }
}

//
// MARK: - Keyboard
//
extension CollectionTextFieldViewController {
  
  func keyboardWillShow(_ n: Notification) {
    self.cancelButtonWidth.constant = 80.0

    UIView.animate(
      withDuration: 0.25,
      delay: 0.0,
      options: [.curveEaseOut, .beginFromCurrentState],
      animations: {
        self.collectionView.collectionViewLayout.invalidateLayout()
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
        self.collectionView.collectionViewLayout.invalidateLayout()
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
// MARK: - UICollectionViewDataSource
//
extension CollectionTextFieldViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionTextFieldViewCell.self), for: indexPath)
  }
}

//
// MARK: - UICollectionViewDelegate
//
extension CollectionTextFieldViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
}

//
// MARK: - UICollectionViewDelegateFlowLayout
//
extension CollectionTextFieldViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
}
