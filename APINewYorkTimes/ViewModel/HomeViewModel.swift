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
    
    let networkManager = NetworkManager()
    
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

