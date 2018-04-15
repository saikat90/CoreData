//
//  ImageCache.swift
//  CoreDataPOC
//
//  Created by Saikat on 24/03/18.
//  Copyright © 2018 Techjini. All rights reserved.
//

import Foundation


class ImageCache {
    
    public static let sharedInstance = ImageCache()
    private var imageCache = [URL: Data]()
    
    private init() {
        
    }
    
    func storeImageinCache(from url: URL, data: Data) {
        imageCache[url] = data
    }
    
    func getImagefrom(url: URL) -> Data? {
        return imageCache[url]
    }
}

