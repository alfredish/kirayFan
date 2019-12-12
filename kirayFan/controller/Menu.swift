//
//  Menu.swift
//  kirayFan
//
//  Created by кирилл корнющенков on 02.12.2019.
//  Copyright © 2019 кирилл корнющенков. All rights reserved.
//

import UIKit
import GoogleMobileAds
//import UserNotifications

class Menu: UIViewController {
    

    
    @IBOutlet weak var cliccerButtom: UIButton!{
        didSet{
            buttomView(sender:cliccerButtom)
        }
    }
    @IBOutlet weak var imageTapButtom: UIButton!{
        didSet{
            buttomView(sender: imageTapButtom)
        }
    }
    @IBOutlet weak var bannerView: GADBannerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        

    }
    
    @IBAction func backMenu(sender:UIStoryboardSegue){
    }
}

//MARK: view elements
extension Menu{
    //MARK: buttomView
    private func buttomView(sender:UIButton){
        sender.layer.cornerRadius = sender.frame.height / 2
        sender.clipsToBounds = true
    }
}

//MARK: реклама
extension Menu:GADBannerViewDelegate{

    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

