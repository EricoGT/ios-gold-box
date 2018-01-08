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

//TESTES DE REFERÊNCIA **********************************

var alunosNotas = [4, 5, 7, 9, 6, 10, 3]

//Map:
//O Map faz um loop sobre uma coleção (um array por exemplo) e aplica a mesma operação a cada elemento da coleção.
var alunosNotasMap = alunosNotas.map {$0 + 1}
alunosNotasMap

//Filter:
//Faz um loop sobre uma coleção e retorna uma coleção que contém elementos que atendem a uma condição.
var alunosNotasFilter = alunosNotas.filter { $0 >= 5 }
alunosNotasFilter

//Reduce:
//Combina todos os itens de uma coleção para criar um único valor.
var alunosNotasReduce:Float = Float.init(alunosNotas.reduce(0, +))/Float.init(alunosNotas.count)
alunosNotasReduce

//Order:
//Ordena a coleção de elementos
var alunosNotasOrder = alunosNotas
alunosNotasOrder.sort{ $0 < $1 }
alunosNotasOrder
//
var alunosNomes = ["PEdro", "Maria", "JoSé", "Paulo", "Ana"]
var alunosNomesOrder = alunosNomes
alunosNomesOrder = alunosNomes.sorted{$0.caseInsensitiveCompare($1) == .orderedAscending}
alunosNomesOrder


//REFERÊNCIA E VALOR **********************************

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
