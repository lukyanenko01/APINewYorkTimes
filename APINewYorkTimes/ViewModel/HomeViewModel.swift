//
//  HomeViewModel.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 12.07.2023.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var activeTag: BookCategory = .hardcoverNonfiction
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var bookCategories: [String] = []

    let networkManager = NetworkManager()

//    init() {
//        fetchBookCategories()
//    }
//
//    func fetchBookCategories() {
//        networkManager.fetchAllCategories { [weak self] result in
//            switch result {
//            case .success(let categories):
//                DispatchQueue.main.async {
//                    self?.bookCategories = categories
//                    if let firstCategory = categories.first {
//                        self?.activeListName = firstCategory
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.error = error
//                }
//            }
//        }
//    }

    func fetchBooks() {
        self.error = nil
        networkManager.cancelCurrentTask()

        if !self.isLoading {
            self.isLoading = true
            self.books = []
            
            networkManager.fetchBooks(for: activeTag.rawValue) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedBooks):
                        self?.books = fetchedBooks.books
                    case .failure(let error):
                        self?.error = error
                    }
                    self?.isLoading = false
                }
            }
        }
    }

    func handleTagTap(_ tag: BookCategory) {
        if !isLoading {
            activeTag = tag
            fetchBooks()
        }
    }
}

//
//class HomeViewModel: ObservableObject {
////    @Published var activeTag: BookCategory = .hardcoverNonfiction
//    @Published var activeListName: String = "Hardcover Nonfiction"
//    @Published var bookCategories: [String] = []
//    @Published var books: [Book] = []
//    @Published var isLoading: Bool = false
//    @Published var error: Error?
//
//
//    let networkManager = NetworkManager()
//
//    init() {
//        fetchBookCategories()
//    }
//
//    func fetchBookCategories() {
//        networkManager.fetchAllCategories { [weak self] result in
//            switch result {
//            case .success(let categories):
//                self?.bookCategories = categories
//            case .failure(let error):
//                self?.error = error
//            }
//        }
//    }
//
//    func fetchBooks() {
//        self.error = nil
//        networkManager.cancelCurrentTask()
//
//        if !self.isLoading {
//            self.isLoading = true
//            self.books = []
//
//            networkManager.fetchBooks(for: activeTag.rawValue) { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let fetchedBooks):
//                        self?.books = fetchedBooks.books
//                    case .failure(let error):
//                        self?.error = error
//                    }
//                    self?.isLoading = false
//                }
//            }
//        }
//    }
//
//    func handleTagTap(_ tag: BookCategory) {
//        if !isLoading {
//            activeTag = tag
//            fetchBooks()
//        }
//    }
//}
//
