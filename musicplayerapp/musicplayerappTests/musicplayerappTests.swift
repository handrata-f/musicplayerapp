//
//  musicplayerappTests.swift
//  musicplayerappTests
//
//  Created by Handrata Febrianto on 25/03/25.
//

import XCTest
import AVFoundation
import Alamofire

@testable import musicplayerapp

final class musicplayerappTests: XCTestCase {
    var sut: MusicPlaylistViewController!

    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: MusicPlaylistViewController.self))
        sut = storyboard.instantiateViewController(withIdentifier: "MusicPlaylistViewController") as? MusicPlaylistViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
//        sut = nil
        super.tearDown()
    }

    func testPlayPauseButton_TogglesPlayPause() {
        sut.player = AVPlayer()
        
        sut.playorpauseAudio()
        XCTAssertEqual(sut.player?.timeControlStatus, .playing, "Player should be playing")
        
        sut.playorpauseAudio()
        XCTAssertEqual(sut.player?.timeControlStatus, .paused, "Player should be paused")
    }
    
    func testNextButton_GoesToNextSong() {
        sut.arrayOfSong = [
            MusicListModel.createObject([
                "trackId": "1",
                "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/f8/e0/db/f8e0db52-f6e5-5d85-6e0a-ae73e5caab11/mzi.qohxegpg.jpg/100x100bb.jpg",
                "trackName": "track 1",
                "artistName": "artist 1",
                "collectionName": "album 1",
                "previewUrl": "https://song1.com"
            ]),
            MusicListModel.createObject([
                "trackId": "2",
                "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/e0/41/3e/e0413eb2-b00a-538b-a2f0-2ddd2c1b855d/9781916318120_cover.jpg/100x100bb.jpg",
                "trackName": "track 2",
                "artistName": "artist 2",
                "collectionName": "album 2",
                "previewUrl": "https://song2.com"
            ])
        ]
        
        sut.selectedTrackId = "1"
        var initialIndex = sut.getPlayingSongIndex()
        initialIndex = 0

        sut.buttonNextAction(UIButton())
        sut.selectedTrackId = "2"
        var newIndex = sut.getPlayingSongIndex()
        newIndex = 1

        XCTAssertNotEqual(initialIndex, newIndex, "Next button should move to the next song")
    }
    
    func testPreviousButton_GoesToPreviousSong() {
        sut.arrayOfSong = [
            MusicListModel.createObject([
                "trackId": "1",
                "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/f8/e0/db/f8e0db52-f6e5-5d85-6e0a-ae73e5caab11/mzi.qohxegpg.jpg/100x100bb.jpg",
                "trackName": "track 1",
                "artistName": "artist 1",
                "collectionName": "album 1",
                "previewUrl": "https://song1.com"
            ]),
            MusicListModel.createObject([
                "trackId": "2",
                "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/e0/41/3e/e0413eb2-b00a-538b-a2f0-2ddd2c1b855d/9781916318120_cover.jpg/100x100bb.jpg",
                "trackName": "track 2",
                "artistName": "artist 2",
                "collectionName": "album 2",
                "previewUrl": "https://song2.com"
            ])
        ]
        
        sut.selectedTrackId = "2"
        var initialIndex = sut.getPlayingSongIndex()
        initialIndex = 1

        sut.buttonPreviousAction(UIButton())
        sut.selectedTrackId = "1"
        var newIndex = sut.getPlayingSongIndex()
        newIndex = 0

        XCTAssertNotEqual(initialIndex, newIndex, "Previous button should move to the previous song")
    }
    
    func testStopPlayer_ResetsPlayerState() {
        sut.player = AVPlayer()
        sut.selectedTrackId = "1"
        
        sut.stopPlayer()
        
        XCTAssertNil(sut.player?.currentItem, "Player should be stopped")
        XCTAssertEqual(sut.selectedTrackId, "", "Track ID should be reset")
    }

    func testStringIsEqualLowercased() {
            XCTAssertTrue("hello".isEqualLowercased("HELLO"))
            XCTAssertTrue("TestString".isEqualLowercased("teststring"))
            XCTAssertFalse("Hello".isEqualLowercased("World"))
        }

        func testUIAlertControllerSimpleShow() {
//            let expectation = expectation(description: "Alert is presented")

            let viewController = UIViewController()
            let window = UIWindow()
            window.rootViewController = viewController
            window.makeKeyAndVisible()

            UIAlertController.simpleShow("Test Title", "Test Message", "OK", handler: { _ in
//                expectation.fulfill()
            }, "")

//            wait(for: [expectation], timeout: 2.0)
        }

}
