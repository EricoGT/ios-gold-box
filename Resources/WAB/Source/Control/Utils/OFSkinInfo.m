//
//  OFSkinInfo.m
//  Ofertas
//
//  Created by Marcelo Santos on 9/22/13.
//  Copyright (c) 2013 Marcelo Santos. All rights reserved.
//

#import "OFSkinInfo.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation OFSkinInfo

static NSDictionary *dictStat;

- (void) assignSkinDictionary:(NSDictionary *) dict {
    
    dictStat = [[NSDictionary alloc] initWithDictionary:dict];
    LogInfo(@"dictStat: %@", dictStat);
}


+ (NSDictionary *) getSkinDictionary {

    return dictStat;
}


+ (double)currentMemoryUsage {
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn == KERN_SUCCESS)
		return vmStats.wire_count/1024.0;
	else return 0;
    
    //How to use:
    //NSLog(@"Current memory usage: %.2f MB", [OFSkinInfo currentMemoryUsage]);
}

@end
