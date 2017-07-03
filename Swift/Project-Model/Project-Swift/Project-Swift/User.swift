//
//  User.swift
//  Etna
//
//  Created by Lab360 on 05/05/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import UIKit

//MARK: - ENUMS

enum Gender: Int {
    case male = 1
    case female = 2
    //
    mutating func toStringKEY() -> String {
        switch self {
        case .male: return "ENUM_KEY_USER_GENDER_MALE"
        case .female: return "ENUM_KEY_USER_GENDER_FEMALE"
        }
    }
}

enum UserType: Int {
    case physical = 1
    case legal = 2
    //
    mutating func toStringKEY() -> String {
        switch self {
        case .physical: return "ENUM_KEY_USER_TYPE_PHYSICAL"
        case .legal: return "ENUM_KEY_USER_TYPE_LEGAL"
        }
    }
}

enum AddressType: Int {
    case residential = 1
    case commercial = 2
    //
    mutating func toStringKEY() -> String {
        switch self {
        case .residential: return "ENUM_KEY_USER_RESIDENTIAL"
        case .commercial: return "ENUM_KEY_USER_COMMERCIAL"
        }
    }
}

//MARK: - DEFINES
struct k {
    static let app_user_key = "app_user"
    
    //user:
    static let user_id = "id"
    static let user_email = "email"
    static let user_password = "password"
    static let user_news_email = "news_email"
    static let user_news_sms = "news_sms"
    static let user_delivery_same_address = "same_address"
    
    //physical user:
    static let physicaluser_firstName = "first_name"
    static let physicaluser_lastName = "last_name"
    static let physicaluser_nickName = "nickname"
    static let physicaluser_dateOfBirth = "date_of_birth"
    static let physicaluser_gender = "Sexo"
    static let physicaluser_cpf = "cpf"
    
    //legal user:
    static let legaluser_contactName = "name_contact"
    static let legaluser_cnpj = "cnpj"
    static let legaluser_fantasyName = "fantasy_name"
    static let legaluser_socialName = "social_name"
    static let legaluser_ie = "ie"
    static let legaluser_stateIE = "stats_ie"
    static let legaluser_freeIE = "isento"
    
    //address:
    static let address_contactName = "name"
    static let address_type = "type_address"
    static let address_prefix = "prefix"
    static let address_zipCode = "zip_code"
    static let address_streetName = "address"
    static let address_number = "number"
    static let address_complement = "complement"
    static let address_neighborhood = "neighborhood"
    static let address_city = "city"
    static let address_state = "state"
    static let address_reference = "reference"
    static let address_phoneNumber = "phone"
    static let address_cellphoneNumber = "cellphone"
    
}

//MARK: - USER CLASS

class User: ObjectProtocol {
    
    typealias T = User
    
    //Properties:
    var type:UserType!
    //
    var id:Int!
    var email:String?
    var password:String?
    var acceptNewsByEmail:Bool!
    var acceptNewsBySMS:Bool!
    var deliverySameAddress:Bool!
    //
    var physical:PhysicalUser?
    var legal:LegalUser?
    //
    var contactAddress:Address?
    var deliveryAddress:Address?
    //
    var originalLoginData:Dictionary<String, Any>?
    
    //Initializer:
    required init() {
        self.type = .physical
        //
        self.id = 0
        self.email = nil
        self.password = nil
        self.acceptNewsByEmail = true
        self.acceptNewsBySMS = true
        self.deliverySameAddress = true
        //
        self.physical = PhysicalUser.init()
        self.legal = LegalUser.init()
        //
        self.contactAddress = Address.init()
        self.deliveryAddress = Address.init()
        //
        self.originalLoginData = nil
    }
    
    //Protocol
    class func new(_ objectDictionary:Dictionary<String, Any>?, _ typeD:String?) -> T? {
        
