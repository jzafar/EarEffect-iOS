//
//  SettingsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-17.
//

import UIKit

class SettingViewController: BaseViewController {

    let settingsList = ["Login information", "Conected streaming service",
                       "Available streaming service",
                       "Available earphone","Available headphone","Push notification","Policy"]
    
   func getImage() -> UIView{
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        //imageView.constrainAspectRatio(17.0/10.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(imageView)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRightBarButton()
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
        
        let navigationTitleFont = UIFont(name: "NotoSans-Bold", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white]

        self.title = "Settings"
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 25))
//        backButton.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
//        backButton.tintColor = .white
//        backButton.addTarget(self, action: #selector(SettingViewController.backPressed), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    @objc func backPressed(){
        self.dismiss(animated: true)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AvailableDevicesCategoryViewController" {
            if let indexPath = sender as? IndexPath {
                let vc = segue.destination as! AvailableDevicesCategoryViewController
                let devices = self.fetchDeviceName()
                if indexPath.row == 3{
                    let filteredArray = devices.filter {  $0.type == .earBuds }
                    vc.devices = filteredArray
                } else {
                    let filteredArray = devices.filter {  $0.type == .headPhone }
                    vc.devices = filteredArray
                }
                
            }
           

        }
    }
    
}
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
            
            switch indexPath.row {
            case 0:
                goToLoginViewController()
            case 1:
                self.performSegue(withIdentifier: "ConnectedStreamsViewController", sender: self)
            case 2:
                self.performSegue(withIdentifier: "AvailableStreamViewController", sender: self)
            case 3, 4 :
                self.performSegue(withIdentifier: "AvailableDevicesCategoryViewController", sender: indexPath)
            case 5:
                self.performSegue(withIdentifier: "PushNotificationSettingsViewController", sender: self)
            case 6:
                goToPolicyViewController()
            default:
                break
            }
        }
    }
    func goToPolicyViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PolicyViewController") as! PolicyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goToLoginViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginInformationViewController") as! LoginInformationViewController
        vc.isPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = settingsList[indexPath.row]
        cell.textLabel?.font = UIFont(name: "NotoSans-Regular", size: 14)
        cell.textLabel?.textColor = .white
        //cell.accessoryType = .detailDisclosureButton
        let configuration = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let lockIcon =  UIImage(systemName: "chevron.right", withConfiguration: configuration)
        let lockIconView = UIImageView(image: lockIcon)
        lockIconView.frame = CGRect(x: 0, y: 0, width: 15, height: 20)
        cell.accessoryView = lockIconView
        return cell
    }
}
