//
//  StorageManagerRealm.swift
//  DemoDoorsCameras
//
//  Created by Artem Pavlov on 04.08.2023.
//

import Foundation
import RealmSwift

// MARK: - Realm

class StorageManagerRealm {
  static let shared = StorageManagerRealm()
  let realm = try! Realm()
  init() {}

  //MARK: - Realm writing data

  private func write(completion: () -> Void) {
    do {
      try realm.write {
        completion()
      }
    } catch let error {
      print(error)
    }
  }

  //MARK: - Realm private methods of Door
  
  func save(_ doors: [RealmDoorInfo]) {
    write {
      realm.add(doors)
    }
  }

  func save(_ cameras: [RealmCameraInfo]) {
    write {
      realm.add(cameras)
    }
  }

  func rename(_ camera: RealmCameraInfo, newName: String) {
    write {
      camera.name = newName
    }
  }

  func rename(_ door: RealmDoorInfo, newName: String) {
    write {
      door.name = newName
    }
  }

  func addToFavorite(_ camera: RealmCameraInfo) {
    write {
      camera.favorites.toggle()
    }
  }

  func addToFavorite(_ door: RealmDoorInfo) {
    write {
      door.favorites.toggle()
    }
  }
}
