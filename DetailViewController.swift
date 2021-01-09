//
//  DetailViewController.swift
//  JansixoneAPI
//
//  Created by 황현지 on 2021/01/09.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var videoLabel: UILabel!
    
    var id : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = String(id)
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    

    func getData() {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=b804ea7f3826d58a902a69a0e017708f&language=en-US"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if err != nil {
                return print("err",err?.localizedDescription)
            } else {
                //파싱
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print("+++++++++++++++", jsonResult)
                    self.titleLabel.text = jsonResult["original_title"] as! String
                    self.videoLabel.text = jsonResult["status"] as! String
                    self.languageLabel.text = jsonResult["original_language"] as! String
                    
                    self.navigationItem.title = jsonResult["original_title"] as! String
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }

}
