#include <amxmodx>     // Подключение заголовочного файла AMX Mod X
#include <engine>     // Подключение заголовочного файла движка
#include <fakemeta>  // Подключение заголовочного файла FakeMeta

new const wellcome[][64] = { "Song1_Welcome.mp3", "Song2_Welcome.mp3", "Song3_Welcome.mp3", "Song4_Welcome.mp3", "Song5_Welcome.mp3" }; // Массив с названиями приветственных песен

public plugin_init() {
    register_plugin("Join_Music", "1.1", "hpp forever"); // Регистрация плагина
    register_cvar("join_music_version", "1.1", FCVAR_SERVER); // Регистрация CVAR-переменной
}

public plugin_precache() { // Функция предварительной загрузки ресурсов
    for (new i = 0; i < sizeof(wellcome); i++) { // Цикл для предварительной загрузки каждой песни
        engfunc(EngFunc_PrecacheSound, wellcome[i]); // Предварительная загрузка звука
    }
}

public client_putinserver(id) { // Функция вызывается, когда клиент присоединяется к серверу
    set_task(1.0, "consound", 100 + id); // Установка задачи с интервалом в 1 секунду для проигрывания музыки
}

public consound(timerid_id) { // Функция для проигрывания музыки
    new id = timerid_id - 100; // Получение ID игрока
    new Usertime; // Переменная для хранения времени игрока
    Usertime = get_user_time(id, 0); // Получение времени игрока

    if (Usertime <= 0) // Если время игрока меньше или равно 0
        set_task(1.0, "consound", timerid_id); // Установка задачи для повторного проигрывания музыки через 1 секунду
		
      else {
        new randomSong = random_num(0, sizeof(wellcome) - 1); // Генерация случайного числа для выбора песни
        new songName[64]; // Переменная для хранения названия песни
        format(songName, sizeof(songName), "sound/%s", wellcome[randomSong]); // Форматирование названия песни
        client_cmd(id, "mp3 play ^"%s^"", songName); // Команда для проигрывания песни клиентом
    }

    return PLUGIN_CONTINUE; // Возвращаем значение для продолжения работы плагина
}