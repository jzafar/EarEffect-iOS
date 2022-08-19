//
//  AvailableDeviceListViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import UIKit

class AvailableDeviceListViewController: BaseViewController {
    @IBOutlet var tblView: UITableView!
    var devicesList: [Device] = []
    let bleManger = BLEManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        devicesList = fetchDeviceName()
        let device = Device(name: "Using with other device", model: "", image: "", type: .unknown)
        devicesList.append(device)
        bleManger.startBleManger()
        // tblView.register(DeviceListTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SoundControlViewController" {
            let vc = segue.destination as! SoundControlViewController
            if let customIndexPath = tblView.indexPathForSelectedRow {
                vc.selectedDevice = devicesList[customIndexPath.row]
            }
           
        } else {
            let vc = segue.destination as! BLEConnectionViewController
            if let customIndexPath = tblView.indexPathForSelectedRow {
                vc.device = devicesList[customIndexPath.row]
                vc.selectedIndex = customIndexPath.row
            }
        }
        
    }
}

extension AvailableDeviceListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
            performSegue(withIdentifier: "SoundControlViewController", sender: self)
//            performSegue(withIdentifier: "BLEConnectionViewController", sender: self)
        }
        return
        if bleManger.state == BLEState.poweredOn {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = .clear
                performSegue(withIdentifier: "BLEConnectionViewController", sender: self)
            }
            return
        } else if bleManger.state == .unauthorized {
            let alertController = UIAlertController (title: "", message: "Please enable Bluetooth from setting app. Go to Settings?", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
            return
        } else if bleManger.state == .poweredOff  {
            let alertController = UIAlertController (title: "", message: "Please turn on bluetooth.  Go to Settings?", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: "App-Prefs:root=General") else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
        }
    }
}

extension AvailableDeviceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath) as! DeviceListTableViewCell
        cell.setData(name: devicesList[indexPath.row].name)
        return cell
    }
}
