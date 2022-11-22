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

    var color: UIColor {
        switch self {
        case .netflix:
            return UIColor(red: 255/255, green: 160/255, blue: 120/255, alpha: 0.5)
        case .youtube:
            return UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 0.5)
        case .spotify:
            return UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 0.5)
        case .appleMusic:
            return UIColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 0.5)
        case .dribbble:
            return UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.5)
        case .evernote:
            return UIColor(red: 255/255, green: 114/255, blue: 110/255, alpha: 0.5)
        case .iCloud:
            return UIColor(red: 255/255, green: 251/255, blue: 109/255, alpha: 0.5)
        case .skype:
            return UIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
        case .playstationPlus:
            return UIColor(red: 255/255, green: 228/255, blue: 181/255, alpha: 0.5)
        case .appleDeveloperProgram:
            return UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 0.5)
        case .appleTV:
            return UIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 0.5)
        case .dropbox:
            return UIColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 0.5)
        }
    }
}
