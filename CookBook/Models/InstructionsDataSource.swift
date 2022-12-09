//
//  StepsDataSource.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 07.12.2022.
//

import UIKit

final class InstructionsDataSource: NSObject {
    var instructions: [InstructionModel]
    
    init(instructions: [InstructionModel]) {
        self.instructions = instructions
    }
}

// MARK: - UITableViewDataSource
extension InstructionsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseID, for: indexPath) as! DetailCell
        let instruction = instructions[indexPath.row]
        cell.configure(recipeInstruction: instruction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