        if let dic = objectDictionary{
            
            if (dic.keys.count == 0){
                return nil
            }else{
                
                let newUser:User = User.init()
                //ignore 'typeD'
                let keysList:Array = Array.init(dic.keys)
                
                //BASE: *******************************************************************************
                
                //id:
                if (keysList.contains(k.user_id)){newUser.id = dic[k.user_id] as? Int}
                //email:
                if (keysList.contains(k.user_email)){newUser.email = dic[k.user_email] as? String}
                //password:
                if (keysList.contains(k.user_password)){newUser.password = dic[k.user_password] as? String}
                //acceptNewsByEmail:
                if (keysList.contains(k.user_news_email)){
                    newUser.acceptNewsByEmail = ToolBox.validationHelper_ValidateBolean(text: (dic[k.user_news_email] as? String), comparingBoolean: true)
                }
                //acceptNewsBySMS:
                if (keysList.contains(k.user_news_sms)){
                    newUser.acceptNewsBySMS = ToolBox.validationHelper_ValidateBolean(text: (dic[k.user_news_sms] as? String), comparingBoolean: true)
                }
                //deliverySameAddress:
                if (keysList.contains(k.user_delivery_same_address)){
                    newUser.deliverySameAddress = ToolBox.validationHelper_ValidateBolean(text: (dic[k.user_delivery_same_address] as? String), comparingBoolean: true)
                }
                
                //PHYSICAL: *******************************************************************************
                
                newUser.physical = PhysicalUser.new(dic, nil)
                
                //LEGAL: *******************************************************************************
                
                newUser.legal = LegalUser.new(dic, nil)
                
                //CONTACT_ADDRESS: *******************************************************************************
                
                newUser.contactAddress = Address.new(dic, nil)
                
                //DELIVERY_ADDRESS: *******************************************************************************
                
                if (newUser.deliverySameAddress) {
                    newUser.deliveryAddress = newUser.contactAddress?.copy()
                }else{
                    newUser.deliveryAddress = Address.new(dic, "2")
                }
                
                //Validando campos obrigatórios (opcional):
                //....
                
                newUser.originalLoginData = dic
                
                return newUser
            }
            
        }else{
            return nil
        }
    }
    
    func copy() -> T {
        
        let copyObject:User = User.init()
        copyObject.type = self.type
        copyObject.id = self.id
        copyObject.email = self.email
        copyObject.password = self.password
        copyObject.acceptNewsByEmail = self.acceptNewsByEmail
        copyObject.acceptNewsBySMS = self.acceptNewsBySMS
        copyObject.deliverySameAddress = self.deliverySameAddress
        //
        copyObject.physical = self.physical?.copy()
        copyObject.legal = self.legal?.copy()
        copyObject.contactAddress = self.contactAddress?.copy()
        copyObject.deliveryAddress = self.deliveryAddress?.copy()
        //
        copyObject.originalLoginData = self.originalLoginData
        //
        return copyObject
    }
    
    func isEqual(_ objectToCompare:T?) -> Bool {
        
        if (objectToCompare?.type != self.type){return false}
        if (objectToCompare?.id != self.id){return false}
        if (objectToCompare?.email != self.email){return false}
        if (objectToCompare?.password != self.password){return false}
        if (objectToCompare?.acceptNewsByEmail != self.acceptNewsByEmail){return false}
        if (objectToCompare?.acceptNewsBySMS != self.acceptNewsBySMS){return false}
        if (objectToCompare?.deliverySameAddress != self.deliverySameAddress){return false}
        //
        if ((objectToCompare?.physical?.isEqual(self.physical)) != true){return false}
        if ((objectToCompare?.legal?.isEqual(self.legal)) != true){return false}
        if ((objectToCompare?.contactAddress?.isEqual(self.contactAddress)) != true){return false}
        if ((objectToCompare?.deliveryAddress?.isEqual(self.deliveryAddress)) != true){return false}
        //
        return true
    }
    
