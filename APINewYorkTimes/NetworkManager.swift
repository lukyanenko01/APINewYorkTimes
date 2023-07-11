//
//  NetworkManager.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 11.07.2023.
//

import Foundation
class NetworkManager {
    let baseURL = "https://api.nytimes.com/svc/books/v3/lists/current"
    let apiKey = "S7GRIeVGv4tl3KMIo5QPzujqj1BJ8eHl"

    private var currentTask: URLSessionDataTask?

    func fetchBooks(for category: String, completion: @escaping (Result<NYTBestSellerList, Error>) -> Void) {
        let formattedCategory = category.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "\(baseURL)/\(formattedCategory).json?api-key=\(apiKey)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        currentTask?.cancel()
        currentTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let listResponse = try JSONDecoder().decode(NYTBestSellerListResponse.self, from: data)
                    completion(.success(listResponse.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        currentTask?.resume()
    }

    func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
}

//
//class NetworkManager {
//    let baseURL = "https://api.nytimes.com/svc/books/v3/lists/current"
//    let apiKey = "S7GRIeVGv4tl3KMIo5QPzujqj1BJ8eHl"
//
//    func fetchBooks(for category: String, completion: @escaping (NYTBestSellerList?) -> ()) {
//        let formattedCategory = category.replacingOccurrences(of: " ", with: "%20")
//        guard let url = URL(string: "\(baseURL)/\(formattedCategory).json?api-key=\(apiKey)") else {
//            print("Invalid URL")
//            completion(nil)
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error with dataTask: \(error)")
//                completion(nil)
//                return
//            }
//
//            guard let data = data else {
//                print("Data was nil")
//                completion(nil)
//                return
//            }
//
//            do {
//                let listResponse = try JSONDecoder().decode(NYTBestSellerListResponse.self, from: data)
//                completion(listResponse.results)
//            } catch {
//                print("Couldn't decode JSON: \(error)")
//                completion(nil)
//            }
//        }.resume()
//    }
//
//}
//
