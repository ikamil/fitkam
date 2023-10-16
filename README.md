# fitkam
Уникальная система управления сетью фитнес-клубов
## Ключевые особенности программы:
- Самая гибкая в индустрии настройка цен — вдохновлённая тарифной сеткой интернет-провайдеров.
![alt text](https://fit.kambox.ru/wp-content/uploads/2015/04/serv-cost.png)
- Работа с несколькими юрлицами и авто-разнесение их платежей по разным кассовым аппаратам — кассиру достаточно выбрать услугу, и чек отправится на один из нескольких подключенных ККМ.

![alt text](http://help.planeta.fitness/wp-content/uploads/2015/11/cachregchoose1.png)
- Удобная платформа управления вознаграждением фитнес-инструкторов с накопительной рейтинговой шкалой.

![alt text](https://fit.kambox.ru/wp-content/uploads/2023/10/image.png)
- Наиболее гибкая в индустрии, управляемая и преднастроенная система отчётов, реализованная в виде многоуровневого каталога.
- Интеллектуальный алгоритм равномерного заполнения гардеробов, с учётом платной брони любимых шкафчиков.
- Уникальный функционал управления пачками подарочных сертификатов с авто-погашением при визитах.
- Ролевая модель с возможностью настройки привилегий, как на уровне ограничений, так и отображения интерфейса и доступного функционала.
- Управляемая система выборочной синхронизации данных между серверами распределённой сети клубов, отдельно могут синхронизироваться:
клиентские данные (членства, платежи и заказы услуг работают локально);
номенклатура тарифных планов и услуг (цены настраиваются локально);
сотрудники с привязкой их к фитнес-зонам.
- Строгая типизация бизнес-процессов — платежи отделены от услуг, посещения от тренировок, даты платежей от дат действия услуг, и т.д.
- Инструментарий для массовой печати клубных карт.

## Установка серверной части Oracle XE
1. Подготовить linux сервер с Docker и Docker Compose
2. Предоставить пользователю доступ к docker, например `usermod kam -gdocker`
3. В целевой папке выполнить `git clone https://github.com/ikamil/fitkam.git`
4. Выполнить `chmod 777 fitkam/data && cd fitkam/docker`
5. Запустить установку и дождаться выполнения `docker-compose up -d`

## Клиенсткая часть
1. Скачать Oracle Instant Client версии 19
2. Распаковать Oracle Instant клиент в папку **desktop/instantclient**
3. Отредактировать файл **desktop/instantclient/tnsnames.ora**, вписать на ip-адрес сервера
4. Запустить mms2.exe с параметром -m1

## Документация
https://fit.kambox.ru

## Канал телеграм
https://t.me/fitkam
