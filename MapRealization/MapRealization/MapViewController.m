//
//  MapViewController.m
//  MapRealization
//



#import "MapViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface MapViewController () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapMainView;

@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation MapViewController

#pragma mark - view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];

    
}


#pragma mark - config ui
- (void)configUI{

    // get current user location
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    float currentLatitude = mylocation.placemark.location.coordinate.latitude;
    float currentLongitude = mylocation.placemark.location.coordinate.longitude;
    
    // 1. 添加UI界面
    self.mapMainView.delegate = self;
    self.mapMainView.mapType = MKMapTypeMutedStandard;
    self.mapMainView.showsUserLocation = YES;
    self.mapMainView.userTrackingMode = MKUserTrackingModeFollow;
    //CLLocationCoordinate2DMake：参数： 维度、经度、南北方宽度（km）、东西方宽度（km）
    

    [self.mapMainView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(currentLatitude , currentLongitude), 300, 194)
                       animated:YES];
    
    
    [self configLocationAuthority];
}

/**
 * 2. add system map authority
 */
- (void)configLocationAuthority{
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [_locationManager requestWhenInUseAuthorization];
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"请开启定位:设置 > 隐私 > 定位服务");
    }
    // 持续使用定位服务
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization]; // 永久授权
        [_locationManager requestWhenInUseAuthorization]; //使用中授权
    }
    // 方位服务
    if ([CLLocationManager headingAvailable])
    {
        _locationManager.headingFilter = 5;
        [_locationManager startUpdatingHeading];
    }
    [_locationManager startUpdatingLocation];
}

/**
 * 3. Info.plist --- Privacy - Location When In Use Usage Description
 */



/*
- (void)navByVender {
    CLLocation *begin = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:self.myPlace.latitude] floatValue]
                                                   longitude:[[NSNumber numberWithFloat:self.myPlace.longitude] floatValue]];
    [self.geocoder reverseGeocodeLocation:begin completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        __block CLPlacemark * beginPlace = [placemarks firstObject];
        CLLocation *end = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:self.finishPlace.latitude] floatValue]
                                                     longitude:[[NSNumber numberWithFloat:self.finishPlace.longitude] floatValue]];
        [self.geocoder reverseGeocodeLocation:end completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error Info %@",error.userInfo);
            } else {
                CLPlacemark * endPlace = [placemarks firstObject];
                MKMapItem * beginItem = [[MKMapItem alloc] initWithPlacemark:beginPlace];
                MKMapItem * endItem = [[MKMapItem alloc] initWithPlacemark:endPlace];
                NSString * directionsMode;
                switch (self.navType) {
                    case 0:
                        directionsMode = MKLaunchOptionsDirectionsModeWalking;
                        break;
                    case 1:
                        directionsMode = MKLaunchOptionsDirectionsModeDriving;
                        break;
                    case 2:
                        directionsMode = MKLaunchOptionsDirectionsModeTransit;
                        break;
                    default:
                        directionsMode = MKLaunchOptionsDirectionsModeWalking;
                        break;
                }
                NSDictionary *launchDic = @{
                                            //范围
                                            MKLaunchOptionsMapSpanKey : @(50000),
                                            // 设置导航模式参数
                                            MKLaunchOptionsDirectionsModeKey : directionsMode,
                                            // 设置地图类型
                                            MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                            // 设置是否显示交通
                                            MKLaunchOptionsShowsTrafficKey : @(YES),
                                            };
                [MKMapItem openMapsWithItems:@[beginItem, endItem] launchOptions:launchDic];
            }
        }];
    }];
}
*/





@end
