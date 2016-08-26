//
//  PokemonCVCell.swift
//  Pokedex
//
//  Created by AADITYA NARVEKAR on 8/10/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import UIKit

class PokemonCVCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonLbl: UILabel!
    
    var pokemon: Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 10.0
    }
    
    
    func configureCell(poke: Pokemon) {
        self.pokemon = poke
        self.pokemonLbl.text = self.pokemon.name.capitalizedString
        self.pokemonImg.image = UIImage(named: "\(self.pokemon.pokeDexId).png")
    }
    
}
