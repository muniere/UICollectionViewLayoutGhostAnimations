//
//  MainViewController.swift
//  UICollectionViewLayoutGhostAnimations
//
//  Created by Hiromune Ito on 2017/05/14.
//  Copyright © 2017 Hiromune Ito. All rights reserved.
//

import UIKit

//
// MARk: - Enum
//
enum MainViewEntry {
  case simpleTextField
  case collectionTextField
}

//
// MARK: - UIViewController
//
class MainViewController: UIViewController {

  @IBOutlet fileprivate var tableView: UITableView! {
    didSet {
      guard let v = self.tableView else { return }
      v.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
      v.tableFooterView = UIView()
      v.rowHeight = 60.0
      v.dataSource = self
      v.delegate = self
    }
  }

  fileprivate let entries: [MainViewEntry] = [
    .simpleTextField,
    .collectionTextField,
  ]

  deinit {
    guard self.isViewLoaded else { return }
    self.tableView.dataSource = nil
    self.tableView.delegate = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Index"
  }
}

//
// MARK: - UITableViewDataSource
//
extension MainViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.entries.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
  }
}

//
// MARK: - UITableViewDelegate
//
extension MainViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.textLabel?.text = String(describing: self.entries[indexPath.row])
    cell.accessoryType = .disclosureIndicator
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let entry: MainViewEntry = self.entries[indexPath.row]

    switch entry {
    case .simpleTextField:
      typealias Controller = SimpleTextFieldViewController
      
      let sb: UIStoryboard = .init(name: String(describing: Controller.self), bundle: nil)
      
      guard
        let nvc = self.navigationController,
        let vc = sb.instantiateInitialViewController() as? Controller
      else {
        return
      }

      vc.title = String(describing: entry)
      nvc.pushViewController(vc, animated: true)

    case .collectionTextField:
      typealias Controller = CollectionTextFieldViewController

      let sb: UIStoryboard = .init(name: String(describing: Controller.self), bundle: nil)
      
      guard
        let nvc = self.navigationController,
        let vc = sb.instantiateInitialViewController() as? Controller
      else {
        return
      }

      vc.title = String(describing: entry)
      nvc.pushViewController(vc, animated: true)
    }
  }
}
