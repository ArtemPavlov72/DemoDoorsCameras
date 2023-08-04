//
//  NetworkManager.swift
//  DemoDoorsCameras
//
//  Created by Артем Павлов on 04.08.2023.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
}

class NetworkManager {
  static let shared = NetworkManager()
  private init() {}

  func fetchData(from url: String, completion: @escaping(Result<Camera, NetworkError>) -> Void) {
    guard let url = URL(string: url) else {
      completion(.failure(.invalidURL))
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data else {
        completion(.failure(.noData))
        print(error?.localizedDescription ?? "no description")
        return
      }

      do {
        let camera = try JSONDecoder().decode(Camera.self, from: data)
        DispatchQueue.main.async {
          completion(.success(camera))
        }
      } catch {
        completion(.failure(.decodingError))
      }
    } .resume()
  }

}

class ImageManager {
  static let shared = ImageManager()
  private init() {}
  
  func loadImage(from url: String?) -> Data? {
    guard let imageURL = URL(string: url ?? "") else {return nil}
    return try? Data(contentsOf: imageURL)
  }
}
