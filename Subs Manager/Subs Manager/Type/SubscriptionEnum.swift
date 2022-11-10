//
//  SubscriptionEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 10.11.2022.
//

import UIKit
import CoreData

enum SubscriptionEnum: String, CaseIterable {
    case netflix = "Netflix"
    case youtube = "Youtube"
    case spotify = "Spotify"
    case appleMusic = "Apple Music"
    case dribbble = "Dribbble"
    case evernote = "Evernote"
    case iCloud = "iCloud"
    case skype = "Skype"
    case playstationPlus = "Playstation Plus"
    case appleDeveloperProgram = "Apple Developer Program"
    case appleTV = "Apple TV+"
    case dropbox = "Dropbox"

    var image: UIImage? {
        switch self {
        case .netflix:
            return UIImage(named: "netflix")
        case .youtube:
            return UIImage(named: "youtube")
        case .spotify:
            return UIImage(named: "spotify")
        case .appleMusic:
            return UIImage(named: "appleMusic")
        case .dribbble:
            return UIImage(named: "dribbble")
        case .evernote:
            return UIImage(named: "evernote")
        case .iCloud:
            return UIImage(named: "iCloud")
        case .skype:
            return UIImage(named: "skype")
        case .playstationPlus:
            return UIImage(named: "playstationPlus")
        case .appleDeveloperProgram:
            return UIImage(named: "appleDeveloper")
        case .appleTV:
            return UIImage(named: "appleTV")
        case .dropbox:
            return UIImage(named: "dropbox")
        }
    }
}
