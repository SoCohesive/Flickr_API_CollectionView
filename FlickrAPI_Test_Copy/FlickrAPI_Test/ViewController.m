//
//  ViewController.m
//  FlickrAPI_Test
//
//  Created by Sonam Dhingra on 5/29/13.
//  Copyright (c) 2013 Sonam Dhingra. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () //<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    NSArray *photoResults;
    NSDictionary *searchResultsDict;
}

@end

@implementation ViewController

@synthesize searchField;
@synthesize apikey;
@synthesize searchText;
@synthesize testImage1; 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpFlickrURLRequest {
    
    apikey =[NSString stringWithFormat:@"701414e535a4766da29c4cc56335c98a"];
    searchText = searchField.text;
    searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *fullURL =[ NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&has_geo=1&format=json&nojsoncallback=1",apikey,searchText];
    
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSURLRequest *urlRequest= [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               
    
                               searchResultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:nil];
            
                               
                               // go over this 
                               NSString *status = searchResultsDict[@"stat"];
                               if ([status isEqualToString:@"fail"]) {
                                   NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                                   
                                   NSLog(@"the error in request is %@",error);
                                  
                               } else {
                                   
                            
                                   photoResults = searchResultsDict[@"photos"][@"photo"];
                                   //make an empty mutable array that will be a mutable copy to something else ( its empty now)
                                   
                                   NSMutableArray *flickrPhotos = [@[] mutableCopy];
                                   
                                   // fast enumeration--> pull required properties for FlickrPhotos out of array of dictionaries. 
                                   for(NSMutableDictionary *objPhoto in photoResults)
                                   {
                                       FlickrPhoto *photo = [[FlickrPhoto alloc] init];
                                       photo.farm = [objPhoto[@"farm"] intValue];
                                       photo.server = [objPhoto[@"server"] intValue];
                                       photo.secret = objPhoto[@"secret"];
                                       
                                       //confirm reasoning for longlong value 
                                       photo.photoID = [objPhoto[@"id"] longLongValue];
                                       
                                       
                                       // this will pass along the photo objects created in this method to the "FlickrPhotoUrl" as well as set the size
                                NSString *imageURL = [ViewController flickrPhotoURLForFlickrPhoto:photo size:@"m"];
                                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]
                                                                                 options:0
                                                                                   error:&error];
                    UIImage *image = [UIImage imageWithData:imageData];
                    photo.thumbnail = image;
                                       
                                       
                    [flickrPhotos addObject:photo];
                    
                    [testImage1 setAnimationDuration:0.5];
                    [testImage1 setImage:image]; 

                                   }
                               }
                               
                           }];
    
    
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = @"m";
    }
    
    // this is the URL used to actually fetch the photo once you have all the information of the photo object 
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
}


- (IBAction)searchButton:(id)sender {
    
    [searchField resignFirstResponder];
    
    [self setUpFlickrURLRequest];
    
   // [self.collectionView reloadData];
    
}
//
//#pragma mark - UICollectionView Datasource
//// 1
//
//- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    
//    
//    return 20; 
//   // NSString *searchTerm = photoResults[section];
//   // return [[photoResults valueForKey:searchTerm] count];
//}
//// 2
//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    //return [photoResults count];
//    
//    return 4; 
//}
//// 3
//- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    return cell;
//}
//// 4
///*- (UICollectionReusableView *)collectionView:
// (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
// {
// return [[UICollectionReusableView alloc] init];
// }*/
//
//
//#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    // TODO: Select Item
//}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    // TODO: Deselect item
//}
//
//#pragma mark – UICollectionViewDelegateFlowLayout
//
//// 1
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString *searchTerm = photoResults[indexPath.section];
//    FlickrPhoto *photo =[photoResults valueForKey:searchTerm][indexPath.row];
//    // 2
//    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
//    retval.height += 35; retval.width += 35; return retval;
//}
//
//// 3
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(50, 20, 50, 20);
//}
//

@end
