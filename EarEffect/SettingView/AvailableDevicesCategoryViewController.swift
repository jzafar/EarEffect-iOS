//
//  AvailableDevicesCategoryViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-23.
//

import UIKit

class AvailableDevicesCategoryViewController: BaseViewController {
    @IBOutlet var lblDeviceType: UILabel!
    @IBOutlet var tableView: UITableView!
    var devices: [Device] = []
    var devicesGroup: [String: [Device]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let device = devices.first {
            lblDeviceType.text = "Available \(device.type.toString())"
        }
        
        devicesGroup = Dictionary(grouping: devices, by: {$0.model})
    }
}
extension AvailableDevicesCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         //For Header Background Color
         view.backgroundColor = .clear
        // For Header Text Color
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name: "Kallisto-Bold", size: 14)
        header.textLabel?.sizeToFit()
    }
}
extension AvailableDevicesCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = Array(devicesGroup)[section].key
        return key
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return devicesGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let devicesCount = Array(devicesGroup)[section].value
        return devicesCount.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let devices = Array(devicesGroup)[indexPath.section].value
        let device = devices[indexPath.row]
        cell.textLabel?.text = device.name
        cell.textLabel?.font = UIFont(name: "Kallisto-Light", size: 12)
        cell.textLabel?.textColor = .white
        return cell
    }
}
