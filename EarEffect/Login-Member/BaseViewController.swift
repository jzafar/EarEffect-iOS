//
//  BaseViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
        // Do any additional setup after loading the view.
    }
    
    func setRightBarButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(self.cancelButtonPressed))

    }
    
    func showOkAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    func prepareNavigationContoroller(controller: UIViewController) -> UINavigationController{
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.barTintColor = .white
        return navController
    }
    
    
    @objc func cancelButtonPressed(){
        dismiss(animated: true)
    }
    
   
    func fetchDeviceName () -> [Device]{
        let jsonData = readFile()
            
        let decodedData = try? JSONDecoder().decode([Device].self, from: jsonData!)
                
        return decodedData ?? []
                
        
    }
    
    private func readFile() -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: "SupportedDevices", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }

}
