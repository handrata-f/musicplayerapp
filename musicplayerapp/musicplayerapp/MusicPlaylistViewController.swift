//
//  MusicPlaylistViewController.swift
//  musicplayerapp
//
//  Created by Handrata Febrianto on 25/03/25.
//

import UIKit
import AVFoundation

class MusicPlaylistViewController: UIViewController {
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewSongList: UITableView!

    @IBOutlet weak var viewMiniPlayer: UIView!
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var sliderProgress: UISlider!

    @IBOutlet weak var viewBottonBackground: UIView!

    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var timeObserver: Any?

    let cellID = "MusicListViewCell"
    var arrayOfSong: [MusicListModel] = [] {
        didSet {
            tableViewSongList.reloadData()
        }
    }
    var selectedTrackId: String = ""

    deinit {
        removeTimeObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupSlider()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error.localizedDescription)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textFieldSearch.becomeFirstResponder()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup
extension MusicPlaylistViewController {
    private func setupTableView() {
        tableViewSongList.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableViewSongList.separatorStyle = .none
        tableViewSongList.rowHeight = 81
        tableViewSongList.keyboardDismissMode = .interactive
        tableViewSongList.delegate = self
        tableViewSongList.dataSource = self
    }

    func setupSlider() {
        sliderProgress.minimumValue = 0
        sliderProgress.maximumValue = 1
        sliderProgress.value = 0
        sliderProgress.isUserInteractionEnabled = false  // Disable user interaction
    }
}

// MARK: - Load Data
extension MusicPlaylistViewController {
    func loadData(_ searchText: String) {
        APIManager.showLoading()
        APIManager.shared.getSearchMusic(searchText, completion: { response in
            APIManager.hideLoading()
            if let results = response["results"] as? [[String: Any]] {
                var arrayOfResult: [MusicListModel] = []
                for dict in results {
                    arrayOfResult.append(MusicListModel.createObject(dict))
                }
                self.arrayOfSong = arrayOfResult
            }
        })
    }
}

// MARK: - Button Action
extension MusicPlaylistViewController {
    @IBAction func buttonPlayPauseAction(_ sender: Any) {
        playorpauseAudio()
    }

    @IBAction func buttonPreviousAction(_ sender: Any) {
        let index = getPlayingSongIndex()

        if index == -1 {
            UIAlertController.simpleShow(nil, "Playlist is empty")
            return
        }

        let prevIndex = (index - 1) < 0 ? (arrayOfSong.count - 1) : (index - 1)
        playMusic(prevIndex)
    }

    @IBAction func buttonNextAction(_ sender: Any) {
        let index = getPlayingSongIndex()

        if index == -1 {
            UIAlertController.simpleShow(nil, "Playlist is empty")
            return
        }

        let nextIndex = (index + 1) > (arrayOfSong.count - 1) ? 0 : (index + 1)
        playMusic(nextIndex)
    }
}

// MARK: - UITextFieldDelegate
extension MusicPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else { return false }

        textField.resignFirstResponder()

        stopPlayer()
        loadData(searchText)

        return true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MusicPlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSong.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MusicListViewCell {
            cell.selectionStyle = .none
            cell.prepareForReuse()
            let model = arrayOfSong[index]
            cell.updateCell(photoAssetName: model.photoAlbum,
                            songName: model.songTitle,
                            artistName: model.songArtist,
                            albumName: model.songAlbum,
                            isPlaying: model.trackId.isEqualLowercased(selectedTrackId))

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        playMusic(index)
    }
}

// MARK: - Player
extension MusicPlaylistViewController {
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        print("Music finished playing")

        let index = getPlayingSongIndex()
        if index == -1 {
            UIAlertController.simpleShow(nil, "Playlist is empty")
            stopPlayer()
        } else {
            buttonNextAction(buttonNext as Any)
        }
    }

    func playMusic(_ selectedIndex: Int) {
        if selectedIndex < arrayOfSong.count {
            let model = arrayOfSong[selectedIndex]
            startPlayer(model)
            tableViewSongList.reloadData()
        }
    }

    func startPlayer(_ model: MusicListModel) {
        removeTimeObserver()
        guard let url = URL(string: model.songSourceURLString) else {
            print("Invalid URL")
            return
        }
        selectedTrackId = model.trackId

        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()

        viewMiniPlayer.isHidden = false
        viewBottonBackground.isHidden = viewMiniPlayer.isHidden
        buttonPlayPause.setImage(UIImage(named: "icon-pause"), for: .normal)

        addPeriodicTimeObserver() // Update slider as the song plays
    }

    func playorpauseAudio() {
        guard let player = player else {
            print("Audio Player not initialized")

            return
        }

        if player.timeControlStatus == .playing {
            player.pause()
            buttonPlayPause.setImage(UIImage(named: "icon-play"), for: .normal)
        } else {
            player.play()
            buttonPlayPause.setImage(UIImage(named: "icon-pause"), for: .normal)
        }
    }

    func stopPlayer() {
        player?.pause()
        player?.seek(to: .zero)

        viewMiniPlayer.isHidden = true
        viewBottonBackground.isHidden = viewMiniPlayer.isHidden
        selectedTrackId = ""
    }

    func addPeriodicTimeObserver() {
        guard let player = player else { return }

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1,
                                                                          preferredTimescale: 1),
                                                      queue: DispatchQueue.main) { [weak self] time in
            guard let self = self, let duration = self.playerItem?.duration.seconds else { return }
            let currentTime = time.seconds
            let progress = Float(currentTime / duration)
            self.sliderProgress.value = progress
        }
    }

    func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}

// MARK: - Custom Function
extension MusicPlaylistViewController {
    func getPlayingSongIndex() -> Int {
        if let index = arrayOfSong.firstIndex(where: { $0.trackId.isEqualLowercased(selectedTrackId) }) {
            return index
        }

        return -1
    }
}
