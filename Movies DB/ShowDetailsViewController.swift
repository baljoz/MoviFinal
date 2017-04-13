//
//  ShowDetailsViewController.swift
//  Movies DB
//
//  Created by Milos Stosic on 4/11/17.
//  Copyright © 2017 Milos Stosic. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
   
    var movies = Movie()
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var ttitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptions: UITextView!
    
    @IBOutlet weak var productionText: UITextView!
    
    @IBOutlet weak var ggenresText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        img1.image = movies.poster
        ttitle.text = movies.title
      
        
        
        releaseDate.text = movies.release_date
        descriptions.text = movies.overview

        ggenresText.text = ""
        productionText.text = ""
        
        if !movies.isLoad {
        getServerData ()
        }
        setProduciton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getServerData () -> Void
    {
   
        let ID = String(movies.id)
        let url = URL(string: "https://api.themoviedb.org/3/movie/"+ID+"?api_key=45e2e6359cc3ea28ae0a581788ecaef9&language=en-US")
        
        let task = URLSession.shared.dataTask(with: url!) { (data ,response , error) in
            if error != nil{
                print ("ERROR")
            }
            else{
                if let content = data{
                    do {
                        
                        let myJson = try JSONSerialization.jsonObject(with: content) as! [String: AnyObject]
                        
                        let re = myJson
                        print (myJson)
                       
                            
                            self.movies.budget = re["budget"] as! Int
                            self.movies.homepage = re["homepage"] as? String ?? ""
                            self.movies.imdb_id = re["imdb_id"] as? String ?? ""
                            self.movies.status = re["status"] as? String ?? ""
                            self.movies.tagline = re["tagline"] as? String ?? ""
                            
                            let genr = re["genres"] as! [[String : AnyObject]]
                            for ge in genr {
                                var myStruct = genres()
                                myStruct.id = ge["id"] as! Int
                                myStruct.name = ge["name"] as? String ?? ""
                                self.movies.genre.append(myStruct)
                            }
                            let product  = re["production_companies"] as! [[String : AnyObject]]
                            for pro in product {
                                var myStruct = genres()
                                myStruct.id = pro["id"] as! Int
                                myStruct.name = pro["name"] as? String ?? ""
                                self.movies.production_compani.append(myStruct)
                            }
                            let proCotry = re["production_companies"] as! [[String : AnyObject]]
                            for cont in proCotry {
                                var myStruct = production_countries()
                                myStruct.iso_639_1 = cont["iso_639_1"] as? String ?? ""
                                myStruct.name = cont["name"] as? String ?? ""
                                self.movies.production_countri.append(myStruct)
                            }
                            
                            let spoken = re["spoken_languages"] as! [[String : AnyObject]]
                            for spok in spoken {
                                var myStruct = production_countries()
                                myStruct.iso_639_1 = spok["iso_639_1"] as? String ?? ""
                                myStruct.name = spok["name"] as? String ?? ""
                                self.movies.spoken_languages.append(myStruct)
                            }
                            
                       
                           
                            
                        
                        
                        self.movies.isLoad = true
                        DispatchQueue.main.async {
                            self.setProduciton()
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
    
    func setProduciton () -> Void
    {
        self.productionText.text? = ""
        self.productionText.text = ""
        var count = 1
        for gr in self.movies.genre
        {
            
            if gr.name != "" {
                self.ggenresText.text?.append(gr.name)
                if count < self.movies.genre.count {
                    self.ggenresText.text?.append(",")
                }
                
                
            }
            count += 1
            
        }
        count = 1
        for pro in self.movies.production_compani
        {
            if pro.name != ""
            {
                self.productionText.text?.append(pro.name)
                if count < self.movies.production_compani.count
                {
                    self.productionText.text?.append(",")
                }
            }
            count += 1
        }

    
    }

    @IBAction func back(_ sender: UISwipeGestureRecognizer) {
        
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "main") as! ViewController
        let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
        self.present(newFrontController, animated: false, completion: nil)
        
        
    }
    
    @IBAction func goToimdb(_ sender: Any) {
        var imdb = "http://www.imdb.com/title/"
        imdb.append(movies.imdb_id)
        let url = NSURL(string: imdb)!
        UIApplication.shared.openURL(url as URL)
    }
    
}