    func dictionary(_ typeD:String?) -> Dictionary<String, Any> {
        
        var dic:Dictionary<String, Any> = Dictionary.init()
        //
        //ignore typeD
        //
        dic[k.user_id] = self.id == nil ? "" : self.id
        dic[k.user_email] = self.email == nil ? "" : self.email!
        dic[k.user_password] = self.password == nil ? "" : self.password!
        dic[k.user_news_email] = self.acceptNewsByEmail == true ? "true" : "false"
        dic[k.user_news_sms] = self.acceptNewsBySMS == true ? "true" : "false"
        dic[k.user_delivery_same_address] = self.deliverySameAddress == true ? "true" : "false"
        //
        if (self.type == .physical){
            dic.update(other: self.physical?.dictionary(nil))
        }else{
            dic.update(other: self.legal?.dictionary(nil))
        }
        //
        dic.update(other: self.contactAddress?.dictionary(nil))
        dic.update(other: self.deliveryAddress?.dictionary("2"))
        //
        return dic
        
    }
}

//MARK: - PHYSICAL USER CLASS

class PhysicalUser:ObjectProtocol {
    
    typealias T = PhysicalUser
    
    //Properties:
    var firstName:String?
    var lastName:String?
    var nickname:String?
    //
    var gender:Gender!
    var birthdate:Date?
    //
    var cpf:String!
    
    required init() {
        
        self.firstName = nil
        self.lastName = nil
        self.nickname = nil
        self.gender = .female
        self.birthdate = nil
        self.cpf = nil
    }
    
    //Protocol
    class func new(_ objectDictionary:Dictionary<String, Any>?, _ typeD:String?) -> T? {
        
        if let dic = objectDictionary{
            
            if (dic.keys.count == 0){
                return nil
            }else{
                
                let newPhysicalUser:PhysicalUser = PhysicalUser.init()
                //ignore 'typeD'
                let keysList:Array = Array.init(dic.keys)
                
                //firstName:
                if (keysList.contains(k.physicaluser_firstName)){newPhysicalUser.firstName = dic[k.physicaluser_firstName] as? String}
                //lastName:
                if (keysList.contains(k.physicaluser_lastName)){newPhysicalUser.lastName = dic[k.physicaluser_lastName] as? String}
                //nickname:
                if (keysList.contains(k.physicaluser_nickName)){newPhysicalUser.nickname = dic[k.physicaluser_nickName] as? String}
                //birthdate:
                if (keysList.contains(k.physicaluser_dateOfBirth)){
                    let bDate:String? = dic[k.physicaluser_dateOfBirth] as? String
                    newPhysicalUser.birthdate = ToolBox.dateHelper_DateFromString(dateString: bDate, stringFormat: ToolBox.DATE_BAR_ddMMyyyy)
                }
                //gender:
                if (keysList.contains(k.physicaluser_gender)){
                    let str:String? = dic[k.physicaluser_gender] as? String
                    if (str == "M"){
                        newPhysicalUser.gender = .male
                    }else{
                        newPhysicalUser.gender = .female
                    }
                }
                //cpf:
                if (keysList.contains(k.physicaluser_cpf)){newPhysicalUser.cpf = dic[k.physicaluser_cpf] as? String}
                
                //Validando campos obrigatórios (opcional):
                //....
                
                return newPhysicalUser
            }
            
        }else{
            return nil
        }
    }
    
    func copy() -> T {
        
        let copyObject:PhysicalUser = PhysicalUser.init()
        copyObject.firstName = self.firstName
        copyObject.lastName = self.lastName
        copyObject.nickname = self.nickname
        copyObject.gender = self.gender
        copyObject.birthdate = ToolBox.dateHelper_CopyDate(date:self.birthdate)
        copyObject.cpf = self.cpf
        //
        return copyObject
    }
    
    func isEqual(_ objectToCompare:T?) -> Bool {
        
        if (objectToCompare?.firstName != self.firstName){return false}
        if (objectToCompare?.lastName != self.lastName){return false}
        if (objectToCompare?.nickname != self.nickname){return false}
        if (objectToCompare?.gender != self.gender){return false}
        if (objectToCompare?.birthdate != self.birthdate){return false}
        if (objectToCompare?.cpf != self.cpf){return false}
        //
        return true
    }
    
