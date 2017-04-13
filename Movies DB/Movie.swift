//
//  Movie.swift
//  Movies DB
//
//  Created by Milos Stosic on 4/10/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//
import UIKit
import Foundation

struct genres {
    var id : Int = 0
    var name : String = ""
}
struct production_countries {
    var iso_639_1 : String = ""
    var name : String = ""
}

class Movie {
    
      var adult : Bool = false
     var backdrop_path : String = ""
    var genre_ids : String  = ""
    var id : Int = 0
      var original_language : String = ""
     var original_title : String = ""
     var overview : String = ""
     var popularity : String = ""
      var poster_path :String = ""
      var release_date : String = ""
      var title : String = ""
     var  video : Bool = false
     var vote_average : Int = 0
     var vote_count : Int = 0
     var poster = UIImage()

    
    
    var budget : Int = 0
    var genre = [genres()]
    var homepage : String = ""
    var imdb_id : String = ""
    var production_compani = [genres()]
    var production_countri = [production_countries()]
    var status : String = ""
    var tagline : String = ""
    var spoken_languages  = [production_countries()]
    
    var isLoad : Bool = false
    
    init(adl : Bool , backDrop : String,genrIds :String , iD : Int , orgLang : String , orgTit : String , overve : String , popul : String , posterPath : String , realasedate : String , tiTle : String , vid : Bool , voteAverage : Int , voteCount : Int) {
        
        adult = adl
        backdrop_path = backDrop
        
 //     genre_ids = genrIds
        
        id = iD
        original_language = orgLang
        original_title = orgTit
        overview = overve
        popularity = popul
        poster_path = posterPath
        release_date = realasedate
        title = tiTle
        video = vid
        vote_average = voteAverage
        vote_count = voteCount
        
    }
    
    init () {
        
    }
 
  
}
