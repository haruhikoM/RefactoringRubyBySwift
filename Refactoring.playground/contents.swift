import UIKit
// import XCTest


//: ## 最初のサンプル
//: ### 1.1 最初の状態

enum MovieType: Int {
    case Regular = 0, NewRelase, Children
}


protocol Chargeable { mutating func charge(daysRented: Int) -> Double }

class RegularPrice: Chargeable {
    func charge(daysRented: Int) -> Double {
        var result = 2.0
        if daysRented > 2 {
            result += Double(daysRented - 2) * 1.5
        }
        return result
    }
}
class NewReleasePrice: Chargeable {
    func charge(daysRented: Int) -> Double {
        return Double(daysRented * 3)
    }
}
class ChildrenPrice: Chargeable {
    func charge(daysRented: Int) -> Double {
        var result = 1.5
        if daysRented > 3 {
            result += Double(daysRented - 3) * 1.5
        }
        return result
    }
}

class Movie {
    let title: String
    var price: Chargeable?
    var priceCode: MovieType {
        // [P63] Custom Setter Method.
        didSet {
            switch priceCode {
            case .Regular:
                price = RegularPrice()
            case .NewRelase:
                price = NewReleasePrice()
            case .Children:
                price = ChildrenPrice()
            default:
                println("This suppesed not to be called 😨 1")
            }
        }
    }
    
    init(title: String, priceCode thePriceCode: MovieType) {
        self.title = title
        self.price = nil
        self.priceCode = thePriceCode
    }

    func charge(daysRented: Int) -> Double {
        var result = 0.0
        switch priceCode {
        case .Regular:
//: Swift does not have an implicit conversion. That's why I need to assign Double value to thisAmount variable.
            // If swift had interfaces, it easy to add Chargable... oh wait, Protocol? Is that you???
//            if self.price != nil {
//                return (price as! RegularPrice).charge(daysRented)
//            } else {
//                println("This suppesed not to be called 😨 2")
//            }
//            return (price as! RegularPrice).charge(daysRented)
            return Double(daysRented)
        case .NewRelase:
            return Double(daysRented) * 3.0
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
    
    func frequentRenterPoints(daysRented: Int) -> Int {
        return (priceCode == .NewRelase && daysRented > 1) ? 2 : 1
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
        return movie.charge(daysRented)
    }
    
    func frequentRenterPoints() -> Int {
        return movie.frequentRenterPoints(daysRented)
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
        var result = "Rental record for \(name).\n"
        
        for element in rentals {
            // Show the price of the rental
            result = "\(result)\t\(element.movie.title)\t\(element.charge())\n"
        }
        // Add footer line
        result = "\(result)Amount owed is \(totalCharge())\n"
        result = "\(result)You earned \(totalFrequentRenterPoints()) frequent renter points"
        return result
    }
    
    func totalCharge() -> Double {
        var result = 0.0
        for element in rentals {
            result += element.charge()
        }
        return result
    }
    
    func totalFrequentRenterPoints() -> Int {
        var frequentRenterPoints = 0
        // Add rental points // Add bonus points to two days New Release rental.
        for element in rentals {
            frequentRenterPoints += element.frequentRenterPoints()
        }
        return frequentRenterPoints
    }
    
    func htmlStatement() -> String {
        var result = "<h1>Rentals for <em>\(name)</em></h1><p>\n"
        for element in rentals {
            result += "\t\(element.movie.title): \(element.charge())<br>\n"
        }
        result += "<p>You owe <em>\(totalCharge())</em><p>\n"
        result += "On this rental you earned " + "<em>\(totalFrequentRenterPoints())</em> " + "frequent renter points<p>"
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
customer.htmlStatement()

func assertTrue(condition: Bool, message: String = "Message Empty.") {
    if condition != true {
        println("😢 \(message) failed")
    } else {
        println("😄 \(message) passes")
    }
}

func assertMatch(expectedString str1: String, actualString str2: String, message: String = "Message Empty.") {
    if str2.lowercaseString.rangeOfString(str1) != nil {
        println("😙 Test \(message) passes!!")
    } else {
        println("😢 Test failed: \(message) expected->\(str1) actual->\(str2)")
    }
}

let test: String = "This is a test phrase."
test._bridgeToObjectiveC().containsString("test")

var counter = 1
assertTrue(2 == count(customer.rentals), message: "Customer Test No.\(counter++)");println("Test No.\(counter - 1)")
assertTrue(2.0 == rent1.charge(), message: "Rental Test No.\(counter++)");println("Test No.\(counter - 1)")
assertTrue(9.0 == rent2.charge(), message: "Rental Test No.\(counter++)");println("Test No.\(counter - 1)")
assertMatch(expectedString: "amount owed is 11.0", actualString: customer.statement(), message: "No.\(counter++)");println("Test No.\(counter - 1)")


//: ### 1.2 リファクタリングの第一歩　- テストケースの重要性

//MARK: -
//: ### statementメソッドの分解、再配置 - Extract Method

//: ### 1.4 金額計算ルーチンの移動 - Move Method
//:     Replace Temp with Query ->
//:     "We need to focus on clarity over performance in regard to refacoring the code"

//: ### 1.5 レンタルポイント計算メソッドの抽出
//: ### 1.6 一時変数の削除
//:    Replace Loop with Collection Closure -> @rentals.injet(0) {...} # but I don't know how to make this into Swift.
//: ### 1.7 料金コードによる条件分岐からポリモーフィズムへ
//: ### 1.8 継承の導入？
//:    Replace type code with state/strategy
//:     -> Apply "Self Encapsulate Field" to Type code (in this case <priceCode>)


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
