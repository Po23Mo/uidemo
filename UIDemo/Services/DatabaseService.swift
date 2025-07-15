import Foundation
import SQLite3

class DatabaseService {
    static let shared = DatabaseService()
    private var db: OpaquePointer?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("favorites.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        let createTableString = """
            CREATE TABLE IF NOT EXISTS favorites(
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                iconURL TEXT NOT NULL,
                addedDate TEXT NOT NULL
            );
        """
        
        if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
        }
    }
    
    func addFavorite(_ favorite: Favorite) -> Bool {
        let insertString = "INSERT INTO favorites (id, name, iconURL, addedDate) VALUES (?, ?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(favorite.id))
            sqlite3_bind_text(statement, 2, (favorite.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (favorite.iconURL as NSString).utf8String, -1, nil)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: favorite.addedDate)
            sqlite3_bind_text(statement, 4, (dateString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func getAllFavorites() -> [Favorite] {
        var favorites: [Favorite] = []
        let queryString = "SELECT * FROM favorites ORDER BY addedDate DESC"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let iconURL = String(cString: sqlite3_column_text(statement, 2))
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let addedDate = dateFormatter.date(from: dateString) ?? Date()
                
                let favorite = Favorite(id: id, name: name, iconURL: iconURL, addedDate: addedDate)
                favorites.append(favorite)
            }
        }
        
        sqlite3_finalize(statement)
        return favorites
    }
    
    func searchFavorites(query: String) -> [Favorite] {
        var favorites: [Favorite] = []
        let queryString = "SELECT * FROM favorites WHERE name LIKE ? ORDER BY addedDate DESC"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            let searchPattern = "%\(query)%"
            sqlite3_bind_text(statement, 1, (searchPattern as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(cString: sqlite3_column_text(statement, 1))
                let iconURL = String(cString: sqlite3_column_text(statement, 2))
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let addedDate = dateFormatter.date(from: dateString) ?? Date()
                
                let favorite = Favorite(id: id, name: name, iconURL: iconURL, addedDate: addedDate)
                favorites.append(favorite)
            }
        }
        
        sqlite3_finalize(statement)
        return favorites
    }
    
    func deleteFavorite(id: Int) -> Bool {
        let deleteString = "DELETE FROM favorites WHERE id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteString, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func clearAllFavorites() -> Bool {
        let deleteString = "DELETE FROM favorites"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteString, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            }
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    deinit {
        sqlite3_close(db)
    }
} 