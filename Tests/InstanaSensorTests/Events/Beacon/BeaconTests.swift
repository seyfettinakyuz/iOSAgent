//
//  File.swift
//  
//
//  Created by Christian Menschel on 29.11.19.
//

import XCTest
@testable import InstanaSensor

class BeaconTests: XCTestCase {

    func test_create_default() {
        // Given
        let timestamp = Date().millisecondsSince1970
        let sut = Beacon.createDefault(key: "KEY123", timestamp: timestamp, sessionId: "SID", eventId: "EID")

        // Then
        AssertEqualAndNotNil(sut.k, "KEY123")
        AssertEqualAndNotNil(sut.ti, String(timestamp))
        AssertEqualAndNotNil(sut.sid, "SID")
        AssertEqualAndNotNil(sut.bid, "EID")
        AssertEqualAndNotNil(sut.buid, InstanaSystemUtils.applicationBundleIdentifier)
        AssertEqualAndNotNil(sut.ul, Locale.current.languageCode)
        AssertEqualAndNotNil(sut.ab, InstanaSystemUtils.applicationBuildNumber)
        AssertEqualAndNotNil(sut.av, InstanaSystemUtils.applicationVersion)
        AssertEqualAndNotNil(sut.osn, InstanaSystemUtils.systemName)
        AssertEqualAndNotNil(sut.osv, InstanaSystemUtils.systemVersion)
        AssertEqualAndNotNil(sut.dmo, InstanaSystemUtils.deviceModel)
        AssertEqualAndNotNil(sut.dma, "Apple")
        AssertEqualAndNotNil(sut.ro, String(InstanaSystemUtils.isDeviceJailbroken))
        AssertEqualAndNotNil(sut.vw, String(Int(InstanaSystemUtils.screenSize.width)))
        AssertEqualAndNotNil(sut.vh, String(Int(InstanaSystemUtils.screenSize.height)))
        AssertEqualAndNotNil(sut.cn, InstanaSystemUtils.carrierName)
        AssertEqualAndNotNil(sut.ct, InstanaSystemUtils.connectionTypeDescription)
    }

    func testNumberOfFields_all() {
        // Given
        let sut = Beacon.createDefault(key: "KEY123")

        // When
        let values = Mirror(reflecting: sut).children

        // Then
        XCTAssertEqual(values.count, 34)
    }

    func testNumberOfFields_non_nil() {
        // Given
        let sut = Beacon.createDefault(key: "KEY123")

        // When
        let values = Mirror(reflecting: sut).nonNilChildren

        // Then
        XCTAssertEqual(values.count, 18)
    }


    func test_all_keys() {
        // Given
        let sut = Beacon.createDefault(key: "KEY123")
        // TODO: Add all keys of Beacon
        let expectedKeys = ["t", "bt", "k"]
    
        // When
        let keys = Mirror(reflecting: sut).children.compactMap {$0.label}

        // Then
        let matchingKeys = expectedKeys.filter {key in
            keys.contains(key)
        }

        XCTAssertEqual(expectedKeys.count, matchingKeys.count)
    }

    func test_formattedKVPair() {
        // Given
        let sut = Beacon.createDefault(key: "KEY123")

        // When
        let value = sut.ab

        // When
        XCTAssertEqual(sut.formattedKVPair(key: "ab", value: value), "ab\t\(value)")
    }

    func test_cleaning() {
        // Given
        var beacon = Beacon.createDefault(key: "KEY123")
        beacon.bt = """

                        Trace ab

                    """

        // When
        let sut = beacon.cleaning(beacon.bt)

        // Then
        XCTAssertEqual(beacon.bt, "\n    Trace ab\n")
        XCTAssertEqual(sut, "Trace ab")
    }

    func test_truncate_at_max_length() {
        // Given
        guard let url = Bundle(for: BeaconReporter.self).url(forResource: "BeaconReporter", withExtension: "swift"),
            let data = try? Data(contentsOf: url),
             let string = String(data: data, encoding: .utf8) else {
            XCTFail("BeaconReporter.swift does not exist")
            return
        }
        var beacon = Beacon.createDefault(key: "KEY123")
        beacon.bt = string + string

        // When
        let sut = beacon.cleaning(beacon.bt) ?? ""

        // Then
        XCTAssertTrue(sut.hasSuffix("…"))
    }
}
