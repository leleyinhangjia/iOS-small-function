//
//  OVLocationCity.m
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "OVLocationCity.h"


NSString *const kOVLocationCityName = @"name";
NSString *const kOVLocationCityArea = @"area";


@interface OVLocationCity ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OVLocationCity

@synthesize name = _name;
@synthesize area = _area;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.name = [self objectOrNilForKey:kOVLocationCityName fromDictionary:dict];
            self.area = [self objectOrNilForKey:kOVLocationCityArea fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kOVLocationCityName];
    NSMutableArray *tempArrayForArea = [NSMutableArray array];
    for (NSObject *subArrayObject in self.area) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForArea addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForArea addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForArea] forKey:kOVLocationCityArea];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.name = [aDecoder decodeObjectForKey:kOVLocationCityName];
    self.area = [aDecoder decodeObjectForKey:kOVLocationCityArea];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kOVLocationCityName];
    [aCoder encodeObject:_area forKey:kOVLocationCityArea];
}

- (id)copyWithZone:(NSZone *)zone
{
    OVLocationCity *copy = [[OVLocationCity alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
    }
    
    return copy;
}


@end
