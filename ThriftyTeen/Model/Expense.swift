//
//  Expense.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import Foundation

struct ExpensePayload: Codable {
    let title: String
    let category: Category
    let amount: Double
    let date: Date
}

struct Expense: Codable {
    let id, title: String
    let category: Category
    let amount: Double
    let date: Date
    
//    init(id: String, title: String, category: String, amount: Double, date: String) {
//        self.id = id
//        self.title = title
//        self.category = category
//        self.amount = amount
//        self.date = date
//    }
//    
//    init(id: String) {
//        self.id = id
//        self.title = ""
//        self.category = ""
//        self.amount = 0.0
//        self.date = ""
//    }
//    
//    static func getSampleExpenses() -> [Expense] {
//        return [
//            Expense(id: "e6092901-b36c-4a12-b437-035fa3c9abbd",
//                    title: "Amazon", category: "Shopping",
//                    amount: 59.99, date: "2023-01-02"),
//            Expense(id: "392680d0-c884-465d-a955-f445e53df465",
//                    title: "Apple Music", category: "Entertainment",
//                    amount: 9.99, date: "2023-01-07"),
//            
//            Expense(id: "b11ca22b-4ba2-4952-8959-248c1c47b8d6",
//                    title: "Movie", category: "Entertainment",
//                    amount: 37.98, date: "2023-02-13"),
//            
//            Expense(id: "46bff49a-0c44-4b35-9ccd-1a02f2eb8fa6",
//                    title: "Amazon", category: "Shopping",
//                    amount: 45.99, date: "2023-03-10"),
//            
//            Expense(id: "1b4ece7c-9f6d-469d-a369-6435c3201264",
//                    title: "Nike Shoes", category: "Shoes",
//                    amount: 120.67, date: "2023-04-03"),
//            Expense(id: "9fa1b4e3-fcd3-4550-9734-0d721db7dbce",
//                    title: "Home Depot", category: "Home",
//                    amount: 75.1, date: "2023-04-18"),
//            
//            Expense(id: "09002d8a-eba3-45f2-99aa-32287939348c",
//                    title: "Monthly Rent", category: "Housing",
//                    amount: 1000.0, date: "2023-05-01"),
//            Expense(id: "40d3bb95-cbda-4ca4-a8a0-73d2683864fb",
//                    title: "Cab Ride", category: "Transportation",
//                    amount: 20.0, date: "2023-05-15"),
//            Expense(id: "6a2ac0c4-933f-4335-9c3a-e35d2fd6b6c9",
//                    title: "Coffee Shop", category: "Food",
//                    amount: 4.5, date: "2023-05-11"),
//            Expense(id: "c98a70b2-0aa2-4552-a7b7-9377f699f0ed",
//                    title: "Uber Ride", category: "Transportation",
//                    amount: 20.76, date: "2023-05-24"),
//            Expense(id: "ab2d6e4b-ec86-4a18-86d4-588871117089",
//                    title: "Gas Fill Up", category: "Transportation",
//                    amount: 37.52, date: "2023-05-19"),
//            
//            Expense(id: "4bc7f86b-e020-4088-b4b8-6d69db4cbb7a",
//                    title: "Supermarket", category: "Food",
//                    amount: 70.0, date: "2023-06-17"),
//            Expense(id: "8a5ee947-0a6b-4cc9-b707-ba6ae88897d1",
//                    title: "Uber", category: "Transportation",
//                    amount: 19.35, date: "2023-06-30"),
//            Expense(id: "fb1e7e13-627f-4285-ad99-63ff497ac6cb",
//                    title: "Amazon", category: "Shopping",
//                    amount: 49.99, date: "2023-06-20"),
//            
//            Expense(id: "241ee38b-c092-4f92-ac93-ad1cc35c5ccf",
//                    title: "Gas", category: "Transportation",
//                    amount: 80.11, date: "2023-07-17"),
//            Expense(id: "0bf8ae26-cf00-4e5a-9dd6-3a7da654cf96",
//                    title: "Rent", category: "Housing",
//                    amount: 1500.0, date: "2023-07-01"),
//            
//            Expense(id: "446bc8ba-0c36-4e09-b2ed-619dc9ae9614",
//                    title: "Amazon", category: "Shopping",
//                    amount: 50.0, date: "2023-08-29"),
//            
//            Expense(id: "0561a30d-50e5-4922-92c7-a93ee63979de",
//                    title: "Netflix", category: "Entertainment",
//                    amount: 14.99, date: "2023-09-1"),
//            Expense(id: "072bd0e7-852c-47af-8875-8f4f563a5e2b",
//                    title: "Amazon", category: "Shopping",
//                    amount: 75.0, date: "2023-09-17"),
//            
//            Expense(id: "3267f15f-ffdb-4f9d-8a6d-a297b1464fbb",
//                    title: "Haircut", category: "Personal Care",
//                    amount: 30.0, date: "2023-10-08"),
//            Expense(id: "32b5dcf4-cf51-45c0-8a4e-5d793f7edbaa",
//                    title: "Grocery Store", category: "Food",
//                    amount: 150.0, date: "2023-10-10"),
//            
//            Expense(id: "171b398f-3832-4cfe-92b0-c18c2f2472e8",
//                    title: "Gym", category: "Health",
//                    amount: 40.0, date: "2023-11-18"),
//            Expense(id: "95ea8b75-c0aa-4eed-80dc-10608c9ca339",
//                    title: "Starbucks", category: "Food",
//                    amount: 5.4, date: "2023-11-07"),
//            Expense(id: "b01a5db3-1c34-411b-8648-bec71bdb0278",
//                    title: "Pharmacy", category: "Health",
//                    amount: 43.0, date: "2023-11-14"),
//            
//            Expense(id: "a9ec7542-42d5-4e51-948c-800b4d922b82",
//                    title: "Uber", category: "Transportation",
//                    amount: 45.0, date: "2023-12-25"),
//            Expense(id: "7267e13e-5107-401b-a47b-a859648611f0",
//                    title: "Snowboarding Lessons", category: "Entertainment",
//                    amount: 75.0, date: "2023-12-30"),
//            Expense(id: "fe2e1756-7e3a-4f7c-ba70-1e299e723f3e",
//                    title: "Ski Trip", category: "Travel",
//                    amount: 102.52, date: "2023-12-30")
//        ]
//    }
}
