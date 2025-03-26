//
//  MusicListViewCell.swift
//  musicplayerapp
//
//  Created by Handrata Febrianto on 25/03/25.
//

import UIKit

class MusicListViewCell: UITableViewCell {
    @IBOutlet weak var imageViewPhotoAlbum: UIImageView!
    @IBOutlet weak var labelSongName: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var labelAlbum: UILabel!
    @IBOutlet weak var imageViewIconPlaying: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        imageViewIconPlaying.isHidden = true
    }

    func updateCell(photoAssetName: String,
                    songName: String,
                    artistName: String,
                    albumName: String,
                    isPlaying: Bool) {
        imageViewPhotoAlbum.loadImage(from: photoAssetName)
        labelSongName.text = songName
        labelArtist.text = artistName
        labelAlbum.text = albumName
        imageViewIconPlaying.isHidden = !isPlaying
    }
}
