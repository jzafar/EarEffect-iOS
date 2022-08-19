//
//  ModelsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-15.
//

import UIKit
protocol ModelSelectedDelegate {
    func setModel(device: Device)
}
class ModelsViewController: BaseViewController {

    var devicesList: [Device] = []
    var selectedDevice: Device?
    var delegate: ModelSelectedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.devicesList = fetchDeviceName()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
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
extension ModelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        let device = devicesList[indexPath.row]
        if device.name == selectedDevice?.name {
            setSelected(cell: cell)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            delegate?.setModel(device: devicesList[indexPath.row])
            dismiss(animated: true)
        }
    }
    
    func setSelected(cell: UITableViewCell){
        cell.contentView.layer.cornerRadius = 52
        cell.contentView.backgroundColor = UIColor.hexStr(hexStr: "#B8B8B8", alpha: 0.9)
    }
}

extension ModelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! ModelsTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 0
        cell.setData(device: devicesList[indexPath.row])
        return cell
    }
}
