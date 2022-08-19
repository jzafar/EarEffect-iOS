//
//  DryWetViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-16.
//

import UIKit

class AlgorithmViewController: BaseViewController {
    @IBOutlet var lblAlgorithmName: UILabel!
    @IBOutlet var waveImage: UIImageView!
    var algorithm: Algorithm = .DRYWET
    @IBOutlet var lblLeftHundered: UILabel!
    @IBOutlet var knob: Knob!
    @IBOutlet var lblRightHundered: UILabel!
    @IBOutlet var slider: HorizontalSlider!
    @IBOutlet var lblWet: UILabel!
    @IBOutlet var lblDry: UILabel!
    @IBOutlet var lblAlgorithmType: UILabel!

    @IBOutlet weak var lblSliderMaxValue: UILabel!
    @IBOutlet weak var lblSliderZero: UILabel!
    @IBOutlet weak var lblSliderMinValue: UILabel!
    @IBOutlet var lblEnhance: UILabel!
    @IBOutlet var lblNegative: UILabel!
    @IBOutlet var lblZero: UILabel!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var lblFrequency: UILabel!
    @IBOutlet var lblWetDirection: UILabel!
    @IBOutlet var lblDryDirection: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if algorithm == .DRYWET {
            knob.minimumValue = 0
            knob.maximumValue = 100
            slider.minimumValue = 0
            slider.maximumValue = 100
            self.lblSliderZero.isHidden = true
            self.lblSliderMinValue.text = "0"
            self.lblLeftHundered.text = "0"
        } else {
            knob.minimumValue = -100
            knob.maximumValue = 100
        }
       
        knob.setValue(0, animated: false)
        knob.lineWidth = 4
        knob.pointerLength = 12
        knob.addTarget(self, action: #selector(AlgorithmViewController.handleValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(AlgorithmViewController.handleSliderValueChanged(_:)), for: .valueChanged)
        shadowView.dropShadowUnderView()
        loadValues()
    }

    func loadValues(){
        switch algorithm {
        case .DRYWET:
            lblAlgorithmName.text = "DRY／WET Adjustment"
            lblAlgorithmType.isHidden = true
            let isFirst = UserDefaults.standard.bool(forKey: UserDefaults.dryWetFirst)
            if !isFirst {
                UserDefaults.standard.set(true, forKey: UserDefaults.dryWetFirst)
                AlgorithmConstants.saveDryWetValue(value: 100.0)
            }
            let attitude = UserDefaults.standard.float(forKey: UserDefaults.dryWet)
            updateLabel(value: attitude)
            updateSliderAndKnob(value: attitude)
        case .LOW:
            setAlgoritmData(type: "LOW")
            let attitude = UserDefaults.standard.float(forKey: UserDefaults.low)
            updateLabel(value: attitude)
            updateSliderAndKnob(value: attitude)
        case .MID:
            setAlgoritmData(type: "MID")
            let attitude = UserDefaults.standard.float(forKey: UserDefaults.mid)
            updateLabel(value: attitude)
            updateSliderAndKnob(value: attitude)
        case .HIGH:
            setAlgoritmData(type: "HIGH")
            let attitude = UserDefaults.standard.float(forKey: UserDefaults.high)
            updateLabel(value: attitude)
            updateSliderAndKnob(value: attitude)
        case .ATTITUDE:
            lblAlgorithmName.text = "ATTITUDE"
            lblAlgorithmType.isHidden = true
            setAttitudeData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func setAlgoritmData(type: String) {
        lblAlgorithmName.text = "BOOM ALGORITHM"
        lblAlgorithmType.text = type
        lblAlgorithmType.isHidden = false
        lblLeftHundered.text = "-100"
        lblWet.isHidden = true
        lblDry.isHidden = true
        lblDryDirection.isHidden = true
        lblWetDirection.isHidden = true
        waveImage.image = UIImage(named: "algoImage")
        lblFrequency.isHidden = false
    }

    func setAttitudeData() {
        lblDryDirection.text = "NEGATIVE"
        lblWetDirection.text = "ENHANCE"
        lblZero.text = "NORMAL"
        lblLeftHundered.isHidden = true
        lblRightHundered.isHidden = true
        lblDry.isHidden = true
        lblWet.isHidden = true
        lblEnhance.isHidden = false
        lblNegative.isHidden = false
        lblFrequency.isHidden = false
        let attitude = UserDefaults.standard.float(forKey: UserDefaults.attitude)
        updateLabel(value: attitude)
        updateSliderAndKnob(value: attitude)
    }

    func updateSliderAndKnob(value: Float){
        slider.value = value
        knob.setValue(value, animated: true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func handleValueChanged(_ sender: Any) {
        if let knob = sender as? Knob {
            updateLabel(value: knob.value)
            slider.value = knob.value
        }
    }

    @objc func handleSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            updateLabel(value: slider.value)
            knob.setValue(slider.value, animated: true)
        }
    }

    func updateLabel(value: Float) {
        if algorithm == .ATTITUDE {
            if value > -10 && value < 10 {
                lblFrequency.text = "NORMAL"
            } else if value < -10 {
                lblFrequency.text = "NEGATIVE"
            } else {
                lblFrequency.text = "ENHANCE"
            }
            AlgorithmConstants.saveAttitudeValue(value: value)
        } else {
            if algorithm == .LOW {
                AlgorithmConstants.saveKnoValue(algo: Algorithm.LOW.rawValue, value: value)
            } else if (algorithm == .MID) {
                AlgorithmConstants.saveKnoValue(algo: Algorithm.MID.rawValue, value: value)
            } else if (algorithm == .HIGH){
                AlgorithmConstants.saveKnoValue(algo: Algorithm.HIGH.rawValue, value: value)
            } else if (algorithm == .DRYWET) {
                AlgorithmConstants.saveDryWetValue(value: value)
            }
            lblFrequency.text = String(format: "%.0f", value) + " " + "%"
        }
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

enum Algorithm {
    case DRYWET
    case LOW
    case MID
    case HIGH
    case ATTITUDE

    var rawValue: String {
        switch self {
        case .DRYWET: return "DRYWET"
        case .LOW: return "LOW"
        case .MID: return "MID"
        case .HIGH: return "HIGH"
        case .ATTITUDE: return "ATTITUDE"
        }
    }
    
    
}
