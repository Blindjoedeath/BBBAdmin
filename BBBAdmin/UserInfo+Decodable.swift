//
//  UserInfo+Decodable.swift
//  BBBAdmin
//
//  Created by Blind Joe Death on 13.09.2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

struct UserInfoParsed {
    
    var userId : String
    var firstName: String
    var lastName: String
    var nickName: String
    var videoMessageCount: Int
    var videoCount: Int
    var audioMessageCount: Int
    var audioCount: Int
    var settings: SettingsParsed
    
    init(userId: String, firstName: String, lastName: String, nickName: String,
         videoMessageCount: Int, videoCount: Int, audioMessageCount: Int,
         audioCount: Int, settings: SettingsParsed) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.videoMessageCount = videoMessageCount
        self.videoCount = videoCount
        self.audioMessageCount = audioMessageCount
        self.audioCount = audioCount
        self.settings = settings
    }
}

extension UserInfoParsed : Decodable {
    enum CodingKeys : String, CodingKey {
        case userId = "Id"
        case firstName = "FirstName"
        case lastName = "LastName"
        case nickName = "UserName"
        case videoMessageCount = "VideoMessagesCount"
        case videoCount = "VideoCount"
        case audioMessageCount = "VoiceMessagesCount"
        case audioCount = "AudioCount"
        case settings = "Settings"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var firstName = ""
        var lastName = ""
        var nickName = ""
        
        if let first = try? container.decode(String.self, forKey: .firstName) {
            firstName = first
        } else {
            firstName = ""
        }
        
        if let last = try? container.decode(String.self, forKey: .lastName){
            lastName = last
        }else {
            lastName = ""
        }
        if let nick = try? container.decode(String.self, forKey: .nickName){
            nickName = nick
        } else {
            nickName = ""
        }
        
        let closure: (inout Int, CodingKeys) -> Void = { count, key in
            if let c = try? container.decode(Int.self, forKey: key){
                count = Int(c)
            } else {
                count = 0
                print("Чето не то")
            }
        }
        
        let userId = try! container.decode(String.self, forKey: .userId)
        
        var videoMessageCount = 0
        var videoCount = 0
        var audioMessageCount = 0
        var audioCount = 0
        
        closure(&videoMessageCount, .videoMessageCount)
        closure(&videoCount, .videoCount)
        closure(&audioMessageCount, .audioMessageCount)
        closure(&audioCount, .audioCount)
        
        let settings = try! container.decode(SettingsParsed.self, forKey: .settings)
        
        self.init(userId: userId, firstName: firstName, lastName: lastName, nickName: nickName,
                  videoMessageCount: videoMessageCount, videoCount: videoCount,
                  audioMessageCount: audioMessageCount,
                  audioCount: audioCount, settings: settings)

    }
}
