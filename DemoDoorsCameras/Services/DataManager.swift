//
//  DataManager.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import Foundation

class DataManager {
  static let shared = DataManager()
  private init() {}

  // MARK: - Category Data
  func getFakeCategoryData() -> [String] {
    return ["Камеры", "Двери"]
  }
}
