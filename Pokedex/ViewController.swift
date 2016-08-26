//
//  ViewController.swift
//  Pokedex
//
//  Created by AADITYA NARVEKAR on 8/8/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var pokemon: [Pokemon] = [Pokemon]()
    var filteredPokmon: [Pokemon] = [Pokemon]()
    
    var inSearchMode: Bool = false

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        
        // Preparing audio file to be played
        let audioUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!)
        do {
            player = try AVAudioPlayer(contentsOfURL: audioUrl)
            player.volume = 0.25
            player.prepareToPlay()
            playAudio()
        } catch let err as NSError {
            print(err.description)
        }
        
        parsePokemanCSV()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func playAudio() {
        if player.playing {
            player.stop()
        }
        
        player.volume = 0.1
        player.play()
        player.numberOfLoops = -1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pokemonCell", forIndexPath: indexPath) as? PokemonCVCell {
            let character: Pokemon
            if inSearchMode {
                character = filteredPokmon[indexPath.row]
            } else {
                character = pokemon[indexPath.row]
            }
            cell.configureCell(character)
            return cell
        } else {
            let cell = PokemonCVCell()
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokmon.count
        }
        
        return pokemon.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destinationViewController as? PokemonDetailVC {
                if let selectedIndex = collectionView.indexPathsForSelectedItems()?.first {
                    if inSearchMode {
                        detailVC.selectedPokemon = filteredPokmon[selectedIndex.row]
                    } else {
                        detailVC.selectedPokemon = pokemon[selectedIndex.row]
                    }
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(110, 110)
    }
    
    func parsePokemanCSV() {
        let csvFilePath = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: csvFilePath)
            let rows = csv.rows
            
            
            for row in rows {
                let name = row["identifier"]!
                let characterId = Int(row["id"]!)!
                let character = Pokemon(name: name, Id: characterId)
                pokemon.append(character)
            }
            
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    
    @IBAction func musicBtnTapped(sender: AnyObject) {
        
        if let btn = sender as? UIButton {
            if player.playing {
                player.stop()
                player.currentTime = 0
                btn.alpha = 0.5
            } else {
                btn.alpha = 1.0
                playAudio()
            }
        }
        
        
    }
    
    //MARK: Search Bar Delegate Methods
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            searchBar.endEditing(true)
        } else {
            inSearchMode = true
            let searchString = searchText.lowercaseString
            filteredPokmon = pokemon.filter({
                $0.name.lowercaseString.containsString(searchString)
            })
        }

        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }


}

