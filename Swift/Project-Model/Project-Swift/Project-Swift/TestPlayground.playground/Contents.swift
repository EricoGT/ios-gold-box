//: Playground - noun: a place where people can play

import UIKit

class User{
    var name:String
    var idade:Int
    
    init(n:String, i:Int){
        name = n
        idade = i
    }
}

//TESTES DE REFERÊNCIA: **********************************
//var user1:User = User.init(n: "João", i: 10)
//let user2:User = User.init(n: "Maria", i: 20)
//var user3:User = User.init(n: "Pedro", i: 30)
//
//var list:Array = [user1, user2, user3]
//
//var list2:Array = list
//
//list[1] = User.init(n: "Ana", i: 40)
//list
//
//var user4:User = list[1]
//user4.idade = 15
//list
//
//print("User4 - name: \(user4.name), idade: \(user4.idade)")
//
//list[2] = user4
//list
//
//user4.idade = 99
//list
//list2
//
//
//for i in 0...(list.count-1){
//    var user:User = list[i]
//    user.idade = 100
//}
//
//list.append(User.init(n: "Tavarez", i: 666))
//var user5:User = list.first!
//user5.idade = 99
//list




