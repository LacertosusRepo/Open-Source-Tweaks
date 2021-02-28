/*
 * Tweak.x
 * NickOfTime
 *
 * Created by Zachary Thomas Paul <LacertosusThemes@gmail.com> on 2/26/2021.
 * Copyright © 2021 LacertosusDeus <LacertosusThemes@gmail.com>. All rights reserved.
 */
#import "NickOfTime.h"
#import "HBLog.h"

  NSUserDefaults *clockDefaults;
  MTAlarmManager *alarmManager;

static void updateCachedAlarms() {
  if(!alarmManager) {
    alarmManager = [%c(MTAlarmManager) new];
  }

  [alarmManager.cache getCachedAlarmsWithCompletion:nil];
}

static SBSApplicationShortcutSystemIcon* iconForAlarmState(BOOL state) {
  if(state) {
    return [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"checkmark.circle.fill"];
  } else {
    return [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"xmark.circle"];
  }
}

%group SpringBoard
%hook SBIconView
  -(NSArray *)applicationShortcutItems {
    if([self.applicationBundleIdentifierForShortcuts isEqualToString:@"com.apple.mobiletimer"]) {
      NSMutableArray *shortcuts = [%orig mutableCopy];

      for(SBSApplicationShortcutItem *item in [shortcuts reverseObjectEnumerator]) {
        if([item.type containsString:@"com.apple.mobiletimer"]) {
          [shortcuts removeObject:item];
        }
      }

      clockDefaults = (clockDefaults) ?: [[%c(SBApplicationController) sharedInstanceIfExists] applicationWithBundleIdentifier:@"com.apple.mobiletimer"].info.userDefaults;
      NSMutableArray *alarmIDsForContextMenu = [[clockDefaults objectForKey:@"alarmIDsForContextMenu"] mutableCopy];
      MTAlarmCache *alarmCache = alarmManager.cache;

      for(MTAlarm *alarm in alarmCache.orderedAlarms) {
        if(![alarmIDsForContextMenu containsObject:[alarm.alarmID UUIDString]] && alarmIDsForContextMenu.count > 0) {
          continue;
        }

        SBSApplicationShortcutItem *item = [[%c(SBSApplicationShortcutItem) alloc] init];
        item.localizedTitle = [NSString stringWithFormat:@"%02ld:%02ld", alarm.hour, alarm.minute];
        item.localizedSubtitle = alarm.displayTitle;
        item.type = @"com.lacertosusrepo.nickoftime.alarm";
        item.activationMode = 0;
        item.icon = iconForAlarmState(alarm.enabled);
        item.userInfo = @{@"AlarmID" : [alarm.alarmID UUIDString]};

        [shortcuts addObject:item];
      }

      return [shortcuts copy];
    }

    return %orig;
  }

  +(void)activateShortcut:(SBSApplicationShortcutItem *)arg1 withBundleIdentifier:(NSString *)arg2 forIconView:(id)arg3 {
    if([arg1.type isEqualToString:@"com.lacertosusrepo.nickoftime.alarm"]) {
      MTAlarm *alarm = [alarmManager alarmWithIDString:arg1.userInfo[@"AlarmID"]];
      alarm.enabled = !alarm.enabled;
      [alarmManager updateAlarm:alarm];

      return;
    }

    %orig;
  }
%end
%end

%group MobileTimer
%hook MTAAlarmEditViewController
  -(UITableViewCell *)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2 {
    UITableViewCell *cell = %orig;

    if(arg2.section == 0 && arg2.row == [self tableView:arg1 numberOfRowsInSection:0] - 1) {
      NSMutableArray *alarmIDsForContextMenu = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"alarmIDsForContextMenu"] mutableCopy]) ?: [[NSMutableArray alloc] init];
      NSString *alarmID = [self.originalAlarm.alarmID UUIDString];

      UISwitch *showAlarmSwitch = [[UISwitch alloc] init];
      [showAlarmSwitch setOn:[alarmIDsForContextMenu containsObject:alarmID] animated:NO];
      [showAlarmSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];

      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NickOfTimeCell"];
      cell.accessoryView = showAlarmSwitch;
      cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
      cell.contentView.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.text = @"Show in Context Menu";
    }

    return cell;
  }

  -(NSInteger)tableView:(UITableView *)arg1 numberOfRowsInSection:(NSInteger)arg2 {
    return (arg2 == 0) ? %orig + 1 : %orig;
  }

%new
  -(void)switchValueChanged:(UISwitch *)control {
    NSMutableArray *alarmIDsForContextMenu = ([[[NSUserDefaults standardUserDefaults] objectForKey:@"alarmIDsForContextMenu"] mutableCopy]) ?: [[NSMutableArray alloc] init];
    NSString *alarmID = [self.originalAlarm.alarmID UUIDString];

    if(!control.on && [alarmIDsForContextMenu containsObject:alarmID]) {
      [alarmIDsForContextMenu removeObject:alarmID];
    } else {
      [alarmIDsForContextMenu addObject:alarmID];
    }

    [[NSUserDefaults standardUserDefaults] setObject:alarmIDsForContextMenu forKey:@"alarmIDsForContextMenu"];
  }
%end
%end

%ctor {
  if([[NSProcessInfo processInfo].processName isEqualToString:@"SpringBoard"]) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, updateCachedAlarms, CFSTR("MTAlarmManagerAlarmsChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    %init(SpringBoard);
    updateCachedAlarms();
  } else {
    %init(MobileTimer)
  }
}
