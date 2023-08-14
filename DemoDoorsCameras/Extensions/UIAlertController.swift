//
//  UIAlertController.swift
//  DemoDoorsCameras
//
//  Created by Artem Pavlov on 11.08.2023.
//

import UIKit

extension UIAlertController {

  static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
    UIAlertController(title: title, message: message, preferredStyle: .alert)
  }

  func cameraAction(camera: RealmCameraInfo?, completion: @escaping(String) -> Void) {
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      guard let textValue = self.textFields?.first?.text, !textValue.isEmpty else {
        return
      }
      completion(textValue)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

    addAction(saveAction)
    addAction(cancelAction)
    addTextField { textField in
      textField.placeholder = "Enter camera name"
      textField.text = camera?.name
    }
  }

  func doorAction(door: RealmDoorInfo?, completion: @escaping(String) -> Void) {
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      guard let textValue = self.textFields?.first?.text, !textValue.isEmpty else {
        return
      }
      completion(textValue)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

    addAction(saveAction)
    addAction(cancelAction)
    addTextField { textField in
      textField.placeholder = "Enter camera name"
      textField.text = door?.name
    }
  }

}
