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

  func fetchData<T: Decodable>(dataType: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
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
        let type = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async {
          completion(.success(type))
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
  
  func loadImageWithCache(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
      URLSession.shared.dataTask(with: url) { data, response, error in
          guard let data = data, let response = response else {
              return
          }
          guard url == response.url else {return}
          DispatchQueue.main.async {
              completion(data, response)
          }
      }.resume()
  }
}
