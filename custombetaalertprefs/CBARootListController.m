#include "CBARootListController.h"

@implementation CBARootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)save {
    [self.view endEditing:YES];
}

- (void)viewSource {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Samplasion/CustomBetaAlert"]];
}

@end
