﻿

Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.СтоимостьТоваров.Записывать = Истина;
	Движения.Основной.Записывать = Истина;
	Движения.Продажи.Записывать = Истина;
	
	
	//Установим блокировки данных в регистрах
	Движения.ТоварыНаСкладах.БлокироватьДляИзменения = Истина;	
	Движения.Основной.БлокироватьДляИзменения = Истина;
	
	Движения.ТоварыНаСкладах.Записать();
	Движения.СтоимостьТоваров.Записать();
	
	
	РезультатТовары = ПолучитьВыборкуТоваров();  
	ТекстрокаТовары = РезультатТовары.Выбрать();   
	
	СчетТовары = ПланыСчетов.Основной.Товары; 
	
	//Для Каждого ТекСтрокаТовары Из Товары Цикл
	Пока ТекСтрокаТовары.Следующий() Цикл
		
		// регистр ТоварыНаСкладах Расход
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Количество = ТекСтрокаТовары.Количество;
		
		// регистр СтоимостьТоваров Расход
		Движение = Движения.СтоимостьТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Стоимость = ТекСтрокаТовары.Стоимость * ТекСтрокаТовары.Количество;
		
		// регистр Продажи 
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Договор = Договор;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Количество = ТекСтрокаТовары.Количество;   
		Движение.Менеджер = Автор;
		
		// регистр Основной  дт90- кт 10
		
		Движение = Движения.Основной.Добавить();
		Движение.Период = Дата;
		Движение.СчетДт = ПланыСчетов.Основной.Капитал;
		Если ТекСтрокаТовары.Номенклатура.ВидНоменклатуры = Перечисления.ВидНоменклатуры.Материал Тогда
			Движение.СчетКт = ПланыСчетов.Основной.Материалы;           
		Иначе	Движение.СчетКт = ПланыСчетов.Основной.Товары;     
		КонецЕсли;
		Движение.КоличествоКт = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Стоимость * ТекСтрокаТовары.Количество;
		Движение.СубконтоКт.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.СубконтоКт.Склады = Склад;
	КонецЦикла;     
	
	Движения.Записать();
	
	
	СписокНоменклатур = РезультатТовары.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	Если Не РаботаСДокументамиСервер.ПроверкаОстатковТоваров(Дата, Склад, СписокНоменклатур) Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры 

Функция ПолучитьВыборкуТоваров()  
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|    Таблица.Номенклатура КАК Номенклатура,
	|    Таблица.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|    ВЫБОР
	|        КОГДА Таблица.Номенклатура.ВидНоменклатуры
	|				= ЗНАЧЕНИЕ (Перечисление.ВидНоменклатуры.Материал)
	|            ТОГДА ЗНАЧЕНИЕ (ПланСчетов.Основной.Капитал)
	|        ИНАЧЕ ЗНАЧЕНИЕ (ПланСчетов.Основной.Капитал)
	|    КОНЕЦ КАК СчетДт,
	|    ВЫБОР
	|        КОГДА Таблица.Номенклатура.ВидНоменклатуры
	|				= ЗНАЧЕНИЕ (Перечисление.ВидНоменклатуры.Материал)
	|            ТОГДА ЗНАЧЕНИЕ (ПланСчетов.Основной.Материалы)
	|        ИНАЧЕ ЗНАЧЕНИЕ (ПланСчетов.Основной.Товары)
	|    КОНЕЦ КАК СчетКт,
	|    СУММА(Таблица.Количество) КАК Количество,
	|    СУММА(Таблица.Сумма) КАК Сумма       
	|ИЗ
	|    Документ.РеализацияОПТ.Товары КАК Таблица
	|ГДЕ
	|    Таблица.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|    Таблица.Номенклатура,
	|    Таблица.Номенклатура.ВидНоменклатуры";    
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТаблицаТоваров = Запрос.Выполнить().Выгрузить();   
	РезультатЗапроса = РаботаСДокументамиСервер.ПолучитьСреднююЦенуДляТаблицыНоменклатур(Дата, ТаблицаТоваров);
	
	Возврат РезультатЗапроса;
	
КонецФункции     

