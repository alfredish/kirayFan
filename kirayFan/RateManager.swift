//
//  RateManager.swift
//  kirayFan
//
//  Created by кирилл корнющенков on 08.12.2019.
//  Copyright © 2019 кирилл корнющенков. All rights reserved.
//

import UIKit
import StoreKit

//MARK: оценка приложений
@available(iOS 10.3, *)
class RateManager {
    
    class func incrementCount(){
        let count = UserDefaults.standard.integer(forKey: "run_count")
        if count < 12{
            UserDefaults.standard.set(count+1,forKey: "run_count")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func showRatesController() {
        let count = UserDefaults.standard.integer(forKey: "run_count")
        if count == 10{
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                SKStoreReviewController.requestReview()
            }
        }
    }
}
