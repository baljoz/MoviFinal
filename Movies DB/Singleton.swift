//
//  Singleton.swift
//  Movies DB
//
//  Created by Milos Stosic on 4/11/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import Foundation

/*
 
 I use this class not to send request to the server when you look at the details of the movie
 */

class MySingleton {
    
    static let sharedInstance = MySingleton()
    
    var movies = [Movie]()
    var maxpage = 1
    
    
    var mName : String = ""
    var page = 1
    var isLoad = false
    
}
