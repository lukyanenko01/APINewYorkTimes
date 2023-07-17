//
//  Book.swift
//  APINewYorkTimes
//
//  Created by Vladimir Lukyanenko on 10.07.2023.
//

import Foundation

enum BookCategory: String, CaseIterable {
    case hardcoverNonfiction = "Hardcover Nonfiction"
    case combinedPrintAndEBookFiction = "Combined Print and E-Book Fiction"
    case combinedPrintAndEBookNonfiction = "Combined Print and E-Book Nonfiction"
    case hardcoverFiction = "Hardcover Fiction"
    case tradeFictionPaperback = "Trade Fiction Paperback"
    case massMarketPaperback = "Mass Market Paperback"
    case paperbackNonfiction = "Paperback Nonfiction"
    case eBookFiction = "E-Book Fiction"
    case eBookNonfiction = "E-Book Nonfiction"
}

struct NYTBestSellerListResponse: Codable {
    let status: String?
    let numResults: Int?
    let results: NYTBestSellerList?

    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
}

struct NYTBestSellerList: Codable {
    let listName: String
    let bestsellersDate: String
    let publishedDate: String
    let books: [Book]

    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case books
    }
}

struct Book: Codable, Identifiable {
    let id = UUID().uuidString
    let title: String
    let description: String
    let author: String
    let bookImage: String
    let amazonProductUrl: String

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case author
        case bookImage = "book_image"
        case amazonProductUrl = "amazon_product_url"
    }
}
