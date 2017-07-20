//
//  ViewController.swift
//  Project-Swift
//
//  Created by Erico GT on 3/31/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, InternetHelperDelegate, LoadingViewDelegate, UITextFieldDelegate {

    var soundManager:SoundManager?
    var locationManager:LocationServiceControl?
    //
    @IBOutlet weak var txtCPF:ASTextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        self.soundManager = SoundManager.init()
        locationManager = nil
        //
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.soundManager = SoundManager.init()
        locationManager = nil
        //
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = App.Delegate.createSideMenuItem()
        
        self.view.backgroundColor = App.Style.colorView_Light
        
        let arrayImages:Array<UIImage> = [UIImage(named:"flame_a_0001.png")!,
                                 UIImage(named:"flame_a_0002.png")!,
                                 UIImage(named:"flame_a_0003.png")!,
                                 UIImage(named:"flame_a_0004.png")!,
                                 UIImage(named:"flame_a_0005.png")!,
                                 UIImage(named:"flame_a_0006.png")!]
        
        let alert:SCLAlertViewPlus = SCLAlertViewPlus.createRichAlert(bodyMessage: "Este aplicativo é um projeto modelo para Swift 3.1. Várias classes, frameworks e pods já constam no projeto, prontas para uso.\n\nBasta fazer uma cópia e renomear para um novo projeto!", images: arrayImages, animationTimePerFrame: 0.1)
        alert.addButton(title: "OK", type: SCLAlertButtonType.Default) {
            
            App.Utils.graphicHelper_ApplyHeartBeatAnimation(view: self.txtCPF, scale: 1.5)
            
        }
        alert.showSuccess("Bem vindo!", subTitle: "")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = LocationServiceControl.initAndStartMonitoringLocation()
        
        
        self.updateLayout(textField: &txtCPF)
        txtCPF.placeholder = "Digite o CPF"
        txtCPF.inputAccessoryView = App.Style.createAccessoryView(targetView: txtCPF, selector: #selector(UIResponder.resignFirstResponder))
        txtCPF.showError(message: "Campo obrigatório.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtCPF) {
            let strValidated:String? = txtCPF.validateText(inputMask: "###.###.###-##", maxLenght:0, range: range, textFieldString:textField.text ?? "", replacementString: string, charactersRestriction: nil)
            if let str:String = strValidated {
                textField.text = str
            }
            return false
        }
        
        return true
    }
    
    @IBAction func actionPlaySound(sender:UIButton) {
        
        let iH:InternetHelper = InternetHelper.init()
        
        //URL destino
        var urlRequest:String = "http://md5.jsontest.com/?text=<text>"
        urlRequest = urlRequest.replacingOccurrences(of: "<text>", with: "erico.gimenes")
        
        //Parameters
        let parameters:Dictionary = [
            "x": App.RandInt(1, 100),
            "y": App.RandInt(1, 100)
        ]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        iH.post(toURL: urlRequest, httpBodyData: parameters, delegate: self)
    }
    
    @IBAction func actionLoading(sender:UIButton){
        
        App.Delegate.activityView?.useBlurEffect = true
        App.Delegate.activityView?.useCancelButton = true
        //
        App.Delegate.activityView?.startActivity(.saving, true, self, nil)
        
    }
    
    @IBAction func actionSendNotification() {
        
        if #available(iOS 10.0, *) {
            
            //App.Notifications.deleteAllLocalNotifications()
            
            let requestIdentifier = "demoNotification"
            
            let content = UNMutableNotificationContent()
            content.title = "iOS10 Notification!"
            content.subtitle = "– Thomas Edison"
            content.body = "Nossa maior fraqueza está em desistir. O caminho mais certo de vencer é tentar mais uma vez."
            content.badge = 1
            content.sound = UNNotificationSound.init(named: "alert.m4a")
            
            
            var contentInfo:Dictionary = [String : Any]()
            contentInfo["identifier"] = "remedio"
            //
            content.userInfo = contentInfo
            
            // If you want to attach any image to show in local notification
            let url = Bundle.main.url(forResource: "guardachuva", withExtension: ".jpeg")
            do {
                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
                content.attachments = [attachment!]
            }
            
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            var dComponents:DateComponents = DateComponents.init()
            dComponents.timeZone = TimeZone.current
            dComponents.hour = 20
            let triggerCalendar = UNCalendarNotificationTrigger.init(dateMatching: dComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: triggerCalendar)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                
                if let err:Error = error {
                    print(err)
                }
                
            })
            
        } else {
            
            let alert:SCLAlertViewPlus = SCLAlertViewPlus.init()
            alert.addButton(title: "OK", type: SCLAlertButtonType.Error) {
                print("OK")
            }
            
            alert.showError("Error", subTitle: "Funcionalidade disponível apenas para iOS 10.0 e superior.")
        }
    }
    
    func didFinishTaskWithError(error: NSError) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        DispatchQueue.main.async {
            let alert:SCLAlertViewPlus = SCLAlertViewPlus.init()
            alert.addButton(title: "OK", type: SCLAlertButtonType.Error) {
                print("teste")
            }
            
            alert.showError("Error", subTitle: error.userInfo["message"] as! String)
        }
    }
    
    func didFinishTaskWithSuccess(resultData: Dictionary<String, Any>) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        DispatchQueue.main.async {
            let alert:SCLAlertViewPlus = SCLAlertViewPlus.init()
            alert.addButton(title: "OK", type: SCLAlertButtonType.Success) {
                print("teste")
            }
            
            alert.showSuccess("Success", subTitle: String.init(format: "%@", [resultData]))
        }
    }
    
    func loadingViewWillShow(lV: LoadingView) {
        print("loadingViewWillShow")
    }
    
    func loadingViewDidShow(lV: LoadingView) {
        print("loadingViewDidShow")
    }
    
    func loadingViewDidHide(lV: LoadingView) {
        print("loadingViewDidHide")
    }
    
    func loadingViewWillHide(lV: LoadingView) {
        print("loadingViewWillHide")
    }
 
    func loadingViewCanceled(lV: LoadingView) {
        print("loadingViewCanceled")
        //
        App.Delegate.activityView?.stopActivity(nil)
        
    }
    
    func updateLayout(textField: inout ASTextField!){
        
        textField.canShowBorder = true
        textField.asLayer.borderColor = App.Style.colorView_Normal.cgColor
        textField.asLayer.borderWidth = 1.0
        textField.asLayer.cornerRadius = 0.0
        //Padding
        textField.paddingYFloatLabel = 8.0
        textField.extraPaddingForBottomConstrait = 2.0
        //Colors
        textField.textColor = App.Style.colorText_GrayDark
        textField.errorColorView = App.Style.colorText_RedDefault
        textField.normalColorView = App.Style.colorView_Normal
        //Placeholder
        textField.floatPlaceholderFont = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_LABEL_MINI)!
        textField.placeholderColor = UIColor.gray
        textField.floatPlaceholderColor = UIColor.gray
        //Font
        textField.font = UIFont.init(name: App.Constants.FONT_SAN_FRANCISCO_REGULAR, size: App.Constants.FONT_SIZE_TEXT_FIELDS)
        //Ajustando o tamanho dos textos:
        textField.minimumFontSize = App.Constants.FONT_SIZE_TEXT_FIELDS / 2.0
        textField.adjustsFontSizeToFitWidth = true
        //Ajustando o tamanho para o placeholder:
        for  subView in textField.subviews {
            if let label = subView as? UILabel {
                
                label.adjustsFontSizeToFitWidth = true
                if (label.tag == 101) {
                    //floating placeholder
                    label.minimumScaleFactor = 0.5
                }else{
                    //normal placeholder
                    label.minimumScaleFactor = 0.5
                }
            }
        }
    }
}