    func dictionary(_ typeD:String?) -> Dictionary<String, Any> {
        
        var dic:Dictionary<String, Any> = Dictionary.init()
        //
        //ignore typeD
        //
        dic[k.physicaluser_firstName] = self.firstName == nil ? "" : self.firstName!
        dic[k.physicaluser_lastName] = self.lastName == nil ? "" : self.lastName!
        dic[k.physicaluser_nickName] = self.nickname == nil ? "" : self.nickname!
        dic[k.physicaluser_dateOfBirth] = self.birthdate == nil ? "" : ToolBox.dateHelper_StringFromDate(date: self.birthdate, stringFormat: ToolBox.DATE_BAR_ddMMyyyy)
        dic[k.physicaluser_gender] = self.gender == .male ? "M" : "F"
        dic[k.physicaluser_cpf] = self.cpf == nil ? "" : self.cpf!
        //
        return dic
    }
}


//MARK: - LEGAL USER CLASS

class LegalUser:ObjectProtocol {
    
    typealias T = LegalUser
    
    //Properties:
    var contactName:String?
    var cnpj:String?
    var fantasyName:String?
    var socialName:String?
    var ie:String?
    var stateIE:String?
    var freeIE:Bool!
    
    required init() {
        
        self.contactName = nil
        self.cnpj = nil
        self.fantasyName = nil
        self.socialName = nil
        self.ie = nil
        self.stateIE = nil
        self.freeIE = true
    }
    
    //Protocol:
    class func new(_ objectDictionary:Dictionary<String, Any>?, _ typeD:String?) -> T? {
        
        if let dic = objectDictionary{
            
            if (dic.keys.count == 0){
                return nil
            }else{
                
                let newLegalUser:LegalUser = LegalUser.init()
                //ignore 'typeD'
                let keysList:Array = Array.init(dic.keys)
                
                //contactName:
                if (keysList.contains(k.legaluser_contactName)){newLegalUser.contactName = dic[k.legaluser_contactName] as? String}
                //cnpj:
                if (keysList.contains(k.legaluser_cnpj)){newLegalUser.cnpj = dic[k.legaluser_cnpj] as? String}
                //fantasyName:
                if (keysList.contains(k.legaluser_fantasyName)){newLegalUser.fantasyName = dic[k.legaluser_fantasyName] as? String}
                //socialName:
                if (keysList.contains(k.legaluser_socialName)){newLegalUser.socialName = dic[k.legaluser_socialName] as? String}
                //ie:
                if (keysList.contains(k.legaluser_ie)){newLegalUser.ie = dic[k.legaluser_ie] as? String}
                //stateIE:
                if (keysList.contains(k.legaluser_stateIE)){newLegalUser.stateIE = dic[k.legaluser_stateIE] as? String}
                //freeIE:
                if (keysList.contains(k.legaluser_freeIE)){newLegalUser.freeIE = ((dic[k.legaluser_freeIE] as? Bool) ?? newLegalUser.freeIE)}
                
                //Validando campos obrigatórios (opcional):
                //....
                
                return newLegalUser
            }
            
        }else{
            return nil
        }
    }
    
    func copy() -> T {
        
        let copyObject:LegalUser = LegalUser.init()
        copyObject.contactName = self.contactName
        copyObject.cnpj = self.cnpj
        copyObject.fantasyName = self.fantasyName
        copyObject.socialName = self.socialName
        copyObject.ie = self.ie
        copyObject.stateIE = self.stateIE
        copyObject.freeIE = self.freeIE
        //
        return copyObject
        
    }
    
