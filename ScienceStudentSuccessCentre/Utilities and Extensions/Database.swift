//
//  Database.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import SQLite
import UIKit

/// Singleton class that handles all interactions with the SQLite database.
class Database {
    
    public static let instance = Database()
    private static let name = "ssscdb.sqlite3"
    private static let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    private let t_terms = Table("terms")
    private let t_terms_id = Expression<String>("termId")
    private let t_terms_term = Expression<String>("term")
    private let t_terms_year = Expression<String>("year")
    
    private let t_courses = Table("courses")
    private let t_courses_id = Expression<String>("courseId")
    private let t_courses_name = Expression<String>("name")
    private let t_courses_code = Expression<String>("code")
    private let t_courses_credits = Expression<Double>("credits")
    private let t_courses_isMajorCourse = Expression<Bool>("isMajorCourse")
    private let t_courses_finalGrade = Expression<String>("finalGrade")
    private let t_courses_termId = Expression<String>("termId")
    private let t_courses_colour = Expression<String>("colour")
    
    private let t_assignments = Table("assignments")
    private let t_assignments_id = Expression<String>("assignmentId")
    private let t_assignments_name = Expression<String>("name")
    private let t_assignments_gradeEarned = Expression<Double>("gradeEarned")
    private let t_assignments_gradeTotal = Expression<Double>("gradeTotal")
    private let t_assignments_weightId = Expression<String>("weightId")
    private let t_assignments_courseId = Expression<String>("courseId")
    
    private let t_weights = Table("weights")
    private let t_weights_id = Expression<String>("weightId")
    private let t_weights_name = Expression<String>("name")
    private let t_weights_value = Expression<Double>("value")
    private let t_weights_courseId = Expression<String>("courseId")
    
    private var db: Connection?
    
    /// Initializes the Database singleton and prepares the database for use.
    ///
    /// This constructor starts by attempting to connect to the database at the given path. If successful, `foreign_key` functionality is turned on. Following this, pre-table-creation scripts run, the tables are created (if they don't already exist), and post-table-creation scripts are run.
    private init() {
        db = try? Connection("\(Database.path)/\(Database.name)")
        if db != nil {
            print("Connected to database \(Database.name)")
            
            do {
                try db?.execute("PRAGMA foreign_keys = ON;")
            } catch let error {
                print("PRAGMA foreign_keys failed: \(error)")
            }
            
            preCreationScripts()
            
            createTermsTable()
            createCoursesTable()
            createWeightsTable()
            createAssignmentsTable()
            
            postCreationScripts()
        }
    }
    
    /// Creates a table to store `Term` objects, if one doesn't already exist.
    private func createTermsTable() {
        do {
            try db?.run(t_terms.create(ifNotExists: true) { t in
                t.column(t_terms_id, primaryKey: true)
                t.column(t_terms_term)
                t.column(t_terms_year)
            })
        } catch {
            print("Could not create terms table: \(error)")
        }
    }
    
    /// Creates a table to store `Course` objects, if one doesn't already exist.
    private func createCoursesTable() {
        do {
            try db?.run(t_courses.create(ifNotExists: true) { t in
                t.column(t_courses_id, primaryKey: true)
                t.column(t_courses_name)
                t.column(t_courses_code)
                t.column(t_courses_credits)
                t.column(t_courses_isMajorCourse)
                t.column(t_courses_finalGrade)
                t.column(t_courses_termId)
                t.column(t_courses_colour)
                t.foreignKey(t_courses_termId, references: t_terms, t_terms_id, delete: .cascade)
            })
        } catch {
            print("Could not create courses table: \(error)")
        }
    }
    
    /// Creates a table to store `Weight` objects, if one doesn't already exist.
    private func createWeightsTable() {
        do {
            try db?.run(t_weights.create(ifNotExists: true) { t in
                t.column(t_weights_id, primaryKey: true)
                t.column(t_weights_name)
                t.column(t_weights_value)
                t.column(t_weights_courseId)
                t.foreignKey(t_weights_courseId, references: t_courses, t_courses_id, delete: .cascade)
            })
        } catch {
            print("Could not create weights table: \(error)")
        }
    }
    
