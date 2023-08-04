//
//  Camera.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 03.08.2023.
//

import RealmSwift

//MARK: - Data transfer objet

struct Camera: Codable, Hashable {
  let success: Bool
  let data: CameraData?
}

struct CameraData: Codable, Hashable {
  let room: [String]
  let cameras: [CameraInfo]
}

struct CameraInfo: Codable, Hashable {
  let name: String
  let snapshot: String
  let room: String?
  let id: Float
  let favorites: Bool
  let rec: Bool?
}

//MARK: - Realm models

class RealmCamera: Object {
  @Persisted var success: Bool
  @Persisted var data: RealmCameraData?
}

class RealmCameraData: Object {
  @Persisted var room = List<String>()
  @Persisted var cameras = List<RealmCameraInfo>()
}

class RealmCameraInfo: Object {
  @Persisted var name: String
  @Persisted var snapshot: String
  @Persisted var room: String
  @Persisted var id: Int
  @Persisted var favorites: Bool
  @Persisted var rec: Bool
}
