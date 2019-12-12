//
//  shopVC.swift
//  kirayFan
//
//  Created by кирилл корнющенков on 02.12.2019.
//  Copyright © 2019 кирилл корнющенков. All rights reserved.
//


//MARK: просмотрел видео - 1 раз
// и убрать ячейку

import UIKit
import CoreData
import GoogleMobileAds

class shopVC: UIViewController{
    
    //реклама
    var rewardBasedAd: GADRewardBasedVideoAd!
    var moneyCountArray:[CountMoney] = []
    var chooseImageChoose:[ImageChoose] = []
    var imageIsOpen:[OpenImag] = []
    var imageArray:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    @IBOutlet weak var firstCv: UICollectionView!
    @IBOutlet weak var secondCv: UICollectionView!
    @IBOutlet weak var countMoneyLabel: UILabel!
    @IBOutlet weak var blackLine: UIView!
    var sizeBlackLine:CGRect? = nil
    var sizeFirstCV:CGRect? = nil
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeBlackLine = blackLine.frame
        sizeFirstCV = firstCv.frame
        
        requestCountMoney()
        if moneyCountArray.count==0{
            addCountMoney(sender: 0)
            requestCountMoney()
        }
        requestImageChoose()
        if chooseImageChoose.count==0{
            addImageChoose(sender: 0)
            requestImageChoose()
        }
        requestOpenImag()
        if imageIsOpen.count != imageArray.count{
            addOpenImag(value: true)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            addOpenImag(value: false)
            requestOpenImag()
        }
        
        countMoneyLabel.text = String(moneyCountArray[0].money)
        
        //MARK: реклама
        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        rewardBasedAd.load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")

    }
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        requestCountMoney()
        requestImageChoose()
        requestOpenImag()
        countMoneyLabel.text = String(moneyCountArray[0].money)
    }
}

//MARK: CollectionView
extension shopVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView==secondCv{
            return imageArray.count
        }else if collectionView==firstCv{
            return 1
        }
        return 0
    }
    //MARK: CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView==secondCv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
            if imageIsOpen[indexPath.row].imageIsOpen{
                cell.imageCell.image = UIImage(named: imageArray[indexPath.row])
            }else{
                cell.imageCell.image = UIImage(named: "shop")
            }
            if Int(chooseImageChoose[0].image)==indexPath.row{
                cell.checkImageCell.isHidden = false
            }else{
                cell.checkImageCell.isHidden = true
            }
            return cell
        }
        if collectionView==firstCv{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! Cell
//            if indexPath.row==3{
//                cell.imageCell.image = UIImage(named: "shop1")
//            }else{
//                cell.imageCell.image = UIImage(named: "shop2")
//            }
            cell.imageCell.image = UIImage(named: "shop1")
            return cell
        }
        return UICollectionViewCell()
    }
    //MARK: Size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView==firstCv{
//            if indexPath.row==3{
//                return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height - 20) * 2 / 5)
//            }else{
//                return CGSize(width: (collectionView.frame.width - 40) / 3, height: (collectionView.frame.height - 20) * 3 / 5 )
//            }
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }else if collectionView==secondCv{
            return CGSize(width: (secondCv.frame.width - 40) / 3, height: (firstCv.frame.height - 20) * 1.5)
        }
        
        return CGSize(width: 110, height: 110)
    }
    //MARK: Нажатие
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView==firstCv{
            //MARK: реклама
//            if indexPath.row == 3{
//                if rewardBasedAd.isReady{
//                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
//                    tabCellFirstCVC(indexPath: indexPath)
//                }
            if rewardBasedAd.isReady{
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                //tabCellFirstCVC(indexPath: indexPath)
            }
//            }else{
//                tabCellFirstCVC(indexPath: indexPath)
//            }
        }else if collectionView==secondCv{
            if moneyCountArray[0].money > 199 || imageIsOpen[indexPath.row].imageIsOpen{
                tabCellSecondCVC(digite: indexPath.row)
            }else{
                alertMoney()
            }
        }
    }
    
    
}

