//
//  FileManager.swift
//  Project-Swift
//
//  Created by Erico GT on 03/04/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

import Foundation

class DataFileManager{
 
    //TODO: personalizar para cada tipo de arquivo necessário salvar
    
    //Methods:
    
    //SAVE
    func saveData(dictionaryData:Dictionary<String, Any>?) -> Bool{
        
        if var dicToSave:Dictionary = dictionaryData{
            
            dicToSave = App.Utils.converterHelper_NewDictionaryRemovingNullValuesFromDictionary(oldDictionary: dicToSave as NSDictionary, withString: "") as! Dictionary<String, Any>
            
            var baseURL:URL? = nil
            
            do{
                baseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            }catch{
                return false
            }
            
            let directoryPath:URL = baseURL!.appendingPathComponent("DataDir")
            let filePath:URL = directoryPath.appendingPathComponent("DataFile")
            
            //verificando diretório:
            if (!self.directoryExists(atPath: directoryPath)){
                if (!self.createDirectory(atPath: directoryPath)){
                    return false
                }
            }
            
            //verificando arquivo:
            if (!self.fileExists(atPath: filePath)){
                if (!self.createFile(atPath: filePath)){
                    return false
                }
            }
            
            //salvando:
            let dataToSave:Data = NSKeyedArchiver.archivedData(withRootObject: dicToSave)
            
            do{
                try dataToSave.write(to: filePath)
                return true
            } catch{
                print("Error >> applicationHelper_LoadDataFromFile: \(error.localizedDescription)")
                return false
            }
        }else{
            return false
        }
    }
    
    //DELETE
    func deleteData() -> Bool{
        
        let paths:Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir:String = paths.first!
        let directoryPath:String = documentsDir.appending("/DataDir")
        let filePath:String = directoryPath.appending("/DataFile")
        
        if (FileManager.default.isDeletableFile(atPath: filePath)){
            
            do{
                try FileManager.default.removeItem(atPath: filePath)
                return true
            }catch{
                print("Error >> applicationHelper_DeleteFile: \(error)")
                return false
            }
        }else{
            return false
        }
    }
    
    //LOAD
    func loadData() -> Dictionary<String, Any>?{
        
        let baseURL:URL = URL.init(string:(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)).last!)!
        let directoryPath:URL = baseURL.appendingPathComponent("DataDir")
        let filePath:URL = directoryPath.appendingPathComponent("DataFile")
        
        do{
            let data:NSData = try NSData.init(contentsOfFile: filePath.absoluteString)
            let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String : Any]
            return dictionary
        } catch{
            print("Error >> applicationHelper_LoadDataFromFile: \(error)")
            //
            return nil
        }
    }
    
    
    //MARK: - Private Methods
    
    private func directoryExists(atPath:URL) -> Bool{
        return FileManager.default.fileExists(atPath: atPath.absoluteString)
    }
    
    private func createDirectory(atPath:URL) -> Bool{
        do{
            try FileManager.default.createDirectory(at: atPath, withIntermediateDirectories: true, attributes: nil)
            return true
        }catch{
            print("createDirectory Error: \(error.localizedDescription)")
            return false
        }
    }
    
    private func fileExists(atPath:URL) -> Bool{
        return FileManager.default.fileExists(atPath: atPath.absoluteString)
    }
    
    private func createFile(atPath:URL) -> Bool{
        return FileManager.default.createFile(atPath: atPath.absoluteString.replacingOccurrences(of: "file:/", with: ""), contents: nil, attributes: nil)
    }
}
