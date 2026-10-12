import Foundation

class Subject {
    // Properties
    private var id: String
    private var name: String
    private var credits: Int
    private var semester: Int

    // Constructors
    init() {
        self.id = ""
        self.name = ""
        self.credits = 0
        self.semester = 0
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.credits = 0
        self.semester = 0
    }

    init(id: String, name: String, credits: Int, semester: Int) {
        self.id = id
        self.name = name
        self.credits = credits
        self.semester = semester
    }

    // Getters
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getCredits() -> Int { return credits }
    func getSemester() -> Int { return semester }

    // Setters
    func setId(_ newId: String) { self.id = newId }
    func setName(_ newName: String) { self.name = newName }
    func setCredits(_ newCredits: Int) { self.credits = newCredits }
    func setSemester(_ newSemester: Int) { self.semester = newSemester }

    // Display
    func displayInfo() {
        print("[\(id)] \(name) (Credits: \(credits), Semester: \(semester))")
    }

    func getShortInfo() -> String {
        return "[\(id)] \(name)"
    }
}
