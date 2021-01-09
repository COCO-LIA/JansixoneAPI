//
//  ViewController.swift
//  JansixoneAPI
//
//  Created by 황현지 on 2021/01/06.
//

import UIKit
import ProgressHUD
//ALAMOFIRE 1-3
import Alamofire
import Kingfisher

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
        
        ProgressHUD.animationType = .lineScaling
        //ProgressHUD.showProgress(1.5)
        ProgressHUD.show()
        
        //네트워킹 방법 3 Json 형태
        
        AF.request(request).responseJSON { (data) in
            if data.error != nil {
                ProgressHUD.dismiss()
                return print("err", data.error?.localizedDescription as Any)
            }
            
            print(data.data)
            self.results = self.parseJsonData(orgData: data.data!)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
//            print("+++++++++++", self.results)
            
        }
        
        
        //네트워킹 방법2 ALAMOFIRE
        //ALAMOFIRE 1-1 .pods > podfile > pod 'Alamofire' 추가
        //ALAMOFIRE 1-2. 추가 후 터미널 > pod install
        //ALAMOFIRE 1-4. (Making request)
        
         //af에 요청 하고     -  요청 응답을 데이터 형식으로 받은것
//        AF.request(request).responseData { (data) in
//           // print(data.data) data.err
//            if data.error != nil {
//                ProgressHUD.dismiss()
//                return print("err", data.error?.localizedDescription)
//            } else { //데이터파싱
//                //오리지널 데이터 = data.data
//                self.results = self.parseJsonData(orgData: data.data!)
//                OperationQueue.main.addOperation {
//                    self.tableView.reloadData()
//                    ProgressHUD.dismiss()
//                }
//            }
//        }.resume()
//    }
        
       
        
//        //네트워킹 방법1. url session //session 접속하기 / task 특정작업 수행하기
//        URLSession.shared.dataTask(with: request) { [self] (data, response, err) in
//            print("+++++++res++++++++", response)
//            if err != nil {
//                ProgressHUD.dismiss()
//                return print("err", err?.localizedDescription)
//            } else {
//                self.results = parseJsonData(orgData: data!)
//
//                //*테이블뷰 새로고침
//                OperationQueue.main.addOperation {
//                    self.tableView.reloadData()
//                    ProgressHUD.dismiss()
//                }
//            }
//
//        }.resume()
        
    }
    //전체 데이터 json파싱
    func parseJsonData(orgData:Data) -> [Result] {
        self.results = [Result]()
        
        //데이터파싱 2-4.
        let decoder = JSONDecoder()
        
        do {                                     //decoding할것을 넣어줌
      //Decode:JSON 데이터를 decodable 자료형에 저장하는 작업이다. 마찬가지로 try의 사용을 강제하고, 원본 데이터로 Data 자료형을 요구한다.
         let resultDataStore = try decoder.decode(ResultDataStore.self, from: orgData)
            print("___________-______", resultDataStore.results)
            results = resultDataStore.results
        } catch {
            print(error)
        }
        
        return results
        
        
        //데이터 파싱방법 1
//        do {
//
//            //웹에 있는 자료
//            let jsonResult = try JSONSerialization.jsonObject(with: orgData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
//
//            let jsonResults = jsonResult["results"] as! [AnyObject]
//            print(jsonResults)
//
//            for jsonResult in jsonResults {
//                var result = Result()
//
//                result.language = jsonResult["original_language"] as! String
//                result.title = jsonResult["original_title"] as! String
//                result.overview = jsonResult["overview"] as! String
//             //   result.popularity = jsonResult["popularity"] as! Float
//                result.video = jsonResult["video"] as! Bool
//
//                results.append(result)
//            }
//
//        } catch {
//            print("----------------",error)
//        }
        
        //데이터 파싱방법 2.
        //2-1.Result로 간다
//        return results
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let indexpath = self.tableView.indexPathForSelectedRow
        let indexId = results[indexpath!.row].id
        
        destination.id = indexId
        
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
        cell1.overViewLabel.text = results[indexPath.row].overView
        let imgurl = URL(string: "https://image.tmdb.org/t/p/w500\(results[indexPath.row].poster)")
        cell1.imgView.kf.setImage(with: imgurl)
        
        return cell1
    }
}
