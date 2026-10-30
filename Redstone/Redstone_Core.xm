#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Глобальный фикс: перехватываем инициализацию словарей и защищаем iOS 10 от nil-объектов
%hook __NSPlaceholderDictionary

- (instancetype)initWithObjects:(const id _Nonnull [_Nullable])objects forKeys:(const id <NSCopying> _Nonnull [_Nullable])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeCount = 0;

    for (NSUInteger i = 0; i < cnt; i++) {
        id obj = objects[i];
        id key = keys[i];
        
        if (key != nil) {
            safeKeys[safeCount] = key;
            // Если объект nil, подменяем его на NSNull, чтобы CoreFoundation не уходила в краш
            safeObjects[safeCount] = (obj != nil) ? obj : [NSNull null];
            safeCount++;
        }
    }
    
    return %orig(safeObjects, safeKeys, safeCount);
}

%end

// Оригинальные хуки Redstone_Core
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    
    // Безопасное отключение сбойного уведомления наушников, если оно не поддерживается на iOS 10
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_HeadphoneJackIsConnectedDidChangeNotification" object:nil];
}

%end
