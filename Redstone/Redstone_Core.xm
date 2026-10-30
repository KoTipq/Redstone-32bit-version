#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Глобальный фикс словарей через чистый Objective-C без динамических C-массивов
%hook __NSPlaceholderDictionary

- (instancetype)initWithObjects:(const id *)objects forKeys:(const id *)keys count:(NSUInteger)cnt {
    if (cnt == 0) {
        return %orig;
    }

    NSMutableArray *safeObjects = [NSMutableArray array];
    NSMutableArray *safeKeys = [NSMutableArray array];

    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];

        if (key != nil) {
            [safeKeys addObject:key];
            if (obj != nil) {
                [safeObjects addObject:obj];
            } else {
                [safeObjects addObject:[NSNull null]];
            }
        }
    }

    // Передаем очищенные массивы обратно в оригинальный конструктор
    return %orig(safeObjects, safeKeys, [safeKeys count]);
}

%end

// Хуки SpringBoard
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // Безопасное удаление обсервера
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_HeadphoneJackIsConnectedDidChangeNotification" object:nil];
}

%end
