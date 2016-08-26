//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by AADITYA NARVEKAR on 8/13/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PokemonDetailVC: UIViewController {
    
    var selectedPokemon: Pokemon!
    @IBOutlet weak var pokemonLbl: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonDescriptionLbl: UILabel!
    @IBOutlet weak var pokemonTypeLbl: UILabel!
    @IBOutlet weak var pokemonDefenseLbl: UILabel!
    @IBOutlet weak var pokemonHeightLbl: UILabel!
    @IBOutlet weak var pokemonIdLbl: UILabel!
    @IBOutlet weak var pokemonWeightLbl: UILabel!
    @IBOutlet weak var pokemonBaseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoTextLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonLbl.text = selectedPokemon.name
        pokemonImg.image = UIImage(named:  "\(selectedPokemon.pokeDexId).png")
        currentEvoImg.image = UIImage(named:  "\(selectedPokemon.pokeDexId).png")
        
        selectedPokemon.downloadPokemonDetails { 
            self.updatePokemonDetails()
        }
    }
    
    func updatePokemonDetails()  {
        self.hideLoadingView()
        self.pokemonHeightLbl.text =  self.selectedPokemon.height
        self.pokemonWeightLbl.text = self.selectedPokemon.weight
        self.pokemonTypeLbl.text = self.selectedPokemon.type
        self.pokemonIdLbl.text = "\(self.selectedPokemon.pokeDexId)"
        self.pokemonDefenseLbl.text = self.selectedPokemon.defense
        self.pokemonBaseAttackLbl.text = self.selectedPokemon.attack
        
        if self.selectedPokemon.description.characters.count > 0 {
            self.pokemonDescriptionLbl.text = self.selectedPokemon.description
        } else {
            self.pokemonDescriptionLbl.hidden = true
        }
        
        if self.selectedPokemon.nextEvolutionID > 0 {
            self.nextEvoImg.image = UIImage(named: "\(self.selectedPokemon.nextEvolutionID).png")
            self.evoTextLbl.text = "\(self.evoTextLbl.text!) \(self.selectedPokemon.nextEvolutionTxt)"
        } else {
            self.nextEvoImg.hidden = true
            self.evoTextLbl.text = "\(self.evoTextLbl.text!) - N/A"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideLoadingView() {
        let hideAnimation = CATransition()
        hideAnimation.type = kCATransitionFade
        hideAnimation.duration = 0.5
        
        loadingView.layer.addAnimation(hideAnimation, forKey: nil)
        loadingView.hidden = true
    }
    
    @IBAction func segmentedBtnTapped(sender: AnyObject) {
        if let segment = sender as? UISegmentedControl {
            print(segment.selectedSegmentIndex)
        }
    }
}
