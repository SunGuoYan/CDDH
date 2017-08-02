//
//  CSHProvinceSelectionViewController.m
//  ChargingStationHelper
//
//  Created by WangShaopeng on 7/20/16.
//  Copyright © 2016 com.iycharge. All rights reserved.
//

#import "CSHProvinceSelectionViewController.h"
#import "CSHProvinceNameCollectionViewCell.h"

@interface CSHProvinceSelectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completionButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (nonatomic, copy) NSArray<NSString *> *provinceNames;

@end

@implementation CSHProvinceSelectionViewController

static const CGFloat kLineSpacing = 12.0f;
static const CGFloat kItemSpacing = 4.0f;
static const NSInteger kLineCount = 4;
static const NSInteger kItemCountPerLine = 9;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.provinceNames = @[@"京", @"沪", @"浙", @"苏", @"粤", @"鲁", @"晋", @"冀", @"豫", @"川", @"渝", @"辽", @"吉", @"黑", @"皖", @"鄂", @"湘", @"赣", @"闽", @"陕", @"甘", @"宁", @"蒙", @"津", @"贵", @"云", @"桂", @"琼", @"青", @"新", @"藏"];
    
    CGFloat itemDimension = (kCSHScreenWidth - kItemSpacing * (kItemCountPerLine + 1)) / kItemCountPerLine;
    self.collectionViewHeightConstraint.constant = (itemDimension + kLineSpacing) * kLineCount + kLineSpacing;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = kLineSpacing;
    flowLayout.minimumInteritemSpacing = kItemSpacing;
    flowLayout.itemSize = CGSizeMake(itemDimension, itemDimension);
    
    self.collectionView.allowsSelection = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(kLineSpacing, kItemSpacing, 0, kItemSpacing);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.completionButtonHeightConstraint.constant = itemDimension;
    [self.completionButton csh_setDefaultCornerRadius];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - response to behavior

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.view.backgroundColor = [UIColor clearColor];
    [self.delegate provinceSelectionViewControllerDidStop];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)handleCompletionButton:(UIButton *)sender {
    NSArray<NSIndexPath *> *indexPathes = self.collectionView.indexPathsForSelectedItems;
    if (indexPathes.count == 0) {
        self.view.backgroundColor = [UIColor clearColor];
        [self.delegate provinceSelectionViewControllerDidStop];
    } else {
        self.view.backgroundColor = [UIColor clearColor];
        NSIndexPath *indexPath = indexPathes.firstObject;
        [self.delegate provinceSelectionViewControllerDidStopWithName:self.provinceNames[indexPath.row]];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.provinceNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSHProvinceNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CSHProvinceNameCollectionViewCell class]) forIndexPath:indexPath];
    cell.nameLabel.text = self.provinceNames[indexPath.row];
    return cell;
}

@end
