//
//  CDHelper.swift
//  Play
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import CoreData
import UIKit

func makeAllPokemon(){
    
    makePokemon(name: "Abra", withThe: "abra")
    makePokemon(name: "Pikachu", withThe: "pikachu-2")
    makePokemon(name: "Psyduck", withThe: "psyduck")
    makePokemon(name: "Jigglypuff", withThe: "jigglypuff")
    makePokemon(name: "Belsprout", withThe: "bellsprout")
    makePokemon(name: "bullbasaur", withThe: "bullbasaur")
    makePokemon(name: "Meowth", withThe: "meowth")
    makePokemon(name: "Eevee", withThe: "eevee")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    
    
}


func makePokemon(name: String, withThe imageName:String){
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageName

}

func bringAllPokemon() ->[Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            makeAllPokemon()
            return bringAllPokemon()
        }else {
            return pokemons
        }
    } catch{
        print("Error")
    }
    return[]
}

func getAllCaughtPokemon() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timeCaught > %d", 0)
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }catch {
        print("Error")
    }
    
    return []
}

func getAllUnCaughtPokemon() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timeCaught == %d", 0)
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }catch {
        print("Error")
    }

    return []
}


