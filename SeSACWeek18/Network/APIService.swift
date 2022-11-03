//
//  APIService.swift
//  SeSACWeek18
//
//  Created by 이현호 on 2022/11/02.
//

import Foundation
import Alamofire

struct Login: Codable {
    let token: String
}

struct Profile: Codable {
    let user: Inform
}

struct Inform: Codable {
    let photo: String
    let email: String
    let username: String
}

enum SeSACError: Int, Error {
    case invalidAuthorization = 401
    case takenEmail = 406
    case emptyParameters = 501
}

extension SeSACError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidAuthorization:
            return "토큰이 만료되었습니다. 다시 로그인 해주세요"
        case .takenEmail:
            return "이미 가입된 회원입니다. 로그인 해주세요."
        case .emptyParameters:
            return "파라미터가 없습니다."
        }
    }
}

class APIService {
    
    func requestSeSAC<T: Decodable>(type: T.Type = T.self, url: URL, method: HTTPMethod = .get, parameters: [String:String]? = nil, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data)) //escaping, Result, Enum, 연관값
                case .failure(_):
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            }
    }
    
    func signup(userName: String, email: String, password: String) {
        let api = SeSACAPI.signup(userName: userName, email: email, password: password)
        
        //이 블럭을 하나로 합쳐볼 수 없을까?
        AF.request(api.url, method: .post, parameters: api.parameters, headers: api.headers).responseString { response in
            
            print(response)
            print(response.response?.statusCode)
            
        }
    }
    
    func login(email: String, password: String) {
        let api = SeSACAPI.login(email: email, password: password)
        
        AF.request(api.url, method: .post, parameters: api.parameters, headers: api.headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Login.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response .result {
                case .success(let data):
                    print(data.token)
                    UserDefaults.standard.set(data.token, forKey: "token")
                case .failure(let error):
                    print("상태코드1:",statusCode)
                    print(error)
                }
            }
    }
    
    func profile() {
        let api = SeSACAPI.profile
        
        AF.request(api.url, method: .get, headers: api.headers).responseDecodable(of: Profile.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("상태코드2:", statusCode)
            }
        }
    }
}
