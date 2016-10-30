//
//  RecipeDetailVC.swift
//  Flour Power 2.0
//
//  Created by Kelly Robinson on 8/4/16.
//  Copyright © 2016 Kelly Robinson. All rights reserved.
//

import UIKit
import AVFoundation

class RecipeDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    var recipe: Recipe!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var btnLast: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var btnNextIngredient: UIButton!
    @IBOutlet weak var nextStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var btnNextStep: UIButton!
    
    
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        speechSynthesizer.delegate = self
        
        titleLabel.text = recipe.recipeTitle
        
        print(recipe.recipeTitle!)
        
        recipeImageView.image = recipe.recipeSourceImage ?? recipe.getImage()
        
        recipeImageView.contentMode = .scaleAspectFill
        
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        
        recipeTableView.reloadData()
        
        btnNextIngredient.layer.cornerRadius = 25.0
        btnNextStep.layer.cornerRadius = 25.0
        btnLast.layer.cornerRadius = 25.0
        btnPause.layer.cornerRadius = 25.0
        btnStop.layer.cornerRadius = 25.0
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        
    }
    
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: [String:AnyObject] = ["rate": rate as AnyObject, "pitch": pitch as AnyObject, "volume": volume as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultSpeechSettings)
    }
    
    func loadSettings() -> Bool {
        let userDefaults = UserDefaults.standard as UserDefaults
        
        if let theRate: Float = userDefaults.value(forKey: "rate") as? Float {
            rate = theRate
            pitch = userDefaults.value(forKey: "pitch") as! Float
            volume = userDefaults.value(forKey: "volume") as! Float
            
            return true
        }
        
        return false
    }
    
    var currentIngredient = 0
    
    @IBAction func nextIngredientButton(_ sender: AnyObject) {
        
        if !speechSynthesizer.isSpeaking {
            
            
            let ingredient = recipe.ingredients[currentIngredient]
            
            // create 3 variables
            
            let amount = ingredient["amount"] as? Int ?? 0
            let unit = ingredient["unit"] as? String ?? ""
            let name = ingredient["name"] as? String ?? ""
            
            let thingToSay = "\(amount) \(unit) \(name)"
            
            speechUtterance = AVSpeechUtterance(string: thingToSay)
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            
            speechSynthesizer.speak(speechUtterance)
            
            currentIngredient += 1
            
            if currentIngredient == recipe.ingredients.count { currentIngredient = 0 }
            
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(true)
        
    }
    
    var currentStep = 0
    
    @IBAction func nextStepButton(_ sender: AnyObject) {
        
        
        if !speechSynthesizer.isSpeaking {
            
            
            let step = recipe.directions[currentStep]
            
            
            speechUtterance = AVSpeechUtterance(string: step)
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
            
            speechSynthesizer.speak(speechUtterance)
            
            currentStep += 1
            
            if currentStep == recipe.directions.count { currentStep = 0 }
            
        } else {
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(true)
        if !speechSynthesizer.isSpeaking {
            animateActionButtonAppearance(false)
        }
        
    }
    
    @IBAction func pauseButton(_ sender: AnyObject) {
        
        speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        
        animateActionButtonAppearance(false)
        
    }
    
    var speechUtterance: AVSpeechUtterance!
    
    @IBAction func lastButton(_ sender: AnyObject) {
        
        guard !speechSynthesizer.isSpeaking else { return }
        
        if let utterance = speechUtterance {
            
            speechSynthesizer.speak(utterance)
            
        }
        
        animateActionButtonAppearance(false)
        
    }
    
    
    @IBAction func stopButton(_ sender: AnyObject) {
        
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        
        animateActionButtonAppearance(false)
        
    }
    
    func animateActionButtonAppearance(_ shouldHideSpeakButton: Bool) {
        
        var nextIngredientStepButtonsAlphaValue: CGFloat = 1.0
        var pauseLastStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton {
            
            nextIngredientStepButtonsAlphaValue = 0.0
            pauseLastStopButtonsAlphaValue = 1.0
            
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            
            self.nextStack.alpha = nextIngredientStepButtonsAlphaValue
            
            self.buttonStack.alpha = pauseLastStopButtonsAlphaValue
            
            
        })
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // sections : 0 - Ingredients, 1 - Steps
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            
            print(recipe.ingredients.count)
            return recipe.ingredients.count
            
        } else {
            
            print(recipe.directions.count)
            return recipe.directions.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt cellForRowAtIndexPath: IndexPath) -> UITableViewCell {
        
        
        var reuseID = ""
        
        
        if indexPath.section == 0 {
            
            reuseID = "IngredientCell"
            
        } else {
            
            reuseID = "StepCell"
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        if indexPath.section == 0 {
            
            let ingredient = recipe.ingredients[indexPath.row]
            
            
            
            let amount = ingredient["amount"] as? Float ?? 0.0
            let unit = ingredient["unit"] as? String ?? ""
            let name = ingredient["name"] as? String ?? ""
            
            
            cell.textLabel?.text = "\(amount) \(unit) \(name)"
            
            
            
        } else {
            
            print(recipe.directions[indexPath.row])
            
            cell.textLabel?.text = recipe.directions[indexPath.row]
            
            cell.backgroundColor = UIColor(red:0.82, green:0.99, blue:1, alpha:1)
            
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = UIView(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        
        view.backgroundColor =  UIColor(red:0.21, green:0.45, blue:0.35, alpha:0.8)
        
        
        
        let label = UILabel(frame: view.frame)
        
        label.textColor = UIColor.white
        
        if section == 0 {
            
            label.text = "Ingredients"
        } else {
            
            label.text = "Directions"
        }
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 40
    }
    
}
