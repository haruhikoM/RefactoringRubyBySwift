import UIKit
// import XCTest


//: ## 最初のサンプル
//: ### 1.1 最初の状態

enum MovieType: Int {
    case Regular = 0, NewRelase, Children
}

class Movie {
    let title: String
    var priceCode: MovieType
    
    init(title: String, priceCode: MovieType) {
        self.title = title
        self.priceCode = priceCode
    }
}

class Rental {
    var movie: Movie
    var daysRented: Int
    
    init(movie: Movie, daysRented: Int) {
        self.movie = movie
        self.daysRented = daysRented
    }
    
    func charge() -> Double {
        var result = 0.0
        switch movie.priceCode {
        case .Regular:
//: Swift does not have an implicit conversion. That's why I need to assign Double value to thisAmount variable.
            result += 2.0
            if daysRented > 2 {
                result = result + (Double(daysRented - 2) * 1.5)
            }
        case .NewRelase:
            result += Double(daysRented) * 3.0
        case .Children:
            result += 1.5
            if daysRented > 3 {
                result = result + Double(daysRented) * 1.5
            }
        default:
            println("😐")
        }
        return result
    }
    
    func frequentRenterPoints() -> Int {
        return (movie.priceCode == .NewRelase && daysRented > 1) ? 2 : 1
    }
}

class Customer {
    let name: String
    var rentals: Array<Rental>
    
    init(name: String) {
        self.name = name
        rentals = []
    }
    
    func addRental(arg: Rental) {
        rentals.append(arg)
    }
    
    func statement() -> String {
        var (totalAmount, frequentRenterPoints) = (0.0, 0)
        var result = "Rental record for \(name).\n"
        
        for element in rentals {
            // Add rental points // Add bonus points to two days New Release rental.
            frequentRenterPoints += element.frequentRenterPoints()

            // Show the price of the rental
            // result += "\t" + element.movie.title + "\t" + String(thisAmount) + "\n" <= "too complex" error
            result = "\(result)\t\(element.movie.title)\t\(element.charge())\n"
            totalAmount += element.charge()
        }
        // Add footer line
        result = "\(result)Amount owed is \(totalAmount)\n"
        result = "\(result)You earned \(frequentRenterPoints) frequent renter points"
        return result
    }
}

/* 
    Writing testcases as the book suggested... 
    but cloud not run those in the Playground (at the moment, at least).
*/
let verdict   = Movie(title: "The Verdict", priceCode: .Regular)
let watchmen2 = Movie(title: "Watchmen 2" , priceCode: .NewRelase)
let totoro    = Movie(title: "Totoro"     , priceCode: .Children)

var customer = Customer(name: "Haru")

let rent1 = Rental(movie: verdict,   daysRented: 2)
let rent2 = Rental(movie: watchmen2, daysRented: 3)
let rent3 = Rental(movie: totoro,    daysRented: 5)

customer.addRental(rent1)
customer.addRental(rent2)

customer.statement()

func assertTrue(condition: Bool, message: String = "Message Empty.") {
    if condition != true {
        println("😢 Test failed: \(message)")
    } else {
        println("😄 Test passes")
    }
}

func assertMatch(expectedString str1: String, actualString str2: String, message: String = "Message Empty.") {
    if str2.lowercaseString.rangeOfString(str1) != nil {
        println("😙 Test passes!!")
    } else {
        println("😢 Test failed: \(message)")
    }
}

let test: String = "This is a test phrase."
test._bridgeToObjectiveC().containsString("test")

assertTrue(2 == count(customer.rentals), message: "count customer rentals")
assertTrue(2.0 == rent1.charge(), message: "test amountFor: to charge() Regular")
assertTrue(9.0 == rent2.charge(), message: "test amountFor: to charge() New Release")
assertMatch(expectedString: "amount owed is 11.0", actualString: customer.statement())


//: ### 1.2 リファクタリングの第一歩　- テストケースの重要性
//MARK: -
//: ### statementメソッドの分解、再配置 - Extract Method

//: ### 1.4 金額計算ルーチンの移動 - Move Method
// Replace Temp with Query ->
// "We need to focus on clarity over performance in regard to refacoring the code"

//: ### 1.5 レンタルポイント計算メソッドの抽出


//class CustomerTestCase: XCTestCase {
//    let verdict   = Movie(title: "The Verdict", priceCode: .Regular)
//    let watchmen2 = Movie(title: "Watchmen 2", priceCode: .NewRelase)
//    let catten = Movie(title: "Catten", priceCode: .Children)
//
//    var customer = Customer(name: "Haru")
//
//    func testRegularStatement() {
//        let rent1 = Rental(movie: verdict, daysRented: 2)
//        customer.addRental(rent1)
//        XCTAssertEqual(1, count(customer.rentals), "Rent only one movie.")
//        XCTAssertEqual(2.0, customer.amountFor(rent1))
//
////: #### want to write somethig like this
////: `assert_match /Amount owed is 2.0/, customer.statement()`
//
//    }
//
//    func testNewReleaseStatement() {
//        let rent2 = Rental(movie: watchmen2, daysRented: 3)
//        customer.addRental(rent2)
//    }
//
//    func testChildrenStatement() {
//        let rent3 = Rental(movie: catten, daysRented: 4)
//        customer.addRental(rent3)
//    }
//}