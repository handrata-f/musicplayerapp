//
//  MusicListModel.swift
//  musicplayerapp
//
//  Created by Handrata Febrianto on 25/03/25.
//

import Foundation

class MusicListModel: NSObject {
    var trackId: String = ""
    var photoAlbum: String = ""
    var songTitle: String = ""
    var songArtist: String = ""
    var songAlbum: String = ""
    var songSourceURLString: String = ""

    static func createObject(_ dict: [String: Any]) -> MusicListModel {
        let new = MusicListModel()
        if let trackIDNumber = dict["trackId"] as? NSNumber {
            new.trackId = trackIDNumber.stringValue
        }
        new.photoAlbum = dict["artworkUrl100"] as? String ?? ""
        new.songTitle = dict["trackName"] as? String ?? ""
        new.songArtist = dict["artistName"] as? String ?? ""
        new.songAlbum = dict["collectionName"] as? String ?? ""
        new.songSourceURLString = dict["previewUrl"] as? String ?? ""

        return new
    }
}
