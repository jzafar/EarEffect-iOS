//
//  ModeViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-15.
//

import UIKit
protocol ModeControllerDelegate {
    func setMode(mode: String)
}
class ModeViewController: BaseViewController {
    
    let modeArray = ["JAZZ","ROCK","POOPS","CLASSIC","EASY LISTENING","COUNTRY","BALLAD","METAL","SOUL FUNK","R&B","EDM/CLUB"]
    var delegate: ModeControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.isOpaque = false
        view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
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
extension ModeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.hexStr(hexStr: "#FFFFFF", alpha: 0.60)
            cell.contentView.layer.cornerRadius = 20
            delegate?.setMode(mode:modeArray[indexPath.row])
            dismiss(animated: true)
//            self.performSegue(withIdentifier: "BLEConnectionViewController", sender: self)
        }
    }
}

extension ModeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = modeArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Kallisto-Lined", size: 18)
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center;

        return cell
    }
}
