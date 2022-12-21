//
//  AcknowledgmentsTests.swift
//  
//
//  Created by Lukas Pistrol on 21.12.22.
//

@testable import Acknowledgements
import XCTest

final class AcknowledgmentsTests: XCTestCase {
    var model: Acknowledgements!

    override func setUp() {
        // use `.module` instead of `.main`
        model = Acknowledgements(bundle: .module, file: ("Test", "resolved"))
    }

    func test_listNoFilter() {
        model.loadPackages()
        XCTAssertEqual(model.items.count, 6)
        XCTAssertFalse(model.items.isEmpty)
    }

    func test_listFiltered() {
        model.loadPackages(excluding: ["LP"])
        XCTAssertEqual(model.items.count, 3)
        XCTAssertFalse(model.items.isEmpty)
    }
}
