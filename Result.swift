//
//  Result.swift
//  JansixoneAPI
//
//  Created by 황현지 on 2021/01/06.
//

import Foundation

//데이터파싱 2-2. 주석처리
//struct Result {
//    var language : String = ""
//    var title : String = ""
//    var overview : String = ""
//    //var popularity : Float = 0
//    var video : Bool = false
//}

//데이터파싱 2-3 codable 형식. 찍어내듯이 담아서 데이터를 넣어주는 방법
//초기값을 줄 때는 let이 아니라 var로 선언한다. let은 상수라서 다음번에 정보를 가진 JSON이 들어오더라도 고정되기 떄문

struct Result: Codable {
    var language : String = ""
    var title : String = ""
    var overView : String = ""
    var popularity : Float = 0.0
    var video : Bool = false
    var poster : String = ""
    var id : Int = 0
    
                   //형식
    enum CodingKeys: String, CodingKey {
        case language = "original_language"
        case title = "original_title"
        case overView = "overview"
        case popularity
        case video
        case poster = "poster_path"
        case id
        //하위 요소일경우 case country(하위) = "location"(상위)식으로 작성
    }
    
    //enum LocationKeys : String, CodingKey {
    //  case country }
    
    //decoder로부터 초기화를 설정하는 것
    //Decode:JSON 데이터를 decodable 자료형에 저장하는 작업이다. 마찬가지로 try의 사용을 강제하고, 원본 데이터로 Data 자료형을 요구한다.
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language = try values.decode(String.self, forKey: .language)
        title = try values.decode(String.self, forKey: .title)
        overView = try values.decode(String.self, forKey: .overView)
        //하위 요소일 경우
        //let locatio = try values.mestedContainer(KeyedBy: LocationKeys.self, forKey: .country)
        //country = try location.decode(String.self, forKey: .country)
        popularity = try values.decode(Float.self, forKey: .popularity)
        video = try values.decode(Bool.self, forKey: .video)
        poster = try values.decode(String.self, forKey: .poster)
        id = try values.decode(Int.self, forKey: .id)
    }
}

struct ResultDataStore: Codable {
    var results: [Result]
}

//2-4 viewController파일로 가기
