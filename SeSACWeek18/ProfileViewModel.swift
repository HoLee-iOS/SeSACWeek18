//
//  ProfileViewModel.swift
//  SeSACWeek18
//
//  Created by 이현호 on 2022/11/03.
//

import Foundation
import RxSwift

class ProfileViewModel {
    
    let profile = PublishSubject<Profile>()
    
    func getProfile() {
        
        let api = SeSACAPI.profile
        Network.shared.requestSeSAC(type: Profile.self, url: api.url, headers: api.headers) { [weak self] response in
            
            switch response {
            case .success(let success):
                self?.profile.onNext(success)
            case .failure(let failure):
                self?.profile.onError(failure)
            }
        }
        
    }
}
