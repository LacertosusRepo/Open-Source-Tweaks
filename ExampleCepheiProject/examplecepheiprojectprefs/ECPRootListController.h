#import <Preferences/PSListController.h>
  //import CepheiPrefs HBRootListController
#import <CepheiPrefs/HBRootListController.h>
  //import CepheiPrefs HBRespringController purely for the respring button in preferences
#import <Cephei/HBRespringController.h>

  //Subclass your root list controller as a HBRootListController, purely for appearance
@interface ECPRootListController : HBRootListController //was PSListController
@end
