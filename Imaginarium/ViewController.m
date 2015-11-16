//
//  ViewController.m
//  Imaginarium
//
//  Created by Admin on 13.11.15.
//  Copyright © 2015 Wire IT College. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation ViewController

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData = [@[
    @"abstract",
//    @"animals",
//    @"business",
//    @"cats",
//    @"city",
//    @"food",
//    @"night",
//    @"life",
//    @"fashion",
//    @"people",
//    @"nature",
//    @"sports",
//    @"technics",
    @"transport"] mutableCopy];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const reuseIdentifierItem = @"cell for item";
    static NSString *const reuseIdentifierAddItem = @"cell for add item";
    
    UITableViewCell *cell;
    if (indexPath.row == self.tableData.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierAddItem];
        cell.textLabel.text = @"Add Item...";
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierItem];
        NSString *item = self.tableData[indexPath.row];
        cell.textLabel.text = item;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.tableData count]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Item" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            NSString *text = textField.text;
            if (text.length) {
                [self.tableView beginUpdates];
                
                
                NSIndexPath *insertedIndexPath = [NSIndexPath
                                                  indexPathForRow:self.tableData.count
                                                  inSection:0];
                [self.tableData addObject:text];
                [self.tableView insertRowsAtIndexPaths:@[insertedIndexPath] withRowAnimation:(UITableViewRowAnimationRight)];
                
                [self.tableView endUpdates];
            }
        }]];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Input catagory";
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return indexPath.row < self.tableData.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewRowAction *actionMore = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"More" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Need to implement More action");
    }];
    actionMore.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.tableView beginUpdates];
        
        [self.tableData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
    }];
    
    return @[actionMore, actionDelete];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *item = self.tableData[indexPath.row];
        ImageViewController *ivc = segue.destinationViewController;
        ivc.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lorempixel.com/900/900/%@/", item]];
    }
}

@end
