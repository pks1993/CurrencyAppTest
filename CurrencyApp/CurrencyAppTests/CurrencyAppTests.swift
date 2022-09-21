//
//  CurrencyAppTests.swift
//  CurrencyAppTests
//
//  Created by Phyo Kyaw Swar on 20/09/2022.
//

import XCTest
@testable import CurrencyApp


class CurrencyAppTests: XCTestCase {
    var totalNumber = 20
    var firstNumber = 0
    var secondNumber = 1
    var sum = 0
    var fibonacciArray = [Int]()
    var primeArray = [Int]()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testGenerateFibonacci() {
        print("Fibonacci number")
        for _ in 0..<totalNumber{
            sum = firstNumber
            firstNumber = secondNumber
            secondNumber = sum + secondNumber
            fibonacciArray.append(sum)
        }
        print(fibonacciArray)
    }
    
    func testGeneratePrimeNumber() {
        for num in 2..<totalNumber {
            if primeArray.isEmpty {
                primeArray.append(num)
            }
            else {
                if (num % 2) != 0 {
                    primeArray.append(num)
                }
            }
        }
        print(primeArray)
    }
    
    func testSwapTwoArray() {
        // using Fibonacci array for First
        testGenerateFibonacci()
        // using Prime array for second
        testGeneratePrimeNumber()
        
        primeArray += fibonacciArray
        
        print("Fibonacci :::::" , fibonacciArray)
        print ("Prime ::::: " , primeArray)
        
        for firstNum in primeArray {
            for secondNum in 0..<fibonacciArray.count {
                if firstNum == secondNum || firstNum > secondNum {
                    if let idx = primeArray.firstIndex(of: secondNum) {
                        primeArray.remove(at: idx)
                    }
                }
                
            }
        }
       
        print("Final Result " , primeArray)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
