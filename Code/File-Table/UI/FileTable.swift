import AppKit
import UIToolz
import GetLaid
import SwiftObserver
import SwiftyToolz

class FileTable: NSTableView, NSTableViewDataSource, NSTableViewDelegate, Observer
{
    // MARK: - Life Cycle
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        
        usesAlternatingRowBackgroundColors = true
        
        addColumn(linesColumnID)
        addColumn(fileColumnID, minWidth: 300)
        
        dataSource = self
        delegate = self
        
        observe(Store.shared)
        {
            [weak self] event in
            
            if event == Store.Event.didModifyData
            {
                self?.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit { stopAllObserving() }
    
    // MARK: - Content
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return Store.shared.analytics.count
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView?
    {
        guard let column = tableColumn else { return nil }
        
        let analytics = Store.shared.analytics[row]
        
        switch column.identifier
        {
        case fileColumnID:
            return Label(text: analytics.file.pathInCodeFolder)
            
        case linesColumnID:
            let loc = analytics.linesOfCode
            let label = Label(text: "\(loc)")
            
            label.font = NSFont.monospacedDigitSystemFont(ofSize: 12,
                                                          weight: .regular)
            label.alignment = .right
            label.textColor = warningColor(for: loc).labelColor
            
            return label
            
        default: return nil
        }
    }
    
    func tableView(_ tableView: NSTableView,
                   sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor])
    {
        for new in sortDescriptors
        {
            guard let key = new.key else
            {
                log(warning: "Sort descriptor has no key.")
                continue
            }
            
            let old = oldDescriptors.first { $0.key == key }
            
            if old == nil || old?.ascending != new.ascending
            {
                let store = Store.shared
                
                switch key
                {
                case linesColumnID.rawValue:
                    store.analytics.sortByLinesOfCode(ascending: new.ascending)
                case fileColumnID.rawValue:
                    store.analytics.sortByFilePath(ascending: new.ascending)
                default: break
                }
            }
        }
    }
    
    private let fileColumnID = UIItemID(rawValue: "File")
    private let linesColumnID = UIItemID(rawValue: "Lines of Code")
}

extension WarningColor
{
    var labelColor: NSColor
    {
        switch self
        {
        case .none: return NSColor.labelColor
        case .green: return NSColor.systemGreen
        case .yellow: return NSColor.systemYellow
        case .orange: return NSColor.systemOrange
        case .red:  return NSColor.systemRed
        }
    }
}