//MARK: CORE DATA Count Money
extension shopVC{
    //получение данных
    func requestCountMoney(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = CountMoney.fetchRequest()
        do {
            moneyCountArray = try context.fetch(fetchRequest)
        }catch{
            print("error")
        }
    }
    //добавление данных
    func addCountMoney(sender:Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CountMoney", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! CountMoney
        taskObject.money = Int16(sender)
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
    //изменение данных
    func editCountMoney(sender:Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let name = moneyCountArray[0]
        name.money = Int16(sender)
        moneyCountArray[0] = name
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
}

//MARK: CORE DATA image CHoose
extension shopVC{
    //получение данных
    func requestImageChoose(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = ImageChoose.fetchRequest()
        do {
            chooseImageChoose = try context.fetch(fetchRequest)
        }catch{
            print("error")
        }
    }
    //добавление данных
    func addImageChoose(sender:Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ImageChoose", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! ImageChoose
        taskObject.image = Int16(sender)
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
    //изменение данных
    func editImageChoose(sender:Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let name = chooseImageChoose[0]
        name.image = Int16(sender)
        chooseImageChoose[0] = name
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
}

//MARK: CORE DATA openImage
extension shopVC{
    //получение данных
    func requestOpenImag(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = OpenImag.fetchRequest()
        do {
            imageIsOpen = try context.fetch(fetchRequest)
        }catch{
            print("error")
        }
    }
    //добавление данных
    func addOpenImag(value:Bool){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "OpenImag", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! OpenImag
        taskObject.imageIsOpen = value
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
    //изменение данных
    func editOpenImag(sender:Bool,index:Int){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let name = imageIsOpen[index]
        name.imageIsOpen = sender
        imageIsOpen[index] = name
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
}

//MARK: help func CVC
extension shopVC{
    //обработка нажатия ячейки 2 CVC
    func tabCellSecondCVC(digite:Int){
        if !imageIsOpen[digite].imageIsOpen{
             countMoneyLabel.text = String(Int(countMoneyLabel.text!)! - 200)
             editCountMoney(sender: Int(moneyCountArray[0].money-200))
             editImageChoose(sender: digite)
             editOpenImag(sender: true, index: digite)
        }
        editImageChoose(sender: digite)
        secondCv.reloadData()
    }
    
    //обработка нажатия ячейки 2 CVC
    func tabCellFirstCVC(indexPath:IndexPath){
        helpFuncFortabCellFirstCVC(sender: 20)
//        switch indexPath.row {
//        case 0:
//            helpFuncFortabCellFirstCVC(sender: 200)
//        case 1:
//           helpFuncFortabCellFirstCVC(sender: 400)
//        case 2:
//            helpFuncFortabCellFirstCVC(sender: 600)
//        case 3:
//            helpFuncFortabCellFirstCVC(sender: 20)
//        default:
//            print(Error.self)
//        }
    }
    func helpFuncFortabCellFirstCVC(sender:Int){
        countMoneyLabel.text = String(Int(countMoneyLabel.text!)! + sender)
        editCountMoney(sender: Int(moneyCountArray[0].money + Int16(sender)))
    }
    
    func alertMoney(){
        let alert = UIAlertController(title: "Недостаточно монет", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
}

//MARK: реклама
extension shopVC: GADRewardBasedVideoAdDelegate{
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didRewardUserWith reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
      print("Reward based video ad is received.")
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Opened reward based video ad.")
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad started playing.")
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad has completed.")
        //завершилось
        helpFuncFortabCellFirstCVC(sender: 20)
    }

//    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//      print("Reward based video ad is closed.")
//    }
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
          withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
      print("Reward based video ad will leave application.")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
        didFailToLoadWithError error: Error) {
      print("Reward based video ad failed to load.")
    }
}
