//
//  ViewController.swift
//  CoreDataPOC
//
//  Created by Techjini on 09/12/16.
//  Copyright © 2016 Techjini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bookTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    let helper = BookHelper()
    var books = [Book]() {
        didSet {
            bookTableView.reloadData()
        }
    }
    let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let predicate = NSPredicate(format: "notFavourite == false")
        let bookEntities: [BookEntity] = coreDataManager.fetchRequest(entity: "BookEntity",
                                                                      predicate: predicate)
        books = bookEntities.map({ return Book(title: $0.title,
                                               description: $0.bookDescription,
                                               imageUrl: URL(string: $0.url ?? ""),
                                               publisher: $0.publisher,
                                               publishDate: $0.publishDate,
                                               authors: $0.authors)})
        
        if books.isEmpty {
            createRequest()
        }
        refreshControl.addTarget(self,
                                 action: #selector(ViewController.createRequest),
                                 for: .valueChanged)
        bookTableView.refreshControl = refreshControl
        bookTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private Methods
    func createRequest() {
        deleteBookFromCoreData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        helper.createBookRequest {[weak self] (books, error) in
            self?.refreshControl.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let responseError = error else {
                self?.saveToCoreData(books ?? [])
                self?.books = books ?? []
                return
            }
            print("\(responseError.localizedDescription)")
        }
    }
    
    private func saveToCoreData(_ books: [Book]) {
        _ = books.map({coreDataManager.saveBookEntityfrom(book: $0)})
    }
    
    private func deleteBookFromCoreData() {
        coreDataManager.deleteBooks()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let predicate = NSPredicate(format: "notFavourite == false")
            let bookEntities: [BookEntity] = coreDataManager.fetchRequest(entity: "BookEntity",
                                                                          predicate : predicate)
            bookEntities[indexPath.row].notFavourite = true
            books.remove(at: indexPath.row)
            coreDataManager.saveChnages()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        cell.book = books[indexPath.row]
        return cell
    }
    
}
