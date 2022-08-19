//
//  SoundControllViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-13.
//

import UIKit

class SoundControlViewController: BaseViewController {
    @IBOutlet var lblKnobValue: UILabel!
    
    var playerController: PlayerViewController?

    @IBOutlet weak var btnDryWet: UIButton!
    @IBOutlet var btnRecommended: UIButton!
    @IBOutlet var btnHigh: UIButton!
    @IBOutlet var btnMid: UIButton!
    @IBOutlet var btnLow: UIButton!
    @IBOutlet var knob: Knob!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblDeviceName: UILabel!
    
    @IBOutlet weak var verticalSlider: VerticalSlider!
    @IBOutlet weak var controllView: UIView!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shadowView: BorderView!
    @IBOutlet weak var dottedLines: DotedLines!
    @IBOutlet weak var unadjustAbleImage: UIImageView!
    @IBOutlet weak var imageSelectedDevice: UIImageView!
    @IBOutlet weak var lblModelName: UILabel!
    var selectedDevice : Device?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
        knob.lineWidth = 4
        knob.pointerLength = 12
        knob.minimumValue = -100
        knob.maximumValue = 100
        knob.addTarget(self, action: #selector(SoundControlViewController.handleValueChanged(_:)), for: .valueChanged)
        knob.addTarget(self, action: #selector(SoundControlViewController.tapOnKnob(_:)), for: .touchUpInside)
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(SoundControlViewController.tapOnSlider(_:)))
        verticalSlider.addGestureRecognizer(touchRecognizer)
        verticalSlider.addTarget(self, action: #selector(SoundControlViewController.handleSliderValueChanged(_:)), for: .valueChanged)
        btnLow.setBackgroundImage(UIImage(named: "led_on_btn"), for: .selected)
        btnMid.setBackgroundImage(UIImage(named: "led_on_btn"), for: .selected)
        btnHigh.setBackgroundImage(UIImage(named: "led_on_btn"), for: .selected)
        btnRecommended.setBackgroundImage(UIImage(named: "led_on_btn"), for: .selected)

        if let device = fetchDeviceName().first{
            selectedDevice = device
        }
        self.lblModelName.text = selectedDevice?.model
        self.lblDeviceName.text = selectedDevice?.name
        self.imageSelectedDevice.image = UIImage(named: selectedDevice!.image)
        setRecommendedButton()
        btnDryWet.dropShadow()
        shadowView.dropShadowUnderView()
        setLeftNavigationBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAlgorithmValues()
        updateLabel()
        loadAttitude()
        if let playerController = playerController {
            playerController.btnPlayerView.addTarget(self, action: #selector(SoundControlViewController.openMusicSource), for: .touchUpInside)
        }
    }
    func loadAttitude(){
        let attitude = UserDefaults.standard.float(forKey: UserDefaults.attitude)
        verticalSlider.value = attitude
    }
    
    @objc func handleSliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            AlgorithmConstants.saveAttitudeValue(value: slider.value)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerViewController" {
            self.playerController = segue.destination as? PlayerViewController
       }
    }

    func setLeftNavigationBar(){
        let offButton = UIButton(frame: CGRect(x: 0, y: 0, width: 51, height: 20))
        offButton.setBackgroundImage(UIImage(named: "on_off_background"), for: .normal)
        offButton.setImage(UIImage(named: "check_music"), for: .normal)
        offButton.addTarget(self, action: #selector(SoundControlViewController.offButtonPressed(_:)), for: .touchUpInside)
        offButton.setTitle("off", for: .normal)
        offButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        offButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        offButton.titleLabel?.font = UIFont(name: "Kallisto-Medium", size: 10)

        let menuBarItem = UIBarButtonItem(customView: offButton)
        
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 51).isActive = true

        self.navigationItem.leftBarButtonItem = menuBarItem
            
        }

    @IBAction func dryWetBtnPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlgorithmViewController") as! AlgorithmViewController
        vc.modalPresentationStyle = .fullScreen
        switch sender.tag {
        case 0:
            vc.algorithm = .LOW
        case 1:
            vc.algorithm = .MID
        case 2:
            vc.algorithm = .HIGH
        case 10:
            vc.algorithm = .DRYWET
        default:
            break
        }
        
