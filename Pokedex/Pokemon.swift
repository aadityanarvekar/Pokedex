//
//  Pokeman.swift
//  Pokedex
//
//  Created by AADITYA NARVEKAR on 8/9/16.
//  Copyright © 2016 Aaditya Narvekar. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _pokemonURL: String!
    var pokemonURL: String {
        return _pokemonURL
    }
    
    private var _name: String!
    var name: String {
        get {
            return _name
        }
        set {
            if newValue.characters.count > 0 {
                _name = newValue
            }
        }
    }
    
    private var _pokeDexId: Int!
    var pokeDexId: Int {
        get {
            return _pokeDexId
        }
    }
    
    private var _description: String?
    var description: String {
        get {
            if let desc = _description {
                return desc
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _description = newValue
            }
        }
    }
    
    private var _type: String?
    var type: String {
        get {
            if let tp = _type {
                return tp
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _type = newValue
            }
        }
    }
    
    private var _defense: String?
    var defense: String {
        get {
            if let dfnse = _defense {
                return dfnse
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _defense = newValue
            }
        }
    }
    
    private var _height: String?
    var height: String {
        get {
            if let ht = _height {
                return ht
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _height = newValue
            }
        }
    }
    
    private var _weight: String?
    var weight: String {
        get {
            if let wt = _weight {
                return wt
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _weight = newValue
            }
        }
    }
    
    private var _baseExp: String?
    var baseExp: String {
        get {
            if let exp = _baseExp {
                return exp
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _baseExp = newValue
            }
        }
    }
    
    private var _attack: String?
    var attack: String {
        get {
            if let atck = _attack {
                return atck
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _attack = newValue
            }
        }
    }
    
    private var _nextEvolutionTxt: String?
    var nextEvolutionTxt: String {
        get {
            if let evo = _nextEvolutionTxt {
                return evo
            } else {
                return ""
            }
        }
        set {
            if newValue.characters.count > 0 {
                _nextEvolutionTxt = newValue
            }
        }
    }
    
    private var _nextEvolutionID: Int?
    var nextEvolutionID: Int {
        get {
            if _nextEvolutionID != nil {
                return _nextEvolutionID!
            } else {
                return -1
            }
        }
        set {
            _nextEvolutionID = newValue
        }
    }
    
    
    init(name: String, Id: Int) {
        self._name = name
        self._pokeDexId = Id
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokeDexId)"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        var statDownloadComplete = false
        var abilityDownloadComplete = false
        var evolutionDownloadComplete = false
        
        let url = NSURL(string: pokemonURL)!
        Alamofire.request(.GET, url).responseJSON (completionHandler: { (response: Response<AnyObject, NSError>) in
            if let data = response.data {
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    if let dict = jsonData as? Dictionary<String, AnyObject> {
                        if let wt = dict["weight"] {
                            self.weight = "\(wt)"
                        }
                        
                        if let ht = dict["height"] {
                            self.height = "\(ht)"
                        }
                        
                        if let types = dict["types"] as? [Dictionary<String, AnyObject>] where types.count > 0 {
                            for tp in types {
                                if let nm = tp["type"]!["name"] as? String {
                                    if self.type.characters.count > 0 {
                                        self.type += " / "
                                    }
                                    self.type += nm.capitalizedString
                                }
                            }
                        } else {
                            self.type = ""
                        }
                        
                        if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] where stats.count > 0 {
                            for individualStat in stats {
                                if individualStat["stat"]!["name"] as? String == "defense" {
                                    if let dfnse = individualStat["base_stat"] {
                                        self.defense = "\(dfnse)"
                                    }
                                }
                                
                                if individualStat["stat"]!["name"] as? String == "attack" {
                                    if let atck = individualStat["base_stat"] {
                                        self.attack = "\(atck)"
                                    }
                                }
                            }
                        } else {
                            self.defense = ""
                            self.attack = ""
                        }
                        
                        statDownloadComplete = true
                        print("Stat Download Complete")
                        if statDownloadComplete && evolutionDownloadComplete && abilityDownloadComplete {
                            completed()
                        }
                        
                    }
                } catch let err as NSError {
                    print(err)
                }
            }
        })
        
        let abilityURL = NSURL(string: "\(URL_BASE)\(URL_ABILITY)\(self.pokeDexId)")
        Alamofire.request(.GET, abilityURL!).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
            do {
                let abilitiesJson = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                if let abilitiesDict = abilitiesJson as? Dictionary<String, AnyObject> {
                    if let effectEntries = abilitiesDict["effect_entries"] as? [Dictionary<String, AnyObject>] {
                        for effectEntry in effectEntries {
                            if let desc = effectEntry["effect"] as? String {
                                if self.description.characters.count > 0 {
                                    self.description.appendContentsOf("\n")
                                }
                                self.description.appendContentsOf(desc)
                            }
                        }
                    }
                }
                abilityDownloadComplete = true
                print("Abilities Download Complete")
                if statDownloadComplete && evolutionDownloadComplete && abilityDownloadComplete {
                    completed()
                }
            } catch let err as NSError {
                print("Error when getting abilities JSON: \(err)")
            }
        })
        
        let evolutionURL = NSURL(string: "\(URL_BASE)\(URL_EVOLUTION)\(self.pokeDexId)")!
        Alamofire.request(.GET, evolutionURL).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
            do {
                let evolutionJson = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                if let dict = evolutionJson as? Dictionary<String, AnyObject> {
                    if let chainDict = dict["chain"] as? Dictionary<String, AnyObject> {
                        if let evolutionDict = chainDict["evolves_to"] as? [Dictionary<String, AnyObject>] where evolutionDict.count > 0 {
                            for val in evolutionDict {
                                if let nextEvolutionCharacter = val["species"] as? Dictionary<String, AnyObject> {
                                    if let name = nextEvolutionCharacter["name"] as? String {
                                        self.nextEvolutionTxt = name.capitalizedString
                                    }
                                    
                                    if let url = nextEvolutionCharacter["url"] as? String {
                                        
                                        let urlComponents = NSURLComponents(string: url)
                                        let pathArray = urlComponents?.path?.componentsSeparatedByString("/")
                                        let nextID = pathArray![(pathArray?.count)! - 2]
                                        self.nextEvolutionID = Int(nextID)!
                                    }
                                }
                            }
                        } else {
                            self.nextEvolutionTxt = "N/A"
                        }
                    }
                }
                evolutionDownloadComplete = true
                print("Evolution Download Complete")
                if statDownloadComplete && evolutionDownloadComplete && abilityDownloadComplete {
                    completed()
                }
            } catch let err as NSError {
                print("Error getting evolution JSON: \(err)")
            }
        })
        
    }
    
}