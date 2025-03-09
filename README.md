# Описание архитектуры
## Архитектурынй паттерн - MVC
## Применение паттерна

MainScreen отвечает за ленту постов.
Model (PostModel): отвечает за модель постов, приходящих с сервера;
View (MainScreenView): отвечает за отобраение View элементов;
Controller (MainScreenViewController): связывает Model и View, обрабатывает действия пользователя.

SavedPosts отвечает за экран сохраненных постов.
Model (PostModel): отвечает за модель постов, приходящих с сервера;
View (SavedPostsView): отвечает за отобраение View элементов;
Controller (SavedPostsViewController): связывает Model и View, обрабатывает действия пользователя.

# Функции 
При запуске пользователь видит главный экран, на котором отображается лента. 
Каждый пост включает:
-Аватар пользователя;
-Название поста;
-Текст поста.
Также в ячейке поста есть кнопка лайка, при нажатию на которую пост сохраняется на устройство (CoreData).
С помощью TabBar пользователь может переключится на экран сохраненных на утройство постов.
Добавлена темная тема.

# Скриншоты экранов
## Темная тема
![Simulator Screenshot - iPhone 16 New - 2025-03-09 at 14 08 11](https://github.com/user-attachments/assets/2d8e2d70-2881-4a6d-a4c4-18b06def578f)
![Simulator Screenshot - iPhone 16 New - 2025-03-09 at 14 08 29](https://github.com/user-attachments/assets/69d29c3f-f4ff-470e-9850-7e7a718c0127)
## Светлая тема
![Simulator Screenshot - iPhone 16 New - 2025-03-09 at 14 11 00](https://github.com/user-attachments/assets/eaf1b2e5-16b8-4157-85c4-d1f91ea6dabb)
![Simulator Screenshot - iPhone 16 New - 2025-03-09 at 14 11 06](https://github.com/user-attachments/assets/ac70f2c1-928e-44b4-92d6-0d057276da30)

# Применяемые технологии
- Swift;
- UIKit + AutoLayout (верстка кодом);
- CoreData: сохранение постов на устройство;
- URLSession: работа с сетью;
## Загрузка данных 
- JSONPlaceholder: название и текст поста;
- Lorem Picsum: аватары пользователей;
Примечание: аватары пользователей будут загружаться только с VPN.

# Инструкция по сборке
1. Установить Xcode
2. Клонировать репозиторий проекта
3. Открыть проект в Xocode и запустить приложение


