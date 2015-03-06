import UIKit

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
            //: ### Swift does not have an implicit conversion. That's why I need to assign Double value to thisAmount variable.
            var thisAmount = 0.0
            // Calculating each line.
            switch element.movie.priceCode {
            case .Regular:
                thisAmount += 2.0
                if element.daysRented > 2 {
                    thisAmount = thisAmount + (Double(element.daysRented - 2) * 1.5)
                }
            case .NewRelase:
                thisAmount += Double(element.daysRented) * 3.0
            case .Children:
                thisAmount += 1.5
                if element.daysRented > 3 {
                    thisAmount = thisAmount + Double(element.daysRented) * 1.5
                }
            default:
                println("😐")
            }
            
            // Add rental points
            frequentRenterPoints += 1
            // Add bonus points to two days New Release rental.
            if element.movie.priceCode == .NewRelase && element.daysRented > 1 {
                frequentRenterPoints += 1
            }
            // Show the price of the rental
            // result += "\t" + element.movie.title + "\t" + String(thisAmount) + "\n" <= "too complex" error
            result = "\(result)\t\(element.movie.title)\t\(thisAmount)\n"
            totalAmount += thisAmount
        }
        // Add footer line
        result = "\(result)Amount owed is \(totalAmount)\n"
        result = "\(result)You earned \(frequentRenterPoints) frequent renter points"
        return result
    }
}

let verdict   = Movie(title: "The Verdict", priceCode: .Regular)
let watchmen2 = Movie(title: "Watchmen 2", priceCode: .NewRelase)

var customer = Customer(name: "Haru")

let rent1 = Rental(movie: verdict, daysRented: 2)
let rent2 = Rental(movie: watchmen2, daysRented: 3)

customer.addRental(rent1)
customer.addRental(rent2)

customer.statement()

