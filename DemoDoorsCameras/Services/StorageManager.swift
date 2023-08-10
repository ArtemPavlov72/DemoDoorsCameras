//
//  StorageManager.swift
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
      try realm.write{ completion() }
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

  //    //create new section with contact
  //    func save(_ sectionWithContact: SectionTitleForContact) {
  //        write {
  //            realm.add(sectionWithContact)
  //        }
  //    }
  //
  //    //update list of contacts in section
  //    func save(_ contact: Contact, to section: SectionTitleForContact) {
  //        write {
  //            section.containsContacts.append(contact)
  //        }
  //    }
  //
  //    func delete(_ section: SectionTitleForContact) {
  //        write {
  //            realm.delete(section)
  //        }
  //    }
  //
  //    func delete(_ contact: Contact) {
  //        write {
  //            realm.delete(contact)
  //        }
  //    }
}
