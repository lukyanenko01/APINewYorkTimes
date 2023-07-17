//
//  NetworkManager.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 11.07.2023.
//

import Foundation
import UIKit

class NetworkManager {
    let baseURL = "https://api.nytimes.com/svc/books/v3/lists/current"
    let apiKey = "S7GRIeVGv4tl3KMIo5QPzujqj1BJ8eHl"

    private var currentTask: URLSessionDataTask?
    
    func fetchAllCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        // Здесь список всех возможных категорий, которые вы знаете
        let allKnownCategories = BookCategory.allCases.map { $0.rawValue }
        var allCategories = Set<String>()

        let group = DispatchGroup()

        for category in allKnownCategories {
            group.enter()

            fetchBooks(for: category) { result in
                switch result {
                case .success(let bookList):
                    allCategories.insert(bookList.listName)
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(Array(allCategories)))
        }
    }


    func fetchBooks(for category: String, completion: @escaping (Result<NYTBestSellerList, Error>) -> Void) {
        let formattedCategory = category.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "\(baseURL)/\(formattedCategory).json?api-key=\(apiKey)"),
              UIApplication.shared.canOpenURL(url) else {
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
                    if let results = listResponse.results {
                        completion(.success(results))
                    } else {
                        completion(.failure(URLError(.badServerResponse)))
                    }
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
