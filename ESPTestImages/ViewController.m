//
//  ViewController.m
//  ESPTestImages
//
//  Created by Kate on 22.03.17.
//  Copyright © 2017 Kate. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ESPImageCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Constants.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSArray *imageUrls;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ESPImageCell" bundle:nil] forCellWithReuseIdentifier:@"ESPImageCell"];
    
    WEAK_SELF_INIT
    [self loadImagesURL:kImageUrl WithCompletion:^(NSArray *array, NSError *error) {
        STRONG_SELF_INIT
        if (strongSelf) {
            if (array) {
                strongSelf.imageUrls = array;
                [strongSelf.collectionView reloadData];
            }
            if (error) {
                NSLog(@"Error");
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCollectionViewCellIdentifier = @"ESPImageCell";
    ESPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[[NSURL alloc] initWithString:[self.imageUrls objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        CGSize size = CGSizeMake(self.collectionView.frame.size.width/kSizeIpad, self.collectionView.frame.size.width/kSizeIpad);
        return size;
    }
    else {
        CGSize size = CGSizeMake(self.collectionView.frame.size.width/kSizeIphone, self.collectionView.frame.size.width/kSizeIphone);
        return size;
    }
}

#pragma mark - loadind data

-(void) loadImagesURL: (NSString*) urlString WithCompletion:(void (^)(NSArray *array, NSError * error))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = (NSArray*)responseObject;
        
        if (completion) {
            completion(array,nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - orientation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
    }];
}
@end
