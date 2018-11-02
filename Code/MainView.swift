import AppKit
import UIToolz
import GetLaid
import SwiftyToolz

class MainView: LayerBackedView
{
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        
        layoutTable()
    }
    
    required init?(coder decoder: NSCoder) { fatalError() }
    
    private func layoutTable()
    {
        fileTable.constrainToParent()
    }
    
    private lazy var fileTable = addForAutoLayout(ScrollTable<FileTable>())
}

class FileTable: NSTableView, NSTableViewDataSource, NSTableViewDelegate
{
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        
        addColumn(fileColumnID, minWidth: 200)
        addColumn(linesColumnID)
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView?
    {
        guard let column = tableColumn else { return nil }
        
        switch column.identifier
        {
        case fileColumnID: return Label(text: "SuperMegaCode.swift")
        case linesColumnID: return Label(text: "666")
        default: return nil
        }
    }
    
    private let fileColumnID = UIItemID(rawValue: "File")
    private let linesColumnID = UIItemID(rawValue: "Lines of Code")
}

// MARK: - Framework Candidates

class ScrollTable<T: NSTableView>: NSScrollView
{
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)

        documentView = table
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    let table = T()
}

extension NSTableView
{
    func addColumn(_ id: UIItemID, minWidth: CGFloat = 100)
    {
        let column = NSTableColumn(identifier: id)
        column.resizingMask = .userResizingMask
        column.minWidth = minWidth
        column.title = id.rawValue
        
        addTableColumn(column)
    }
}

typealias UIItemID = NSUserInterfaceItemIdentifier