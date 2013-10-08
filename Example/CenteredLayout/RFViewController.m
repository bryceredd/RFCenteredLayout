//
//  RFViewController.m
//  QuiltDemo
//
//  Created by Bryce Redd on 12/26/12.
//  Copyright (c) 2012 Bryce Redd. All rights reserved.
//

#import "RFViewController.h"
#import "RFCenteredLayout.h"
#import <QuartzCore/QuartzCore.h>

@interface RFViewController () {
    BOOL isAnimating;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet RFCenteredLayout *layout;
@property (nonatomic) NSMutableArray* numbers;
@property (nonatomic) BOOL isLarge;
@end

int num = 0;

@implementation RFViewController

- (void)viewDidLoad {
    
    self.numbers = [@[] mutableCopy];
    for(; num<10; num++) { [self.numbers addObject:@(num)]; }
    
    self.layout.minimumInteritemSpacing = 0.f;
    self.layout.minimumLineSpacing = 0.f;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.demandElasticity = YES;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (IBAction)remove:(id)sender {
    if(!self.numbers.count) return;
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % MAX(1, self.numbers.count);
        [self.numbers removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (IBAction)refresh:(id)sender {
    [self.collectionView reloadData];
}

- (IBAction)size:(id)sender {
    int index = arc4random() % MAX(1, self.numbers.count);
    
    [self.collectionView performBatchUpdates:^{
        self.isLarge = YES;
        [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                     toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } completion:nil];
    
    [self performSelector:@selector(shrink) withObject:nil afterDelay:2.f];
}

- (void) shrink {
    self.isLarge = NO;
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (IBAction)add:(id)sender {
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.collectionView performBatchUpdates:^{
        int index = arc4random() % MAX(self.numbers.count,1);
        [self.numbers insertObject:@(++num) atIndex:index];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
    
    UILabel* label = (id)[cell viewWithTag:5];
    if(!label) label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
    label.tag = 5;
    label.textColor = [UIColor blackColor];
    label.text = [self.numbers[indexPath.row] description];
    label.backgroundColor = [UIColor clearColor];
    [cell addSubview:label];
    
    return cell;
}


#pragma mark – UICollectionViewFlowDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isLarge && indexPath.row == 0)
        return CGSizeMake(255, 255);

    return CGSizeMake(100, 100);
}

@end
