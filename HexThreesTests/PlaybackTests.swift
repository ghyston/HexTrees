//
//  PlaybackTests.swift
//  HexThreesTests
//
//  Created by Ilja Stepanow on 02.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import XCTest
@testable import HexThrees

class PlaybackRegularTests: XCTestCase {

    var playback : Playback!
    
    override func setUp() {
        playback = Playback()
    }

    func anotherTest() {
        
    }
    
    func unreversedUnscaled() {
        playback.start(duration: 5.0)
        XCTAssertEqual(playback.update(delta: 1.0), 0.2)
        XCTAssertEqual(playback.update(delta: 2.0), 0.6)
        XCTAssertEqual(playback.update(delta: 3.0), 1.0)
        XCTAssertEqual(playback.update(delta: 1.0), 1.0)
    }
    
    func reversedUnscaled() {
        playback.start(duration: 5.0, reversed: true)
        XCTAssertEqual(playback.update(delta: 1.0), 0.8)
        XCTAssertEqual(playback.update(delta: 2.0), 0.4)
        XCTAssertEqual(playback.update(delta: 3.0), 0.0)
        XCTAssertEqual(playback.update(delta: 1.0), 0.0)
    }
}