    func isEqual(_ objectToCompare:T?) -> Bool {
        
        if (objectToCompare?.contactName != self.contactName){return false}
        if (objectToCompare?.cnpj != self.cnpj){return false}
        if (objectToCompare?.fantasyName != self.fantasyName){return false}
        if (objectToCompare?.socialName != self.socialName){return false}
        if (objectToCompare?.ie != self.ie){return false}
        if (objectToCompare?.stateIE != self.stateIE){return false}
        if (objectToCompare?.freeIE != self.freeIE){return false}
        //
        return true
    }
    
    func dictionary(_ typeD:String?) -> Dictionary<String, Any> {
        
        var dic:Dictionary<String, Any> = Dictionary.init()
        //
        //ignore typeD
        //
        dic[k.legaluser_contactName] = self.contactName == nil ? "" : self.contactName!
        dic[k.legaluser_cnpj] = self.cnpj == nil ? "" : self.cnpj!
        dic[k.legaluser_fantasyName] = self.fantasyName == nil ? "" : self.fantasyName!
        dic[k.legaluser_socialName] = self.socialName == nil ? "" : self.socialName!
        dic[k.legaluser_ie] = self.ie == nil ? "" : self.ie!
        dic[k.legaluser_stateIE] = self.stateIE == nil ? "" : self.stateIE!
        dic[k.legaluser_freeIE] = self.freeIE == nil ? "" : self.freeIE!
        //
        return dic
    }
}

//MARK: - ADDRESS CLASS

class Address:ObjectProtocol {
    
    typealias T = Address
    
    //Properties:
    var contactName:String?
    var type:AddressType!
    var prefix:String?
    var zipCode:String?
    var streetName:String?
    var number:Int!
    var complement:String?
    var neighborhood:String? //bairro
    var city:String?
    var state:String? //estado
    var reference:String? //ponto de referência
    var phoneNumber:String?
    var cellphoneNumber:String?
    
    required init() {
        
        self.contactName = nil
        self.type = .residential
        self.prefix = nil
        self.zipCode = nil
        self.streetName = nil
        self.number = 0
        self.complement = nil
        self.neighborhood = nil
        self.city = nil
        self.state = nil
        self.reference = nil
        self.phoneNumber = nil
        self.cellphoneNumber = nil
    }
    
    
    //Protocol:
    class func new(_ objectDictionary:Dictionary<String, Any>?, _ typeD:String?) -> T? {
        
        if let dic = objectDictionary{
            
            if (dic.keys.count == 0){
                return nil
            }else{
                
                let newAddress:Address = Address.init()
                //
                let appendK:String = typeD == nil ? "" : typeD!
                //
                let keysList:Array = Array.init(dic.keys)
                
                //contactName:
                if (keysList.contains((k.address_contactName + appendK))){newAddress.contactName = dic[(k.address_contactName + appendK)] as? String}
                //type:
                if (keysList.contains((k.address_type + appendK))){
                    let str:String? = dic[(k.address_type + appendK)] as? String
                    if (str == "R"){
                        newAddress.type = .residential
                    }else{
                        newAddress.type = .commercial
                    }
                }
                //prefix:
                if (keysList.contains((k.address_prefix + appendK))){newAddress.prefix = dic[(k.address_prefix + appendK)] as? String}
                //CEP:
                if (keysList.contains((k.address_zipCode + appendK))){newAddress.zipCode = dic[(k.address_zipCode + appendK)] as? String}
                //streetName:
                if (keysList.contains((k.address_streetName + appendK))){newAddress.streetName = dic[(k.address_streetName + appendK)] as? String}
                //number:
                if (keysList.contains((k.address_number + appendK))){newAddress.number = Int.init((dic[(k.address_number + appendK)] as! String)) }
                //complement:
                if (keysList.contains((k.address_complement + appendK))){newAddress.complement = dic[(k.address_complement + appendK)] as? String}
                //neighborhood:
                if (keysList.contains((k.address_neighborhood + appendK))){newAddress.neighborhood = dic[(k.address_neighborhood + appendK)] as? String}
                //city:
                if (keysList.contains((k.address_city + appendK))){newAddress.city = dic[(k.address_city + appendK)] as? String}
                //state:
                if (keysList.contains((k.address_state + appendK))){newAddress.state = dic[(k.address_state + appendK)] as? String}
                //reference
                if (keysList.contains((k.address_reference + appendK))){newAddress.reference = dic[(k.address_reference + appendK)] as? String}
                //phoneNumber:
                if (keysList.contains((k.address_phoneNumber + appendK))){newAddress.phoneNumber = dic[(k.address_phoneNumber + appendK)] as? String}
                //cellphoneNumber
                if (keysList.contains((k.address_cellphoneNumber + appendK))){newAddress.cellphoneNumber = dic[(k.address_cellphoneNumber + appendK)] as? String}
                
                //Validando campos obrigatórios (opcional):
                //....
                
                return newAddress
            }
            
        }else{
            return nil
        }
    }
    
