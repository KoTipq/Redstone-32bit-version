#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Перехватываем функцию изменения состояния наушников и ставим проверку входящих данных
%hook SBVolumeControl

- (void)headphoneConnectionChanged:(NSNotification*)notification {
    // Если объект уведомления или его словарь данных пустой (nil), прерываем выполнение, чтобы не крашить SpringBoard
    if (!notification || !notification.userInfo) {
        return;
    }
    
    // Безопасная обработка словаря перед передачей в оригинальный метод
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"AVSystemController_HeadphoneJackIsConnectedAttribute"] == nil) {
        return; // Пропускаем хук, если ключ отсутствует на старой iOS 10
    }

    %orig(notification);
}

%end
