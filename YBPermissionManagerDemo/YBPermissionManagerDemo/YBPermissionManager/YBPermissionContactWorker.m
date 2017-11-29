//
//  YBPermissionContactWorker.m
//  YoubanLoan
//
//  Created by asance on 2017/7/24.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionContactWorker.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#define kSystemVersion      (9)

@implementation YBPermissionContactWorker

+ (void)fetchAccessContactPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=kSystemVersion){
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){NSLog(@"Access contact permissions");}
            else{NSLog(@"Rejected contact permissions:%@",error.localizedDescription);}
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion){
                    completion(granted);
                }
            });
        }];
    }
    else{
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){NSLog(@"Access contact permissions");}
                else{
                    NSError *err = (__bridge_transfer NSError *)error;
                    NSLog(@"Rejected contact permissions:%@",err.localizedDescription);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(completion){
                        completion(granted);
                    }
                });
            });
        });
    }
}

+ (BOOL)canAccessContact{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=kSystemVersion){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status != CNAuthorizationStatusAuthorized) {
            NSLog(@"Rejected contact permissions");
            return NO;
        };
    }
    else{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (status != kABAuthorizationStatusAuthorized) {
            NSLog(@"Rejected contact permissions");
            return NO;
        };
    }
    return YES;
}
+ (YBCNAuthorizationStatus)accessContactStatus{
    YBCNAuthorizationStatus getstatus = YBCNAuthorizationStatusNotDetermined;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=kSystemVersion){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:{
                getstatus = YBCNAuthorizationStatusNotDetermined;
                break;
            }
            case CNAuthorizationStatusRestricted:{
                getstatus = YBCNAuthorizationStatusDenied;
                break;
            }
            case CNAuthorizationStatusDenied:{
                getstatus = YBCNAuthorizationStatusDenied;
                break;
            };
            case CNAuthorizationStatusAuthorized:{
                getstatus = YBCNAuthorizationStatusAuthorized;
                break;
            }
            default:
                break;
        }
    }
    else{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined:{
                getstatus = YBCNAuthorizationStatusNotDetermined;
                break;
            }
            case kABAuthorizationStatusRestricted:{
                getstatus = YBCNAuthorizationStatusDenied;
                break;
            }
            case kABAuthorizationStatusDenied:{
                getstatus = YBCNAuthorizationStatusDenied;
                break;
            };
            case kABAuthorizationStatusAuthorized:{
                getstatus = YBCNAuthorizationStatusAuthorized;
                break;
            }
            default:
                break;
        }
    }
    return getstatus;
}

+ (void)fetchDeviceContactsWithComplete:(void (^)(NSMutableArray *))complete{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *contactArray = [YBPermissionContactWorker fetchDeviceAllContacts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(complete){
                complete(contactArray);
            }
        });
    });
}

+ (NSMutableArray *)fetchDeviceAllContacts{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=kSystemVersion){
        return [self fetchDeviceAllContactsForIOS9Later];
    }
    else{
        return [self fetchDeviceAllContactsForIOS9Before];
    }
}

+ (NSMutableArray *)fetchDeviceAllContactsForIOS9Later{
    
    CNContactStore *store = [[CNContactStore alloc] init];
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey, CNContactMiddleNameKey,CNContactPhoneticFamilyNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactOrganizationNameKey]];
    
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *fullName = @"";
        if(contact.familyName.length){
            fullName = [NSString stringWithFormat:@"%@",contact.familyName];
        }
        if(contact.middleName.length){
            fullName = [NSString stringWithFormat:@"%@%@",fullName,contact.middleName];
        }
        if(contact.givenName.length){
            fullName = [NSString stringWithFormat:@"%@%@",fullName,contact.givenName];
        }
        if(contact.organizationName.length){
            fullName = [NSString stringWithFormat:@"%@%@",fullName,contact.organizationName];
        }
        NSLog(@"fullName:%@",fullName);

        NSString *phoneNmbers = @"";
        NSArray *phoneNums = contact.phoneNumbers;
        for (CNLabeledValue *labeledValue in phoneNums) {
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            if(phoneValue.length){
                if(0==phoneNmbers.length){
                    phoneNmbers = [NSString stringWithFormat:@"%@",phoneValue];
                }
                else{
                    phoneNmbers = [NSString stringWithFormat:@"%@,%@",phoneNmbers,phoneValue];
                }
            }
        }
        
        if(phoneNmbers.length){
            NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
            [contactDict setObject:fullName forKey:@"linkMan"];
            [contactDict setObject:phoneNmbers forKey:@"phone"];
            
            NSLog(@"phoneNmbers:%@",phoneNmbers);
            
            [contactArray addObject:contactDict];
        }
        
    }];
    
    if(0==contactArray.count){
        contactArray = nil;
    }
    
    return contactArray;
}

+ (NSMutableArray *)fetchDeviceAllContactsForIOS9Before{
    
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex num = ABAddressBookGetPersonCount(addressBook);
    
    for (NSInteger i=0; i<num; i++) {
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        NSString *middleName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonMiddleNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        if(0==firstName.length){
            firstName = @"";
        }
        if(0==middleName.length){
            middleName = @"";
        }
        if(0==lastName.length){
            lastName = @"";
        }
        
        NSString *fullName = [NSString stringWithFormat:@"%@%@%@",lastName,middleName,firstName];
        
        NSString *organizationName = (__bridge_transfer NSString *)ABRecordCopyValue(people, kABPersonOrganizationProperty);
        
        if(organizationName.length){
            fullName = [NSString stringWithFormat:@"%@%@",fullName,organizationName];
        }
        NSLog(@"fullName:%@",fullName);
        
        NSString *phoneNmbers = @"";
        ABMultiValueRef phoneNums = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (int k=0; k<ABMultiValueGetCount(phoneNums); k++) {
            //获取该Label下的电话值
            NSString *phoneValue = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNums, k);
            
            if(phoneValue.length){
                if(0==phoneNmbers.length){
                    phoneNmbers = [NSString stringWithFormat:@"%@",phoneValue];
                }
                else{
                    phoneNmbers = [NSString stringWithFormat:@"%@,%@",phoneNmbers,phoneValue];
                }
            }
        }
        
        if(phoneNmbers.length){
            NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
            [contactDict setObject:fullName forKey:@"linkMan"];
            [contactDict setObject:phoneNmbers forKey:@"phone"];
            
            NSLog(@"phoneNmbers:%@",phoneNmbers);
            
            [contactArray addObject:contactDict];
        }
    }
    
    return contactArray;
}

@end
