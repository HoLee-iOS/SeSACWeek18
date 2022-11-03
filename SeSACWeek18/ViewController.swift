//
//  ViewController.swift
//  SeSACWeek18
//
//  Created by 이현호 on 2022/11/02.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController { //프로필
    
    let label = UILabel()
    
    let viewModel = ProfileViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phone = Phone()
        
        print(phone.numbers[2])
        print(phone[1])
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(50)
        }
        
        viewModel.profile // <Single>, Syntax Sugar
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.label.text = value.user.email
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        viewModel.getProfile()
        
        checkCOW()
    }
    
    //값 타입, 참조 타입 8회차
    //copyOnWrite - 값타입이지만 참조하는 경우
    func checkCOW() {
        
        var test = "h-ho"
        address(&test) // inout 매개변수
        
        print(test[2])
        print(test[200])
        
        var test2 = test
        address(&test2)
        
        test2 = "sesac"
        
        address(&test)
        address(&test2)
        
        print("=================")
        
        var array = Array(repeating: "A", count: 100)
        address(&array)
        
        print(array[safe: 99])
        print(array[safe: 199])
        print(array.indices)
        
        //Array, Dictionary, Set == Collection 의 특성
        //copyOnWrite로 성능을 최적화함!
        //값에 대한 수정이 일어나지 않는다면 아래와 같은 상황에서는 같은 메모리를 공유하고 있고
        var newArray = array //실제로 복사 안함! 원본을 공유하고 있음!
        address(&newArray)
        
        newArray[0] = "B"
        address(&array)
        address(&newArray)
        
    }
    
    func address(_ value: UnsafeRawPointer) {
        let address = String(format: "%p", Int(bitPattern: value))
        print(address)
    }
}

