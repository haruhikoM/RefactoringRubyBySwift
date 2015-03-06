import UIKit

class Movie {
    enum Type {
        Regular = 0
        NewRelase
        Childrens
    }
    
    let title: String
    var priceCode: Int
    
    init(title: String, priceCode: Int) {
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
    var rentals: Array<Movie>
    
    init(name: String) {
        self.name = name
        rentals = []
    }
    
    func addRental(arg: Movie) {
        rentals.append(arg)
    }
    
    func statement() {
        var (totalAmount, frequentRenterPoints) = (0, 0)
        let result = "Rental record for \(name).\n"
        
    }
}