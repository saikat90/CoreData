//
//  BookHelper.swift
//  CoreDataPOC
//
//  Created by Techjini on 1/10/18.
//  Copyright © 2018 Techjini. All rights reserved.
//

import Foundation

let bookRequestAPI = "https://www.googleapis.com/books/v1/volumes?q=quilting&maxResults=20"

struct BookHelper {
    
    func createBookRequest(completion: ((_ books: [Book]?, _ error: Error?) -> Void)?) {
        guard let url = URL(string: bookRequestAPI) else  { return }
        let bookRequest = URLRequest(url: url)
        let coreService = CoreService(request: bookRequest)
        coreService.makeRequest { (data, error) in
            guard let data = data, let books = self.convertDataToDictionary(data: data) else {
                completion?(nil, error)
                return
            }
            completion?(books,nil)
        }
    }
    
    func convertDataToDictionary(data: Data) -> [Book]? {
        do {
            let bookVolumes =  try JSONDecoder().decode(BookVolumes.self, from: data)
            return bookVolumes.books
        } catch let error as NSError {
            print("\(error)")
            return nil
        }
    }
    
}
