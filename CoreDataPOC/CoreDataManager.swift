//
//  CoreDataManager.swift
//  CoreDataPOC
//
//  Created by Techjini on 2/14/18.
//  Copyright © 2018 Techjini. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    
    var appDelegate: AppDelegate?  {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func deleteBooks(){
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BookEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext?.execute(deleteRequest)
            try managedContext?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func saveBookEntityfrom(book: Book) {
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        let bookEntity = BookEntity(context: managedContext!)
        bookEntity.title = book.title
        bookEntity.authors = book.authors
        bookEntity.publishDate = book.publishDate
        bookEntity.bookDescription = book.description
        bookEntity.url = book.imageUrl?.absoluteString ?? ""
        bookEntity.notFavourite = false
        appDelegate?.saveContext()
    }
    
    func fetchRequest<T: NSManagedObject>(entity: String, predicate: NSPredicate? = nil) -> [T] {
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        do {
            let records = try managedContext?.fetch(fetchRequest) as! [T]
            return records
        } catch {
            print(error)
        }
        return []
    }
    
    func saveChnages() {
        appDelegate?.saveContext()
    }
}
