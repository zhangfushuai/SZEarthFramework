
#import "SZEarthHttpHead.h"

@implementation SZEarthHttpHead
@synthesize valid = _valid;
@synthesize ID = _ID;
@synthesize length = _length;
@synthesize error = _error;

-(id)initWithValid:(NSString*)valid andID:(NSNumber*)ID Length:(NSNumber*)length error:(NSNumber*)error {
    self = [super init];
    self.valid = valid;
    self.ID = ID;
    self.length = length;
    self.error = error;
    return self;
}

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.valid forKey:@"valid"];
//    [aCoder encodeObject:self.ID forKey:@"id"];
//    [aCoder encodeObject:self.length forKey:@"length"];
//    [aCoder encodeObject:self.error forKey:@"error"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        self.valid = [aDecoder decodeObjectForKey:@"valid"];
//        self.ID = [aDecoder decodeObjectForKey:@"id"];
//        self.length = [aDecoder decodeObjectForKey:@"length"];
//        self.error = [aDecoder decodeObjectForKey:@"error"];
//    }
//    return self;
//}

////接口测试
//- (void)httpTest:(NSData*)data{
//    NSURL *url = [[NSURL alloc]initWithString:@"http://192.168.1.103:8080/SZearth/servlet/Login"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //        NSLog(@"response....%@",data);
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"data....%@",dic);
//    }] resume];
//    
//}

@end
