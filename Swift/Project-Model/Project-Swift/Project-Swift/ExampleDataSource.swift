//
//  OrderDataSource.swift
//  Etna
//
//  Created by Erico GT on 25/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

import UIKit

class ExampleDataSource: NSObject, DataSourceResponseProtocol {
    
    // GET AVAILABLE STORES ====================================================================================
    
    @discardableResult func getRandomExampleData(handler:@escaping (_ data:Dictionary<String,Any>?, _ response:DataSourceResponse) -> ()) -> DataSourceRequest?{
        
        let internectConnection:DataSourceConnection = DataSourceConnection.init()
        
        if (internectConnection.isConnectionReachable){
            
            let url:String = "www.qualquer.coisa.com.br"
            return internectConnection.get(fromURL: url, httpBodyData: nil) { (object, statusCode, error) in
                
                if let _:NSError = error {
                    print(error?.localizedDescription ?? "Error >> getRandomExampleData")
                    let dsr:DataSourceResponse = DataSourceResponse.new(.error, statusCode, self.errorMessage(.connection_error, ""), .connection_error)
                    handler(nil, dsr)
                } else {
                    if let r = object as? Dictionary<String,Any>{
                        print(r)
                        //sucesso:
                        let dsr:DataSourceResponse = DataSourceResponse.new(.success, statusCode, self.errorMessage(.none, ""), .none)
                        handler(r, dsr)
                    }else{
                        //erro:
                        let dsr:DataSourceResponse = DataSourceResponse.new(.error, statusCode, self.errorMessage(.invalid_data, ""), .invalid_data)
                        handler(nil, dsr)
                    }
                }
            }
            
        }else{
            //erro:
            let dsr:DataSourceResponse = DataSourceResponse.new(.error, 0, self.errorMessage(.no_connection, ""), .no_connection)
            handler(nil, dsr)
            return nil
        }
    }
    
    // PROTOCOL METHOD ====================================================================================
    func errorMessage(_ forType: DataSourceResponseErrorType, _ identifier: String?) -> String {
        
        switch forType {
        case .none:     //Quando a operação não encontrou erro algum.
            return "Dados recuperados com sucesso!"
        case .no_connection:    //Os dados precisam de internet para serem resgatados mas não há conexão disponível.
            return "Ops...\n\nParece que não há nenhuma conexão disponível no momento.\n\nVerifique sua internet e tente novamente!"
        case .connection_error:     //Ocorreu um erro na conexão que impede o resgate dos dados.
            return "Um problema na conexão impede que os dados sejam carregados no momento. Por favor, tente mais tarde."
        case .invalid_data:     //Os dados encontrados não correspondem aos esperados (por tipo, qtd, formato, etc).
            return "Nenhum dado válido foi encontrado!"
        case .internal_exception:   //Ocorreu um erro interno no processamento dos dados (parse por exemplo). Por padrão o 'identifier' já deve ser a descrição da exceção.
            return identifier ?? "Erro interno!"
        case .generic:     //Erro genérico, não categorizado.
            return "Não foi possível carregar os dados no momento. Por favor, tente mais tarde."
        }
        
    }
}


