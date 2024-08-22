﻿&НаКлиенте
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Объект.СуммаДокумента = Товары.Итог("Сумма");
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.Основной.Записывать = Истина;
	
	//Установим блокировки данных в регистрах
	Движения.ТоварыНаСкладах.БлокироватьДляИзменения = Истина;	
	Движения.Основной.БлокироватьДляИзменения = Истина;
	
	РезультатТовары = ПолучитьВыборкуТоваров();  
    ТекстрокаТовары = РезультатТовары.Выбрать();   
    
	Пока ТекСтрокаТовары.Следующий()Цикл
	// регистр ТоварыНаСкладах Приход
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Склад = СкладПолучателя;
		Движение.Количество = ТекСтрокаТовары.Количество;

	// регистр ТоварыНаСкладах Расход
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Склад = СкладОтправителя;
		Движение.Количество = ТекСтрокаТовары.Количество;

	// регистр Основной 
		Движение = Движения.Основной.Добавить();
		Движение.СчетДт = ПланыСчетов.Основной.Товары;
		Движение.СчетКт = ПланыСчетов.Основной.Товары;
		Движение.Период = Дата;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.КоличествоДт = ТекСтрокаТовары.Количество;
		Движение.КоличествоКт = ТекСтрокаТовары.Количество;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ТекСтрокаТовары.Номенклатура;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = СкладПолучателя;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ТекСтрокаТовары.Номенклатура;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Склады] = СкладОтправителя;
	КонецЦикла;
	
	Движения.Записать();
		
		СписокНоменклатур = РезультатТовары.Выгрузить().ВыгрузитьКолонку("Номенклатура");
		
		Если Не РаботаСДокументамиСервер.ПроверкаОстатковТоваров(Дата, СкладОтправителя, СписокНоменклатур) Тогда
			Отказ = Истина;
		КонецЕсли;

КонецПроцедуры



Функция ПолучитьВыборкуТоваров()  
    
    Запрос = Новый Запрос;
    Запрос.Текст =
        "ВЫБРАТЬ
        |	ПеремещениеТовары.Номенклатура КАК Номенклатура,
        |	ПеремещениеТовары.Номенклатура.ВидНоменклатуры КАК НоменклатураВидНоменклатуры,
        |	ВЫБОР
        |		КОГДА ПеремещениеТовары.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидНоменклатуры.Материал)
        |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Основной.Материалы)
        |		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Основной.Товары)
        |	КОНЕЦ КАК СчетДт,
        |	ЗНАЧЕНИЕ(ПланСчетов.Основной.Товары) КАК СчетКт,
        |	СУММА(ПеремещениеТовары.Количество) КАК Количество,
        |	СУММА(ПеремещениеТовары.Сумма) КАК Сумма
        |ИЗ
        |	Документ.Перемещение.Товары КАК ПеремещениеТовары
        |ГДЕ
        |	ПеремещениеТовары.Ссылка = &Ссылка
        |
        |СГРУППИРОВАТЬ ПО
        |	ПеремещениеТовары.Номенклатура,
        |	ПеремещениеТовары.Номенклатура.ВидНоменклатуры";    
            
    Запрос.УстановитьПараметр("Ссылка", Ссылка);
    
 
Возврат Запрос.Выполнить();
    
КонецФункции          
 




