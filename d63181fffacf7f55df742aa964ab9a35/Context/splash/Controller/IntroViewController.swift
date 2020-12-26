//
//  IntroViewController.swift
//  d63181fffacf7f55df742aa964ab9a35
//
//  Created by amir on 23.12.2020.
//

import UIKit

class IntroViewController: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            nextButton.setshadowRadiusView(radius: 12, shadowRadiuss: 1, shadowheight: 5, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.08))
        }
    }
    
    @IBOutlet private weak var whartonTextField: UITextField! {
        didSet {
            whartonTextField.addDoneButtonOnKeyboard()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var durabilitySlider: UISlider!
    @IBOutlet private weak var durabilityLabel: UILabel!
    
    @IBOutlet private weak var speedSlider: UISlider!
    @IBOutlet private weak var speedLabel: UILabel!
    
    @IBOutlet private weak var capacitySlider: UISlider!
    @IBOutlet private weak var capacityLabel: UILabel!
    
    private var scrore: Int = 0 {
        didSet {
            scoreLabel.text = "\(scrore)"
        }
    }
    
    private var spacecraft = Spacecraft() {
        didSet {
            scrore = (spacecraft.durability) + (spacecraft.spped) + (spacecraft.capacity)
        }
    }
    
    // MARK: - Lifecycle Methods
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        isNavigationBarHidden = true
        durabilitySlider.addTarget(self, action: #selector(slidersValueChanged(_:_:)), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(slidersValueChanged(_:_:)), for: .valueChanged)
        capacitySlider.addTarget(self, action: #selector(slidersValueChanged(_:_:)), for: .valueChanged)
    }
    
    // MARK: - IBAction
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        Coordinator.shared.removeControllersInNavigation([ControllerKeys.main.rawValue])
        Coordinator.shared.requestNavigation(.main, data: spacecraft, animated: true)
    }
    
    @objc func slidersValueChanged(_ slider: UISlider, _ event: UIEvent) {
        let roundedStepValue = round(slider.value / 1) * 1
        switch slider {
        case durabilitySlider:
            durabilitySlider.value = roundedStepValue
//            durability = Int(roundedStepValue)
            spacecraft.durability = Int(roundedStepValue)
            durabilityLabel.text = String(Int(roundedStepValue))
        case speedSlider:
            speedSlider.value = roundedStepValue
//            spped = Int(roundedStepValue)
            spacecraft.spped = Int(roundedStepValue)
            speedLabel.text = String(Int(roundedStepValue))
        case capacitySlider:
            capacitySlider.value = roundedStepValue
//            capacity = Int(roundedStepValue)
            spacecraft.capacity = Int(roundedStepValue)
            capacityLabel.text = String(Int(roundedStepValue))
        default:
            break
        }
        
        /*
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                if scrore > 100 {
                    handleAlertView(title: "ops", message: "err")
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = .lightGray
                } else {
                    nextButton.isEnabled = true
                    nextButton.backgroundColor = #colorLiteral(red: 1, green: 0.5254901961, blue: 0, alpha: 1)
                }
            default: break
            }
        }
        */
    }
}
