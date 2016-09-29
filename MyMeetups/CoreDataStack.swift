import Foundation
import CoreData

class CoreDataStack {
    
    
    let managedObjectModelName: String
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: url,
                                                        options: nil)
        return coordinator
    }()
    
    public lazy var mainQueueContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI)"
        return moc
    }()
    
    public lazy var privateQueueContext: NSManagedObjectContext = {
        let poc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        poc.name = "Private Queue Context"
        poc.parent = self.mainQueueContext
        return poc
    }()
    
    public func saveChanges() throws {
        var saveError: Error?
        mainQueueContext.performAndWait {
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                } catch {
                    saveError = error
                }
            }
        }
        if let thrownError = saveError {
            throw thrownError
        }
    }
    
}