    func copy() -> T {
        
        let copyObject:Address = Address.init()
        copyObject.contactName = self.contactName
        copyObject.type = self.type
        copyObject.prefix = self.prefix
        copyObject.zipCode = self.zipCode
        copyObject.streetName = self.streetName
        copyObject.number = self.number
        copyObject.complement = self.complement
        copyObject.neighborhood = self.neighborhood
        copyObject.city = self.city
        copyObject.state = self.state
        copyObject.reference = self.reference
        copyObject.phoneNumber = self.phoneNumber
        copyObject.cellphoneNumber = self.cellphoneNumber
        //
        return copyObject
    }
    
    func isEqual(_ objectToCompare:T?) -> Bool {
        
        if (objectToCompare?.contactName != self.contactName){return false}
        if (objectToCompare?.type != self.type){return false}
        if (objectToCompare?.prefix != self.prefix){return false}
        if (objectToCompare?.zipCode != self.zipCode){return false}
        if (objectToCompare?.streetName != self.streetName){return false}
        if (objectToCompare?.number != self.number){return false}
        if (objectToCompare?.complement != self.complement){return false}
        if (objectToCompare?.neighborhood != self.neighborhood){return false}
        if (objectToCompare?.city != self.city){return false}
        if (objectToCompare?.state != self.state){return false}
        if (objectToCompare?.reference != self.reference){return false}
        if (objectToCompare?.phoneNumber != self.phoneNumber){return false}
        if (objectToCompare?.cellphoneNumber != self.cellphoneNumber){return false}
        //
        return true
    }
    
    func dictionary(_ typeD:String?) -> Dictionary<String, Any> {
        
        var dic:Dictionary<String, Any> = Dictionary.init()
        //
        let appendK:String = typeD == nil ? "" : typeD!
        //
        dic[(k.address_contactName + appendK)] = self.contactName == nil ? "" : self.contactName!
        //
        if (self.type == .residential){
            dic[(k.address_type + appendK)] = "R"
        }else{
            dic[(k.address_type + appendK)] = "C"
        }
        //
        dic[(k.address_prefix + appendK)] = self.prefix == nil ? "" : self.prefix!
        dic[(k.address_zipCode + appendK)] = self.zipCode == nil ? "" : self.zipCode!
        dic[(k.address_streetName + appendK)] = self.streetName == nil ? "" : self.streetName!
        dic[(k.address_number + appendK)] = String.init(self.number)
        dic[(k.address_complement + appendK)] = self.complement == nil ? "" : self.complement!
        dic[(k.address_neighborhood + appendK)] = self.neighborhood == nil ? "" : self.neighborhood!
        dic[(k.address_city + appendK)] = self.city == nil ? "" : self.city!
        dic[(k.address_state + appendK)] = self.state == nil ? "" : self.state!
        dic[(k.address_reference + appendK)] = self.reference == nil ? "" : self.reference!
        dic[(k.address_phoneNumber + appendK)] = self.phoneNumber == nil ? "" : self.phoneNumber!
        dic[(k.address_cellphoneNumber + appendK)] = self.cellphoneNumber == nil ? "" : self.cellphoneNumber!
        //
        return dic
    }
    
}
