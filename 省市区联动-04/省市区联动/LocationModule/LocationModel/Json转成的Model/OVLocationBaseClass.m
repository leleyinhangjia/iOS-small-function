//
//  OVLocationBaseClass.m
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "OVLocationBaseClass.h"
#import "OVLocationCity.h"


NSString *const kOVLocationBaseClassName = @"name";
NSString *const kOVLocationBaseClassCity = @"city";


@interface OVLocationBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OVLocationBaseClass

@synthesize name = _name;
@synthesize city = _city;


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
            self.name = [self objectOrNilForKey:kOVLocationBaseClassName fromDictionary:dict];
    NSObject *receivedOVLocationCity = [dict objectForKey:kOVLocationBaseClassCity];
    NSMutableArray *parsedOVLocationCity = [NSMutableArray array];
    if ([receivedOVLocationCity isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedOVLocationCity) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedOVLocationCity addObject:[OVLocationCity modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedOVLocationCity isKindOfClass:[NSDictionary class]]) {
       [parsedOVLocationCity addObject:[OVLocationCity modelObjectWithDictionary:(NSDictionary *)receivedOVLocationCity]];
    }

    self.city = [NSArray arrayWithArray:parsedOVLocationCity];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kOVLocationBaseClassName];
    NSMutableArray *tempArrayForCity = [NSMutableArray array];
    for (NSObject *subArrayObject in self.city) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCity addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCity addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCity] forKey:kOVLocationBaseClassCity];

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

    self.name = [aDecoder decodeObjectForKey:kOVLocationBaseClassName];
    self.city = [aDecoder decodeObjectForKey:kOVLocationBaseClassCity];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kOVLocationBaseClassName];
    [aCoder encodeObject:_city forKey:kOVLocationBaseClassCity];
}

- (id)copyWithZone:(NSZone *)zone
{
    OVLocationBaseClass *copy = [[OVLocationBaseClass alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
    }
    
    return copy;
}


@end
