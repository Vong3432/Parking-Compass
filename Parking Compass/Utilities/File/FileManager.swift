//
//  FileManager.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 21/02/2022.
//

import Foundation

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    // copied from: https://www.hackingwithswift.com/forums/100-days-of-swiftui/bucketlist-possible-extension-to-filemanager/11162
    static func encode<T: Encodable>(_ input: T, to file: String) throws {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(file)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(input)
        
        try data.write(to: url, options: [.atomic, .completeFileProtection])
    }
    
    static func decode<T: Decodable>(_ type: T.Type,
                                     from file: String,
                                     dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(file)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let data = try Data(contentsOf: url)
        let loaded = try decoder.decode(T.self, from: data)
        return loaded
    }
}
