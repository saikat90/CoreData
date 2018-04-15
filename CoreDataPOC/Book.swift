//
//  Book.swift
//  CoreDataPOC
//
//  Created by Techjini on 1/10/18.
//  Copyright © 2018 Techjini. All rights reserved.
//

import Foundation

struct BookVolumes {
    let books: [Book]?
}

struct Book {
    let title: String?
    let description: String?
    let imageUrl: URL?
    let publisher: String?
    let publishDate: String?
    let authors: String?
    
    init(title: String?,
         description: String?,
         imageUrl: URL?,
         publisher: String?,
         publishDate: String?,
         authors: String?) {
        
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.publisher = publisher
        self.publishDate = publishDate
        self.authors = authors
    }
}


extension BookVolumes: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        books = try container.decode([Book]?.self, forKey: .items)
    }
}

extension Book: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case imageLinks = "imageLinks"
        case description = "description"
        case volumeInfo = "volumeInfo"
        case thumbnail = "thumbnail"
        case publisher = "publisher"
        case publishedDate = "publishedDate"
        case authors = "authors"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let volumeInfo = try container.nestedContainer(keyedBy: CodingKeys.self,
                                                       forKey: .volumeInfo)
        title = try volumeInfo.decode(String?.self,
                                      forKey: .title)
        do {
            let imageLinks = try volumeInfo.nestedContainer(keyedBy: CodingKeys.self,
                                                            forKey: .imageLinks)
            imageUrl = try imageLinks.decode(URL.self,
                                             forKey: .thumbnail)
        } catch {
            imageUrl = nil
        }
        do {
            publisher = try volumeInfo.decode(String?.self,
                                              forKey: .publisher)
        } catch {
            publisher = "NA"
        }
        publishDate = try volumeInfo.decode(String?.self,
                                            forKey: .publishedDate)
        do {
            authors = try volumeInfo.decode([String].self, forKey: .authors).joined(separator: ",")
        } catch {
            authors = "NA"
        }
        do {
            description = try volumeInfo.decode(String?.self,
                                                forKey: .description)
        } catch {
            description = "No Description Available"
        }
    }
}
