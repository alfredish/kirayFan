import UIKit
import CoreData
import GoogleMobileAds

class GameViewController: UIViewController {
    
    var gameTimer: Timer?
    var timeInterval = 0.2
    var checkStartGame: Bool = false
    var count = 0
    var moneyCountArray:[CountMoney] = []
    var chooseImageChoose:[ImageChoose] = []
    //реклама
    var countLoose:Int = 0
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var viewGame: UIView!{
        didSet{
           viewGameView(sender: viewGame)
        }
    }
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var pointCount: UILabel!
    @IBOutlet weak var shapeX: NSLayoutConstraint!
    @IBOutlet weak var shapeY: NSLayoutConstraint!
    @IBOutlet weak var startGame: UIButton!{
        didSet{
            buttomView(sender: startGame)
        }
    }
    @IBOutlet weak var backMenuButton: UIButton!{
        didSet{
            buttomView(sender: backMenuButton)
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // оценка приложения
//         if #available(iOS 10.3, *) {
//             RateManager.showRatesController()
//         }
        
        startGame.setTitle("Старт", for: .normal)
        load.progress = 0
        pointCount.text = "Счет: \(count)"
        requestCountMoney()
        if moneyCountArray.count == 0{
            addCountMoney(sender: 0)
        }
        requestImageChoose()
        if chooseImageChoose.count == 0{
            addImageChoose(sender: 0)
        }
        
        //реклама
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
    }

    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        requestCountMoney()
        requestImageChoose()
        gameImage.image = UIImage(named: String(chooseImageChoose[0].image + 1)) //костыль
    }
    
    // MARK: - tapImage (tap gesture recognizer)
    //задаем новое место для картинки при нажатии
    @IBAction func tapImge(_ sender: Any) {
        load.progress = 0
        count += 1
        pointCount.text = "Cчет: \(count)"
        let maxX = viewGame.bounds.maxX - gameImage.frame.width
        let maxY = viewGame.bounds.maxY - gameImage.frame.height
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxX)))
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxY)))
    }
    
    @IBOutlet weak var load: UIProgressView!
    
    // MARK: - startGame
    @IBAction func startGame(_ sender: Any) {
        load.progress = 0
        
        if checkStartGame == false{
        
            viewGame.isHidden = false
            pointCount.text = "Cчет: \(count)"
            checkStartGame = true
            startGame.setTitle("Пауза", for: .normal)
        }else{
            startGame.setTitle("Старт", for: .normal)
            viewGame.isHidden = true
            checkStartGame = false
        }
       
        timeInterval = 0.2
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
}

//MARK: CORE DATA count mo
extension GameViewController{
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

//MARK: view element
extension GameViewController{
    
    func buttomView(sender:UIButton){
        sender.layer.cornerRadius = backMenuButton.frame.height / 2
        sender.clipsToBounds = true
    }
    
    func viewGameView(sender:UIView){
          sender.layer.cornerRadius = 10
          sender.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
          sender.layer.borderWidth = 1
          sender.clipsToBounds = true
      }
      
}

//MARK: game func
extension GameViewController{

    //MARK: alert finish GAME
    func alertFinishGame(){
        let alert = UIAlertController(title: "You loose", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true, completion: nil)
    }
    
    //MARK: скорость полоски
    func timeIntervalSpeed(sender:Double) {
        gameTimer?.invalidate()
        timeInterval = sender
        gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    @objc func timerFunc(){
        if count == 10 {
            timeIntervalSpeed(sender: 0.15)
        }else if count == 20{
            timeIntervalSpeed(sender: 0.1)
        }else if count == 30{
            timeIntervalSpeed(sender: 0.075)
        }else if count == 40{
            timeIntervalSpeed(sender: 0.05)
        }
        
        if checkStartGame == false{
            gameTimer?.invalidate()
        }
        //поражение
        if load.progress == 1 {
            loose()
        }
         load.progress += 0.1
    }
    //MARK: поражение 
    func loose(){
        editCountMoney(sender: count+Int(moneyCountArray[0].money))
        count = 0
        countLoose+=1
        //MARK: реклама при 5 поряжениях
        if interstitial.isReady && countLoose==5{
            countLoose = 0
            interstitial.present(fromRootViewController: self)
        }
        startGame.setTitle("Старт", for: .normal)
        viewGame.isHidden = true
        checkStartGame = false
        //viewGame.isHidden = true
        gameTimer?.invalidate()
        alertFinishGame()
    }
}

//MARK: CORE DATA image CHoose
extension GameViewController{
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

//MARK: реклама
extension GameViewController: GADInterstitialDelegate{
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}
