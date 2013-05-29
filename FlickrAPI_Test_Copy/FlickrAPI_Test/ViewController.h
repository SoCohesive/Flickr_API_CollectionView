//
//  ViewController.h
//  FlickrAPI_Test
//
//  Created by Sonam Dhingra on 5/29/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"

@interface ViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)searchButton:(id)sender;

@property (strong,nonatomic) NSString *apikey;
@property (strong,nonatomic) NSString *searchText;

-(void)setUpFlickrURLRequest;
+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto size:(NSString *) size;

@property (weak, nonatomic) IBOutlet UIImageView *testImage1;

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