    /// Creates a table to store `Assignment` objects, if one doesn't already exist.
    private func createAssignmentsTable() {
        do {
            try db?.run(t_assignments.create(ifNotExists: true) { t in
                t.column(t_assignments_id, primaryKey: true)
                t.column(t_assignments_name)
                t.column(t_assignments_gradeEarned)
                t.column(t_assignments_gradeTotal)
                t.column(t_assignments_weightId)
                t.column(t_assignments_courseId)
                t.foreignKey(t_assignments_weightId, references: t_weights, t_weights_id, delete: .cascade)
                t.foreignKey(t_assignments_courseId, references: t_courses, t_courses_id, delete: .cascade)
            })
        } catch {
            print("Could not create assignments table: \(error)")
        }
    }
    
    /// Inserts a term into the database.
    ///
    /// - Parameter term: The term to insert
    /// - Returns: A Boolean indicating if insertion was successful
    public func insert(term: Term) -> Bool {
        print("Adding term \(term.term) \(term.year) into \(t_terms)")
        do {
            let rowid = try db?.run(t_terms.insert(or: .replace,
                                                   t_terms_id <- term.id,
                                                   t_terms_term <- term.term,
                                                   t_terms_year <- term.year))
            print("Inserted rowid \(rowid!)")
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    /// Inserts or updates a course in the database.
    ///
    /// This function will attempt to insert a new course into the table, unless a course with matching ID is found in the table, in which case it will attempt to update the existing course.
    /// - Parameter course: The course to insert or update
    /// - Returns: A Boolean indicating if insertion/updating was successful
    public func insertOrUpdate(course: Course) -> Bool {
        do {
            if getCourseById(id: course.id) == nil {
                print("Inserting course \(course.name) (\(course.code)) with id \(course.id) into \(t_courses)")
                try db?.run(t_courses.insert(or: .replace,
                                             t_courses_id <- course.id,
                                             t_courses_name <- course.name,
                                             t_courses_code <- course.code,
                                             t_courses_credits <- course.credits,
                                             t_courses_isMajorCourse <- course.isMajorCourse,
                                             t_courses_finalGrade <- course.finalGrade,
                                             t_courses_termId <- course.termId,
                                             t_courses_colour <- String(describing: course.colour)))
            } else {
                print("Updating course \(course.name) (\(course.code)) with id \(course.id) in \(t_courses)")
                let courseWithId = t_courses.filter(t_courses_id == course.id)
                try db?.run(courseWithId.update(t_courses_name <- course.name,
                                                t_courses_code <- course.code,
                                                t_courses_credits <- course.credits,
                                                t_courses_isMajorCourse <- course.isMajorCourse,
                                                t_courses_finalGrade <- course.finalGrade,
                                                t_courses_termId <- course.termId,
                                                t_courses_colour <- String(describing: course.colour)))
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    /// Inserts or updates a weight in the database.
    ///
    /// This function will attempt to insert a new weight into the table, unless a weight with matching ID is found in the table, in which case it will attempt to update the existing weight.
    /// - Parameter weight: The weight to insert or update
    /// - Returns: A Boolean indicating if insertion/updating was successful
    public func insertOrUpdate(weight: Weight) -> Bool {
        do {
            if getWeightById(id: weight.id) == nil {
                print("Inserting weight \(weight.name) (\(weight.value)) with id \(weight.id) into \(t_weights)")
                try db?.run(t_weights.insert(or: .replace,
                                             t_weights_id <- weight.id,
                                             t_weights_name <- weight.name,
                                             t_weights_value <- weight.value,
                                             t_weights_courseId <- weight.courseId))
            } else {
                print("Updating weight \(weight.name) (\(weight.value)) with id \(weight.id) in \(t_weights)")
                let weightWithId = t_weights.filter(t_weights_id == weight.id)
                try db?.run(weightWithId.update(t_weights_name <- weight.name,
                                                t_weights_value <- weight.value,
                                                t_weights_courseId <- weight.courseId))
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    /// Inserts or updates an assignment in the database.
    ///
    /// This function will attempt to insert a new assignment into the table, unless an assignment with matching ID is found in the table, in which case it will attempt to update the existing assignment.
    /// - Parameter assignment: The assignment to insert or update
    /// - Returns: A Boolean indicating if insertion/updating was successful
    public func insertOrUpdate(assignment: Assignment) -> Bool {
        do {
            if getAssignmentById(id: assignment.id) == nil {
                print("Inserting assignment \(assignment.name) (\(assignment.gradeEarned), \(assignment.gradeTotal)) with id \(assignment.id) into \(t_assignments)")
                try db?.run(t_assignments.insert(or: .replace,
                                                 t_assignments_id <- assignment.id,
                                                 t_assignments_name <- assignment.name,
                                                 t_assignments_gradeEarned <- assignment.gradeEarned,
                                                 t_assignments_gradeTotal <- assignment.gradeTotal,
                                                 t_assignments_weightId <- assignment.weight.id,
                                                 t_assignments_courseId <- assignment.courseId))
            } else {
                print("Updating assignment \(assignment.name) (\(assignment.gradeEarned), \(assignment.gradeTotal)) with id \(assignment.id) in \(t_assignments)")
                let assignmentWithId = t_assignments.filter(t_assignments_id == assignment.id)
                try db?.run(assignmentWithId.update(t_assignments_name <- assignment.name,
                                                    t_assignments_gradeEarned <- assignment.gradeEarned,
                                                    t_assignments_gradeTotal <- assignment.gradeTotal,
                                                    t_assignments_weightId <- assignment.weight.id,
                                                    t_assignments_courseId <- assignment.courseId))
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    /// Attempts to delete an existing term from the database.
    ///
    /// - Parameter termId: The ID of the term to delete
    /// - Returns: A Boolean indicating if deletion was successful
    public func delete(termId: String) -> Bool {
        print("Deleting term \(termId)...")
        let term = t_terms.filter(t_terms_id == termId)
        do {
            try db?.run(term.delete())
            print("Deleted term \(termId)")
        } catch let error {
            print("Delete failed: \(error)")
            return false
        }
        return true
    }
    
    /// Attempts to delete an existing course from the database.
    ///
    /// - Parameter courseId: The ID of the course to delete
    /// - Returns: A Boolean indicating if deletion was successful
    public func delete(courseId: String) -> Bool {
        print("Deleting course \(courseId)...")
        let course = t_courses.filter(t_courses_id == courseId)
        do {
            try db?.run(course.delete())
            print("Deleted course \(courseId)")
        } catch let error {
            print("Delete failed: \(error)")
            return false
        }
        return true
    }
    
    /// Attempts to delete an existing weight from the database.
    ///
    /// - Parameter weightId: The ID of the weight to delete
    /// - Returns: A Boolean indicating if deletion was successful
    public func delete(weightId: String) -> Bool {
        print("Deleting weight \(weightId)...")
        let weight = t_weights.filter(t_weights_id == weightId)
        do {
            try db?.run(weight.delete())
            print("Deleted weight \(weightId)")
        } catch let error {
            print("Delete failed: \(error)")
            return false
        }
        return true
    }
    
    /// Attempts to delete an existing assignment from the database.
    ///
    /// - Parameter assignmentId: The ID of the assignment to delete
    /// - Returns: A Boolean indicating if deletion was successful
    public func delete(assignmentId: String) -> Bool {
        print("Deleting assignment \(assignmentId)...")
        let assignment = t_assignments.filter(t_assignments_id == assignmentId)
        do {
            try db?.run(assignment.delete())
            print("Deleted assignment \(assignmentId)")
        } catch let error {
            print("Delete failed: \(error)")
            return false
        }
        return true
    }
    
    /// Retrieves all of the terms stored in the database.
    ///
    /// - Returns: List of terms
    public func getTerms() -> [Term] {
        print("Getting terms...")
        var terms = [Term]()
        do {
            for row in try (db?.prepare(t_terms))! {
                let termId = try row.get(t_terms_id)
                let term = try row.get(t_terms_term)
                let year = try row.get(t_terms_year)
                terms.append(Term(id: termId, term: term, year: year))
            }
        } catch let error {
            print("Terms select failed: \(error)")
        }
        print("Found \(terms.count) terms")
        return terms
    }
    
    /// Retrieves all of the courses stored in the database.
    ///
    /// - Returns: List of courses
    public func getCourses() -> [Course] {
        print("Getting courses...")
        var courses = [Course]()
        do {
            for row in try (db?.prepare(t_courses))! {
                let courseId = try row.get(t_courses_id)
                let name = try row.get(t_courses_name)
                let code = try row.get(t_courses_code)
                let credits = try row.get(t_courses_credits)
                let isMajorCourse = try row.get(t_courses_isMajorCourse)
                let finalGrade = try row.get(t_courses_finalGrade)
                let termId = try row.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row.get(t_courses_colour))
                courses.append(Course(id: courseId, name: name, code: code, credits: credits, isMajorCourse: isMajorCourse, finalGrade: finalGrade, termId: termId, colour: colour))
            }
        } catch let error {
            print("Courses select failed: \(error)")
        }
        print("Found \(courses.count) courses")
        return courses
    }
    
    /// Retrieves a course from the database by its ID.
    ///
    /// - Parameter id: The ID of the course to retrieve
    /// - Returns: The course
    public func getCourseById(id: String) -> Course? {
        print("Getting course with id \(id)...")
        var course: Course? = nil
        do {
            let row = try db?.pluck(t_courses.filter(t_courses_id == id))
            if (row != nil) {
                let courseId = try row!.get(t_courses_id)
                let name = try row!.get(t_courses_name)
                let code = try row!.get(t_courses_code)
                let credits = try row!.get(t_courses_credits)
                let isMajorCourse = try row!.get(t_courses_isMajorCourse)
                let finalGrade = try row!.get(t_courses_finalGrade)
                let termId = try row!.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row!.get(t_courses_colour))
                course = Course(id: courseId, name: name, code: code, credits: credits, isMajorCourse: isMajorCourse, finalGrade: finalGrade, termId: termId, colour: colour)
            }
        } catch let error {
            print("Course select failed: \(error)")
        }
        return course
    }
    
    /// Retrieves all courses from the database with a given termId.
    ///
    /// - Parameter id: The ID of the term with which the courses are associated
    /// - Returns: List of courses
    public func getCoursesByTermId(id: String) -> [Course] {
        print("Getting courses by termId \(id)...")
        var courses = [Course]()
        do {
            for row in try (db?.prepare(t_courses.filter(t_courses_termId == id)))! {
                let courseId = try row.get(t_courses_id)
                let name = try row.get(t_courses_name)
                let code = try row.get(t_courses_code)
                let credits = try row.get(t_courses_credits)
                let isMajorCourse = try row.get(t_courses_isMajorCourse)
                let finalGrade = try row.get(t_courses_finalGrade)
                let termId = try row.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row.get(t_courses_colour))
                courses.append(Course(id: courseId, name: name, code: code, credits: credits, isMajorCourse: isMajorCourse, finalGrade: finalGrade, termId: termId, colour: colour))
            }
        } catch let error {
            print("Courses select failed: \(error)")
        }
        print("Found \(courses.count) courses")
        return courses
    }
    
    /// Retrieves a weight from the database by its ID.
    ///
    /// - Parameter id: The ID of the weight to retrieve
    /// - Returns: The weight
    public func getWeightById(id: String) -> Weight? {
        print("Getting weight with id \(id)...")
        var weight: Weight? = nil
        do {
            let row = try db?.pluck(t_weights.filter(t_weights_id == id))
            if (row != nil) {
                let weightId = try row!.get(t_weights_id)
                let name = try row!.get(t_weights_name)
                let value = try row!.get(t_weights_value)
                let courseId = try row!.get(t_weights_courseId)
                weight = Weight(id: weightId, name: name, value: value, courseId: courseId)
            }
        } catch let error {
            print("Weight select failed: \(error)")
        }
        return weight
    }
    
    /// Retrieves all weights from the database with a given courseId.
    ///
    /// - Parameter id: The ID of the course with which the weights are associated
    /// - Returns: List of weights
    public func getWeightsByCourseId(id: String) -> [Weight] {
        print("Getting weights by courseId \(id)...")
        var weights = [Weight]()
        do {
            for row in try (db?.prepare(t_weights.filter(t_weights_courseId == id)))! {
                let weightId = try row.get(t_weights_id)
                let name = try row.get(t_weights_name)
                let value = try row.get(t_weights_value)
                let courseId = try row.get(t_weights_courseId)
                weights.append(Weight(id: weightId, name: name, value: value, courseId: courseId))
            }
        } catch let error {
            print("Weights select failed: \(error)")
        }
        print("Found \(weights.count) weights")
        return weights
    }
    
    /// Retrieves an assignment from the databse by its ID.
    ///
    /// - Parameter id: The ID of the assignment to retrieve
    /// - Returns: The assignment
    public func getAssignmentById(id: String) -> Assignment? {
        print("Getting assignment with id \(id)...")
        var assignment: Assignment? = nil
        do {
            let row = try db?.pluck(t_assignments.filter(t_assignments_id == id))
            if (row != nil) {
                let assignmentId = try row!.get(t_assignments_id)
                let name = try row!.get(t_assignments_name)
                let gradeEarned = try row!.get(t_assignments_gradeEarned)
                let gradeTotal = try row!.get(t_assignments_gradeTotal)
                let weightId = try row!.get(t_assignments_weightId)
                let weight = getWeightById(id: weightId)
                let courseId = try row!.get(t_assignments_courseId)
                assignment = Assignment(id: assignmentId, name: name, gradeEarned: gradeEarned, gradeTotal: gradeTotal, weight: weight!, courseId: courseId)
            }
        } catch let error {
            print("Assignment select failed: \(error)")
        }
        return assignment
    }
    
    /// Retrieves all assignments from the database with a given courseId.
    ///
    /// - Parameter id: The ID of the course with which the assignments are associated
    /// - Returns: List of assignments
    public func getAssignmentsByCourseId(id: String) -> [Assignment] {
        print("Getting assignments by courseId \(id)...")
        var assignments = [Assignment]()
        do {
            for row in try (db?.prepare(t_assignments.filter(t_assignments_courseId == id)))! {
                let assignmentId = try row.get(t_assignments_id)
                let name = try row.get(t_assignments_name)
                let gradeEarned = try row.get(t_assignments_gradeEarned)
                let gradeTotal = try row.get(t_assignments_gradeTotal)
                let weightId = try row.get(t_assignments_weightId)
                let weight = getWeightById(id: weightId)
                let courseId = try row.get(t_assignments_courseId)
                assignments.append(Assignment(id: assignmentId, name: name, gradeEarned: gradeEarned, gradeTotal: gradeTotal, weight: weight!, courseId: courseId))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(assignments.count) assignments")
        return assignments
    }
    
    /// Runs any custom scripts that should be run BEFORE creating tables.
    ///
    /// - Attention: This function should only be used for development/testing/debugging purposes.
    private func preCreationScripts() {
        print("No pre-creation scripts to run")
    }
    
    /// Runs any custom scripts that should be run AFTER creating tables.
    ///
    /// - Attention: This function should only be used for development/testing/debugging purposes.
    private func postCreationScripts() {
        print("No post-creation scripts to run")
    }
    
}