        present(vc, animated: true, completion: nil)
    }
    @IBAction func modeBtnPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModeViewController") as! ModeViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.view.alpha = 0.9
        vc.view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    @IBAction func selectModelBtnPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModelsViewController") as! ModelsViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.view.alpha = 0.9
        vc.view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        vc.selectedDevice = selectedDevice
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    @objc func handleValueChanged(_ sender: Any) {
        updateLabel()
        let selected = getSelectedAlgorithm()
        AlgorithmConstants.saveKnoValue(algo: selected, value: knob.value)
    }

    @objc func tapOnKnob(_ sender: Any){
        if btnLow.isSelected {
            dryWetBtnPressed(btnLow)
        } else if btnMid.isSelected {
            dryWetBtnPressed(btnMid)
        } else if btnHigh.isSelected {
            dryWetBtnPressed(btnHigh)
        } else {
            
        }
    }
    @objc func tapOnSlider(_ sender: Any){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlgorithmViewController") as! AlgorithmViewController
        vc.modalPresentationStyle = .fullScreen
        vc.algorithm = .ATTITUDE
        present(vc, animated: true, completion: nil)
    }
    private func updateLabel() {
        self.lblKnobValue.text = String(format: "%.0f", knob.value) + " " + "%"
    }

    @objc func openMusicSource(){
        if SpotifyAuthManager.shared.isSignedIn {
            self.performSegue(withIdentifier: "MusicDataViewController", sender: self)
        } else {
            
        }
    }
    @IBAction func settingBtnPressed(_ sender: UIButton) {
        deselectAll()
        switch sender.tag {
        case 0:
            btnLow.isSelected = true
            loadSelectedConfig(tag: sender.tag)
            AlgorithmConstants.saveSelectedConfigurations(config: Algorithm.LOW.rawValue)
        case 1:
            btnMid.isSelected = true
            loadSelectedConfig(tag: sender.tag)
            AlgorithmConstants.saveSelectedConfigurations(config: Algorithm.MID.rawValue)
        case 2:
            btnHigh.isSelected = true
            loadSelectedConfig(tag: sender.tag)
            AlgorithmConstants.saveSelectedConfigurations(config: Algorithm.HIGH.rawValue)
        case 3:
            UserDefaults.standard.removeObject(forKey: UserDefaults.selectedConfig)
            setRecommendedButton()
        default:
            break
        }
    }

    func loadSelectedConfig(tag: Int) {
        if tag == 0 {
            let low = UserDefaults.standard.float(forKey: UserDefaults.low)
            knob.setValue(low, animated: true)
        } else if tag == 1 {
            let mid = UserDefaults.standard.float(forKey: UserDefaults.mid)
            knob.setValue(Float(mid), animated: true)
        } else if tag == 2 {
            let heigh = UserDefaults.standard.float(forKey: UserDefaults.high)
            knob.setValue(Float(heigh), animated: true)
        }
        updateLabel()
    }
    
    func loadAlgorithmValues(){
        if let selectedConfig = UserDefaults.standard.value(forKey: UserDefaults.selectedConfig) as? String{
            if selectedConfig == Algorithm.LOW.rawValue {
                settingBtnPressed(btnLow)
            } else if selectedConfig == Algorithm.MID.rawValue {
                settingBtnPressed(btnMid)
            } else if selectedConfig == Algorithm.HIGH.rawValue {
                settingBtnPressed(btnHigh)
            } else {
                setRecommendedButton()
            }
        } else {
            setRecommendedButton()
        }
    }
    
    func getSelectedAlgorithm() -> String{
        if let selectedConfig = UserDefaults.standard.value(forKey: UserDefaults.selectedConfig) as? String{
            return selectedConfig
        }
        return "RECOMMENDED"
    }
    
    
    func deselectAll(){
        btnLow.isSelected = false
        btnMid.isSelected = false
        btnHigh.isSelected = false
        btnRecommended.isSelected = false
        unadjustAbleImage.isHidden = true
        lblKnobValue.isHidden = false
        dottedLines.isHidden = false
    }
    func setRecommendedButton() {
        btnRecommended.isSelected = true
        unadjustAbleImage.isHidden = false
        lblKnobValue.isHidden = true
        dottedLines.isHidden = true
    }

    @objc func offButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AutoModeViewController") as! AutoModeViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.view.alpha = 0.9
        vc.view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

    
}

extension SoundControlViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension SoundControlViewController: ModeControllerDelegate {
    func setMode(mode: String) {
        self.lblMode.text = mode
    }
}

extension SoundControlViewController: AutoModeDelegate {
    func setAutoMode(mode: String) {
        self.lblMode.text = mode
    }
}

extension SoundControlViewController: ModelSelectedDelegate {
    func setModel(device: Device) {
        self.selectedDevice = device
        self.lblModelName.text = device.model
        self.lblDeviceName.text = device.name
        self.imageSelectedDevice.image = UIImage(named: device.image)
    }
}
