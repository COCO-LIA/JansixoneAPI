//
//  ViewController.swift
//  JansixoneAPI
//
//  Created by 황현지 on 2021/01/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var results = [Result]()
    
    let originalAddress = "https://api.themoviedb.org/3/movie/now_playing?api_key=b804ea7f3826d58a902a69a0e017708f&language=en-US&page=1"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
    
    }

    func getData() {
        
        let resultUrl = URL(string: originalAddress)
        let request = URLRequest(url: resultUrl!)
        
        //네트워킹 //session 접속하기 / task 특정작업 수행하기
        URLSession.shared.dataTask(with: request) { [self] (data, response, err) in
            print("+++++++res++++++++", response)
            if err != nil {
                return print("err", err?.localizedDescription)
            } else {
                self.results = parseJsonData(orgData: data!)
                
                //*테이블뷰 새로고침
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        }.resume()
        
    }
    //전체 데이터 json파싱
    func parseJsonData(orgData:Data) -> [Result] {
        self.results = [Result]()
        
        do {
            
            //웹에 있는 자료
            let jsonResult = try JSONSerialization.jsonObject(with: orgData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            
            let jsonResults = jsonResult["results"] as! [AnyObject]
            print(jsonResults)
            
            for jsonResult in jsonResults {
                var result = Result()
                
                result.language = jsonResult["original_language"] as! String
                result.title = jsonResult["original_title"] as! String
                result.overview = jsonResult["overview"] as! String
             //   result.popularity = jsonResult["popularity"] as! Float
                result.video = jsonResult["video"] as! Bool
                
                results.append(result)
            }
            
        } catch {
            print("----------------",error)
        }
        return results
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Cell1
        
        cell1.languageLabel.text = results[indexPath.row].language
        cell1.titleLabel.text = results[indexPath.row].title
        cell1.videoLabel.text = "\(results[indexPath.row].video)"
        cell1.overViewLabel.text =
            results[indexPath.row].overview
        
        return cell1
    }
}
