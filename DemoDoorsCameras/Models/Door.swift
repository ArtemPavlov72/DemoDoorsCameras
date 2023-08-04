//
//  Door.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 03.08.2023.
//

import RealmSwift

//MARK: - Data transfer objet

struct Door: Codable, Hashable {
  let success: Bool
  let data: [DoorInfo]
}

struct DoorInfo: Codable, Hashable {
  let name: String
  let snapshot: String?
  let room: String?
  let id: Int
  let favorites: Bool
}

//MARK: - Realm models

class RealmDoor: Object {
  @Persisted var success: Bool
  @Persisted var data = List<RealmDoorInfo>()
}

class RealmDoorInfo: Object {
  @Persisted var name: String
  @Persisted var snapshot: String?
  @Persisted var room: String
  @Persisted var id: Int
  @Persisted var favorites: Bool
}
