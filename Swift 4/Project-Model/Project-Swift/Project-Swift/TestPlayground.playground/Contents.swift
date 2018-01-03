//: Playground - noun: a place where people can play

import UIKit

class User{
    var name:String
    var idade:Int
    
    init(n:String, i:Int){
        name = n
        idade = i
    }
    
    func copy()->User{
        let copyUser:User = User.init(n:self.name, i:self.idade)
        return copyUser
    }
}

//TESTES DE REFERÊNCIA: **********************************

/*
var user1:User = User.init(n: "João", i: 10)
let user2:User = User.init(n: "Maria", i: 20)
var user3:User = User.init(n: "Pedro", i: 30)

var list:Array = [user1, user2, user3]
var list2:Array = list
var list3:Array = list.map{$0.copy()}

list[1] = User.init(n: "Ana", i: 40)
list
list2

var user4:User = list[2]
user4.idade = 15
list
list2

user4.name = "Juca"
list
list2

list3

for i in 0...(list.count-1){
    let user:User = list[i]
    user.idade = 100
}

list.append(User.init(n: "Tavarez", i: 666))
var user5:User = list.first!
user5.name = "Erico"
user5.idade = 99

list
list2
list3
*/
