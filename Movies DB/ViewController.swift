//
//  ViewController.swift
//  Movies DB
//
//  Created by Milos Stosic on 4/10/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UISearchBarDelegate , UISearchDisplayDelegate{

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var sing = MySingleton.sharedInstance
    @IBOutlet weak var info: UILabel!
    var movies = [Movie]()
    private var page : Int = 1
       override func viewDidLoad() {
        super.viewDidLoad()
      
        activity.stopAnimating()
        activity.isHidden=true
         info.isHidden = false
      if sing.isLoad
      {
            for m in sing.movies
            {
            movies.append(m)
            }
            info.isHidden = true
            tableView.reloadData()
            }
        
      // self.tableView.tableHeaderView = searchBar
       self.searchBar.delegate = self
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 // MARK Table View 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        cell.title.text  = movies[indexPath.row].original_title
        cell.img.image = movies[indexPath.row].poster
        cell.ddescription.text = movies[indexPath.row].overview
        
        return cell
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies.removeAll()
        for m in self.sing.movies
        {
            self.movies.append(m)
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "details") as! ShowDetailsViewController
        newViewcontroller.movies = movies[indexPath.row]
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
        
        
        self.present(newFrontController, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !sing.movies[indexPath.row].isLoad {
            let rotateTransform = CATransform3DTranslate(CATransform3DIdentity , -500, 10, 0)
            cell.layer.transform = rotateTransform
            UIView.animate(withDuration: 0.5,  animations: {() -> Void in
                
             
                cell.layer.transform = CATransform3DIdentity
                self.sing.movies[indexPath.row].isLoad = true
            })
        }
      
    }
    
    
    // MARK Search Bar
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        sing.page = 1
        sing.mName = searchBar.text!
        sing.movies.removeAll()
        movies.removeAll()

        getServerData()
        activity.startAnimating()
        activity.isHidden=false
        tableView.isHidden = true
        info.isHidden = true
        
    }

    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        
    }
    
    func filterTableView(ind:Int,text:String) {
    
         movies = sing.movies.filter({ (mod) -> Bool in
            return mod.title.lowercased().contains(text.lowercased()) })
      
    }
    
    
    
    //MARK Scroll
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if sing.maxpage > 0 && sing.maxpage >= sing.page && sing.isLoad {
            getServerData() }
        
    }
    
    
    func getServerData () -> Void
    {
        let pag = String(sing.page)
        var muvieName = sing.mName
       muvieName =  muvieName.replacingOccurrences(of: " ", with: "+")
        sing.page+=1
        
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=45e2e6359cc3ea28ae0a581788ecaef9&language=en-US&query="+muvieName+"&page="+pag+"&include_adult=false")
        
        let task = URLSession.shared.dataTask(with: url!) { (data ,response , error) in
            if error != nil{
                print ("ERROR")
            }
            else{
                if let content = data{
                    do {
                        
                        let myJson = try JSONSerialization.jsonObject(with: content) as! [String: AnyObject]
                        
                        let res = myJson["results"] as! [[String : AnyObject]]
                        print (myJson)
                        self.sing.maxpage = myJson["total_pages"] as! Int
                       for re in res
                       {
                      
                        let myMovie = Movie ()
                        myMovie.adult = re["adult"] as! Bool
                        myMovie.backdrop_path = re["bacldrop_path"] as? String ?? ""
                        myMovie.overview = re["overview"] as? String ?? ""
                        myMovie.release_date = re["release_date"] as? String ?? ""
                        myMovie.id = re["id"] as! Int
                        myMovie.original_title = re["original_title"] as? String ?? ""
                        myMovie.original_language = re["original_language"] as? String ?? ""
                        myMovie.title = re["title"] as? String ?? ""
                        myMovie.backdrop_path = re["backdrop_path"] as? String ?? ""
                        let pop = re["popularity"] as! Int
                        myMovie.popularity = String (pop)
                        myMovie.vote_count = re["vote_count"] as! Int
                        myMovie.video = re["video"]  as! Bool
                        myMovie.vote_average = re["vote_average"] as! Int
                        myMovie.poster_path.append(re["poster_path"] as? String ?? "")
                        
                        self.sing.movies.append(myMovie)
                        self.movies.append(myMovie)
                        }
                        
                        self.LoadImage()
                        self.sing.isLoad = true
                        
                        DispatchQueue.main.async {
                           self.activity.stopAnimating()
                            self.activity.isHidden=true
                            self.tableView.isHidden = false
                        self.tableView.reloadData()
                            let p = self.searchBar.text
                            self.searchBar.text?.removeAll()
                            self.searchBar.text = p
                           
                        }
                      
                   
                    }
                    catch{
                        print ("error")
                    }
                
                }
            
            }
        }
        task.resume()
        
        
       
    }
  

    func LoadImage () -> Void {
        for i in 0..<sing.movies.count {
            if sing.movies[i].poster_path != ""
            {
            var url = "http://image.tmdb.org/t/p/w185/"
                url.append(sing.movies[i].poster_path)
            let str = NSURL(string : url)
            let dst = NSData(contentsOf: str! as URL)!
                
             sing.movies[i].poster =  UIImage(data: dst as Data)!
            }
            else {
                sing.movies[i].poster =  UIImage(named: "noImage")!
            }
            
        }
          }
    
    
    
    
    }
