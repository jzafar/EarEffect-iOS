//
//  SettingsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-14.
//

import UIKit

class SettingsViewController: BaseViewController {
    @IBOutlet var tbleView: UITableView!
    let settingsList = ["Settings", "Login information",
                        "About EarEffect",
                        "Instructions", "Help", "Company detail", "Submit Enquiry"]
    let settingsListImages = ["settings", "login", "logo_white", "equalizer", "help", "pin", "email"]
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        tbleView.delegate = self
        // self.view.addBlurredBackground(style:.regular)
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
            // let navController = UINavigationController()

            switch indexPath.row {
            case 0:
                let settings = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                let navController = prepareNavigationContoroller(controller: settings)
                present(navController, animated: true, completion: nil)
            case 1:
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginInformationViewController") as! LoginInformationViewController
                let navController = prepareNavigationContoroller(controller: login)
                present(navController, animated: true, completion: nil)
            case 2:
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                let navController = prepareNavigationContoroller(controller: login)
                present(navController, animated: true, completion: nil)
            case 3:
                let inst = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstructionsViewController") as! InstructionsViewController
                let navController = prepareNavigationContoroller(controller: inst)
                present(navController, animated: true, completion: nil)
            case 4:
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                let navController = prepareNavigationContoroller(controller: login)
                present(navController, animated: true, completion: nil)
            case 5:
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyInformationViewController") as! CompanyInformationViewController
                let navController = prepareNavigationContoroller(controller: login)
                present(navController, animated: true, completion: nil)
            case 6:
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubmitEnquiryViewController") as! SubmitEnquiryViewController
                let navController = prepareNavigationContoroller(controller: login)
                present(navController, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
}

extension SettingsViewController: UITableViewDataSource {
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
        cell.imageView?.image = UIImage(named: settingsListImages[indexPath.row])
        return cell
    }
}
