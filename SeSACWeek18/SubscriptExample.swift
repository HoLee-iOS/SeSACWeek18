//
//  SubscriptExample.swift
//  SeSACWeek18
//
//  Created by 이현호 on 2022/11/03.
//

import Foundation

extension String {
    
    //jack >> [1] >> a
    
    subscript(idx: Int) -> String? {
        
        guard (0..<count).contains(idx) else {
            return nil
        }
        
        let result = index(startIndex, offsetBy: idx)
        return String(self[result])
    }
    
}

extension Collection {
    //index out of range에 대한 처리가 가능해짐
    subscript(safe index: Index) -> Element? {
        //
        return indices.contains(index) ? self[index] : nil
    }
    
}

struct Phone {
    
    var numbers = ["1234", "5678", "3123", "7777"]
    
    subscript(idx: Int) -> String {
        get {
            return self.numbers[idx]
        }
        set {
            self.numbers[idx] = newValue
        }
    }
    
}
