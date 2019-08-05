//
//  SampleDataSource.swift
//  ProjectModel
//
//  Created by Erico Gimenes Teixeira on 27/06/19.
//  Copyright © 2019 Erico Gimenes Teixeira. All rights reserved.
//

import UIKit

struct ResponseDataSource {
    var code:Int = 0
    var message:String? = ""
    var error:String? = ""
    var valid:Bool = false
    var data:Any? = nil
}

class SampleDataSource {
    
    public func getUser(id userID:Int, handler:@escaping (_ response:ResponseDataSource) -> ()) -> InternetRequestDataSource? {
        
        let con = ConnectionManager.init()
        
        //Parameters
        var parameters:Dictionary<String, Any> = Dictionary()
        parameters["userID"] = userID
        
        var parametersData:Data? = nil
        
        do {
            parametersData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch {
            print(error.localizedDescription)
        }
        
        //Request
        return con.connect(url: "http...", method: .get, body:parametersData , handler: { (data, code, error) in
            
            var RDS = ResponseDataSource()
            RDS.code = code
            
            if let er = error {
                //CHAMADA COM ERRO:
                RDS.error = er.localizedDescription
                //Se necessário, o erro pode ser especializado:
                switch code {
                case 404:
                    RDS.message = "Endereço inválido..."
                default:
                    RDS.message = "Não foi possível buscar o usuário no momento"
                }
            } else {
                //CHAMADA SEM ERRO:
                if let d = data {
                    //Verificação dos dados e conversão para o tipo de retorno determinado:
                    do {
                        let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? [String:Any]
                        //let user = try JSONDecoder().decode(UserModel.self, from: d)
                        
                        //Dados válidos:
                        RDS.valid = true
                        RDS.data = json
                        
                    } catch {
                        //Dados inválidos:
                        RDS.message = "Nenhum dado válido foi encontrado no momento!"
                        RDS.error = "Data Error: Invalid data..."
                    }
                    
                } else {
                    //DADOS INVÁLIDOS
                    RDS.message = "Nenhum dado válido foi encontrado no momento!"
                    RDS.error = "Data Error: Empty return..."
                }
            }
            handler(RDS)
            
        })
        
    }
    
    
}
